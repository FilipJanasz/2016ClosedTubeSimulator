clc, clear all, close all

endtime='40000.';
mindt='1.e-10';
maxdt='1e-4';
minor='600000';
major='12000000';
%define the timestep
time_step=str2num(minor)*str2num(maxdt);

%get path to script correctly
setPaths;
cd(default_dir)


%read binary results
userChoice=menu('Choose your processing option','Point to a directory and process all .r files within it and all subdirectories', 'Point to a file');   
   
    if userChoice==1
        
        %display gui to pick directory
        directoryname = uigetdir('Pick a directory');
        
        %GET ALL FILES FROM DIRECTORY AND SUBFOLDERS
        [subDirectories,file_names]=subdir(directoryname);

        %mark all cells which contain a name of .r file - BUT keep the
        %subfolder structure, i.e. each cell of r_files is a subfolder,
        %which then contains files
        r_files=cellfun(@(x)strfind(x,'.r'),file_names,'UniformOutput', false);

        %find their positions in inner cells
        fileCounter=1;
        allFiles=numel(r_files);

        for counter=1:allFiles

            table{counter}=find(~cellfun(@isempty,r_files{counter}));
            
            for table_counter=1:numel(table{counter})
                if ~isempty(table{counter}(table_counter))
                    x=table{counter}(table_counter);

                    %store names of r files
                    processed_files_list{fileCounter}=file_names{counter}{x};

                    %store names of directories which contain .r files
                    directory{fileCounter}=subDirectories{counter};

                    %increase counter
                    fileCounter=fileCounter+1;

                end
            end

        end
               
    elseif userChoice==2
            
            [processed_files_list,directory,FilterIndex] = uigetfile('*.r','Choose .r file to process','MultiSelect','on');   
            directory=directory(1:end-1);
            directory={directory};
            
            if ~iscell(processed_files_list)
                processed_files_list={processed_files_list};
            end
    end
    
        %define the number of files to process
           number_of_processed_files=numel(processed_files_list);
    
for counter=1:number_of_processed_files
    clear data
    clear header
    clear varFull
    clear varFull_every_second
    
        namePos=[];
        plotInf=[];
        plotAlf=[];
        plotNum=[];
        plotRec_all_positions=[];
    
        %clear used variables:
        clear integerPart alphanumericPart varFull varValue fid
        
        fileName=processed_files_list{counter};
%         fileName=fileName(2:end); %removes empty sign at the beginning (\n)
        pathFile=strcat(directory{counter},'\',fileName);
        res_file=fopen(pathFile,'r');
        data=fread(res_file,inf,'*uint8')';  %XXXXXXXXXXXXXXXXXXXXXXXX
        length=numel(data);
        fclose(res_file);

        file_divisions=1;
    %find & read name and time
        for string_counter=1:file_divisions
            from=floor(string_counter-1)*length/file_divisions+1;
            to=floor(string_counter)*length/file_divisions;
            temp_namePos=strfind(data(from:to),'RELAP')+from-1;
            namePos=[namePos, temp_namePos];
        end
        %take only first position of RELAP word occurence
        namePos=namePos(1);
        %read name
        calculationName=char(data(namePos:namePos+71));

    %find position of plotinf block & read data
        for string_counter=1:file_divisions
            from=floor(string_counter-1)*length/file_divisions+1;
            to=floor(string_counter)*length/file_divisions;
            temp_plotInf=strfind(data(from:to),'plotinf')+from-1;
            plotInf=[plotInf, temp_plotInf];
        end
   
        %read length of plotalf record
        word1=char(data(plotInf:plotInf+7));
        word2=data(plotInf+8:plotInf+15);
        word3=data(plotInf+16:plotInf+23);
        %important: word2 in block plotinf describes length of plotalf and
        %plotnum blocks and on 32bit machines is written as a 2 words of 4
        %bytes length (therefore, program have to use typecast commant to
        %change unit8 to unit32 type of word2 variable to make any sense
        plotAlf_length_two_word_format=typecast(uint8(word2),'uint32');
        plotAlf_length=plotAlf_length_two_word_format(2);

        plotRec_length_two_word_format=typecast(uint8(word3),'uint32');
        plotRec_length=plotRec_length_two_word_format(2);

        %or, if you're running 64 bit machine, comment out the code above and
        %use:
    %     plotAlf_length_two_word_format=typecast(uint8(word2),'uint64');
    %     plotAlf_length=plotAlf_length_two_word_format;
    %     plotRec_length_two_word_format=typecast(uint8(word3),'uint64');
    %     plotRec_length=plotRec_length_two_word_format;

    % find position of plotalf block
        for string_counter=1:file_divisions
            from=floor(string_counter-1)*length/file_divisions+1;
            to=floor(string_counter)*length/file_divisions;
            temp_plotAlf=strfind(data(from:to),'plotalf')+from-1;
            plotAlf=[plotAlf, temp_plotAlf];
        end
        
        %allocate memory for variable
        alphanumericPart=cell(1,plotAlf_length-1);
        %read alphanumeric part of the variable name
        for n=2:plotAlf_length
            start=plotAlf+(n-1)*8;
            finish=start+7;
            alphanumericPart{n-1}=char(data(start:finish)); 
        end
        alphanumericPart=alphanumericPart';  %make a column vector
        
    % find position of plotnum block
        for string_counter=1:file_divisions
            from=floor(string_counter-1)*length/file_divisions+1;
            to=floor(string_counter)*length/file_divisions;
            temp_plotNum=strfind(data(from:to),'plotnum')+from-1;
            plotNum=[plotNum, temp_plotNum];
        end
      
        %allocate memory for variable
        integerPart=cell(1,plotAlf_length-1);
        %read integer part of the variable name
        for n=2:plotAlf_length
            start=plotNum+(n-1)*8;
            finish=start+7;
            integerPart{n-1}=typecast(uint8(data(start:finish)),'uint32');
            integerPart{n-1}=integerPart{n-1}(2);
        end
        integerPart=integerPart'; %make a column vector
        
     % find position of plotrec block   
       
        for string_counter=1:file_divisions
            from=floor(string_counter-1)*length/file_divisions+1;
            to=floor(string_counter)*length/file_divisions;
            temp_plotRec_all_positions=strfind(data(from:to),'plotrec')+from-1;
            plotRec_all_positions=[plotRec_all_positions, temp_plotRec_all_positions];
        end
        amount_of_records=numel(plotRec_all_positions);

        %allocate memory for variable
        varValue=cell(plotAlf_length-1,amount_of_records);
        %store data for all recorded timesteps
        for n=1:amount_of_records
            plotRec=plotRec_all_positions(n)+8;
            %read actual value of each variable
            for m=1:plotAlf_length-1
                start=plotRec+(m-1)*4;
                finish=start+3;
                varValue{m,n}=typecast(uint8(data(start:finish)),'single');
            end
        end
        
     %stitch vectors together
        varFull=[alphanumericPart, integerPart, varValue];
     %prepare header
        header=cell(1,amount_of_records+2);
        header{1,1}='Parameter';
        header{1,2}='Hydraulic component';
         %allocate memory for variable
        
        for n=1:amount_of_records
            header{1,n+2}=num2str(time_step*n);
        end

     %append header
        varFull=[header;varFull];

     %sort array by alphabetical order of the first column (using function
     %sortcell.m, which can be downoladed from here
     %http://www.mathworks.com/matlabcentral/fileexchange/13770-sorting-a-cell-array )
         varFull=sortCell(varFull,1);
         
         
     %print to text file
            %save_fileName=fileName(1:end-2);
%             pat_saveFile=strcat(dirOutput,fileName,'\',fileName,'_processed_for_Matlab.txt');
%             store_file=fopen(path_saveFile,'w');
%             
%             n=1;
%             fprintf(store_file,'%s  %s %f  %f \n',varFull{n,:});
%             for n=2:plotAlf_length
%             fprintf(store_file,'%s  %d  %f  %f \n',varFull{n,:});
%             end
%             fclose(store_file);

     %print to excel
%             path_saveFile=strcat(dirOutput,fileName,'\',fileName,'_processed_for_Matlab');
%             varFull_every_second=varFull(:,1:2:end);
%             
%             xlswrite(path_saveFile,varFull_every_second);
% save to .mat
            % save to .mat
            varFull=varFull(:,1:1:end);    %every NTH
            path_saveFile=strcat(pathFile(1:end-2),'_processed_for_Matlab');
            save(path_saveFile,'varFull');
end
    
% plotter_mat_fun(directory,processed_files_list);
