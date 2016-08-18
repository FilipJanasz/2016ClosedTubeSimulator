function [file_list, fileCounter]=filter_tdms_files(directoryname,file_names) 

    % in case list of files is not given, get one
    file_list{1}=1;
    if nargin==1
        dir_info=dir(directoryname);
        file_names={dir_info.name};
    end
   
    % make a table which marks for each file if it has a certain string in
    % the name
    init_files=cellfun(@(x)regexp(x,'RELAP_INPUT'),file_names,'UniformOutput', false);
    %count all the files
    files_amount=numel(init_files);

    fileCounter=0;
    %for each file, check if it has "RELAP_INPUT" in the name
    %and if yes, then store its name as a file to process
    for i=1:files_amount
        flag_init=isempty(init_files{i});
        if ~flag_init
            %increase counter
            fileCounter=fileCounter+1;
            %store names of tdms files
            file_list{fileCounter}=file_names{i};
        end
    end

%     if isempty(file_list)
%         file_list=1;
%     end
end