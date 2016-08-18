
% c=clock;
% timedate=datestr(c);
default_dir='D:\Data\Relap5\2015ClosedTubeSimulatorHeater';
% pat=':';
% timedate=regexprep(timedate,pat,'_');
% cd(default_dir);
% mkdir(timedate);
% current_dir=strcat('C:\Documents and Settings\janasz_f\Desktop\SimplePipeSimulator\',timedate);
% default_dir=current_dir;
cd(default_dir)
clear path_to_decks_list path_to_processed path_to_log

%Directories manager

%Set default directories
default_dirLogs='Relap5_logs\';
default_dirInput='Relap5_input\';
default_dirOutput='Relap5_output\';
default_dirCode='D:\Data\Relap5\Relap5_code\';

%mkdir
if ~exist('Relap5_logs','file')
 mkdir(default_dirLogs)
end
if ~exist('Relap5_input','file')
 mkdir(default_dirInput)
end
if ~exist('Relap5_output','file')
 mkdir(default_dirOutput)
end
if ~exist('Relap5_code','file')
 mkdir(default_dirCode)
end


%Assign default values to variables used further
dirLogs=default_dirLogs;
dirInput=default_dirInput;
dirOutput=default_dirOutput;
dirCode=default_dirCode;


%set up path variables
path_to_log=strcat(dirLogs,'log.txt');
path_to_processed=strcat(dirLogs,'list of processed files.txt');
path_to_decks_list=strcat(dirLogs,'input_decks_list.txt');

