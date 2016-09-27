function plotter_mat_fun(directory,processed_files_list)

    starting_column=3;  %for some reason sometimes needs to be 2, sometimes 3

    %define the number of files to process
       number_of_processed_files=numel(processed_files_list);

    %define parameters to be plotted
        parameters2process={'sattemp','tempf','tempg','p','vapgen','quala','rho','floreg','velg','velf','htvat','voidg','htrnr','tmassv'};
        parameters2process_secondary={'tempf_secondary','p_secondary','vapgen_secondary','htvat_secondary'};
        parametersAmount=numel(parameters2process);  
        parametersAmount_secondary=numel(parameters2process_secondary);


    for n=1:number_of_processed_files

        clear num txt raw loc position data tempf_primarypipe fileName TPs PPs tmass tmass_mat Time Time_mat
        fileName=processed_files_list{n};
        fileName=fileName(1:end-4); %removes empty sign at the beginning (\n)

        directory_mat=cell2mat(directory(n));

        current_file=cell2mat(processed_files_list(n));
        current_file=[current_file(1:end-2),'_processed_for_Matlab.mat'];
        %define paths to files and to plots
        path_readFile=strcat(directory_mat,'\',current_file); %define path for reading current file
        pathPlots{n}=strcat(directory_mat,'\Plots');
        pathPlots_secondary{n}=strcat(directory_mat,'\Plots\Secondary');

        %create directory Plots if it does not exist
        if exist(pathPlots{n},'dir')~=7
            mkdir(pathPlots{n});  
        end
        if exist(pathPlots_secondary{n},'dir')~=7
            mkdir(pathPlots_secondary{n});  
        end

        temp_data=load(path_readFile);
        data=temp_data.varFull;

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
                paramValue_primarypipe=cell2mat(paramValue_all(1:95,starting_column:end));
                paramValue_secondarypipe=cell2mat(paramValue_all(96:145,starting_column:end));
            elseif strcmp(parameter,'htrnr')
                paramValue_primarypipe=cell2mat(paramValue_all(1:2:190,starting_column:end));
                paramValue_secondarypipe=cell2mat(paramValue_all(191:2:290,starting_column:end));
            elseif strcmp(parameter,'tmassv')
                paramValue_primarypipe=cell2mat(paramValue_all(1:95,starting_column:end));
            else
                paramValue_primarypipe=cell2mat(paramValue_all(1:95,starting_column:end));
                paramValue_secondarypipe=cell2mat(paramValue_all(96:147,starting_column:end));
            end

            %from to are set to last, to plot only last plot
            from=numel(paramValue_primarypipe(1,:));
            to=numel(paramValue_primarypipe(1,:));

            %prepare list of files for plotting legend

            file_list_plot{n}=file_name;
            file_list_plot_clear=strrep(file_list_plot, '_',' ');

            %plot & save to workspace

            command1=strcat(parameter,'{n,1}=file_name;'); 
            command2=strcat(parameter,'{n,2}=paramValue_primarypipe;'); %/sat_temp_inlet;');%'-sat_temp_inlet;');
            eval(command1);
            eval(command2);     

            command3=strcat(parameter_secondary,'{n,1}=file_name;'); 
            command4=strcat(parameter_secondary,'{n,2}=paramValue_secondarypipe;'); %/sat_temp_inlet;');%'-sat_temp_inlet;');
            eval(command3);
            eval(command4);     
        end

        cd 'D:\Data\Relap5\2015ClosedTubeSimulatorHeater\'

    

        %% Define x-axis for plots - time 

        %if clause below gets x data from time stored in output file
        if strcmp(data(7669,1),'time')
            Time=data(7669,starting_column:end);
        else
            time_pos = find(cellfun(@(x) any(strcmp(x,'time')),data));
            Time=data(time_pos,starting_column:end);
            disp('position of time cell has changed - for performance adjust line 217 in plotter.mat');
            disp('instead of 4094 use the following position: ');
            time_pos
        end

        for celmat_time=1:numel(Time)
            Time_mat(celmat_time)=cell2mat(Time(celmat_time));
        end
        Time_mat_cell{n}=Time_mat;


        %% Check and plot mass balance

        if strcmp(data(7670,1),'tmass')
            tmass=data(7670,starting_column:end);
        else
            tmass_pos = find(cellfun(@(x) any(strcmp(x,'tmass')),data));
            tmass=data(tmass_pos,starting_column:end);
            disp('position of tmass cell has changed - for performance adjust line 217 in plotter.mat');
            disp('instead of 4095 use the following position: ');
            tmass_pos
        end


        for tmass_time=1:numel(tmass)
            tmass_mat(tmass_time)=cell2mat(tmass(tmass_time));
        end
        tmass_mat_cell{n}=tmass_mat;
        %plot for each file

        fx=figure('visible','off');
        colormap(fx,jet)
        current_file_name=file_list_plot(n);
        current_file_name_char=[current_file_name{1}(1:end)];
        path_print=strcat(pathPlots{n},'\tmass_',current_file_name_char);
        plot(Time_mat_cell{n},tmass_mat_cell{n});
        xlabel('Time [s]')
        % set(gca,'YDir','normal')

        %-------------------------------------------------------------------------------------------------
        %        PLOTTING COMMAND:  surf(Time,pipeLength,p{plot_counter,2})
        %                           imagesc(Time,pipeLength,tempg{plot_counter,2}); colorbar;
        %                           set(gca,'YDir','normal')
        %-------------------------------------------------------------------------------------------------
        % print to file
        print ('-dpng', path_print)
        close gcf
    end
 
%% Primary Side Plot
%plot results on graphs
for parameter_counter=1:parametersAmount

    printed_parameter=parameters2process{parameter_counter};

    fx=figure('visible','off');

    %plotting loop, goes through all files
    for plot_counter=1:n
        fx=figure('visible','off');
        colormap(fx,jet)
        current_file_name=file_list_plot(plot_counter);
        current_file_name_char=[current_file_name{1}(1:end)];
        path_print=strcat(pathPlots{plot_counter},'\',printed_parameter,'_',current_file_name_char);
        command_size=strcat('size(',printed_parameter,'{plot_counter,2})');
        parameter_size=eval(command_size);


        pipeLength=(10:20:((parameter_size(1)-1)*20)+10);
        command_plot=strcat('imagesc(Time_mat,pipeLength,',printed_parameter,'{plot_counter,2}); colorbar;');
        eval(command_plot);
        xlabel('Time [s]')
        set(gca,'YDir','normal')

%-------------------------------------------------------------------------------------------------
%        PLOTTING COMMAND:  surf(Time,pipeLength,p{plot_counter,2})
%                           imagesc(Time,pipeLength,tempg{plot_counter,2}); colorbar;
%                           set(gca,'YDir','normal')
%-------------------------------------------------------------------------------------------------
        % print to file
        print ('-dpng', path_print)
        close gcf
        % additional mass balance only for primary side
         if strcmp(printed_parameter,'tmassv')
            tmassv_sum=sum(tmassv{plot_counter,2});
            fx=figure('visible','off');
            colormap(fx,jet)
            plot(Time_mat_cell{plot_counter},tmassv_sum)
            xlabel('Time [s]')
            ylabel('Primary side total mass [kg]')
            set(gca,'YDir','normal')
            path_print=strcat(pathPlots{plot_counter},'\tmassv_sum_',current_file_name_char);
            print ('-dpng', path_print)
            close gcf
         end

    end

end

%% Secondary Side Plot
%plot results on graphs
for parameter_counter_secondary=1:parametersAmount_secondary

    printed_parameter_secondary=parameters2process_secondary{parameter_counter_secondary};

    %plotting loop, goes through all files
    for plot_counter=1:n
        fx=figure('visible','off');
        colormap(fx,jet)
        current_file_name=file_list_plot(plot_counter);
        current_file_name_char=[current_file_name{1}(1:end)];
        path_print=strcat(pathPlots_secondary{plot_counter},'\',printed_parameter_secondary,'_',current_file_name_char);
        command_size=strcat('size(',printed_parameter_secondary,'{plot_counter,2})');
        parameter_size=eval(command_size);

        pipeLength=(10:20:((parameter_size(1)-1)*20)+10);
        command_plot=strcat('imagesc(Time_mat,pipeLength,',printed_parameter_secondary,'{plot_counter,2}); colorbar;');
        eval(command_plot);
        xlabel('Time [s]')
        set(gca,'YDir','normal')

%-------------------------------------------------------------------------------------------------
%        PLOTTING COMMAND:  surf(Time,pipeLength,p{plot_counter,2})
%                           imagesc(Time,pipeLength,tempg{plot_counter,2}); colorbar;
%                           set(gca,'YDir','normal')
%-------------------------------------------------------------------------------------------------
        % print to file
        print ('-dpng', path_print)
        close gcf

    end

end

