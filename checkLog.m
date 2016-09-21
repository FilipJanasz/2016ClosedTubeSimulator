%set default values for starting_file, batch size, execution time
function [starting_file,execution_time,processed_amount,starting_batch,batch_size]=checkLog(paths)

    default_starting_file=1;
    default_batch_size=4;
    default_processed_amount=0;
    default_execution_time=1500400;
    default_starting_batch=1;

    %check if log files exists in dirLogs directory, if not set calculation parameters as default
    fid=fopen(paths.log, 'rt');

    if fid==-1

        disp('No log file available, setting defaults')

        %assign default values to variables used further
        starting_file=default_starting_file;
        execution_time=default_execution_time;
        processed_amount=default_processed_amount;
        starting_batch=1;

    else

        disp('Log file found, reading calculation parameters to restart calculation if possible')
        log=importdata(paths.log);
        eval(cell2mat(log(1)));
        eval(cell2mat(log(2)));
        eval(cell2mat(log(3)));
        eval(cell2mat(log(4)));
        execution_time=default_execution_time;
        fclose(fid); 
    end

    batch_size=default_batch_size;

end


