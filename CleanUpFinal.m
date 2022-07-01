clear; clc;


% DataPath = '/Volumes/SONY_32X/data_CP_geneva/Test';
% tbxVBQPath = '/Users/sysadmin/Documents/MATLAB/spm12/toolbox/VBQ';

DataPath = 'D:/louedkhe/Documents/GitHub/MPM/';
% DataPath = 'D:/louedkhe/Documents/GitHub/Groupe_0';
tbxVBQPath = 'D:/louedkhe/Documents/MATLAB/spm12/toolbox/VBQ';


cd(DataPath)
% groupName = {};
groups = dir('Groupe*');



for g = 3:length(groups) 
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
    
    
    
    MT = dir([thisSubjPath,'\*\MPM\MT*']);
    if isempty(MT)
        continue
    else
        for j = 1:length(MT)
            thisMT = fullfile(MT(j).folder, MT(j).name);
            movefile (char(thisMT), thisSubjPath);
        end
    end
    
    PD = dir([thisSubjPath,'\*\PD*']);
    if isempty(PD)
        continue
    else
        for j = 1:length(PD)
            thisPD = fullfile(PD(j).folder, PD(j).name);
            movefile (char(thisPD), thisSubjPath);
        end
    end
    
        T1 = dir([thisSubjPath,'\*\T1*']);
    if isempty(T1)
        continue
    else
        for j = 1:length(T1)
            thisT1 = fullfile(T1(j).folder, T1(j).name);
            movefile (char(thisT1), thisSubjPath);
        end
    end
end
end
