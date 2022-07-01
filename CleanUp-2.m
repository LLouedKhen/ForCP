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
        thisSubjPath3 = fullfile(thisSubjPath1, next.name);
        cd(thisSubjPath3)
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

        if isfolder('MPM')
            status = rmdir('MPM', 's')
        end
   end
end