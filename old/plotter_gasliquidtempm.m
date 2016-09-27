
clear 'der_tempdif1'
clear 'der_tempdif2'
clear 'der_tempdif3'
clear 'der_tempdif4'
clear 'der_tempdif5'
clear 'tempdif1'
clear 'tempdif2'
clear 'tempdif3'
clear 'tempdif4'
clear 'tempdif5'

 fx=figure('visible','on');
     ylabel('pipe length [mm]');
     xlabel('(gas Temp - liquid temp) / (sattemp at inlet - wall temperature at inlet)')
     
%      tempdif1=(tempg{1,2}-tempf{1,2})/(sattemp{1,2}(1)-htvat{1,2}(1));
%      tempdif2=(tempg{2,2}-tempf{2,2})/(sattemp{2,2}(1)-htvat{2,2}(1));
%      tempdif3=(tempg{3,2}-tempf{3,2})/(sattemp{3,2}(1)-htvat{3,2}(1));
%      tempdif4=(tempg{4,2}-tempf{4,2})/(sattemp{4,2}(1)-htvat{4,2}(1));
%      tempdif5=(tempg{5,2}-tempf{5,2})/(sattemp{5,2}(1)-htvat{5,2}(1));
%      for n=1:49
%          der_tempdif1(n)=tempdif1(n+1)-tempdif1(n);
%          der_tempdif2(n)=tempdif2(n+1)-tempdif2(n);
%          der_tempdif3(n)=tempdif3(n+1)-tempdif3(n);
%          der_tempdif4(n)=tempdif4(n+1)-tempdif4(n);
%          der_tempdif5(n)=tempdif5(n+1)-tempdif5(n);
%      end

%      plot( der_tempdif1,pipeLength(1:49),'Color',rand(1,3));
%      plot( der_tempdif2,pipeLength(1:49),'Color',rand(1,3));
%      plot( der_tempdif3,pipeLength(1:49),'Color',rand(1,3));
%      plot( der_tempdif4,pipeLength(1:49),'Color',rand(1,3));
%      plot( der_tempdif5,pipeLength(1:49),'Color',rand(1,3));
hold on
%      plot( -tempdif1+tempdif1(1),pipeLength(1:50),'Color',rand(1,3));
%      plot( -tempdif2+tempdif2(1),pipeLength(1:50),'Color',rand(1,3));
%      plot( -tempdif3+tempdif3(1),pipeLength(1:50),'Color',rand(1,3));
%      plot( -tempdif4+tempdif4(1),pipeLength(1:50),'Color',rand(1,3));
%      plot( -tempdif5+tempdif5(1),pipeLength(1:50),'Color',rand(1,3));
 

%      plot( tempdif1,pipeLength(1:50),'Color',rand(1,3))
%      plot( tempdif2,pipeLength(1:50),'Color',rand(1,3))
%      plot( tempdif3,pipeLength(1:50),'Color',rand(1,3))
%      plot( tempdif4,pipeLength(1:50),'Color',rand(1,3))
%      plot( tempdif5,pipeLength(1:50),'Color',rand(1,3))
%      plot( sattemp{1,2}-htvat{1,2},pipeLength(1:50),'Color',rand(1,3))
%      plot( sattemp{2,2}-htvat{2,2},pipeLength(1:50),'Color',rand(1,3))
%      plot( sattemp{3,2}-htvat{3,2},pipeLength(1:50),'Color',rand(1,3))
%      plot( sattemp{4,2}-htvat{4,2},pipeLength(1:50),'Color',rand(1,3))
%      plot( sattemp{5,2}-htvat{5,2},pipeLength(1:50),'Color',rand(1,3))
   
    % plotted={'tempg0','tempf0','sattemp0','htvat0','tempg1','tempf1','sattemp1','htvat1'};
% legend(8,plotted,'Location','SouthOutside')
     
     legend(x,file_list_plot,'Location','SouthOutside')
        
% plot( tempg{4,2},pipeLength(1:50),'Color',rand(1,3));
% plot( tempf{4,2},pipeLength(1:50),'Color',rand(1,3));
% plot( sattemp{4,2},pipeLength(1:50),'Color',rand(1,3));
% plot( htvat{4,2},pipeLength(1:50),'Color',rand(1,3));
% 
% plot( tempg{5,2},pipeLength(1:50),'Color',rand(1,3));
% plot( tempf{5,2},pipeLength(1:50),'Color',rand(1,3));
% plot( sattemp{5,2},pipeLength(1:50),'Color',rand(1,3));
% plot( htvat{5,2},pipeLength(1:50),'Color',rand(1,3));


% plotted={'tempg0','tempf0','sattemp0','htvat0','tempg1','tempf1','sattemp1','htvat1'};
% legend(8,plotted,'Location','SouthOutside')
%%

%plot liquid and gas velocities together
     plot( velg{1,2},pipeLength(1:50),'r')
     plot( velf{1,2},pipeLength(1:50),'m')
     plot( velg{2,2},pipeLength(1:50),'--b')
     plot( velf{2,2},pipeLength(1:50),'--c')
     plotted={'velg co-current','velf co-current','velg counter-current','velf counter-current'};
    legend(plotted,'Location','SouthOutside')
    path_print_plot='D:\Data\Relap5\2015ClosedTubeSimulator\NEW output\counter_vs_co\counter_vs_cocurrent_lowNC\Plots\velgvelf';
    
    
     %%
     
%path_print_plot='C:\Documents and Settings\janasz_f\Desktop\SimplePipeSimulator\NEW output\counter_output\PS_NCcomposition_lowNC\Plots\sattemp_htvat';
     print ('-dpng', path_print_plot)
     hold off
     %close gcf
     
     
  