clear; clc;


% DataPath = '/Volumes/SONY_32X/data_CP_geneva/Test';
% tbxVBQPath = '/Users/sysadmin/Documents/MATLAB/spm12/toolbox/VBQ';

rootPath = 'D:/louedkhe/Documents/GitHub/MPM/';
DataPath = 'D:/louedkhe/Documents/GitHub/Groupe_1';
tbxVBQPath = 'D:/louedkhe/Documents/MATLAB/spm12/toolbox/VBQ';

cd(DataPath)
cd ..
groups = dir('Groupe*');
for i = 2:length(groups)
    cd(groups(i).name)
    Subjects = dir('S*');
    SubjName = {};
    for j = 1:length(Subjects)
        SubjName{j} = Subjects(j).name;
    end
end


cd(rootPath)
groupNames = {};
for i = 2:length(groups) 
    groupNames{i} = groups(i).name;
    if ~isfolder(groupNames{i})
    mkdir(groupNames{i})
    end
end

    

addpath(genpath(DataPath))
addpath(genpath(tbxVBQPath))

cd(rootPath)
for i = 2:length(groupNames) 
    if ~isfolder(groupNames{i})
        mkdir(groupNames{i})
    end
    cd (char(groupNames(i)))
    for j = 1:length(SubjName)
        if ~isfolder(SubjName{j})
        mkdir(SubjName{j})
        end
    end

    
    for  j =2:length(SubjName)
    source = fullfile(DataPath, SubjName(j));
    cd(char(source))
    thisSubj= SubjName{j};
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
        next = next(find(checkDir));
        end    
        thisSubjPath3 = fullfile(thisSubjPath1, next.name);
        if isfolder(thisSubjPath3)
            cd(thisSubjPath3)
        else
            continue
        end
    end
    
    mpmNames = {};
    mpmsHere = dir([thisSubjPath3,'\*\MPM']);
    mpmFolder = {};
    for m = 1:length(mpmsHere)
        mpmFolder{m} = mpmsHere(m).folder;
    end
    mpmsHere = unique(mpmFolder);
        
        
    
%     mpmsHere(ismember(mpmsHere.name, {'.','..'})) = [];
    for m = 1:length(mpmsHere)
     mpmNames{m} = strcat(char(SubjName(j)),'_',num2str(m));
     thatSubj = fullfile(rootPath, groupNames(i), SubjName(j));
     cd(char(thatSubj))
     mkdir(char(mpmNames{m}))
     thatMPM = char(fullfile(rootPath, groupNames(i), SubjName(j),  mpmNames{m}));
     thisMPM = mpmsHere(m);
     copyfile (char(thisMPM),  char(thatMPM))
    end
end
end
     
    