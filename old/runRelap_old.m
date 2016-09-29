function runRelap(dirCode,default_dir,starting_file,execution_time,starting_batch,batch_size)
    
    %set license as enviromental variable
    try
        lic_file=fopen([dirCode,'\license.txt']);
    catch
        disp('Relap license not found - verify path to RELAP directory')
    end
    license=textscan(lic_file,'%s');
    fclose(lic_file);
    setenv('rslicense',char(license{1}));
    %REMEMBER ABOUT SETTING UP ENV VAR FOR RS LICENSE!!!!!

    %import input decks list form file created by runRelapCalculation.m
    clear input_decks_list input_decks_number
    
    userChoice=menu('Choose your processing option','Point to a directory and process all .i files within it and all subdirectories', 'Point to a file');   
   
    if userChoice==1
        %creates a lists of files in a chosen folder, based on a desired
        %string in the name
        [directories,input_decks_list]=fileFinder('.i',1,default_dir);
    elseif userChoice==2

            [input_decks_list,~,~] = uigetfile('*.i','Choose .i file to process','MultiSelect','on');   

            if ~iscell(input_decks_list)
                input_decks_list={input_decks_list};
            end
    end
%     directory
    input_decks_number=numel(input_decks_list);
    batch_amount=(input_decks_number-starting_file+1)/batch_size;

    %determine number of batches to process:
    if (batch_amount>round(batch_amount))
        batch_count=round(batch_amount)+1;
    elseif (batch_amount<round(batch_amount))
        batch_count=round(batch_amount);
    else
        batch_count=batch_amount;
    end

    %vary batch size if there's less files than batch size to process
    if batch_amount<1
        batch_size=input_decks_number;
    end
   
    %processing loop (outer loop runs batches for an hour, inner loop opens
    %number of files, specified in batch_size at once in Relap5
    for m=starting_batch:batch_count
        for n=starting_file:starting_file+batch_size-1

            fileName=input_decks_list{n};
            fileDir=directories{n};
            inputFile=[fileDir,'\',fileName,'.i -o '];
            outputOfile=[fileDir,'\',fileName(1:end-11),'_output_O.o -r '];
            outputRfile=[fileDir,'\',fileName(1:end-11),'_output_R.r -w '];
            command=[dirCode,'relap5 -i ',inputFile,outputOfile,outputRfile,dirCode,'tpfh2o &'];
%             command=cell2mat(command); %convert cell array to a matrix
            dos(command);
          
        end

        processed_amount=m*batch_size;
        starting_file=processed_amount+1; %set the start file of the next batch (first after all processed ones)
        left_to_process=input_decks_number-processed_amount;
        %if there's less to process than batch_size, assign this value to
        %batch_size
        if (left_to_process<batch_size)
            batch_size=left_to_process;
        end

        %control the calculation time

        pause(execution_time/4)
        disp(['1/4 execution time passed ',num2str(execution_time*0.25),'s'])
        pause(execution_time/4)
        disp(['1/2 execution time passed ',num2str(execution_time*0.5),'s'])
        pause(execution_time/4)
        disp(['3/4 execution time passed ',num2str(execution_time*0.75),'s'])
        pause(execution_time/4)
        disp(['Execution finished after ',num2str(execution_time),'s']) 
        disp('Reading new batch of files')
        dos('taskkill /im relap5.exe')
    end

end