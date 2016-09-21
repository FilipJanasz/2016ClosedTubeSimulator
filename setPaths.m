function paths=setPaths(file_path)

    %Set directories
    paths.dirLogs=[file_path,'\Relap5_logs\'];
    paths.dirInput=[file_path,'\Relap5_input\'];
    paths.dirOutput=[file_path,'\Relap5_output\'];
    paths.dirCode='D:\Data\Relap5\Relap5_code\';

    %mkdir
    if ~exist(paths.dirLogs,'file')
     mkdir(paths.dirLogs)
    end
    if ~exist(paths.dirInput,'file')
     mkdir(paths.dirInput)
    end
    if ~exist(paths.dirOutput,'file')
     mkdir(paths.dirOutput)
    end

    %set up path variables
    paths.log=[paths.dirLogs,'log.txt'];
    paths.processedFiles=[paths.dirLogs,'list of processed files.txt'];
    paths.inputDecks=[paths.dirLogs,'input_decks_list.txt'];

end

