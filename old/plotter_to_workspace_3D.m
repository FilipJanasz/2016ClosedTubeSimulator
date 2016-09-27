clc
clear all
close all
%pipe length

script_dir='D:\Data\Relap5\2015ClosedTubeSimulatorHeater\';
cd 'D:\Data\Relap5\2015ClosedTubeSimulatorHeater\'    

userChoice=menu('Choose your processing option','Point to a directory and process all .xls within it and all subdirectories', 'Point to a file');   
   
    if userChoice==1
        
        %display gui to pick directory
        directoryname = uigetdir('Pick a directory');
        
        %GET ALL FILES FROM DIRECTORY AND SUBFOLDERS
        [subDirectories,file_names]=subdir(directoryname);

        %mark all cells which contain a name of .xls file
        excel_files=cellfun(@(x)regexp(x,'.xls'),file_names,'UniformOutput', false);

        %find their positions in inner cells
        fileCounter=1;
        allFiles=numel(excel_files);

        for counter=1:allFiles

            table{counter}=find(~cellfun(@isempty,excel_files{counter}));

            if ~isempty(table{counter})
                x=table{counter};

                %store names of xls files
                processed_files_list{fileCounter}=file_names{counter}{x};

                %store names of directories which contain .xls files
                directories{fileCounter}=subDirectories{counter};

                %increase counter
                fileCounter=fileCounter+1;

            end

        end
               
    elseif userChoice==2
            
            [processed_files_list,directory,FilterIndex] = uigetfile('*.xls','Choose .r file to process','MultiSelect','on');   
            directoryname=directory;
            if ~iscell(processed_files_list)
                processed_files_list=mat2cell(processed_files_list);
            end
    end
    
        %define the number of files to process
           number_of_processed_files=numel(processed_files_list);

        %define parameters to be plotted
            parameters2process={'sattemp','tempf','tempg','p','vapgen','quala','rhog','rhof','rho','floreg','velg','velf','htvat','voidg','htrnr'};
            parameters2process_secondary={'tempf_secondary','p_secondary','vapgen_secondary','htvat_secondary'};
            parametersAmount=numel(parameters2process);  
            parametersAmount_secondary=numel(parameters2process_secondary);
    
    
for n=1:number_of_processed_files
    
    clear num txt raw loc position data tempf_primarypipe fileName TPs PPs
    fileName=processed_files_list{n};
    fileName=fileName(1:end-4); %removes empty sign at the beginning (\n)
    
    if userChoice==1
        directory=strcat(cell2mat(directories(n)),'\');
    end
    
    %define paths to files and to plots
    path_readFile=strcat(directory,cell2mat(processed_files_list(n))); %define path for reading current file
    pathPlots=strcat(directoryname,'\Plots');
    pathPlots_secondary=strcat(directoryname,'\Plots\Secondary');
    
    %create directory Plots if it does not exist
    if exist(pathPlots,'dir')~=7
        mkdir(pathPlots);  
    end
    if exist(pathPlots_secondary,'dir')~=7
        mkdir(pathPlots_secondary);  
    end
    
    %get values to normalize plots base on file's name, which contains
    %boundary conditions information
%     posOf_=strfind(fileName,'_');
%     PPs=str2num(fileName(1:posOf_(1)-1));
%     NC_mass_fraction=fileName(posOf_(4)+1:posOf_(5)-1);
     
    %read excel file
    [num,txt,data]=xlsread(path_readFile);


%remove empty spaces
    data(:,1)=deblank(data(:,1));

%find all values of all chosen parameters
    for o=1:parametersAmount
        %get data for currently processed parameter
        parameter=parameters2process{o};
        parameter_secondary=strcat(parameter,'_secondary');
        
        loc=strcmp(parameter,data(:,1));
        position=find(loc);
        paramValue_all=data(position(1):position(end),:);
        
        %get name of the file without suffixes
        file_name=fileName(1:end-21);
        %print primary pipe graph
        %different if parameters is for heat structure
        if strcmp(parameter,'htvat') 
            paramValue_primarypipe=cell2mat(paramValue_all(1:95,3:end));
            paramValue_secondarypipe=cell2mat(paramValue_all(96:145,3:end));
        elseif strcmp(parameter,'htrnr')
            paramValue_primarypipe=cell2mat(paramValue_all(1:2:190,3:end));
        else
            paramValue_primarypipe=cell2mat(paramValue_all(1:95,3:end));
            paramValue_secondarypipe=cell2mat(paramValue_all(96:147,3:end));
        end
        
        %from to are set to last, to plot only last plot
        from=numel(paramValue_primarypipe(1,:));
        to=numel(paramValue_primarypipe(1,:));
        
        %prepare list of files for plotting legend
                 
        file_list_plot{n}=file_name;
        file_list_plot_clear=strrep(file_list_plot, '_',' ');
        
        %get sat temp at inlet for tempf and tempg processing
        if strcmp(parameter,'sattemp')
        sat_temp_inlet=paramValue_primarypipe(1,to);
        end
        
        %plot & save to workspace
 %       for m=from:to
            
            %normalize if tempg tempf or p against TPs or P respectively
%              if strcmp(parameter,'tempg') || strcmp(parameter,'tempf')
                             
                command1=strcat(parameter,'{n,1}=file_name;'); 
                command2=strcat(parameter,'{n,2}=paramValue_primarypipe;'); %/sat_temp_inlet;');%'-sat_temp_inlet;');
                eval(command1);
                eval(command2);     
                
                command3=strcat(parameter_secondary,'{n,1}=file_name;'); 
                command4=strcat(parameter_secondary,'{n,2}=paramValue_secondarypipe;'); %/sat_temp_inlet;');%'-sat_temp_inlet;');
                eval(command3);
                eval(command4);     
                 
%              elseif strcmp(parameter,'p')       
%                 
%                 command1=strcat(parameter,'{n,1}=file_name;'); 
%                 command2=strcat(parameter,'{n,2}=paramValue_primarypipe;'); %/paramValue_primarypipe(1,m);');%'-PPs*10^5;');
%                 eval(command1);
%                 eval(command2);
%                 
%              elseif strcmp(parameter,'htvat')       
%                 
%                 command1=strcat(parameter,'{n,1}=file_name;'); 
%                 command2=strcat(parameter,'{n,2}=paramValue_primarypipe;'); %/sat_temp_inlet;');%'-PPs*10^5;');
%                 eval(command1);
%                 eval(command2);
%                
%              else
%                  
%                 command1=strcat(parameter,'{n,1}=file_name;'); 
%                 command2=strcat(parameter,'{n,2}=paramValue_primarypipe;'); 
%                 eval(command1);
%                 eval(command2);
%                 
%              end
            
 %       end
    end


cd 'D:\Data\Relap5\2015ClosedTubeSimulatorHeater\'
end

%% Primary Side Plot
%plot results on graphs
for parameter_counter=1:parametersAmount
    
    printed_parameter=parameters2process{parameter_counter};
      
    fx=figure('visible','off');
%     if strcmp(printed_parameter,'tempg')
%         xlabel('gas Temp'); %sat temp at inlet');
%     elseif strcmp(printed_parameter,'tempf')
%         xlabel('liquid Temp');% - sat temp at inlet');
%     elseif strcmp(printed_parameter,'p')
%         xlabel('pressure'); %pressure at inlet');
%     else
%         xlabel(printed_parameter);
%     end
%     ylabel('pipe length [mm]');
    
    %hold on

    %plotting loop, goes through all files
    for plot_counter=1:n
        fx=figure('visible','off');
        current_file_name=file_list_plot(plot_counter);
        current_file_name_char=[current_file_name{1}(1:end)];
        path_print=strcat(directoryname,'\Plots\',printed_parameter,current_file_name_char);
        command_size=strcat('size(',printed_parameter,'{plot_counter,2})');
        parameter_size=eval(command_size);
        Time=(6:6:parameter_size(2)*6);
        pipeLength=(10:20:((parameter_size(1)-1)*20)+10);
        command_plot=strcat('imagesc(Time,pipeLength,',printed_parameter,'{plot_counter,2}); colorbar;');
        eval(command_plot);
        set(gca,'YDir','normal')
%        command3=strcat('plot(',printed_parameter,'{plot_counter,2},pipeLength,''Color'',rand(1,3));');
%        eval(command3);
%-------------------------------------------------------------------------------------------------
%        PLOTTING COMMAND:  surf(Time,pipeLength,p{plot_counter,2})
%                           imagesc(Time,pipeLength,tempg{plot_counter,2}); colorbar;
%                           set(gca,'YDir','normal')
%-------------------------------------------------------------------------------------------------
        print ('-dpng', path_print)
        close gcf
    
    end
%      %print to file
%      
     %legend(x,file_list_plot(plot_counter),'Location','SouthOutside')
%      print ('-dpng', path_print)
%      %close figure
%      hold off
%      close gcf
end

%% Secondary Side Plot

%% Primary Side Plot
%plot results on graphs
for parameter_counter_secondary=1:parametersAmount_secondary
    
    printed_parameter_secondary=parameters2process_secondary{parameter_counter_secondary};
        
    
%     fx=figure('visible','off');
%     if strcmp(printed_parameter_secondary,'tempg')
%         xlabel('gas Temp'); %sat temp at inlet');
%     elseif strcmp(printed_parameter_secondary,'tempf')
%         xlabel('liquid Temp');% - sat temp at inlet');
%     elseif strcmp(printed_parameter_secondary,'p')
%         xlabel('pressure'); %pressure at inlet');
%     else
%         xlabel(printed_parameter_secondary);
%     end
%     ylabel('pipe length [mm]');
    
    %hold on

    %plotting loop, goes through all files
    for plot_counter=1:n
        fx=figure('visible','off');
        
        current_file_name=file_list_plot(plot_counter);
        current_file_name_char=[current_file_name{1}(1:end)];
        path_print=strcat(directoryname,'\Plots\Secondary\',printed_parameter_secondary,current_file_name_char);
        command_size=strcat('size(',printed_parameter_secondary,'{plot_counter,2})');
        parameter_size=eval(command_size);
        Time=(6:6:parameter_size(2)*6);
        pipeLength=(10:20:((parameter_size(1)-1)*20)+10);
        command_plot=strcat('imagesc(Time,pipeLength,',printed_parameter_secondary,'{plot_counter,2}); colorbar;');
        eval(command_plot);
        set(gca,'YDir','normal')
%        command3=strcat('plot(',printed_parameter,'{plot_counter,2},pipeLength,''Color'',rand(1,3));');
%        eval(command3);
%-------------------------------------------------------------------------------------------------
%        PLOTTING COMMAND:  surf(Time,pipeLength,p{plot_counter,2})
%                           imagesc(Time,pipeLength,tempg{plot_counter,2}); colorbar;
%                           set(gca,'YDir','normal')
%-------------------------------------------------------------------------------------------------
        print ('-dpng', path_print)
        close gcf
    
    end
%      %print to file
%      
     %legend(x,file_list_plot(plot_counter),'Location','SouthOutside')
%      print ('-dpng', path_print)
%      %close figure
%      hold off
%      close gcf
end