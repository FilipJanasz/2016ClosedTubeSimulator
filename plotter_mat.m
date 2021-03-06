function plotter_mat(default_dir,sequence,firstInSeq)

    starting_column=3;  %for some reason sometimes needs to be 2, sometimes 3

    if ~sequence
    userChoice=menu('Choose your processing option','Point to a directory and process all .mat within it and all subdirectories', 'Point to a file');   

    %% get paths to files
        if userChoice==1
            %creates a lists of files in a chosen folder, based on a desired
            %string in the name
            [directory, processed_files_list]=fileFinder('processed',1,default_dir,1);

        elseif userChoice==2

                [processed_files_list,directory,~] = uigetfile('*.mat','Choose .r file to process','MultiSelect','on');  
    %             processed_files_list=cellfun(@(x)regexp(x,'processed'),processed_files_list,'UniformOutput', false);
                if ~iscell(processed_files_list)
                    processed_files_list={processed_files_list};
                end
                directory={directory};
        end
    else
        [directory, processed_files_list]=fileFinder('processed',1,default_dir,firstInSeq);
    end

    %define the number of files to process
    number_of_processed_files=numel(processed_files_list);

    %define parameters to be plotted
    parameters2process={'sattemp','tempf','tempg','p','quala','rho','floreg','velg','velf','htvat','voidg','htrnr','vapgen','tmassv','qualan1'};
    parameters2process_secondary={'tempf_secondary','p_secondary','vapgen_secondary','htvat_secondary'};
    parametersAmount=numel(parameters2process);  
    parametersAmount_secondary=numel(parameters2process_secondary);


    %n_file counts only correct mat files        
    n_file=0; 
    
    %open figure used for plotting
    fx=figure('visible','off');

    %% Based of parameters2process variable, extract desired parameters from results files
    for n=1:number_of_processed_files

        clear num txt raw loc position data horz_tub_pos tempf_primarypipe fileName TPs PPs tmass tmass_mat Time Time_mat
        fileName=processed_files_list{n};
%         fileName=fileName(1:end-4); %removes empty sign at the beginning (\n)
        disp(['Reading data from file: ',fileName])

        % there's another .mat file in the directory which is not with results
        % data, so this if clause ignores it
        if ~strcmp(fileName,'nodalization')

            n_file=n_file+1;
            directory_mat=cell2mat(directory(n));

            %define paths to files and to plots
            path_readFile=[directory_mat,'\',cell2mat(processed_files_list(n))]; %define path for reading current file
            pathPlots{n_file}=[directory_mat,'\Plots'];
            pathPlots_secondary{n_file}=[directory_mat,'\Plots\Secondary'];
            pathPlots_horz{n_file}=[directory_mat,'\Plots\Horizontal'];
            pathPlots_init{n_file}=[directory_mat,'\Plots\Initial_cond'];

            %read nodalization!
            temp_nod=load([directory_mat,'\nodalization.mat']);
            nodalization=temp_nod.nodalization;
            horz_tube_amount(n_file)=nodalization{5,2};
            heater_tank_height(n_file)=nodalization{1,2}+nodalization{2,2};
            condenser_start(n_file)= heater_tank_height(n_file)+nodalization{6,2};
            pipe_unit_length(n_file)=nodalization{7,2}*1000;

            %create directories for plots if the don't exist
            if exist(pathPlots{n_file},'dir')~=7
                mkdir(pathPlots{n_file});  
            end
            if exist(pathPlots_secondary{n_file},'dir')~=7
                mkdir(pathPlots_secondary{n_file});  
            end
            if exist(pathPlots_horz{n_file},'dir')~=7
                mkdir(pathPlots_horz{n_file});  
            end        
            if exist(pathPlots_init{n_file},'dir')~=7
                mkdir(pathPlots_init{n_file});  
            end

            temp_data=load(path_readFile);
            data=temp_data.varFull;

            %remove empty spaces
            data(:,1)=deblank(data(:,1));

            %get name of the file without suffixes
            file_name=fileName(1:end-21);
            %print primary pipe graph
            %different if parameters is for heat structure
            %BASED on nodalization.mat, figure out which values are for
            %primary side or secondary side values
            tube_vol=nodalization{1,2}+nodalization{2,2}+nodalization{3,2};   % -2 because no adiabatic heat structure XXXXXXXXXXXXXXXXXXXXXX

            %if there are horizontal tube divisions, find their posisition
    %         horz_tub_pos=zeros(nodalization{5,2});
            if nodalization{5,2}>1
                for horz_tube_ctr=1:nodalization{5,2}
    %           for horz_tube_ctr=2:nodalization{5,2}
    %                 horz_tub_pos(horz_tube_ctr-1)=tube_vol+1+(horz_tube_ctr-2)*(nodalization{3,2});
                    horz_tub_pos(horz_tube_ctr)=nodalization{1,2}+nodalization{2,2}+1+(horz_tube_ctr-1)*(nodalization{3,2});
                end
            end

            ss_start_vol=nodalization{1,2}+nodalization{2,2}+nodalization{3,2}*nodalization{5,2}+2;
            ss_end_vol=ss_start_vol+nodalization{4,2}-1;

            if nodalization{5,2}<3
                tube_vol_heatstr=nodalization{1,2}+nodalization{2,2}+nodalization{3,2};
                ss_start_heatstr=tube_vol_heatstr+1; % -2 because no adiabatic heat structure XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            else
                tube_vol_heatstr=nodalization{1,2}+nodalization{2,2}+nodalization{3,2};
                ss_start_heatstr=nodalization{1,2}+nodalization{2,2}+nodalization{3,2}*2+2;
            end

            ss_end_heatstr=ss_start_heatstr+nodalization{4,2}-1;

            %find all values of all chosen parameters
            for o=1:parametersAmount
                %get data for currently processed parameter
                parameter=parameters2process{o};
                parameter_secondary=[parameter,'_secondary'];
                parameter_horztube=[parameter,'_horztube'];

                loc=strcmp(parameter,data(:,1));
                position=find(loc);
                %verify that said parameters data is present
                if ~isempty(position)
                    paramValue_all=data(position(1):position(end),:);

                    % depending on which parameter, and nodalization, find values for given parameters     
                    if strcmp(parameter,'htvat') 
                        paramValue_primarypipe=cell2mat(paramValue_all(1:tube_vol_heatstr,starting_column:end));
                        paramValue_secondarypipe=cell2mat(paramValue_all((ss_start_heatstr-1):(ss_end_heatstr-1),starting_column:end));
                    elseif strcmp(parameter,'htrnr')
                        paramValue_primarypipe=cell2mat(paramValue_all(1:2:(2*tube_vol),starting_column:end));
                        paramValue_secondarypipe=cell2mat(paramValue_all((2*tube_vol+1):2:(2*tube_vol+2*nodalization{4,2}),starting_column:end));
                    elseif strcmp(parameter,'tmassv')
                        paramValue_primarypipe=cell2mat(paramValue_all(1:tube_vol,starting_column:end));  
                        if nodalization{5,2}>1
                            command_inter='paramValue_horztube_interleaved=reshape([';
                            for horztube_counter=1:numel(horz_tub_pos)
                                paramValue_horztube{horztube_counter}=cell2mat(paramValue_all(horz_tub_pos(horztube_counter):(horz_tub_pos(horztube_counter)+nodalization{3,2}-1),starting_column:end));
                                command_inter=[command_inter,'paramValue_horztube{',num2str(horztube_counter),'};'];
                            end

                            command_inter=[command_inter,'],',num2str(nodalization{3,2}),',[]);'];   % 30 - two times the number of vertical volumes
                            eval(command_inter);
                        end
                    else
                        paramValue_primarypipe=cell2mat(paramValue_all(1: tube_vol,starting_column:end));
                        paramValue_secondarypipe=cell2mat(paramValue_all(ss_start_vol:ss_end_vol,starting_column:end));                
                        if nodalization{5,2}>1
                            command_inter='paramValue_horztube_interleaved=reshape([';
                            for horztube_counter=1:numel(horz_tub_pos)
                                paramValue_horztube{horztube_counter}=cell2mat(paramValue_all(horz_tub_pos(horztube_counter):(horz_tub_pos(horztube_counter)+nodalization{3,2}-1),starting_column:end));
                                command_inter=[command_inter,'paramValue_horztube{',num2str(horztube_counter),'};'];
                            end

                            command_inter=[command_inter,'],',num2str(nodalization{3,2}),',[]);'];   % 30 - two times the number of vertical volumes
                            eval(command_inter);
                        end
                    end

                    %from to are set to last, to plot only last plot
                    from=numel(paramValue_primarypipe(1,:));
                    to=numel(paramValue_primarypipe(1,:));

                    %prepare list of files for plotting legend

                    file_list_plot{n_file}=file_name;
                    file_list_plot_clear=strrep(file_list_plot, '_',' ');

                    %plot & save to workspace

                    command1=[parameter,'{n_file,1}=file_name;']; 
                    command2=[parameter,'{n_file,2}=paramValue_primarypipe;']; %/sat_temp_inlet;');%'-sat_temp_inlet;');
                    eval(command1);
                    eval(command2);     

                    command3=[parameter_secondary,'{n_file,1}=file_name;']; 
                    command4=[parameter_secondary,'{n_file,2}=paramValue_secondarypipe;']; %/sat_temp_inlet;');%'-sat_temp_inlet;');
                    eval(command3);
                    eval(command4);    

                    if nodalization{5,2}>1
                        command5=[parameter_horztube,'{n_file,1}=file_name;']; 
                        command6=[parameter_horztube,'{n_file,2}=paramValue_horztube_interleaved;']; %/sat_temp_inlet;');%'-sat_temp_inlet;');
                        eval(command5);
                        eval(command6); 
                    end
                else
                    %if no values were found for the parameter, delete it
                    %from the processing list
                    parameters2process(o)=[];
                    parametersAmount=parametersAmount-1;
                end
            end

            %% Define x-axis for plots - time 

            %if clause below gets x data from time stored in output file
            time_row_no=1302;
            if strcmp(data(time_row_no,1),'time')
                Time=data(time_row_no,starting_column:end);
            else
                time_pos = find(cellfun(@(x) any(strcmp(x,'time')),data));
                Time=data(time_pos,starting_column:end);
                disp('position of time cell has changed - for performance adjust line 208 in plotter.mat');
                disp(['for time_row_no use the following position: ',num2str(time_pos)]);              
            end

            for celmat_time=1:numel(Time)
                Time_mat(celmat_time)=cell2mat(Time(celmat_time));
            end
            Time_mat_cell{n_file}=Time_mat;

        %% Check and plot mass balance
            tmass_row_no=1303;
            if strcmp(data(tmass_row_no,1),'tmass')
                tmass=data(tmass_row_no,starting_column:end);
            else
                tmass_pos = find(cellfun(@(x) any(strcmp(x,'tmass')),data));
                tmass=data(tmass_pos,starting_column:end);
                disp('position of tmass cell has changed - for performance adjust line 217 in plotter.mat');
                disp(['for tmass_row_no use the following position: ',num2str(tmass_pos)]);       
            end


            for tmass_time=1:numel(tmass)
                tmass_mat(tmass_time)=cell2mat(tmass(tmass_time));
            end
            tmass_mat_cell{n_file}=tmass_mat;


            %plot for each file
            disp('Plotting mass balance')
            %fx=figure('visible','off');
            colormap(fx,jet)
            current_file_name=file_list_plot(n_file);
            current_file_name_char=[current_file_name{1}(1:end)];
            path_print=[pathPlots{n_file},'\tmass_',current_file_name_char];
            plot(Time_mat_cell{n_file},tmass_mat_cell{n_file});
            xlabel('Time [s]')
            ylabel('Tmass [kg]')

            % set(gca,'YDir','normal')

            %-------------------------------------------------------------------------------------------------
            %        PLOTTING COMMAND:  surf(Time,pipeLength,p{plot_counter,2})
            %                           imagesc(Time,pipeLength,tempg{plot_counter,2}); colorbar;
            %                           set(gca,'YDir','normal')
            %-------------------------------------------------------------------------------------------------
            % print to file
%             print ('-dpng', path_print)
            saveas(fx,path_print,'png')
            %close(fx)
            cla(fx)
            

        end
    end


    %% Primary Side Plot
    %plot results on graphs
    disp('')
    disp('*********************************************')
    disp('Plotting primary side parameters')
    for parameter_counter=1:parametersAmount

        printed_parameter=parameters2process{parameter_counter};
        disp(['Plotting ',printed_parameter])
%         %fx=figure('visible','off');      
        %plotting loop, goes through all files
        for plot_counter=1:n_file
            clear p_avg
            %fx=figure('visible','off');
            colormap(fx,jet)
            current_file_name=file_list_plot(plot_counter);
            current_file_name_char=current_file_name{1}(1:end);
            path_print=[pathPlots{plot_counter},'\',printed_parameter,'_',current_file_name_char];
            command_size=['size(',printed_parameter,'{plot_counter,2})'];
            parameter_size=eval(command_size);

            pipeLength=(10:pipe_unit_length(plot_counter):((parameter_size(1)-1)*pipe_unit_length(plot_counter))+10);  %#ok<NASGU>
            command_plot=['imagesc(Time_mat_cell{plot_counter},pipeLength,',printed_parameter,'{plot_counter,2}); colorbar;'];
            eval(command_plot);
            xlabel('Time [s]')
            ylabel(printed_parameter)
            set(gca,'YDir','normal')


            hold on
            x1_prim=-0.5;
            x2_prim=Time_mat_cell{plot_counter}(end);
            y1_prim=heater_tank_height(plot_counter)*pipe_unit_length(plot_counter);
            y2_prim=y1_prim;

            y1_prim_2=condenser_start(plot_counter)*pipe_unit_length(plot_counter);
            y2_prim_2=y1_prim_2;

            line([x1_prim,x2_prim],[y1_prim,y2_prim],'Color',[1 1 1])    
            line([x1_prim,x2_prim],[y1_prim_2,y2_prim_2],'Color',[1 1 1])    
    %-------------------------------------------------------------------------------------------------
    %        PLOTTING COMMAND:  surf(Time,pipeLength,p{plot_counter,2})
    %                           imagesc(Time,pipeLength,tempg{plot_counter,2}); colorbar;
    %                           set(gca,'YDir','normal')
    %-------------------------------------------------------------------------------------------------
            % print to file
            saveas(fx,path_print,'png')
            %close(fx) %gcf
            cla(fx)
            hold off

            % additional mass balance only for primary side
             if strcmp(printed_parameter,'tmassv')
                tmassv_sum=sum(tmassv{plot_counter,2});
                %fx=figure('visible','off');             
                colormap(fx,jet)
                plot(Time_mat_cell{plot_counter},tmassv_sum)
                xlabel('Time [s]')
                ylabel('Primary side total mass [kg]')
                set(gca,'YDir','normal')
                path_print=[pathPlots{plot_counter},'\tmassv_sum_',current_file_name_char];
                saveas(fx,path_print,'png')
                %close(fx) % gcf
                cla(fx)

                % average p - maybe write this so average X is possible
             elseif strcmp(printed_parameter,'p')
                p_amount=size(p{plot_counter,2});
                for p_counter=1:p_amount(2)
                    p_avg(p_counter)=sum(p{plot_counter,2}(:,p_counter))/p_amount(1);
                end
                %fx=figure('visible','off');
                colormap(fx,jet)
                plot(Time_mat_cell{plot_counter},p_avg)
                xlabel('Time [s]')
                ylabel('Primary side avg press [Pa]')
                set(gca,'YDir','normal')
                path_print=[pathPlots{plot_counter},'\press_avg_',current_file_name_char];
                saveas(fx,path_print,'png')
                %close(fx) %gcf
                cla(fx)
            end

            %plot initial conditions
            %fx=figure('visible','off');
            current_file_name=file_list_plot(plot_counter);
            current_file_name_char=current_file_name{1}(1:end);
            path_print_init=[pathPlots_init{plot_counter},'\',printed_parameter,'_',current_file_name_char];
            command_size=['size(',printed_parameter,'{plot_counter,2})'];
            parameter_size=eval(command_size);

            pipeLength=(10:pipe_unit_length(plot_counter):((parameter_size(1)-1)*pipe_unit_length(plot_counter))+10); %#ok<NASGU>
            command_plot=['plot(',printed_parameter,'{plot_counter,2}(:,1),pipeLength);'];
            eval(command_plot);
            ylabel('Tube length [mm]')
            xlabel(printed_parameter)
            set(gca,'YDir','normal')
            saveas(fx,path_print_init,'png')
            %close(fx) %gcf
            cla(fx)
        end

    end

    %% Secondary Side Plot
    %plot results on graphs
    disp('')
    disp('*********************************************')
    disp('Plotting secondary side parameters')
    for parameter_counter_secondary=1:parametersAmount_secondary

        printed_parameter_secondary=parameters2process_secondary{parameter_counter_secondary};
        disp(['Plotting ',printed_parameter_secondary])
        %plotting loop, goes through all files
        for plot_counter=1:n_file
            %fx=figure('visible','off');
            colormap(fx,jet)
            current_file_name=file_list_plot(plot_counter);
            current_file_name_char=current_file_name{1}(1:end);
            path_print_secondary=[pathPlots_secondary{plot_counter},'\',printed_parameter_secondary,'_',current_file_name_char];
            command_size=['size(',printed_parameter_secondary,'{plot_counter,2})'];
            parameter_size=eval(command_size);

            pipeLength=(10:pipe_unit_length(plot_counter):((parameter_size(1)-1)*pipe_unit_length(plot_counter))+10); %#ok<NASGU>
            command_plot=['imagesc(Time_mat_cell{plot_counter},pipeLength,',printed_parameter_secondary,'{plot_counter,2}); colorbar;'];
            eval(command_plot);
            xlabel('Time [s]')
            ylabel(printed_parameter_secondary)
            set(gca,'YDir','normal')

    %-------------------------------------------------------------------------------------------------
    %        PLOTTING COMMAND:  surf(Time,pipeLength,p{plot_counter,2})
    %                           imagesc(Time,pipeLength,tempg{plot_counter,2}); colorbar;
    %                           set(gca,'YDir','normal')
    %-------------------------------------------------------------------------------------------------
            % print to file
            saveas(fx,path_print_secondary,'png')
            %close(fx) %gcf
            cla(fx)

        end

    end

    %% Horizontal plot
    disp('')
    disp('*********************************************')
    disp('Plotting primary side parameters - horizontal')
    for parameter_counter=1:parametersAmount

        printed_parameter=parameters2process{parameter_counter};
        disp(['Plotting ',printed_parameter])
        
        %plotting loop, goes through all files
        plot_counter=1;
        for a=1:n_file
                clear quala_avg 
                clear vapgen_sum
            if horz_tube_amount(plot_counter)>1            
                try
                %fx=figure('visible','off');
                colormap(fx,jet)
                current_file_name=file_list_plot(plot_counter);
                current_file_name_char=current_file_name{1}(1:end);
                path_print_horz=[pathPlots_horz{plot_counter},'\',printed_parameter,'_',current_file_name_char];
                command_size=['size(',printed_parameter,'_horztube{plot_counter,2})'];
                parameter_size=eval(command_size);

                %plot last n iteration steps
                last_n=5;  %XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                
                current_var_command=[printed_parameter,'_horztube{plot_counter,2}'];
                current_var=eval(current_var_command);
                %verify there's enough data for last_n iteration to be
                %displayed
                [~,dataArrWidth]=size(current_var);
                if last_n>dataArrWidth/2
                    last_n=dataArrWidth/2;
                end
                last_n_iter=current_var(:,(end-last_n*horz_tube_amount(plot_counter)+1):end);
                pipeLength=(10:pipe_unit_length(plot_counter):((parameter_size(1)-1)*pipe_unit_length(plot_counter))+10); %#ok<NASGU>
                imagesc(last_n_iter);
                colorbar;
                
                %add vertical lines between the separate snapshots
                hold on
                y1=0;
                y2=parameter_size(1)+0.5;

                for line_ctr=1:last_n %(parameter_size(2)/horz_tube_amount(plot_counter))
                    x1=horz_tube_amount(plot_counter)*line_ctr+0.5;
                    line([x1,x1],[y1,y2],'Color',[1 1 1])
                end
                
                %add labeling
                xlabel('Time [s]')
                ylabel(printed_parameter)
                set(gca,'YDir','normal')

        %-------------------------------------------------------------------------------------------------
        %        PLOTTING COMMAND:  surf(Time,pipeLength,p{plot_counter,2})
        %                           imagesc(Time,pipeLength,tempg{plot_counter,2}); colorbar;
        %                           set(gca,'YDir','normal')
        %-------------------------------------------------------------------------------------------------
                % print to file
                saveas(fx,path_print_horz,'png')
                
                %close(fx) %gcf
                cla(fx)
                hold off

        %         % additional mass balance only for primary side
        %          if strcmp(printed_parameter,'tmassv')
        %             tmassv_sum=sum(tmassv{plot_counter,2});
        %             %fx=figure('visible','off');
        %             colormap(fx,jet)
        %             plot(Time_mat_cell{plot_counter},tmassv_sum)
        %             xlabel('Time [s]')
        %             ylabel('Primary side total mass [kg]')
        %             set(gca,'YDir','normal')
        %             path_print=[pathPlots{plot_counter},'\tmassv_sum_',current_file_name_char);
        %             saveas(fx,path_print,'png')
        %             %close(fx) %gcf
        %         end
                catch ME
                    rethrow(ME)
                end

                %pritn avg NC fraction vs time for every file
                if strcmp(printed_parameter,'quala')
                    quala_size=size(current_var);

                    % since for every time step has n columns
                    % n=horz_tube_amount(plot_counter)
                    % it has to be summed and averaged for those n columns for
                    % each time step
                    % number of time steps is horizontal length of data matrix
                    % divided by columns number
                    for quala_counter=1:quala_size(2)/horz_tube_amount(plot_counter)
                        quala_sum=0;
                        % the second for loop sums over all the columns
                        % belonging to a single time step (starting at last)
                        for horz_cnt=1:horz_tube_amount(plot_counter)
                            summing_cnt=quala_counter*horz_tube_amount(plot_counter)-(horz_tube_amount(plot_counter)-horz_cnt);
                            quala_sum=quala_sum+sum(current_var(:,summing_cnt));
    %                         if quala_counter==1;
    %                             summing_cnt
    %                         end
                        end
                        quala_avg(quala_counter)=quala_sum/(horz_tube_amount(plot_counter)*quala_size(1));
                   end
                    %fx=figure('visible','off');
                    colormap(fx,jet)
                    plot(Time_mat_cell{plot_counter},quala_avg)
                    xlabel('Time [s]')
                    ylabel('Primary side avg NC quality')
                    set(gca,'YDir','normal')
                    path_print=[pathPlots{plot_counter},'\quala_avg_',current_file_name_char];
                    saveas(fx,path_print,'png')
                    %close(fx) %gcf
                    cla(fx)

                end

                %calculate and print integral vapgen vs time for every file
                %(only in test tube)
                 %pritn avg NC fraction vs time for every file
                if strcmp(printed_parameter,'vapgen')
                    vapgen_size=size(current_var);

                    % since for every time step has n columns
                    % n=horz_tube_amount(plot_counter)
                    % it has to be summed and averaged for those n columns for
                    % each time step
                    % number of time steps is horizontal length of data matrix
                    % divided by columns number
                    for vapgen_sum_counter=1:vapgen_size(2)/horz_tube_amount(plot_counter)
                        vapgen_sum_tmp=0;
                        % the second for loop sums over all the columns
                        % belonging to a single time step (starting at last)
                        for horz_cnt=1:horz_tube_amount(plot_counter)
                            vapgen_summing_cnt=vapgen_sum_counter*horz_tube_amount(plot_counter)-(horz_tube_amount(plot_counter)-horz_cnt);
                            vapgen_sum_tmp=vapgen_sum_tmp+sum(current_var(:,vapgen_summing_cnt));
    %                         if quala_counter==1;
    %                             summing_cnt
    %                         end
                        end
                        % 4.1563e-04 is tube volume in m3, and since vapgen is in
                        % kg/m3.s, then mupltiplying by volume leaves us with
                        % kg/s - comparable to experiment
                        vapgen_sum(vapgen_sum_counter)=vapgen_sum_tmp*4.1563e-04;
                   end
                    %fx=figure('visible','off');
                    colormap(fx,jet) 
                    plot(Time_mat_cell{plot_counter},vapgen_sum)
                    xlabel('Time [s]')
                    ylabel('Total vapour generation rate')
                    set(gca,'YDir','normal')
                    path_print=[pathPlots{plot_counter},'\vapgen_sum_',current_file_name_char];
                    saveas(fx,path_print,'png')
                    %close(fx) %gcf
                    cla(fx)

                end

            end
        plot_counter=plot_counter+1;
        end
    end
    disp('*********************************************')
    disp('Plotting finished')

end