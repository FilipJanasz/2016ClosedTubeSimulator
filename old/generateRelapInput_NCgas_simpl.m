%% clear and call files to find out location on disk
clear all, close all, clc

setPaths

cd(default_dir)

%% INPUT----------------------------------------------------

    %input format: MIN value : step MAX value
    %example  0:5:10 results in vector [0,5,10]
    
    %Primary side - initial conditions  ********************************************************************************
    
    Pps=[1];                %Initial pressure [Bar]
%     NC=[0,0.1,0.5,0.9];               %Non condensable mole fr (quality in relap)
    NC=[0.15];               %Non condensable mole fr (quality in relap)
    Helium=[0];             %Mole fraction of Helium in NC mixture
    
    %Secondary side - initial and operating conditions ********************************************************************************
    Pss=[2];
    Superheat=[5];  %T_secondary_side = T_primary_side(Pressure_primary_side) - superheat
    Mflowss=[2000];  %secondary side mass flow [kg/h]
    
    %Heater ********************************************************************************
    Power=[100]; % [W]
    
    %Timing
    action_start=10; %[s] - when coolant water will start to flow and when heater will start to heat
    action_start=num2str(action_start);
    
    %Condensing tube geometry
    condenser_length=1.3; 
    adiabatic_part_of_condenser=0.3;
    tube_inner_diam=0.021;
    tube_outer_diam=0.03;
    condenser_vol=pi*tube_inner_diam*condenser_length;
    
    %heater tank geometry
    heater_length=0.6;
%     heater_diam_inner=0.021;
%     heater_diam_outer=0.03;
    heater_diam_inner=0.0837;
    heater_diam_outer=0.0889;
    
    %"nodaliyation" of geometry
    amount_of_heater_tube_parts=30;
    amount_of_heating_coils=10;
    amount_of_tube_parts=65;
    
    %coolant jacket geometry
    jacket_diam_inner=0.1091;
    jacket_diam_outer=0.1143;
    
    
    %Relap Calculation parameters
    endtime='400000.';
    mindt='1.e-12';
    maxdt='5e-2';
    minor='50000';
    major='100000';
    restart='100000';
    
    %Properties
    molar_mass_h2o=18.01528;
    molar_mass_He=4.0026;
    molar_mass_N2=28;


%% Pre-test calculations

    %heater
        heater_area=pi*heater_diam_outer*heater_length;
        heater_cross_section=pi*(heater_diam_inner/2)^2;
        radius_heater_inner=num2str(heater_diam_inner/2);
        radius_heater_outer=num2str(heater_diam_outer/2);
        Heatflux=Power/heater_area;
     
    %change pressure from bar to Pa
        Pps=Pps*1e5;
        Pss=Pss*1e5;
    
    %geometry nodalizazion
    % num2str is important when writing values with fprintf
        amount_of_insulators=amount_of_heater_tube_parts-amount_of_heating_coils;
        insulators_starting_volume=num2str(110010000+10000*amount_of_heating_coils);
        heater_part_length=num2str(heater_length/amount_of_heater_tube_parts);
        heater_length=num2str(heater_length);
        
        pipe_part_length=num2str(condenser_length/amount_of_tube_parts);
        amount_of_adiabatic_parts=(adiabatic_part_of_condenser/(condenser_length/amount_of_tube_parts));
        condenser_starting=num2str(125010000+10000*amount_of_adiabatic_parts);
        radius_inner=num2str(tube_inner_diam/2);
        radius_outer=num2str(tube_outer_diam/2);
        condens_tube_cross_section=num2str(pi*(tube_inner_diam/2)^2);
   
        
   %change part numbering to strings
       heater_minus_one=num2str(amount_of_heater_tube_parts-1);
       amount_of_heaters=num2str(amount_of_heating_coils);
       amount_of_heater_tube_parts=num2str(amount_of_heater_tube_parts);
       amount_of_insulators_parts=num2str(amount_of_insulators);

       tube_minus_one=num2str(amount_of_tube_parts-1);
       amount_of_condensation_parts=num2str(amount_of_tube_parts-amount_of_adiabatic_parts);
       amount_of_tube_parts=num2str(amount_of_tube_parts);
       
       adiabatic_minus_one=num2str(amount_of_adiabatic_parts-1);
       amount_of_adiabatic_parts=num2str(amount_of_adiabatic_parts);

             
   %cooling jacket
        radius_jacket_inner=num2str(jacket_diam_inner/2);
        radius_jacket_outer=num2str(jacket_diam_outer/2);
        cooling_cross_section=num2str(pi*((jacket_diam_inner/2)^2-(tube_outer_diam/2)^2));
        jacket_diam_inner_string=num2str(jacket_diam_inner);
        jacket_diam_outer_string=num2str(jacket_diam_outer);
        cross_section_jacket=num2str(pi*(jacket_diam_inner/2)^2);
    
    %Counters
        counterFilename=1;          %used for writing all the file names in one txt file
        amountPps=length(Pps);
        amountPss=length(Pss);
        amountHeatflux=length(Heatflux);
        amountSuperheat=length(Superheat);
        amountMflowss=length(Mflowss);
        amountNC=length(NC);
        amountHelium=length(Helium);
        amount_total=amountPps*amountPss*amountHeatflux*amountSuperheat*amountMflowss*amountNC*amountHelium;
        disp('Number of input decks:');
        disp(amount_total)

    %preallocate memory for filename txt file
        filename=zeros(amount_total);
    %open file to which list of input decks will be saved
        fid1 = fopen(path_to_decks_list,'at');


%% LOOPS

%Primary pressure loop
for Pps_count=1:amountPps;
    %Secondary pressure loop
    for Pss_count=1:amountPss
        %NC mole fraction loop
        for NC_count=1:amountNC;
            %NC composition loop
            for Helium_count=1:amountHelium
                %Heat flux loop
                for Heatflux_count=1:amountHeatflux
                    %Tunderheat loop
                    for Superheat_count=1:amountSuperheat
                        %Mflowss loop
                        for Mflowss_count=1:amountMflowss


                            clear uVsat uLsat
                            %calculate initial temperatures
                            %get saturation conditions
                            Tsat_p = IAPWS_IF97('Tsat_p',Pps(Pps_count)/1e6*(1-NC(NC_count)));
                            Tps=Tsat_p+10;
                            Theater=num2str(Tsat_p-10);
                            Tss=Tps-Superheat(Superheat_count);
                            %get values of parameters for this loop
                            %iteration

                            PrimaryPressure=num2str(Pps(Pps_count));
                            PrimaryTemp=num2str(Tps);
                            %three lines below ensure there's a decimal point - dot in the
                            %string somewhere
                            if isempty(strfind(PrimaryTemp,'.'))
                                PrimaryTemp(end+1)='.';
                            end
                            
                            SecondaryPressure=num2str(Pss(Pss_count));
                            SecondaryTemp=num2str(Tss(Superheat_count)); 
                            
                            if isempty(strfind(SecondaryTemp,'.'))
                                SecondaryTemp(end+1)='.';
                            end
                            
                            Heat_flux=num2str(Heatflux(Heatflux_count));
                            NC_gas=num2str(NC(NC_count));
                            NC_mole_fr=NC_gas;
                            NC_gas(NC_gas=='.')='';  %removes dots from string, so it can be used for file name
                            
                            Helium_content=num2str(Helium(Helium_count));
                            Nitrogen_content=num2str(1-Helium(Helium_count));
                            
                            Helium_content_name=Helium_content;
                            Helium_content_name(Helium_content_name=='.')='';  %removes dots from string, so it can be used for file name

                            
                            if isempty(strfind(Helium_content,'.'))
                                Helium_content(end+1)='.';
                            end
                            if isempty(strfind(Nitrogen_content,'.'))
                                Nitrogen_content(end+1)='.';
                            end
                            

                            %NC content 
                            h2o_mole_fraction=1-NC(NC_count);
                            Helium_mole_fraction=NC(NC_count)*Helium(Helium_count);
                            Nitrogen_mole_fraction=NC(NC_count)*(1-Helium_mole_fraction);
                            
                            %NC masses
                            avg_molar_mass_mixture=h2o_mole_fraction*molar_mass_h2o+Helium_mole_fraction*molar_mass_He+Nitrogen_mole_fraction*molar_mass_N2;
                            mass_fraction_h2o=molar_mass_h2o/avg_molar_mass_mixture*h2o_mole_fraction;
                            mass_fraction_Nitrogen=molar_mass_N2/avg_molar_mass_mixture*Nitrogen_mole_fraction;
                            mass_fraction_Helium=molar_mass_He/avg_molar_mass_mixture*Helium_mole_fraction;
                            
                            
                            
                            % specific internal energy calculation
                            % from Xsteam
                            uLsat = num2str(1000*XSteam('uL_p',Pps(Pps_count)/1e5*(1-NC(NC_count)))); % [J/kg] saturated liquid specific energy, input in Bar
                            
                            uVsat_h2o = 1000*XSteam('uV_p',Pps(Pps_count)/1e5*(1-NC(NC_count))); % [J/kg] saturated vapor specific energy, input in Bar
                            uVsat_N2=5/2*8.314*Tps/molar_mass_N2*1000; % [J/kg], using ideal gas equation for bi atomic gases
                            uVsat_He=3/2*8.314*Tps/molar_mass_He*1000; % [J/kg], using ideal gas equation for mono atomic gases
                            uVsat=uVsat_h2o*mass_fraction_h2o+uVsat_N2*mass_fraction_Nitrogen+uVsat_He*mass_fraction_Helium; % specific internal energy of mixture Engineering Thermodynamics, pg 378
                            % https://books.google.ch/books?id=MyHZAgAAQBAJ&pg=PA378&lpg=PA378&dq=specific+internal+energy+mixture&source=bl&ots=WhuzuoEpau&sig=x05hyJUzkTcBMHLgID3ho-JsZO8&hl=en&sa=X&ved=0CB4Q6AEwAGoVChMI09Co493TyAIVSZEsCh3tTAzO#v=onepage&q=specific%20internal%20energy%20mixture&f=false
%                             uVsat=num2str(uVsat-1000000);
                            if NC(NC_count) > 0
                                uVsat=uVsat*(1+0.5*NC(NC_count));
                            end
                            
                            uVsat=num2str(uVsat);

                            if isempty(strfind(uLsat,'.'))
                                uLsat(end+1)='.';
                            end
                            if isempty(strfind(uVsat,'.'))
                                uVsat(end+1)='.';
                            end

                            Helium_mole_fraction=num2str(Helium_mole_fraction);
                            Nitrogen_mole_fraction=num2str(Nitrogen_mole_fraction);


                            %remember to remove decimal points, because it screws the
                            %file saving to excel later

                            PrimaryPressure_withoutdots=num2str(Pps(Pps_count)/1e5);
                            PrimaryPressure_withoutdots(PrimaryPressure_withoutdots=='.')=[];

                            Heat_flux_withoutdots=num2str(floor(Heatflux(Heatflux_count)));
                            %Heat_flux_withoutdots(Heat_flux_withoutdots=='.')=[];

                            Mflow_secondary_hours=num2str(Mflowss(Mflowss_count));
                            Mflow_secondary_seconds=Mflowss(Mflowss_count)/3600;
                            PrimaryTemp_name=num2str(floor(Tps));
                            Superheat_name=num2str(floor(Superheat));
                            
                            %generate file name and path to file
                            fileName=strcat(PrimaryPressure_withoutdots,'_',PrimaryTemp_name,'_',NC_gas,'_',Helium_content_name,'_',Heat_flux_withoutdots,'_',Superheat_name,'_',Mflow_secondary_hours);                      %save file name WITHOUT extension
                            filePath=strcat(dirInput,PrimaryPressure_withoutdots,'_',PrimaryTemp_name,'_',NC_gas,'_',Helium_content_name,'_',Heat_flux_withoutdots,'_',Superheat_name,'_',Mflow_secondary_hours,'.i'); %create file path for current combination

                            %store filename in a matrix                          
                            fprintf(fid1,'%s\n',fileName);                         
                            counterFilename=counterFilename+1;

                            %WRITE INPUT DECK FILE 
                            fid = fopen(filePath, 'wt'); %open the file


                            heatstr1Temp=num2str(floor((Tps+Tss(Superheat_count))/2));                      %assume heatstructure temp to be an average of PS/SS temperatures [K]

                            %input file txt
                            fprintf(fid,'* title card\n'); 
                            fprintf(fid,'= simple pipe 1 + heat structures\n'); 
                            fprintf(fid,'*================================================================\n'); 
                            fprintf(fid,'* problem type   option\n'); 
                            fprintf(fid,'100       new    transnt\n'); 
                            fprintf(fid,'*================================================================\n'); 
                            fprintf(fid,'* input / output units\n'); 
                            fprintf(fid,'102 si *optional, default are si units\n'); 
                            fprintf(fid,'* Restart-Plot Control Card\n'); 
                            fprintf(fid,'104 ncmpress\n'); 
                            fprintf(fid,'*================================================================\n'); 
                            fprintf(fid,'*define non condensable gases\n');
                            fprintf(fid,'110 helium nitrogen\n');
                            fprintf(fid,'*================================================================\n');
                            fprintf(fid,'*define non condensable gases MASS FRACTIONS\n');
                            fprintf(fid,'*    helium  nitrogen\n');
                            fprintf(fid,'115 %s      %s\n',Helium_content, Nitrogen_content);                                   %****************************************************
                            fprintf(fid,'*================================================================\n');
                            fprintf(fid,'* Initial Time Value\n');
                            fprintf(fid,'200 0.\n');
                            fprintf(fid,'*================================================================\n');
                            fprintf(fid,'* time step control card\n');
                            fprintf(fid,'*   endtime  min.dt  max.dt  control  minor  major    restart\n');
                            fprintf(fid,'201 %s       %s      %s      0        %s     %s       %s\n', endtime, mindt, maxdt, minor, major,restart); %****************************************************
                            fprintf(fid,'*================================================================\n');
                            fprintf(fid,'* extra variables to print\n');
                            fprintf(fid,'*         var param\n');
%                             fprintf(fid,'20800001  tmass \n');
                            % for printing extra variables in heater and
                            % condenser
                            card_no=20800001;
                            heater_vol_no=110010000;
                            condenser_vol_no=125010000;
                            for heater_volume_counter=1:str2num(amount_of_heater_tube_parts)
                                fprintf(fid,'%s  tmassv %s \n', num2str(card_no), num2str(heater_vol_no));
                                card_no=card_no+1;
                                heater_vol_no=heater_vol_no+10000;
                            end
                            
                            for condenser_volume_counter=1:str2num(amount_of_tube_parts)
                                fprintf(fid,'%s  tmassv %s \n', num2str(card_no), num2str(condenser_vol_no));
                                card_no=card_no+1;
                                condenser_vol_no=condenser_vol_no+10000;
                            end
                            
                            fprintf(fid,'* component data\n');
                            fprintf(fid,'*----------------------------------------------------------------\n');

                            %******************** heater
                            fprintf(fid,'*-----------------------------------------------------------------INNER TEST PIPE\n');

                            fprintf(fid,'* component 110 - heater part of the pipe\n');
                            fprintf(fid,'*        name   type\n');
                            fprintf(fid,'1100000  pipe  pipe\n');
                            fprintf(fid,'*        no.volumes\n');
                            fprintf(fid,'1100001  %s \n', amount_of_heater_tube_parts);  
                            fprintf(fid,'*        area                             vol.no.\n');
                            fprintf(fid,'1100101  %s                               %s \n', heater_cross_section, amount_of_heater_tube_parts);
                            fprintf(fid,'*        length                           vol.no.\n');
                            fprintf(fid,'1100301  %s                               %s \n', heater_part_length, amount_of_heater_tube_parts);
                            fprintf(fid,'*        v-ang                            vol.no.\n');
                            fprintf(fid,'1100601  90.                              %s \n', amount_of_heater_tube_parts);
                            fprintf(fid,'*        rough   dhy                      vol.no.\n');
                            fprintf(fid,'1100801  0.      0.                       %s \n', amount_of_heater_tube_parts);
                            fprintf(fid,'*        tlpvbfe                          vol.no.\n');
                            fprintf(fid,'1101001  0001000                          %s \n', amount_of_heater_tube_parts);
                            fprintf(fid,'*        efvcahs                          jun.no.\n');
                            fprintf(fid,'1101101  0000000                          %s \n', heater_minus_one);              
%                                 fprintf(fid,'*        ebt  temperature  stat_qual       vol.no.\n');
%                                 fprintf(fid,'1101201  001  %s.      %s          0.  0. 0.   %s \n', PrimaryTemp,NC_mole_fr, amount_of_heater_tube_parts); %***************************************************
%                                 fprintf(fid,'*        ebt  pressure  stat_qual         vol.no.\n');
%                                 fprintf(fid,'1101201  002  %s.   0.     0.  0.  0.     %s \n',PrimaryPressure, amount_of_heater_tube_parts); %****************************************************
                            fprintf(fid,'*        ebt  pressure temperature        vol.no.\n');
                            fprintf(fid,'1101201  003  %s.      %s          0.  0. 0.   %s \n',PrimaryPressure, Theater, amount_of_heater_tube_parts); %***************************************************
%                                 fprintf(fid,'*        ebt  pressure temperature  stat_qual       vol.no.\n');
%                                 fprintf(fid,'1101201  004  %s.      %s.          0.01  0. 0.   %s \n',PrimaryPressure, PrimaryTemp, amount_of_heater_tube_parts); %***************************************************
                            fprintf(fid,'*        mass flow (=1)\n');
                            fprintf(fid,'1101300  1\n');
                            fprintf(fid,'*        flowf  flowg      velj           jun.no.\n');
                            fprintf(fid,'1101301  0.     0.         0.             %s \n', heater_minus_one);  %****************************************************

                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* component 120 - inlet junction\n');
                            fprintf(fid,'*        name   type\n');
                            fprintf(fid,'1200000  injun  sngljun\n');
                            fprintf(fid,'*        from       to         area  floss rloss  jefvcahs\n');
                            fprintf(fid,'1200101  %s  125010001  %s    0.    0.     00000000\n', num2str(heater_vol_no-10000+2), condens_tube_cross_section);    %*************************************************************
                            fprintf(fid,'*       junctionD  flooding  gasintercept     slope\n');
                            fprintf(fid,'1200110  0.         0.        1.               1.\n');
                            fprintf(fid,'*        ctl  velflowf  velflowg     interface velocity\n');
                            fprintf(fid,'1200201  0.   0.       0.             0.\n');             %****************************************************


                            %******************** tube (adiabatic part + condenser)
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* component 125 - heat exchanger part of the pipe\n');
                            fprintf(fid,'*        name   type\n');
                            fprintf(fid,'1250000  pipe  pipe\n');
                            fprintf(fid,'*        no.volumes\n');
                            fprintf(fid,'1250001  %s \n', amount_of_tube_parts);  
                            fprintf(fid,'*        area                             vol.no.\n');
                            fprintf(fid,'1250101  %s                               %s \n', condens_tube_cross_section, amount_of_tube_parts);
                            fprintf(fid,'*        length                           vol.no.\n');
                            fprintf(fid,'1250301  %s                               %s \n', pipe_part_length, amount_of_tube_parts);
                            fprintf(fid,'*        v-ang                            vol.no.\n');
                            fprintf(fid,'1250601  90.                              %s \n', amount_of_tube_parts);
                            fprintf(fid,'*        rough   dhy                      vol.no.\n');
                            fprintf(fid,'1250801  0.      0.                       %s \n', amount_of_tube_parts);
                            fprintf(fid,'*        tlpvbfe                          vol.no.\n');
                            fprintf(fid,'1251001  0001000                          %s \n', amount_of_tube_parts);
                            fprintf(fid,'*        efvcahs                          jun.no.\n');
                            fprintf(fid,'1251101  0000000                          %s \n', tube_minus_one);   
%                                 fprintf(fid,'*        ebt  press temp liq_spec_en vap_spec_en void_fr       vol.no.\n');
%                                 fprintf(fid,'1251201  000  %s.   %s       0.  0.  0.   %s \n',PrimaryTemp,NC_mole_fr, amount_of_condensation_parts); %****************************************************
%                                 fprintf(fid,'*        ebt  temperature  static_qual       vol.no.\n');
%                                 fprintf(fid,'1251201  001  %s.   %s       0.  0.  0.   %s \n',PrimaryTemp,NC_mole_fr, amount_of_condensation_parts); %****************************************************
%                                 fprintf(fid,'*        ebt  pressure  static_qual       vol.no.\n');
%                                 fprintf(fid,'1251201  002  %s.   %s       0.  0.  0.   %s \n',PrimaryPressure,NC_mole_fr, amount_of_condensation_parts); %****************************************************
%                                 fprintf(fid,'*        ebt  pressure temperature  stat_qual       vol.no.\n');
%                                 fprintf(fid,'1251201  004  %s.      %s.          %s  0. 0.   %s \n',PrimaryPressure, PrimaryTemp,NC_mole_fr,amount_of_condensation_parts); %***************
%                                 fprintf(fid,'1251201  004  %s.      %s.          0.0  0. 0.   %s \n',PrimaryPressure, PrimaryTemp, amount_of_condensation_parts); %***************
                            fprintf(fid,'*        ebt  pressure liq_int_en gas_int_en  gas_void NC_quality   vol.no.\n');
                            fprintf(fid,'1251201  006 %s. %s %s 1.0 %s %s \n',PrimaryPressure,uLsat,uVsat, NC_mole_fr, amount_of_tube_parts); %***************************************************
%                                 fprintf(fid,'*        ebt  pressure liq_temp gas_temp  gas_void NC_quality   vol.no.\n');
%                                 fprintf(fid,'1251201  008  %s.      %s.      %s.       0.9      %s           %s \n',PrimaryPressure, PrimaryTemp, PrimaryTemp,NC_mole_fr, amount_of_condensation_parts); %***************************************************
                            fprintf(fid,'*        mass flow (=1)\n');
                            fprintf(fid,'1251300  1\n');
                            fprintf(fid,'*        flowf  flowg      velj           jun.no.\n');
                            fprintf(fid,'1251301  0.     0.         0.             %s \n', tube_minus_one);  %****************************************************

                            fprintf(fid,'*----------------------------------------------------------------OUTER COOLING JACKET\n');
                            fprintf(fid,'* component 140 - inlet volume\n');
                            fprintf(fid,'*        name     type\n');
                            fprintf(fid,'1400000  inletC   tmdpvol\n');
                            fprintf(fid,'*        area    length  volume  h-ang  v-ang  delz   rough  dhy    tlpvbfe\n');
                            fprintf(fid,'1400101  %s      1.      0.      0.     90.    1.     0.     0.     0000000 \n', cooling_cross_section);
                            fprintf(fid,'*        ctl\n');
                            fprintf(fid,'1400200  003\n');
                            fprintf(fid,'*        time  pressure    temperature\n');
                            fprintf(fid,'1400201  0.    %s.         %s \n',SecondaryPressure, SecondaryTemp);                  %****************************************************
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* component 150 - inlet junction\n');
                            fprintf(fid,'*        name   type\n');
                            fprintf(fid,'1500000  injunC tmdpjun\n');
                            fprintf(fid,'*        from       to         area         floss rloss  jefvcahs\n');
                            fprintf(fid,'1500101  140010002  155010001  %s          *0.    0.     00001000\n',  cooling_cross_section);
                            fprintf(fid,'*        ctl\n');
                            fprintf(fid,'1500200  1\n');
                            fprintf(fid,'*        time  flowf      flowg  interval velocity\n');
                            fprintf(fid,'1500201  %s.    %s         0.     0\n',action_start,Mflow_secondary_seconds);              %****************************************************
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* component 155 - pipes\n');
                            fprintf(fid,'*        name   type\n');
                            fprintf(fid,'1550000  pipeC  pipe\n');
                            fprintf(fid,'*        no.volumes\n');
                            fprintf(fid,'\n');
                            fprintf(fid,'1550001  50\n');
                            fprintf(fid,'*        area                             vol.no.\n');
                            fprintf(fid,'1550101  %s                               50\n', cooling_cross_section);
                            fprintf(fid,'*        length                           vol.no.\n');
                            fprintf(fid,'1550301  %s                               50\n', pipe_part_length);
                            fprintf(fid,'*        v-ang                            vol.no.\n');
                            fprintf(fid,'1550601  90.                              50\n');
                            fprintf(fid,'*        rough   dhy                      vol.no.\n');
                            fprintf(fid,'1550801  0.      0.                       50\n');
                            fprintf(fid,'*        tlpvbfe                          vol.no.\n');
                            fprintf(fid,'1551001  0000000                          50\n');
                            fprintf(fid,'*        efvcahs                          jun.no.\n');
                            fprintf(fid,'1551101  0000000                          49\n');  
                            fprintf(fid,'*        ebt  pressure  temperature       vol.no.\n');
                            fprintf(fid,'1551201  003  %s.      %s    0.  0.  0.  50\n', SecondaryPressure, SecondaryTemp);  %****************************************************
                            fprintf(fid,'*        mass flow (=1)\n');
                            fprintf(fid,'1551300  1\n');
                            fprintf(fid,'*        flowf      flowg  velj          jun.no.\n');
                            fprintf(fid,'1551301  %s    0.     0.                 49 \n',Mflow_secondary_seconds);     %****************************************************
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* component 160 - outlet junction\n');
                            fprintf(fid,'*        name    type\n');
                            fprintf(fid,'1600000  outjunC sngljun\n');
                            fprintf(fid,'*        from         to           area\n');
                            fprintf(fid,'1600101  155500002    165010001    %s \n', cooling_cross_section);
                            fprintf(fid,'*           fwd. loss     rev. loss       jefvcahs\n');
                            fprintf(fid,'1600102     0.0           0.0             00001000\n');
                            fprintf(fid,'*           discharge       thermal\n');       
                            fprintf(fid,'1600103     1.0             1.0\n');
                            fprintf(fid,'*        hydraulic_d  flooding_correlation gas_intercept slope\n');
                            fprintf(fid,'1600110  0            0                    1.0           1.0\n');
                            fprintf(fid,'*        ctl  flowf      flowg\n');
                            fprintf(fid,'1600201  1    %s         0. \n',Mflow_secondary_seconds);                      %****************************************************
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* component 165 - outlet volume\n');
                            fprintf(fid,'*        name    type\n');
                            fprintf(fid,'1650000  outvolC tmdpvol\n');
                            fprintf(fid,'*        area    length  volume h-ang v-ang  delz  rough  dhy  tlpvbfe\n');
                            fprintf(fid,'1650101  %s      1.      0.     0.    90.    1.    0.     0.   0000000\n', cooling_cross_section);
                            fprintf(fid,'*        ctl\n');
                            fprintf(fid,'1650200  003\n');
                            fprintf(fid,'*        time  pressure    temperature\n');
                            fprintf(fid,'1650201  0.    %s.         %s \n',SecondaryPressure,SecondaryTemp);                    %****************************************************
                            fprintf(fid,'\n');
                            fprintf(fid,'*================================================================\n');

                            %********************* HEAT STRUCTURES
                            fprintf(fid,'* heat structure data - heater at the bottom\n');
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* heat structure 105 - HEATER WALL\n');
                            fprintf(fid,'*         no.HS  no.m.p  geo  s.s.flag  left\n');
                            fprintf(fid,'11051000  %s      5       2    0         %s \n', amount_of_heaters, radius_heater_inner);
                            fprintf(fid,'*         mesh flag  format\n');
                            fprintf(fid,'11051100  0          1\n');
                            fprintf(fid,'*         intvl   right.cord.\n');
                            fprintf(fid,'11051101  4       %s \n', radius_heater_outer);
                            fprintf(fid,'*         comp    intvl\n');
                            fprintf(fid,'11051201  001     4\n');
                            fprintf(fid,'*         source  intvl\n');
                            fprintf(fid,'11051301  0.0     4\n');
                            fprintf(fid,'*         temp    no.m.p\n');
                            fprintf(fid,'11051401  %s     5\n',Theater);                           %****************************************************
                            fprintf(fid,'*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11051501  110010000  10000  101  1       %s        %s \n', heater_part_length, amount_of_heaters);
                            fprintf(fid,'*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11051601  0          0      2555 1       %s        %s \n', heater_part_length, amount_of_heaters);
                            fprintf(fid,'*         s.type     mult   dir.left     dir.right  HS.no.\n');
                            fprintf(fid,'11051701  0          1.     1.           1.         %s \n', amount_of_heaters);
                            fprintf(fid,'*         dhy                                HS.no.\n');
                            fprintf(fid,'11051801  0.0  20.  20.  0.  0.  0.  0.  1.  %s \n', amount_of_heaters);
                            fprintf(fid,'*         dhy                                HS.no.\n');
                            fprintf(fid,'11051901  0.0  20.  20.  0.  0.  0.  0.  1.  %s \n', amount_of_heaters);
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'\n'); 
                            
                            %insulation at the bottom
                            fprintf(fid,'* heat structure data - heater at the bottom\n');
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* heat structure 106 - HEATER WALL\n');
                            fprintf(fid,'*         no.HS  no.m.p  geo  s.s.flag  left\n');
                            fprintf(fid,'11061000  %s      5       2    0         %s \n', amount_of_insulators_parts, radius_heater_inner);
                            fprintf(fid,'*         mesh flag  format\n');
                            fprintf(fid,'11061100  0          1\n');
                            fprintf(fid,'*         intvl   right.cord.\n');
                            fprintf(fid,'11061101  4       %s \n', radius_heater_outer);
                            fprintf(fid,'*         comp    intvl\n');
                            fprintf(fid,'11061201  001     4\n');
                            fprintf(fid,'*         source  intvl\n');
                            fprintf(fid,'11061301  0.0     4\n');
                            fprintf(fid,'*         temp    no.m.p\n');
                            fprintf(fid,'11061401  %s     5\n',Theater);                           %****************************************************
                            fprintf(fid,'*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11061501  %s  10000  101  1       %s        %s \n', insulators_starting_volume, heater_part_length, amount_of_insulators_parts);
                            fprintf(fid,'*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11061601  0          0      0    1       %s        %s \n', heater_part_length, amount_of_insulators_parts);
                            fprintf(fid,'*         s.type     mult   dir.left     dir.right  HS.no.\n');
                            fprintf(fid,'11061701  0          1.     1.           1.         %s \n', amount_of_insulators_parts);
                            fprintf(fid,'*         dhy                                HS.no.\n');
                            fprintf(fid,'11061801  0.0  20.  20.  0.  0.  0.  0.  1.  %s \n', amount_of_insulators_parts);
                            fprintf(fid,'*         dhy                                HS.no.\n');
                            fprintf(fid,'11061901  0.0  20.  20.  0.  0.  0.  0.  1.  %s \n', amount_of_insulators_parts);
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'\n'); 
                             
                            %********************** ADIABATIC PART
                            fprintf(fid,'* heat structure data - wall shielding primary flow from environment\n');
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* heat structure 110 - ADIABATIC WALL\n');
                            fprintf(fid,'*         no.HS  no.m.p  geo  s.s.flag  left\n');
                            fprintf(fid,'11101000  %s     5       2    0         %s \n', amount_of_adiabatic_parts, radius_inner);
                            fprintf(fid,'*         mesh flag  format\n');
                            fprintf(fid,'11101100  0          1\n');
                            fprintf(fid,'*         intvl   right.cord.\n');
                            fprintf(fid,'11101101  4       %s \n', radius_outer);
                            fprintf(fid,'*         comp    intvl\n');
                            fprintf(fid,'11101201  001     4\n');
                            fprintf(fid,'*         source  intvl\n');
                            fprintf(fid,'11101301  0.0     4\n'); 
                            fprintf(fid,'*         temp    no.m.p\n');
                            fprintf(fid,'11101401  %s     5\n',PrimaryTemp);                           %****************************************************
                            fprintf(fid,'*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11101501  125010000  10000  101  1       %s         %s \n', pipe_part_length, amount_of_adiabatic_parts);
                            fprintf(fid,'*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11101601  0          0      0    1       %s         %s \n', pipe_part_length, amount_of_adiabatic_parts);
                            fprintf(fid,'*         s.type     mult   dir.left     dir.right  HS.no.\n');
                            fprintf(fid,'11101701  0          1.     1.           1.         %s \n', amount_of_adiabatic_parts);
                            fprintf(fid,'*         dhy\n');
                            fprintf(fid,'11101801  0.0  20.  20.  0.  0.  0.  0.  1.  %s \n', amount_of_adiabatic_parts);
                            fprintf(fid,'*         dhy\n');
                            fprintf(fid,'11101901  0.0  20.  20.  0.  0.  0.  0.  1.  %s \n', amount_of_adiabatic_parts);
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'\n');                            

                            %********************** HEAT EXCHANGER
                            fprintf(fid,'* heat structure data - HEAT EXCHANGER\n');
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* heat structure 111 - HEAT EXCHANGER\n');
                            fprintf(fid,'*         no.HS  no.m.p  geo  s.s.flag  left\n');
                            fprintf(fid,'11111000  %s     5       2    0         %s \n', amount_of_condensation_parts, radius_inner);
                            fprintf(fid,'*         mesh flag  format\n');
                            fprintf(fid,'11111100  0          1\n');
                            fprintf(fid,'*         intvl   right.cord.\n');
                            fprintf(fid,'11111101  4       %s \n', radius_outer);
                            fprintf(fid,'*         comp    intvl\n');
                            fprintf(fid,'11111201  001     4\n');
                            fprintf(fid,'*         source  intvl\n');
                            fprintf(fid,'11111301  0.0     4\n'); 
                            fprintf(fid,'*         temp    intvl\n');
                            fprintf(fid,'11111401  %s     5\n',PrimaryTemp);                           %****************************************************
                            fprintf(fid,'*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11111501  %s  10000  101  1       %s         %s \n', condenser_starting, pipe_part_length, amount_of_condensation_parts);
                            fprintf(fid,'*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11111601  155010000  10000  101  1       %s         %s \n', pipe_part_length, amount_of_condensation_parts);
                            fprintf(fid,'*         s.type     mult   dir.left     dir.right  HS.no.\n');
                            fprintf(fid,'11111701  0          1.     1.           1.         %s \n', amount_of_condensation_parts);
                            fprintf(fid,'*         dhy\n');
                            fprintf(fid,'11111801  0.0  10.  10.  0.  0.  0.  0.  1.  %s \n', amount_of_condensation_parts);
                            fprintf(fid,'*         dhy\n');
                            fprintf(fid,'11111901  0.0  10.  10.  0.  0.  0.  0.  1.  %s \n', amount_of_condensation_parts);
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'\n');
                            
                            %********************* OUTER WALL
                            fprintf(fid,'* heat structure data - OUTER WALL (insulation)\n');
                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'* heat structure 112 - OUTER WALL\n');
                            fprintf(fid,'*         no.HS  no.m.p  geo  s.s.flag  left\n');
                            fprintf(fid,'11121000  %s     5       2    0         %s \n', amount_of_condensation_parts, radius_jacket_inner);
                            fprintf(fid,'*         mesh flag  format\n');
                            fprintf(fid,'11121100  0          1\n');
                            fprintf(fid,'*         intvl   right.cord.\n');
                            fprintf(fid,'11121101  4       %s \n', radius_jacket_outer);
                            fprintf(fid,'*         comp    intvl\n');
                            fprintf(fid,'11121201  001     4\n');
                            fprintf(fid,'*         source  intvl\n');
                            fprintf(fid,'11121301  0.0     4\n');
                            fprintf(fid,'*         temp    intvl\n');
                            fprintf(fid,'11121401  %s     5\n',SecondaryTemp);                                    %****************************************************
                            fprintf(fid,'*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11121501  155010000  10000  101  1       %s         %s \n', pipe_part_length, amount_of_condensation_parts);
                            fprintf(fid,'*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.\n');
                            fprintf(fid,'11121601  0          0      0    1       %s         %s \n', pipe_part_length, amount_of_condensation_parts);
                            fprintf(fid,'*         s.type     mult   dir.left     dir.right  HS.no.\n');
                            fprintf(fid,'11121701  0          1.     1.           1.         %s \n', amount_of_condensation_parts);
                            fprintf(fid,'*         dhy\n');
                            fprintf(fid,'11121801  0.0 20.  20.  0.  0.  0.  0.  1.  %s \n', amount_of_condensation_parts);
                            fprintf(fid,'*         dhy\n');
                            fprintf(fid,'11121901  0.0 20.  20.  0.  0.  0.  0.  1.  %s \n', amount_of_condensation_parts);
                            fprintf(fid,'=================================================================\n');
                            fprintf(fid,'\n'); 

                            % PROPERTY TABLES
                            fprintf(fid,'* heat structure thermal property data\n');
                            fprintf(fid,'*----------------------------------------------------------------\n');

                            fprintf(fid,'** stainless steel \n');
                            fprintf(fid,'20100100  tbl/fctn  1  1 \n');
                            fprintf(fid,'*conduct. vs temp.     \n');
                            fprintf(fid,'20100101  275.0  7.58 \n');
                            fprintf(fid,'20100102  295.0  7.58 \n');
                            fprintf(fid,'20100103  550.0  13.43 \n');
                            fprintf(fid,'20100104  700.0  16.87 \n');
                            fprintf(fid,'20100105  873.0  20.85 \n');
                            fprintf(fid,'20100106  1173.0 27.73 \n');
                            fprintf(fid,'20100107  1671.0 29.16 \n');
                            fprintf(fid,'20100108  1727.0 20.0 \n');
                            fprintf(fid,'20100109  4000.0 20.0 \n');
                            fprintf(fid,'*vol.ht.cap. vs temp. \n');
                            fprintf(fid,'20100151  273.0  4.000e6 \n');
                            fprintf(fid,'20100152  293.0  4.000e6 \n');
                            fprintf(fid,'20100153  373.0  4.008e6 \n');
                            fprintf(fid,'20100154  473.0  4.080e6 \n');
                            fprintf(fid,'20100155  573.0  4.152e6 \n');
                            fprintf(fid,'20100156  673.0  4.224e6 \n');
                            fprintf(fid,'20100157  773.0  4.296e6 \n');
                            fprintf(fid,'20100158  873.0  4.368e6 \n');
                            fprintf(fid,'20100159  10973.0  4.440e6 \n');

                            fprintf(fid,'*----------------------------------------------------------------\n');

                            %***************** DESCRIPTION OF RIGHT BOUNDARY HEAT FLUX
                            fprintf(fid,'* HEAT SOURCE TABLE\n');
                            fprintf(fid,'*        tableType \n');
                            fprintf(fid,'20255500 htrnrate \n');
                            fprintf(fid,'*        time heat flux \n');
                            fprintf(fid,'20255501 %s.   -%s  \n',action_start,Heat_flux);   % HERE DEFINE HEAT FLUX

                            fprintf(fid,'*----------------------------------------------------------------\n');
                            fprintf(fid,'. end of input\n');


                            fclose(fid); %close the file
                        end
                    end
                end
            end
        end
    end
end

%% Close file and generate log file
    fclose('all'); %close namelist file

      disp('Input decks generated succesfully!')
      disp('List of files is available in main directory in input_decks_list.txt');

    %generate log file with information like batch_size, starting_file
    fid2=fopen(path_to_log,'w');
    fprintf(fid2,'starting_file=1\n');
    fprintf(fid2,'batch_size=4\n');
    fprintf(fid2,'processed_amount=0\n');
    fprintf(fid2,'starting_batch=1\n');
    fclose(fid2);

  