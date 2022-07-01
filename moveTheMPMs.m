clear; clc;


% DataPath = '/Volumes/SONY_32X/data_CP_geneva/Test';
% tbxVBQPath = '/Users/sysadmin/Documents/MATLAB/spm12/toolbox/VBQ';

DataPath = '/Volumes/Camille_ordi/MPM';
% DataPath = 'D:/louedkhe/Documents/GitHub/Groupe_0';
tbxVBQPath = 'D:/louedkhe/Documents/MATLAB/spm12/toolbox/VBQ';



cd(DataPath)
% groupName = {};
groups = dir('Groupe*');



for g = 3:length(groups) 
    thisGroupPath = fullfile(DataPath, groups(g).name);
    cd(char(thisGroupPath))
    Subjects = dir(['S' num2str(g-1) '*']);
    SubjName = {};
    for i = 1:length(Subjects)
        SubjName{i} = Subjects(i).name;
    end
    
for  i =1:length(SubjName)
    thisSubj= SubjName{i};
    thisSubjPath = fullfile(thisGroupPath, thisSubj);
    cd(thisSubjPath)
    MTsHere = dir([thisSubjPath,'/*/MPM/MT*']);
    
    if isempty(MTsHere)
        continue
    end
    MTs = {};
    PDs = {};
    T1s = {};
    
    for j = 1:length(MTsHere)
        MTs{j} = MTsHere(j).folder;
    end
    MTs = unique(MTs);
    for j = 1:length(MTs)
        cd(char(MTs(j)))
        copyfile (['MT_', num2str(j)], fullfile(thisSubjPath,['MT_', num2str(j)]))
    end
    
    PDsHere = dir([thisSubjPath,'/*/MPM/PD*']);
    for j = 1:length(PDsHere)
        PDs{j} = PDsHere(j).folder;
    end
    PDs = unique(PDs);
    for j = 1:length(PDs)
        cd(char(PDs(j)))
        copyfile (['PD_', num2str(j)], fullfile(thisSubjPath,['PD_', num2str(j)]))
    end
    
    
        T1sHere = dir([thisSubjPath,'/*/MPM/T1*']);
    for j = 1:length(T1sHere)
       T1s{j} = T1sHere(j).folder;
    end
    T1s = unique(T1s);
    
    for j = 1:length(T1s)
        cd(char(T1s(j)))
        copyfile (['T1_', num2str(j)], fullfile(thisSubjPath,['T1_', num2str(j)]))
    end
end
end



