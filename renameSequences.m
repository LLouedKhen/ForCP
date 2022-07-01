clear; clc;


% DataPath = '/Volumes/SONY_32X/data_CP_geneva/Test';
% tbxVBQPath = '/Users/sysadmin/Documents/MATLAB/spm12/toolbox/VBQ';

DataPath = '/Volumes/Camille_ordi/MPM';
% DataPath = 'D:/louedkhe/Documents/GitHub/Groupe_0';


cd(DataPath)
% groupName = {};
groups = dir('Groupe*');



for g = 3:length(groups) 
    thisGroupPath = fullfile(DataPath, groups(g).name);
    monitorGroup = ['Working on ', char(groups(g).name)];
    disp(monitorGroup)
    cd(char(thisGroupPath))
    Subjects = dir('S*');
    SubjName = {};
    for i = 1:length(Subjects)
        SubjName{i} = Subjects(i).name;
    end
    
for  i =1:length(SubjName)
    thisSubj= SubjName{i};
    monitorSubj = ['Working on ', char(thisSubj)];
    disp(monitorSubj)
    thisSubjPath = fullfile(thisGroupPath, thisSubj);
    cd(thisSubjPath)
    if isfile('.DS_Store')
        delete '.DS_Store'
    end
    next = dir;
    protocol = {};
        
    for k =3:length(next)
        thisMPM = fullfile(thisSubjPath, next(k).name, 'MPM');
        cd(thisMPM)
        cd('niftiANDjson')
        file = fopen('GetImgFromMosaic_header_dump.txt');
        while true
            line = fgetl(file);
            x = line;
            if startsWith(x, 'tProtocolName')
               disp('This is my sequence')
               protocol= x(46:end-2);
               disp(protocol)
%                protocol = strrep(protocol, ' ', '_');
%                protocol = strcat(protocol, '_');
               if strfind(protocol, 'Optimized MT') & length(protocol) ==12
%                    & ~strfind(protocol, 'pd+AF8-') & ~strfind(protocol, 't1+AF8-')
                   cd(thisMPM)
                    mkdir MT
                   prot = 1;    
                   thisSeq = fullfile(thisMPM, 'MT');
               elseif strfind(protocol, 'pd+AF8-')
                   cd(thisMPM)
                   mkdir PD
                   prot = 2;
                   thisSeq = fullfile(thisMPM, 'PD');
               elseif strfind(protocol, 't1+AF8-')
                   cd(thisMPM)
                   mkdir T1
                   prot = 3;
                   thisSeq = fullfile(thisMPM, 'T1');
               else 
                   cd(thisMPM)
                   mkdir Other
                   prot = 0;
                   thisSeq = fullfile(thisMPM, 'Other');
               end   
               break
            end

        end
     
        echoes = dir('Echo*');
        for p = 1:length(echoes)
            thisEcho = echoes(p).name;
            cd(thisEcho)
            delete ('MR.*')
            cd niftiANDjson
            theseFiles = dir('*.nii');
            for q =1:length(theseFiles)
                nameFile = theseFiles(q).name;
                if startsWith(nameFile, 's')
                newNameFile = strcat(protocol, nameFile);
                movefile (nameFile, newNameFile)
                copyfile (newNameFile, thisSeq)
                else
                copyfile (nameFile, thisSeq)
                end
                disp ('Copy Complete.')
            end
             cd ..
%             oldMPM = next(k).name;
%             newMPM = oldMPM(1:end-1);
%             newMPM = strcat(newMPM, protocol(1:end-1));
%             movefile oldMPM newMPM
             cd ..
        end
    end
end
end


