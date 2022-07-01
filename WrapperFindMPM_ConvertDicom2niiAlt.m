%The following program takes dicom images from individual MPM echo times,
%for each subject in a dataset, and converts them to niftii format. 
%Thus, the loops go Subject > MPM > Echo.
%Please use the WrapperFindMPM_GetEcho.m folder prior to running this
%script, to make sure a full volume per echo was obtained (no mosaic, no
%single slices as volumes, etc.
%Ensure that spm is in the path, of course.
%By Leyla Loued-Khenissi, 4th of July, 2019

clear; clc;

%Update path below accordingly, set it to where your data lives.
rootPath = '/Volumes/Camille_ordi';
tbxVBQPath = '/Users/loued/Documents/MATLAB/spm12/toolbox/VBQ';
destPath = '/Volumes/Camille_ordi/MPM';

cd(rootPath)
addpath(rootPath)
addpath(genpath(tbxVBQPath))


groups = dir('Groupe*')
groupNames = {};

for g = 3:length(groups)
    groupNames{g}  = groups(g).name
    cd (destPath)
    if ~isfolder(groupNames(g))
        mkdir (groupNames(g))
    end
end 
for g = 3:length(groupNames)
    DataPath = fullfile(rootPath, groupNames(g));
    cd (char(DataPath))
    %list subjects according to prefix in your database
    Subjects = dir(['S' num2str(g-1) '*']);
    SubjName = {};
    for i = 1:length(Subjects)
        SubjName{i} = Subjects(i).name;
    end

    for  i =1:length(SubjName)
    thisSubj= SubjName{i};
    thisSubjPath = fullfile(DataPath, thisSubj);
    cd(char(thisSubjPath))
    next = dir('DTI_Rest*');
    thisSubjPath1 = fullfile(thisSubjPath, next.name);
    cd(char(thisSubjPath1))
        if isfile('.DS_Store')
        delete '.DS_Store'
        end
    next = dir;
    
    if isfolder('DICOM')
        thisSubjPath2 = fullfile(thisSubjPath1, 'DICOM');
        cd(char(thisSubjPath2))
        next = dir('dcm*');
        thisSubjPath3 = fullfile(thisSubjPath2, next.name);
        cd(char(thisSubjPath3))
            if isfile('.DS_Store')
            delete '.DS_Store'
            end
    else
        next = dir('dcm*');
        if length(next) > 1
            checkDir = [];
            for n =1:length(next)
            checkDir(n) = isfolder(next(n).name);
            end
            next = next(find(checkDir));
        end    
        thisSubjPath3 = fullfile(thisSubjPath1, next.name);
        if isfolder(thisSubjPath3)
            cd(char(thisSubjPath3))
                if isfile('.DS_Store')
                delete '.DS_Store'
                end
        else
            continue
        end
    end
 
%     thisSubjMPMPath =fullfile(thisSubjPath3, 'MPM');
    
    Files = dir;
    FileNames = {};
    
    if isfile('.DS_Store')
        delete '.DS_Store'
    end
   
   for j = 3:length(Files)
    FileNames{j} = Files(j).name;
    thisSubjThisSeqPath = fullfile(thisSubjPath3, FileNames{j});
    cd(char(thisSubjThisSeqPath))
    filesHere = dir;
    if isfolder('MPM')
        disp('Yes')
        thisSubjMPMPath = fullfile(thisSubjThisSeqPath, 'MPM');
         
        cd(char(thisSubjMPMPath))
        thisSubjMPMEcho = dir('Echo*');
        for k =1:length(thisSubjMPMEcho)
%           thisSubjMPMsName = thisSubjMPMs(k).name;
%           thisSubjThisMPM = fullfile(thisSubjMPMPath, thisSubjMPMsName);
%           cd(thisSubjThisMPM)
         % Echoes = dir('Echo*');
          %for m =1:length(Echoes)
          thisSubjThisMPMThisEcho = fullfile(thisSubjMPMPath, thisSubjMPMEcho(k).name);
          cd(char(thisSubjThisMPMThisEcho))
          theseDicoms = dir('MR.*');
          for l = 1:length(theseDicoms)
                theseDicomNames{l} = theseDicoms(l).name;
          end
          if ~isfolder('niftiANDjson')
          mkdir niftiANDjson
          end
          thisOutDir = char(fullfile(thisSubjThisMPMThisEcho, 'niftiANDjson'));
          
          %Now run SPM's dicom2 nifti
          spm('Defaults','fMRI');
          spm_jobman('initcfg');
          matlabbatch{1}.spm.util.import.dicom.data = theseDicomNames';
          matlabbatch{1}.spm.util.import.dicom.root = 'flat';
          matlabbatch{1}.spm.util.import.dicom.outdir = {thisOutDir};
          matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
          matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
          matlabbatch{1}.spm.util.import.dicom.convopts.meta = 1;
          matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
          save('matlabbatch');
          spm_jobman('run',matlabbatch);
          
%           cd(thisOutDir)
%           cd ..
%           jsonFile = 'GetImgFromMosaic_header_dump.txt'
%           value = jsondecode(fileread(jsonFile));
          
          end
        
    else 
        disp('No')
        continue
    end
   end
    end
end