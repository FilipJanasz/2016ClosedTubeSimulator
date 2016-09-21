%clc, clear all, close all

cd(default_dir)

%clear output directory
% dos('DEL Relap5_output\*.o')
% dos('DEL Relap5_output\*.r')

%check if log file exists and if not, set default values for many
%calculation parameters
checkLog;

%set license as enviromental variable
%set license as enviromental variable
lic_file=fopen([dirCode,'\license.txt']);
license=textscan(lic_file,'%s');
fclose(lic_file);
setenv('rslicense',license);
%REMEMBER ABOUT SETTING UP ENV VAR FOR RS LICENSE!!!!!

%import input decks list form file created by runRelapCalculation.m
clear input_decks_list input_decks_number

input_decks_list=importdata(path_to_decks_list);
input_decks_number=numel(input_decks_list);
batch_amount=(input_decks_number-starting_file+1)/batch_size;

%determine number of batches to process:
if (batch_amount>round(batch_amount))
    counter=round(batch_amount)+1;
elseif (batch_amount<round(batch_amount))
    counter=round(batch_amount);
else
    counter=batch_amount;
end

%vary batch size if there's less files than batch size to process
if batch_amount<1
    batch_size=input_decks_number;
end

%open log files
fid=fopen(path_to_log,'wt');
fid2=fopen(path_to_processed,'at');
%processing loop (outer loop runs batches for an hour, inner loop opens
%number of files, specified in batch_size at once in Relap5
for m=starting_batch:counter
    for n=starting_file:starting_file+batch_size-1
        
        fileName=input_decks_list(n);
        processing_path=strcat('',dirOutput,cell2mat(fileName),'\','');
        mkdir(processing_path);
        command=strcat(dirCode,{'relap5 -i '},dirInput,fileName,{'.i -o '},dirOutput,fileName,'\',fileName,{'.o -r '},dirOutput,fileName,'\',fileName,{'.r -w '},dirCode,'tpfh2o &');
        command=cell2mat(command); %convert cell array to a matrix
        dos(command);
        %write names of files that were processed
        fileName_string=cellstr(fileName);
        fprintf(fid2,'\n %s',cell2mat(fileName_string));
        
    end
    
    processed_amount=m*batch_size;
    starting_file=processed_amount+1; %set the start file of the next batch (first after all processed ones)
    left_to_process=input_decks_number-processed_amount;
    %if there's less to process than batch_size, assign this value to
    %batch_size
    if (left_to_process<batch_size)
        batch_size=left_to_process;
    end
    starting_batch=m+1;
    %write info about current processing state to log.txt file
    
    fprintf(fid,'starting_file=%d\n', starting_file);
    fprintf(fid,'batch_size=%d\n',batch_size);
    fprintf(fid,'processed_amount=%d\n',processed_amount);
    fprintf(fid,'starting_batch=%d\n',starting_batch);
    
      
    pause(execution_time/4)
    disp('1/4 execution time passed')
    pause(execution_time/4)
    disp('1/2 execution time passed')
    pause(execution_time/4)
    disp('3/4 execution time passed')
    pause(execution_time/4)
    disp('Execution finished, reading new batch of files')
    dos('taskkill /im relap5.exe')
end

%close log files
fclose(fid2);
fclose(fid);
close all
processResults;