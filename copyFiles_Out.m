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
    groupNames{g}  = groups(g).name;
    cd (destPath)
    if ~isfolder(groupNames(g))
        mkdir (char(groupNames(g)))
    end
end

% for g = 3:length(groupNames)
%     DataPath = fullfile(rootPath, groupNames(g));
%     cd (char(DataPath))
%     Subjects = dir(['S' num2str(g-1) '*']);
%     SubjName = {};
%     for s = 1:length(Subjects)
%         SubjName{s} = Subjects(s).name;
%     end
%     nextDestPath = fullfile(destPath, groupNames(g));
%     cd (char(nextDestPath))
%     if ~isfolder(SubjName{s})
%         mkdir (SubjName{s})
%     end
% end
        

% cd ..
% mkdir MPM 
% cd('MPM')
% for i = 1:length(SubjName)
%     mkdir(SubjName{i})
% end
for g = 3:length(groupNames)
    DataPath = fullfile(rootPath, groupNames(g));
    cd (char(DataPath))
    monitorGroup = ['Working on ', char(groupNames(g))];
    disp(monitorGroup)
    Subjects = dir(['S' num2str(g-1) '*']);
    SubjName = {};
    for s = 1:length(Subjects)
        SubjName{s} = Subjects(s).name;
    end

    for s =1:length(SubjName)
        thisSubj= SubjName{s};
        monitorSubj = ['Working on ', char(thisSubj)];
        disp(thisSubj)
        
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
    if isfile('.DS_Store')
        delete '.DS_Store'
    end
    Files = dir;
    FileNames = {};
   
    for f = 3:length(Files)
        FileNames{f} = Files(f).name;
        thisSubjThisSeqPath = fullfile(thisSubjPath3, FileNames{f});
        cd(char(thisSubjThisSeqPath))
        if isfolder('MPM')
           disp('Yes, MPM')
           nextFolder = fullfile(thisSubjThisSeqPath, 'MPM');
           cd(char(nextFolder))
           if isfile('.DS_Store')
               delete '.DS_Store'
           end
           Echos = dir('Echo*')
           for k = 1:length(Echos)
                thisEcho = char(fullfile(nextFolder, Echos(k).name));
                cd(thisEcho)
                delete 'MR*'
           end
        cd ../..
        sendToPath = char(fullfile(destPath,groupNames{g},SubjName{s}, FileNames{f}, 'MPM'));
        mkdir (sendToPath)
        copyfile (char(nextFolder),sendToPath)
        disp ('Copy Complete.')
        else  
            cd ..
        continue 
    end
   end
  end
end
