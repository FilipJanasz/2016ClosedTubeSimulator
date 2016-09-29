function [directories, input_decks_list_stripped]=fileFinder(fileCharacteristic,firstCall,subdirectoryname,firstInSeq)
    %creates a lists of files in a chosen folder, based on a desired
    %string in the name
    %display gui to pick directory
    if firstCall && firstInSeq
        directoryname = uigetdir(subdirectoryname,'Pick a directory');
    else
        directoryname=subdirectoryname;
    end

    %get a list of all files / entities
    objectsInFolder=dir(directoryname);
    objectsInFolder(1:2)=[];  %removes objects like '.' and '..' from the list
    
    %extract a list of names
    object_names={objectsInFolder.name};
    
    %check if there are any subdirectories
    isdir=[objectsInFolder.isdir];
    subdirs=object_names(isdir==1);
    files=object_names(isdir==0);
    
    %apply to all files found in said directory
    if ~isempty(files)
        %filter the names list by desired characteristic
        desired_files=~cellfun('isempty',strfind(files,fileCharacteristic));
        input_decks_list=files(desired_files);
        
        %if there are actually any suitable files found, store their names
        if ~isempty(input_decks_list)

            %find position of the file extension in the string
            extPos=find(flip(input_decks_list{1})=='.');

            %strip file extension
            input_decks_list_stripped=cellfun(@(x) x(1:end-extPos),input_decks_list,'UniformOutput',0);

            %add directories
            directories = cell(1, numel(input_decks_list_stripped));
            directories(:) = {directoryname};

        else
            input_decks_list_stripped={0}; 
            directories={0};
        end
    else
        input_decks_list_stripped={0};
        directories={0};
    end
    
    %dive deeper into subdirs - yay recursion
    if ~isempty(subdirs)
        for subdirs_counter=1:numel(subdirs)
            %define subdirectory
            subdirectoryname=[directoryname,'\',subdirs{subdirs_counter}];
            %start function
            [subdir_directories, subdir_input_decks]=fileFinder(fileCharacteristic,0,subdirectoryname);
            %check if returned values contain any directories - if not,
            %number of non zero elements
            if subdir_input_decks{1,1}~=0
                input_decks_list_stripped=[input_decks_list_stripped subdir_input_decks]; %#ok<AGROW>
                directories=[directories subdir_directories];   %#ok<AGROW>
            end
        end
    end
    
    %after all subdirectories are dealt with, check if execution is back at
    %the top of recursion
    if firstCall
        %if yes, filter possible faulty first element
        if input_decks_list_stripped{1}==0
            input_decks_list_stripped(1)=[];
            directories(1)=[];
        end
    end
end