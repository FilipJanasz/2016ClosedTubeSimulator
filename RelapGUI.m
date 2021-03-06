function varargout = RelapGUI(varargin)
    % RELAPGUI MATLAB code for RelapGUI.fig
    %      RELAPGUI, by itself, creates a new RELAPGUI or raises the existing
    %      singleton*.
    %
    %      H = RELAPGUI returns the handle to a new RELAPGUI or the handle to
    %      the existing singleton*.
    %
    %      RELAPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in RELAPGUI.M with the given input arguments.
    %
    %      RELAPGUI('Property','Value',...) creates a new RELAPGUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before RelapGUI_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to RelapGUI_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help RelapGUI

    % Last Modified by GUIDE v2.5 28-Sep-2016 15:07:04

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @RelapGUI_OpeningFcn, ...
                       'gui_OutputFcn',  @RelapGUI_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT

% --- Executes just before RelapGUI is made visible.
function RelapGUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to RelapGUI (see VARARGIN)

    % Choose default command line output for RelapGUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
        
    %read default code directory
    handles.dirCode='D:\Data\Relap5\Relap5_code\';
    
    %update handles structure
    guidata(hObject, handles)
    

    % UIWAIT makes RelapGUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = RelapGUI_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;

% --- Executes on button press in genInput.
function genInput_Callback(hObject, eventdata, handles) %#ok<DEFNU>
    clc
    
    %get directory close to user wishes
    default_dir=get(handles.file_path,'String');
    
    %check if the input is manual or automatic (from experiment)
    input_type=get(handles.inputManual,'Value');
    
    %get calculation parameters
    handles.mindt=get(handles.mindtBox,'String');
    handles.initial_maxdt=get(handles.initial_maxdtBox,'String');
    handles.final_maxdt=get(handles.final_maxdtBox,'String');
    handles.initial_endtime=get(handles.initial_endtimeBox,'String');
    handles.endtime=get(handles.endtimeBox,'String');
    %take value specificed by user (in seconds), divide it by final dT (also in seconds) and what you get is a frequency
    %heep major restart and minor the same to keep data storage period
    %constant - otherwise you'll get multiple frequencies of storage
    %(with major, restart and minor being three frequencies)
    handles.minor=num2str(str2double(get(handles.minorBox,'String'))/str2double(handles.final_maxdt));
    handles.major=handles.minor;
    handles.restart=handles.minor;
    handles.initial_cond=get(handles.initial_condBox,'Value');
    
    %generate input decks
    generateRelapInput_annulus_for_experiments(handles,input_type,default_dir)
    
    %update handles structure
    guidata(hObject, handles)

% --- Executes on button press in runRelap.
function runRelap_Callback(hObject, eventdata, handles) %#ok<DEFNU>
    clc
    
    %get directory close to user wishes
    default_dir=get(handles.file_path,'String'); 
    %get RELAP runs options 
    starting_file=str2double(get(handles.startFile,'String'));
    starting_batch=str2double(get(handles.startBatch,'String'));
    execution_time=str2double(get(handles.execTime,'String'));
    batch_size=str2double(get(handles.batchSize,'String'));   
    %run RELAP
    runRelap(handles.dirCode,default_dir,starting_file,execution_time,starting_batch,batch_size,0,0)
    
    %update handles structure
    guidata(hObject, handles)
        
% --- Executes on button press in procResults.
function procResults_Callback(hObject, eventdata, handles) %#ok<DEFNU>
    clc
    %get directory close to user wishes
    default_dir=get(handles.file_path,'String');
    %process results
    processResults(default_dir,0,0);
    
    %update handles structure
    guidata(hObject, handles)
    
        
    % --- Executes on button press in plotResults. 
function plotResults_Callback(hObject, eventdata, handles) %#ok<DEFNU>
    clc
    %get directory close to user wishes
    default_dir=get(handles.file_path,'String');
    %start plotting
    plotter_mat(default_dir,0,0);
    
    %update handles structure
    guidata(hObject, handles)
    

% --- Executes on button press in sequence.
function sequence_Callback(hObject, eventdata, handles) %#ok<DEFNU>
    clc
    genFlag=get(handles.genInputBox,'Value');
    runFlag=get(handles.runRelapBox,'Value');
    ProcFlag=get(handles.procResultsBox,'Value');
    PlotFlag=get(handles.plotResultsBox,'Value');
    
    %check if there are no processing gaps
    processingString=[genFlag runFlag ProcFlag PlotFlag];
    er_1=[1 0 1];
    er_2=[1 0 0 1];
    gap1=strfind(processingString,er_1);
    
    if gap1==1
        button = questdlg('No gaps in processing change allowed. Continue with ''Run RELAP5'' option as ON?','Action required','Yes','No','Yes');
        if strcmp(button,'Yes')
            set(handles.runRelapBox,'Value',1)
            runFlag=1;
        else
            return
        end
        
    elseif gap1==2      
        button = questdlg('No gaps in processing change allowed. Continue with ''Process Results'' option as ON?','Action required','Yes','No','Yes');
        if strcmp(button,'Yes')
            set(handles.procResultsBox,'Value',1)
            ProcFlag=1;
        else
            return
        end
    else

        if isequal(processingString,er_2)
            button = questdlg('No gaps in processing change allowed. Continue with ''Run RELAP5'' and ''Process Results'' options as ON?','Action required','Yes','No','Yes');
            if strcmp(button,'Yes')
                set(handles.runRelapBox,'Value',1)
                set(handles.procResultsBox,'Value',1)
                runFlag=1;
                ProcFlag=1;
            else
                return
            end            
        end
    end
    
    %run required code parts
    %get directory close to user wishes
    default_dir=get(handles.file_path,'String');
    
    if genFlag  
        %check if the input is manual or automatic (from experiment)
        input_type=get(handles.inputManual,'Value');
        
         %get calculation parameters
        handles.mindt=get(handles.mindtBox,'String');
        handles.initial_maxdt=get(handles.initial_maxdtBox,'String');
        handles.final_maxdt=num2str(str2double(get(handles.final_maxdtBox,'String')));
        handles.initial_endtime=get(handles.initial_endtimeBox,'String');
        handles.endtime=get(handles.endtimeBox,'String');
        %take value specificed by user (in seconds), divide it by final dT (also in seconds) and what you get is a frequency
        %heep major restart and minor the same to keep data storage period
        %constant - otherwise you'll get multiple frequencies of storage
        %(with major, restart and minor being three frequencies)
        handles.minor=num2str(str2double(get(handles.minorBox,'String'))/str2double(handles.final_maxdt));
        handles.major=handles.minor;
        handles.restart=handles.minor;
        handles.initial_cond=get(handles.initial_condBox,'Value');
    
        %generate input decks
        generateRelapInput_annulus_for_experiments(handles,input_type,default_dir)
        disp('-------------------------------------------')
    end
    
    %parameter firstAndSeq is a boolean showing the function that it's
    %being run in sequence mode AND being first to start - effectively
    %requiring user to pick a directory with files to process - following
    %code parts will employ the same directory
    if runFlag
        %check if this is the first element to be run
        if ~genFlag
            first=1;
        else
            first=0;
        end
        disp('Running Relap')
        %get parameters of handling RELAP runs   
        starting_file=str2double(get(handles.startFile,'String'));
        starting_batch=str2double(get(handles.startBatch,'String'));
        execution_time=str2double(get(handles.execTime,'String'));
        batch_size=str2double(get(handles.batchSize,'String'));
        %run RELAP
        runRelap(handles.dirCode,default_dir,starting_file,execution_time,starting_batch,batch_size,1,first)
        disp('-------------------------------------------')
    end
    
    if ProcFlag
        if ~runFlag
            first=1;
        else
            first=0;
        end    
        disp('Processing Files')
        %process results
        processResults(default_dir,1,first);
        disp('-------------------------------------------')
    end
    
    if PlotFlag
        if ~ProcFlag
            first=1;
        else
            first=0;
        end
        disp('Plotting files')
        %start plotting
        plotter_mat(default_dir,1,first);
        disp('-------------------------------------------')
    end
    disp('Sequence finished')

% --- Executes on button press in genInputBox.
function genInputBox_Callback(hObject, eventdata, handles) %#ok<DEFNU>
 
% --- Executes on button press in runRelapBox.
function runRelapBox_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes on button press in procResultsBox.
function procResultsBox_Callback(hObject, eventdata, handles) %#ok<DEFNU>
    
% --- Executes on button press in plotResultsBox.
function plotResultsBox_Callback(hObject, eventdata, handles) %#ok<DEFNU>

function Pps_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function Pps_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function NC_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function NC_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function Helium_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function Helium_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function Pss_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function Pss_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function coolantTemp_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function coolantTemp_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function Mflowss_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function Mflowss_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function Power_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function Power_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function file_path_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function file_path_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function startBatch_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function startBatch_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function batchSize_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function batchSize_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function execTime_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function execTime_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function startFile_Callback(hObject, eventdata, handles) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function startFile_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function mindtBox_Callback(hObject, eventdata, handles)
% hObject    handle to mindtBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindtBox as text
%        str2double(get(hObject,'String')) returns contents of mindtBox as a double


% --- Executes during object creation, after setting all properties.
function mindtBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindtBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initial_maxdtBox_Callback(hObject, eventdata, handles)
% hObject    handle to initial_maxdtBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initial_maxdtBox as text
%        str2double(get(hObject,'String')) returns contents of initial_maxdtBox as a double


% --- Executes during object creation, after setting all properties.
function initial_maxdtBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initial_maxdtBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function final_maxdtBox_Callback(hObject, eventdata, handles)
% hObject    handle to final_maxdtBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of final_maxdtBox as text
%        str2double(get(hObject,'String')) returns contents of final_maxdtBox as a double


% --- Executes during object creation, after setting all properties.
function final_maxdtBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to final_maxdtBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initial_endtimeBox_Callback(hObject, eventdata, handles)
% hObject    handle to initial_endtimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initial_endtimeBox as text
%        str2double(get(hObject,'String')) returns contents of initial_endtimeBox as a double


% --- Executes during object creation, after setting all properties.
function initial_endtimeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initial_endtimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endtimeBox_Callback(hObject, eventdata, handles)
% hObject    handle to endtimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endtimeBox as text
%        str2double(get(hObject,'String')) returns contents of endtimeBox as a double


% --- Executes during object creation, after setting all properties.
function endtimeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endtimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minorBox_Callback(hObject, eventdata, handles)
% hObject    handle to minorBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minorBox as text
%        str2double(get(hObject,'String')) returns contents of minorBox as a double


% --- Executes during object creation, after setting all properties.
function minorBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minorBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function majorBox_Callback(hObject, eventdata, handles)
% hObject    handle to majorBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of majorBox as text
%        str2double(get(hObject,'String')) returns contents of majorBox as a double


% --- Executes during object creation, after setting all properties.
function majorBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to majorBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function restartBox_Callback(hObject, eventdata, handles)
% hObject    handle to restartBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of restartBox as text
%        str2double(get(hObject,'String')) returns contents of restartBox as a double


% --- Executes during object creation, after setting all properties.
function restartBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to restartBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in initial_condBox.
function initial_condBox_Callback(hObject, eventdata, handles)
% hObject    handle to initial_condBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns initial_condBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from initial_condBox


% --- Executes during object creation, after setting all properties.
function initial_condBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initial_condBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in changeDir.
function changeDir_Callback(hObject, eventdata, handles)
    default_dir=get(handles.file_path,'String');
    directoryname = uigetdir(default_dir,'Pick a new directory');
    set(handles.file_path,'String',directoryname);
