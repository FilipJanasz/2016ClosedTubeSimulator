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

    % Last Modified by GUIDE v2.5 26-Sep-2016 16:58:13

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
    
    %Path to subscripts
    addpath('D:\Data\Relap5\2016ClosedTubeSimulator\export_figure');
    
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
function genInput_Callback(hObject, eventdata, handles)
    clc
    
    %get directory close to user wishes
    default_dir=get(handles.file_path,'String');
    %check if the input is manual or automatic (from experiment)
    input_type=get(handles.inputManual,'Value');
    %generate input decks
    generateRelapInput_annulus_for_experiments(handles,input_type,default_dir)
    
    %update handles structure
    guidata(hObject, handles)

% --- Executes on button press in runRelap.
function runRelap_Callback(hObject, eventdata, handles)
    clc
    
    %get directory close to user wishes
    default_dir=get(handles.file_path,'String'); 
    %get parameters of handling RELAP runs   
    starting_file=str2double(get(handles.startFile,'String'));
    starting_batch=str2double(get(handles.startBatch,'String'));
    execution_time=str2double(get(handles.execTime,'String'));
    batch_size=str2double(get(handles.batchSize,'String'));   
    %run RELAP
    runRelap(handles.dirCode,default_dir,starting_file,execution_time,starting_batch,batch_size)
    
    %update handles structure
    guidata(hObject, handles)
        
% --- Executes on button press in procResults.
function procResults_Callback(hObject, eventdata, handles)
    clc
    %get directory close to user wishes
    default_dir=get(handles.file_path,'String');
    %process results
    processResults_manual(default_dir);
    
    %update handles structure
    guidata(hObject, handles)
    
        
    % --- Executes on button press in plotResults.
function plotResults_Callback(hObject, eventdata, handles)
    clc
    %get directory close to user wishes
    default_dir=get(handles.file_path,'String');
    %start plotting
    plotter_mat_manual(default_dir);
    
    %update handles structure
    guidata(hObject, handles)
    

% --- Executes on button press in sequence.
function sequence_Callback(hObject, eventdata, handles)

% --- Executes on button press in genInputBox.
function genInputBox_Callback(hObject, eventdata, handles)

% --- Executes on button press in runRelapBox.
function runRelapBox_Callback(hObject, eventdata, handles)

% --- Executes on button press in procResultsBox.
function procResultsBox_Callback(hObject, eventdata, handles)

function Pps_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Pps_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function NC_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function NC_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function Helium_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Helium_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function Pss_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Pss_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function coolantTemp_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function coolantTemp_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function Mflowss_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Mflowss_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function Power_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Power_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function file_path_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function file_path_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on button press in plotResultsBox.
function plotResultsBox_Callback(hObject, eventdata, handles)

function startBatch_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function startBatch_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function batchSize_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function batchSize_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function execTime_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function execTime_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function startFile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function startFile_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
