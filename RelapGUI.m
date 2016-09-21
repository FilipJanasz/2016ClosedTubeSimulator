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

% Last Modified by GUIDE v2.5 21-Sep-2016 16:18:59

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


% --- Executes on button press in procResults.
function procResults_Callback(hObject, eventdata, handles)
% hObject    handle to procResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in genInput.
function genInput_Callback(hObject, eventdata, handles)
    file_path=get(handles.file_path,'String');
    handles.paths=setPaths(file_path);
    input_type=get(handles.inputManual,'Value');
    generateRelapInput_annulus_for_experiments(handles,input_type)
    %update handles structure
    guidata(hObject, handles)


% --- Executes on button press in runRelap.
function runRelap_Callback(hObject, eventdata, handles)
    file_path=get(handles.file_path,'String');
    handles.paths=setPaths(file_path);
    runRelap(handles.paths)
    %update handles structure
    guidata(hObject, handles)


% --- Executes on button press in sequence.
function sequence_Callback(hObject, eventdata, handles)
% hObject    handle to sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in genInputBox.
function genInputBox_Callback(hObject, eventdata, handles)
% hObject    handle to genInputBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of genInputBox


% --- Executes on button press in runRelapBox.
function runRelapBox_Callback(hObject, eventdata, handles)
% hObject    handle to runRelapBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of runRelapBox


% --- Executes on button press in procResultsBox.
function procResultsBox_Callback(hObject, eventdata, handles)
% hObject    handle to procResultsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of procResultsBox



function Pps_Callback(hObject, eventdata, handles)
% hObject    handle to Pps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pps as text
%        str2double(get(hObject,'String')) returns contents of Pps as a double


% --- Executes during object creation, after setting all properties.
function Pps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NC_Callback(hObject, eventdata, handles)
% hObject    handle to NC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NC as text
%        str2double(get(hObject,'String')) returns contents of NC as a double


% --- Executes during object creation, after setting all properties.
function NC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Helium_Callback(hObject, eventdata, handles)
% hObject    handle to Helium (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Helium as text
%        str2double(get(hObject,'String')) returns contents of Helium as a double


% --- Executes during object creation, after setting all properties.
function Helium_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Helium (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pss_Callback(hObject, eventdata, handles)
% hObject    handle to Pss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pss as text
%        str2double(get(hObject,'String')) returns contents of Pss as a double


% --- Executes during object creation, after setting all properties.
function Pss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Superheat_Callback(hObject, eventdata, handles)
% hObject    handle to Superheat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Superheat as text
%        str2double(get(hObject,'String')) returns contents of Superheat as a double


% --- Executes during object creation, after setting all properties.
function Superheat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Superheat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mflowss_Callback(hObject, eventdata, handles)
% hObject    handle to Mflowss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mflowss as text
%        str2double(get(hObject,'String')) returns contents of Mflowss as a double


% --- Executes during object creation, after setting all properties.
function Mflowss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mflowss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Power_Callback(hObject, eventdata, handles)
% hObject    handle to Power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Power as text
%        str2double(get(hObject,'String')) returns contents of Power as a double


% --- Executes during object creation, after setting all properties.
function Power_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file_path_Callback(hObject, eventdata, handles)
% hObject    handle to file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_path as text
%        str2double(get(hObject,'String')) returns contents of file_path as a double


% --- Executes during object creation, after setting all properties.
function file_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
