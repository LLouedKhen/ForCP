clear; clc;


% DataPath = '/Volumes/SONY_32X/data_CP_geneva/Test';
% tbxVBQPath = '/Users/sysadmin/Documents/MATLAB/spm12/toolbox/VBQ';

DataPath = 'D:/louedkhe/Documents/GitHub/MPM/';
% DataPath = 'D:/louedkhe/Documents/GitHub/Groupe_0';
tbxVBQPath = 'D:/louedkhe/Documents/MATLAB/spm12/toolbox/VBQ';

addpath(genpath(DataPath))
addpath(genpath(tbxVBQPath))

cd(DataPath)
% groupName = {};
groups = dir('Groupe*');


for g = 2:length(groups) 
    thisGroupPath = fullfile(DataPath, groups(g).name);
    cd(char(thisGroupPath))
    Subjects = dir('S*');
    SubjName = {};
    for i = 1:length(Subjects)
        SubjName{i} = Subjects(i).name;
    end
for  i =1:length(SubjName)
    thisSubj= SubjName{i};
    thisSubjPath = fullfile(thisGroupPath, thisSubj);
    cd(thisSubjPath)
    MTF = dir([thisSubjPath,'/**/MPM/MT']);
    for m = 1:length(MTF)
    MTsHere{m} = MTF(m).folder;
    end
    if isempty(MTsHere)
        continue
    else 
        MTs = unique(MTsHere)';
    end
    

    if ~isempty(MTs)
    for j = 1:length(MTs)
        cd (MTs(j))
        movefile (MTsHere(j),thisSubjPath)
    end
    else
        continue
    end
    
    PDsHere = dir([thisSubjPath,'\*\PD*']);
    for j = 1:length(PDsHere)
        PDs{j} = PDsHere(j).folder;
    end
    PDs = unique(PDs);
    if ~isempty(PDs)
    
    for j = 1:length(PDs)
        cd (PDsHere(j).folder)
        movefile (PDsHere(j).name,thisSubjPath)
    end
    else
        continue
    end
    
    
    T1sHere = dir([thisSubjPath,'\*\T1*']);
    for j = 1:length(T1sHere)
       
       T1s{j} = T1sHere(j).folder;
    end
    T1s = unique(T1s);
    
    if ~isempty(T1s)
    for j = 1:length(T1s)
        cd (T1sHere(j).folder)
        movefile (T1sHere(j).name,thisSubjPath)
    end
    else
        continue
    end
end
end



