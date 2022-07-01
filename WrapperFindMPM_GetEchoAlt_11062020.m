%The following program trawls through raw dicoms to, first, identify MPMs,
%and second, extract them, according to their headers into the right
%contrats (PT, MT, T1, etc) and into the correct echoes.
%Routinues written for C. Piguet, unige, following dicom2niftii conversion
%problems; cannot be unique given the existence of GetImgFromMosaic in VBQ
%toolbox.
%If MPM sequences haven't yet been identified and placed in a separate folder, uncomment lines 40-55
%Lines 40-55 have not been tested!!! Use with caution.
%Use WrapperFindMPM_GetEcho.m after this, to complete dicom2nifti
%conversion.
%Make sure the VBQ toolbox is in the path
%By Leyla Loued-Khenissi, 4th of July, 2019


clear; clc;


% DataPath = '/Volumes/SONY_32X/data_CP_geneva/Test';
% tbxVBQPath = '/Users/sysadmin/Documents/MATLAB/spm12/toolbox/VBQ';

rootPath = '/Volumes/Camille_ordi';
tbxVBQPath = '/Users/loued/Documents/MATLAB/spm12/toolbox/VBQ';
destPath = '/Volumes/Camille_ordi/MPM';



% addpath(genpath(rootPath))
addpath(genpath(tbxVBQPath))


cd(rootPath)
groups = dir('Groupe*');
groupNames = {};

for g = 3:length(groups)
    groupNames{g}  = groups(g).name
    cd (destPath)
    if ~isfolder(groupNames(g))
        mkdir (char(groupNames(g)))
    end
end

for g = 6:length(groupNames)
    DataPath = fullfile(rootPath, groupNames(g));
    cd (char(DataPath))


Subjects = dir(['S' num2str(g-1) '*']);
SubjName = {};
for i = 1:length(Subjects)
    SubjName{i} = Subjects(i).name;
end
% cd ..
% mkdir MPM 
% cd('MPM')
% for i = 1:length(SubjName)
%     mkdir(SubjName{i})
% end


for i =1:length(SubjName)
    thisSubj= SubjName{i};
    thisSubjPath = fullfile(DataPath, thisSubj);
    cd(char(thisSubjPath))
    next = dir('DTI_Rest*');
    
    thisSubjPath1 = fullfile(thisSubjPath, next.name);
    cd(char(thisSubjPath1))
    
    next = dir;
    if isfolder('DICOM')
        thisSubjPath2 = fullfile(thisSubjPath1, 'DICOM');
        cd(char(thisSubjPath2))
        next = dir('dcm*');
        thisSubjPath3 = fullfile(thisSubjPath2, next.name);
        cd(char(thisSubjPath3))
    
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
        else
            continue
        end
    end
%     if isfolder('MPM')
%     rmdir MPM
%     end
%     thisSubjMPMPath =fullfile(thisSubjPath3, 'MPM');
   
   
    if isfile('.DS_Store')
        delete '.DS_Store'
    end
    Files = dir;
    FileNames = {};
   
   for j = 3:length(Files)
    FileNames{j} = Files(j).name;
    thisSubjThisSeqPath = fullfile(thisSubjPath3, FileNames{j});
    cd(char(thisSubjThisSeqPath))
    filesHere = dir ('MR*');
%     if isfile('.DS_Store')
%         delete '.DS_Store'
%     end
    if length(filesHere) >= 176 & length(filesHere)  <=  178
    disp('Yes')
%     mkdir MPM
    disp(length(filesHere))
        if ~isfolder('MPM')
        mkdir MPM
        end
%      copyfile('thisSubjThisSeqPath', 'MPM\thisSubjThisSeqPath')
     copyfile('MR*', 'MPM')
     SubjSeqPath = fullfile(thisSubjThisSeqPath, 'MPM');
     cd(char(SubjSeqPath))
     if isfile('.DS_Store')
        delete '.DS_Store'
     end

   
      thisSubjMPMs = dir;
      for k =3:length(thisSubjMPMs)
        if isfile('.DS_Store')
            delete '.DS_Store'
        end
          thisSubjMPMsName = thisSubjMPMs(k).name;
          thisSubjThisMPM = fullfile(SubjSeqPath, thisSubjMPMsName);
%           cd(thisSubjThisMPM)
%           mkdir niftiANDjson
        if ~isfolder('niftiANDjson')
            mkdir niftiANDjson
        end
          Here = SubjSeqPath;
          There = fullfile(char(Here), 'niftiANDjson');
          cd(tbxVBQPath)
          echoOut = GetImgFromMosaic(There, char(Here));    
      end
          else
         disp('NO')
         disp(length(filesHere))
%          pause
        continue
    end
end
end
end
