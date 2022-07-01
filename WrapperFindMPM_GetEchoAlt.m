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
tbxVBQPath = '/Users/loued/Documents/MATLAB/spm12/toolbox/hMRI-toolbox-0.2.2';
destPath = '/Volumes/Camille_ordi/MPM';



addpath(genpath(rootPath))
addpath(genpath(tbxVBQPath))


cd(DataPath)
Subjects = dir('S*');
SubjName = {};
for i = 1:length(Subjects)
    SubjName{i} = Subjects(i).name;
end
cd ..
mkdir MPM 
cd('MPM')
for i = 1:length(SubjName)
    mkdir(SubjName{i})
end


for i =1:length(SubjName)
    thisSubj= SubjName{i};
    thisSubjPath = fullfile(DataPath, thisSubj);
    cd(thisSubjPath)
    next = dir('DTI_Rest*');
    
    thisSubjPath1 = fullfile(thisSubjPath, next.name);
    cd(thisSubjPath1)
    
    next = dir;
    if isfolder('DICOM')
        thisSubjPath2 = fullfile(thisSubjPath1, 'DICOM');
        cd(thisSubjPath2)
        next = dir('dcm*');
        thisSubjPath3 = fullfile(thisSubjPath2, next.name);
        cd(thisSubjPath3)
    
    else
        next = dir('dcm*');
        if length(next) > 1
            checkDir = [];
        for n =1:length(next)
            checkDir(n) = isfolder(next(n).name);
        end
        next = next(find(checkDir))
        end    
        thisSubjPath3 = fullfile(thisSubjPath1, next.name);
        if isfolder(thisSubjPath3)
            cd(thisSubjPath3)
        else
            continue
        end
    end
    if isfolder('MPM')
    rmdir MPM
    end
%     thisSubjMPMPath =fullfile(thisSubjPath3, 'MPM');
   
    Files = dir;
    FileNames = {};
   
   for j = 3:length(Files)
    FileNames{j} = Files(j).name;
    thisSubjThisSeqPath = fullfile(thisSubjPath3, FileNames{j});
    cd(thisSubjThisSeqPath)
    filesHere = dir ('MR*');
    if isfile('.DS_Store')
        delete '.DS_Store'
    end
    if length(filesHere) >= 176 & length(filesHere)  <=  178
    disp('Yes')
    disp(length(filesHere))
        if ~isfolder('MPM')
        mkdir MPM
        end
%      copyfile('thisSubjThisSeqPath', 'MPM\thisSubjThisSeqPath')
     copyfile(thisSubjThisSeqPath, 'MPM')
     SubjSeqPath = fullfile(thisSubjThisSeqPath, 'MPM');
     cd(SubjSeqPath)
     if isfile('.DS_Store')
        delete '.DS_Store'
    end

   
      thisSubjMPMs = dir;
      for k =3:length(thisSubjMPMs)
          thisSubjMPMsName = thisSubjMPMs(k).name;
          thisSubjThisMPM = fullfile(SubjSeqPath, thisSubjMPMsName);
%           cd(thisSubjThisMPM)
%           mkdir niftiANDjson
        if ~isfolder('niftiANDjson')
            mkdir niftiANDjson
        end
          Here = SubjSeqPath;
          There = fullfile(Here, 'niftiANDjson');
          cd(tbxVBQPath)
          echoOut = GetImgFromMosaic(There, Here);    
      end
          else
         disp('NO')
         disp(length(filesHere))
%          pause
        continue
    end
end
  end
   
