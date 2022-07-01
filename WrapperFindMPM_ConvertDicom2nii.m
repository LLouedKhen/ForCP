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
DataPath = 'D:/louedkhe/Documents/GitHub/Groupe_0';
tbxVBQPath = 'D:/louedkhe/Documents/MATLAB/spm12/toolbox/hMRI-toolbox-0.2.2';

addpath(genpath(DataPath))
addpath(genpath(tbxVBQPath))

cd(DataPath)

%list subjects according to prefix in your database
Subjects = dir('S0*');
SubjName = {};
for i = 1:length(Subjects)
    SubjName{i} = Subjects(i).name;
end

for i =1:length(SubjName)
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
    
      cd(thisSubjMPMPath)
      thisSubjMPMs = dir;
      for k =3:length(thisSubjMPMs)
          thisSubjMPMsName = thisSubjMPMs(k).name;
          thisSubjThisMPM = fullfile(thisSubjMPMPath, thisSubjMPMsName);
          cd(thisSubjThisMPM)
          Echoes = dir('Echo*');
          for m =1:length(Echoes)
          thisSubjThisMPMThisEcho = fullfile(thisSubjThisMPM, Echoes(i).name);
          cd(thisSubjThisMPMThisEcho)
          theseDicoms = dir('MR.*');
            for l = 1:length(theseDicoms)
            theseDicomNames{l} = theseDicoms(l).name;
            end
          mkdir niftiANDjson
          thisOutDir = fullfile(thisSubjThisMPMThisEcho, 'niftiANDjson');
          
          %Now run SPM's dicom2 nifti
          spm('Defaults','fMRI');
          spm_jobman('initcfg');
          matlabbatch{1}.spm.util.import.dicom.data = theseDicomNames';
          matlabbatch{1}.spm.util.import.dicom.root = 'patid';
          matlabbatch{1}.spm.util.import.dicom.outdir = {thisOutDir};
          matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
          matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
          matlabbatch{1}.spm.util.import.dicom.convopts.meta = 1;
          matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
          save('matlabbatch');
          spm_jobman('run',matlabbatch);
          end
      end
   
end