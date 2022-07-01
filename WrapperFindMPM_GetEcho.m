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

DataPath = 'D:/louedkhe/Documents/GitHub/Groupe_0';
tbxVBQPath = 'D:/louedkhe/Documents/MATLAB/spm12/toolbox/hMRI-toolbox-0.2.2';


addpath(genpath(DataPath))
addpath(genpath(tbxVBQPath))

cd(DataPath)
Subjects = dir('S0*');
SubjName = {};
for i = 2:length(Subjects)
    SubjName{i} = Subjects(i).name;
end

for i =2:length(SubjName)
    thisSubj= SubjName{i};
    thisSubjPath = fullfile(DataPath, thisSubj);
    cd(thisSubjPath)
    thisSubjPath1 = fullfile(thisSubjPath, 'DICOM');
    cd(thisSubjPath1)
    next = dir('dcm*');
    thisSubjPath2 = fullfile(thisSubjPath1, next.name);
    cd(thisSubjPath2)
    %%
    thisSubjMPMPath =fullfile(thisSubjPath2, 'MPM');
   
    Files = dir;
    FileNames = {};
   
    for j = 3:length(Files)
    FileNames{j} = Files(j).name;
    thisSubjThisSeqPath = fullfile(thisSubjPath2, FileNames{j});
    cd(thisSubjThisSeqPath)
    filesHere = dir;
     if length(filesHere) == 178
        if ~exist('MPM', 'dir')
            mkdir MPM
        end
         copyfile('thisSubjThisSeqPath', 'MPM\thisSubjThisSeqPath')
 
     else
        continue
     end
    end
   

      cd(thisSubjMPMPath)
      thisSubjMPMs = dir;
      for k =3:length(thisSubjMPMs)
          thisSubjMPMsName = thisSubjMPMs(k).name;
          thisSubjThisMPM = fullfile(thisSubjMPMPath, thisSubjMPMsName);
          cd(thisSubjThisMPM)
          mkdir niftiANDjson
%           if ~exist('niftiANDjson', 'dir')
%             mkdir niftiANDjson
%           end
          Here = pwd;
          There = fullfile(pwd, 'niftiANDjson');
          cd(tbxVBQPath)
          echoOut = GetImgFromMosaic(There, Here);    
      end
   
end