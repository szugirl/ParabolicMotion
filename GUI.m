function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 05-Jul-2021 14:50:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);  % ����Object

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in generate_button.
function generate_button_Callback(hObject, eventdata, handles)
% hObject    handle to generate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

H = get(handles.height_slider, 'Value');
V0 = get(handles.speed_slider, 'Value');
% ȷ�����ٶ�
if get(handles.earth_radiobutton, 'Value') 
    G = 9.80;
end

if get(handles.moon_radiobutton, 'Value') 
    G = 1.62;
end

if get(handles.mars_radiobutton, 'Value') 
    G = 3.72;
end

% �����������
clear_axes_Fcn(handles); 
% ƽ��--����б������
if get(handles.flat_radiobutton, 'Value') 
    [x_max, y_max, best_theta] = plot_flat_Fcn(handles, H, V0, G);
    text(x_max + 8, 5, ['�׳���Զ����Ϊ��', num2str(x_max), '��']);
    text(10, get(handles.height_slider, 'Value') + 10, ['�����׳��Ƕ�Ϊ��', num2str(best_theta), '��']);
end


% ����--����б������
if get(handles.up_radiobutton, 'Value') 
    [x_max, y_max, best_theta] = plot_up_Fcn(handles, H, V0, G);
    % ���»���б��
    plot_up_slope_Fcn(handles);
    % ��ע��Զ��
    plot([x_max, 0], [y_max, y_max],'--', 'linewidth', 1);
    plot([x_max, x_max], [0, y_max],'--', 'linewidth', 1);
    text(x_max + 8, y_max + 5, ['�׳���Զ����Ϊ��', num2str(x_max), '��']);
    text(0, get(handles.height_slider, 'Value') + 10, ['�����׳��Ƕ�Ϊ��', num2str(best_theta), '��']);
end

% ����--����б������
if get(handles.down_radiobutton, 'Value') 
    [x_max, y_max, best_theta] = plot_down_Fcn(handles, H, V0, G);
    % ���»���б��
    plot_down_slope_Fcn(handles);
    % ��ע��Զ��
    plot([x_max, 0], [y_max, y_max], '--', 'linewidth', 1);
    plot([x_max, x_max], [0, y_max], '--', 'linewidth', 1);
    text(x_max + 8, y_max + 5, ['�׳���Զ����Ϊ��', num2str(x_max), '��']);
    text(0, get(handles.height_slider, 'Value') + 10, ['�����׳��Ƕ�Ϊ��', num2str(best_theta), '��']);
end
% ���»���С��
plot_ball_Fcn(handles);

% ���������᷶Χ
plot_axes_Fcn(handles, x_max + 50, V0^2 / (2*G) + 80);


% --- Executes during object creation, after setting all properties.
function draw_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to draw_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function height_slider_Callback(hObject, eventdata, handles)
% hObject    handle to height_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% �������������
clear_axes_Fcn(handles);
% �жϵ�ǰ�Ƿ�������ģʽ��
if get(handles.up_radiobutton, 'Value')
    % ����б��ֱ��
    plot_up_slope_Fcn(handles);
end 
% �жϵ�ǰ�Ƿ�������ģʽ��
if get(handles.down_radiobutton, 'Value')
    % ����б��ֱ��
    plot_down_slope_Fcn(handles);
end 
% ���»���С��
plot_ball_Fcn(handles);
% ���������᷶Χ
plot_axes_Fcn(handles, 100, 100);

% --- Executes during object creation, after setting all properties.
function height_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Max', 100);
set(hObject, 'SliderStep', [0.05, 0.05]);
set(hObject, 'Value', 50);


% --- Executes on button press in earth_radiobutton.
function earth_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to earth_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of earth_radiobutton
set(handles.earth_radiobutton,'value',1);
set(handles.moon_radiobutton,'value',0);
set(handles.mars_radiobutton,'value',0);

% --- Executes on button press in moon_radiobutton.
function moon_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to moon_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of moon_radiobutton
set(handles.earth_radiobutton,'value',0);
set(handles.moon_radiobutton,'value',1);
set(handles.mars_radiobutton,'value',0);

% --- Executes on button press in mars_radiobutton.
function mars_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to mars_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mars_radiobutton
set(handles.earth_radiobutton,'value',0);
set(handles.moon_radiobutton,'value',0);
set(handles.mars_radiobutton,'value',1);


% --- Executes on button press in up_radiobutton.
function up_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to up_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of up_radiobutton
set(handles.flat_radiobutton,'value',0);
set(handles.up_radiobutton,'value',1);
set(handles.down_radiobutton,'value',0);
% ��ջ�����
clear_axes_Fcn(handles);
% ����б��ֱ��
plot_up_slope_Fcn(handles);
% ���»���С��
plot_ball_Fcn(handles);
% ���������᷶Χ
plot_axes_Fcn(handles, 100, 100);


% --- Executes on button press in down_radiobutton.
function down_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to down_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of down_radiobutton
set(handles.flat_radiobutton,'value',0);
set(handles.up_radiobutton,'value',0);
set(handles.down_radiobutton,'value',1);
% ��ջ�����
clear_axes_Fcn(handles);
% ���»�������
plot_down_slope_Fcn(handles);
% ���»���С��
plot_ball_Fcn(handles);
% ���������᷶Χ
plot_axes_Fcn(handles, 100, 100);


% --- Executes on button press in flat_radiobutton.
function flat_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to flat_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flat_radiobutton
set(handles.flat_radiobutton,'value',1);
set(handles.up_radiobutton,'value',0);
set(handles.down_radiobutton,'value',0);
% ��ջ���������
clear_axes_Fcn(handles);
% ���»���С��
plot_ball_Fcn(handles);
% ���������᷶Χ
plot_axes_Fcn(handles, 100, 100);


function angle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_edit as text
%        str2double(get(hObject,'String')) returns contents of angle_edit as a double
angle_slider = handles.angle_slider;
set(angle_slider, 'Value', str2double(hObject.String));
% �������������
clear_axes_Fcn(handles);
% ���»���С��
plot_ball_Fcn(handles);
% �жϵ�ǰ�Ƿ�������ģʽ��
if get(handles.up_radiobutton, 'Value')
    % ����б��ֱ��
    plot_up_slope_Fcn(handles);
end 
% �жϵ�ǰ�Ƿ�������ģʽ��
if get(handles.down_radiobutton, 'Value')
    % ����б��ֱ��
    plot_down_slope_Fcn(handles);
end 
% ���������᷶Χ
plot_axes_Fcn(handles, 100, 100);

% --- Executes during object creation, after setting all properties.
function angle_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function angle_slider_Callback(hObject, eventdata, handles)
% hObject    handle to angle_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
angle_edit = handles.angle_edit;
angle_edit_value = ceil(hObject.Value);
set(angle_edit, 'String', num2str(angle_edit_value));
% �������������
clear_axes_Fcn(handles);
% ���»���С��
plot_ball_Fcn(handles);
% �жϵ�ǰ�Ƿ�������ģʽ��
if get(handles.up_radiobutton, 'Value')
    % ����б��ֱ��
    plot_up_slope_Fcn(handles);
end 
% �жϵ�ǰ�Ƿ�������ģʽ��
if get(handles.down_radiobutton, 'Value')
    % ����б��ֱ��
    plot_down_slope_Fcn(handles);
end 
% ���������᷶Χ
plot_axes_Fcn(handles, 100, 100);

% --- Executes during object creation, after setting all properties.
function angle_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Max', 89);
set(hObject, 'SliderStep', [0.1, 0.1]);
set(hObject, 'Value', 45);

% --- Executes on slider movement.
function distance_slider_Callback(hObject, eventdata, handles)
% hObject    handle to distance_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
distance_edit = handles.distance_edit;
% ���±༭���ı�
distance_edit_value = ceil(hObject.Value);
set(distance_edit, 'String', num2str(distance_edit_value));
% �������������
clear_axes_Fcn(handles);
% �жϵ�ǰ�Ƿ���б��ģʽ��
if get(handles.up_radiobutton, 'Value')
    % ����б��ֱ��
    plot_up_slope_Fcn(handles);
end 
% ���»���С��
plot_ball_Fcn(handles);
% ���������᷶Χ
plot_axes_Fcn(handles, 100, 100);

% --- Executes during object creation, after setting all properties.
function distance_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distance_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Max', 100);
set(hObject, 'SliderStep', [0.1, 0.1]);
set(hObject, 'Value', 10);


function distance_edit_Callback(hObject, eventdata, handles)
% hObject    handle to distance_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distance_edit as text
%        str2double(get(hObject,'String')) returns contents of distance_edit as a double

% ���»�����ֵ
distance_slider = handles.distance_slider;
set(distance_slider, 'Value', str2double(hObject.String));
% �������������
clear_axes_Fcn(handles);
% ���»���С��
plot_ball_Fcn(handles);
% �жϵ�ǰ�Ƿ���б��ģʽ��
if get(handles.up_radiobutton, 'Value')
    % ����б��ֱ��
    plot_up_slope_Fcn(handles);
end 
% ���������᷶Χ
plot_axes_Fcn(handles, 100, 100);

% --- Executes during object creation, after setting all properties.
function distance_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distance_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Ĭ��ѡ��ƽ��
set(handles.flat_radiobutton,'value',1);
set(handles.up_radiobutton,'value',0);
set(handles.down_radiobutton,'value',0);
% Ĭ��ѡ�����
set(handles.earth_radiobutton,'value',1);
set(handles.moon_radiobutton,'value',0);
set(handles.mars_radiobutton,'value',0);
% ����Ĭ�ϲ���
set(handles.distance_slider, 'Value', 10);
set(handles.distance_edit, 'String', '10');
set(handles.angle_slider, 'Value', 45);
set(handles.angle_edit, 'String', '45');
set(handles.speed_slider, 'Value', 10);
set(handles.speed_edit, 'String', '10');
% �������������
clear_axes_Fcn(handles);
% ���»���С��
plot_ball_Fcn(handles);
% ���������᷶Χ
plot_axes_Fcn(handles, 100, 100);

% --- Executes on slider movement.
function speed_slider_Callback(hObject, eventdata, handles)
% hObject    handle to speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
speed_edit = handles.speed_edit;
speed_edit_value = ceil(hObject.Value);
set(speed_edit, 'String', num2str(speed_edit_value));

% --- Executes during object creation, after setting all properties.
function speed_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Max', 50);
set(hObject, 'SliderStep', [0.1, 0.1]);
set(hObject, 'Value', 10);

function speed_edit_Callback(hObject, eventdata, handles)
% hObject    handle to speed_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed_edit as text
%        str2double(get(hObject,'String')) returns contents of speed_edit as a double
speed_slider = handles.speed_slider;
set(speed_slider, 'Value', str2double(hObject.String));


% --- Executes during object creation, after setting all properties.
function speed_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function generate_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function earth_radiobutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to earth_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Value', 1);


% --- Executes during object creation, after setting all properties.
function flat_radiobutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flat_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Value', 1);


% --- Executes during object deletion, before destroying properties.
function draw_axes_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to draw_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function reset_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function plot_ball_Fcn(handles)
% �Զ��庯��������С�����
% handles    structure with handles and user data (see GUIDATA)
% draw_axes = handles.draw_axes;
draw_axes = handles.draw_axes;
axes(draw_axes);
height_slider = handles.height_slider;
plot(1, height_slider.Value,'r-o', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
% ��ʾ�߶��ı�
text(5, height_slider.Value, [num2str(height_slider.Value), '��']);
hold on;


function plot_up_slope_Fcn(handles)
% �Զ��庯��������ģʽ -> ����б�淽�̻���
% handles    structure with handles and user data (see GUIDATA)

% �������бʽ��ֱ�߷���
line_function = @(x, k, x0, y0) k*(x-x0)+y0; 
% ��ȡб��ֱ����б�� -> ���б��
angle_slider = handles.angle_slider;
k = tan(angle_slider.Value/180*pi);
% ��ȡб�涨������
distance_slider = handles.distance_slider;
x0 = distance_slider.Value;
y0 = 0;
% ����б���������򣬲����
x1 = 5000;
y1 = line_function(x1, k, x0, y0);
axes(handles.draw_axes);
fill([x1, x0, x1], [0, y0, y1], [0.9, 0.9, 0.9]);
hold on;

function plot_down_slope_Fcn(handles)
% �Զ��庯��������ģʽ -> ����б�淽�̻���
% handles    structure with handles and user data (see GUIDATA)

% ��ȡб��ֱ����б�� -> ���б��
angle_slider = handles.angle_slider;
k = tan(angle_slider.Value/180*pi);
% ��ȡб�涨������
height_slider = handles.height_slider;
x0 = 0;
y0 = height_slider.Value;
% ����б���������򣬲����
y1 = 0;
x1 = y0 / k; 
axes(handles.draw_axes);
fill([0, x0, x1], [0, y0, y1], [0.9, 0.9, 0.9]);
hold on;


function plot_axes_Fcn(handles, x_max, y_max)
% �Զ��庯�������������᷶Χ
% handles    structure with handles and user data (see GUIDATA)
draw_axes = handles.draw_axes;
set(draw_axes, 'XLim', [0, x_max]);
set(draw_axes, 'YLim', [0, y_max]);
set(draw_axes, 'YAxisLocation', 'right');
grid on;


function clear_axes_Fcn(handles)
% �Զ��庯������ջ���������
% handles    structure with handles and user data (see GUIDATA)
axes(handles.draw_axes);
cla;


function [x_max, y_max, theta] = plot_flat_Fcn(handles, H, V0, G)
% �Զ��庯��������ƽ���׳�����
axes(handles.draw_axes);
[theta, distance] = flat_Fcn(H, V0, G);
move_time = distance / (V0 * cos(theta));
time = linspace(0, move_time, 1000);
x_pos = V0 .* cos(theta) .* time;
y_pos = H + V0 .* sin(theta) .* time - 0.5 .* G .* time.^2;
plot(x_pos, y_pos, '.',  'Color', [0.93, 0.69, 0.13]);
hold on;
% �������������Ƕȹ켣
for it = linspace(0, pi/2, 20)
    d = V0 .* cos(it) .* ((V0 .* sin(it) + ((V0 .* sin(it)).^2 + 2 .* G .* H).^(1/2)) ./ G);
    move_time = d / (V0 * cos(it));
    time = linspace(0, move_time, 1000);
    x_pos = V0 .* cos(it) .* time;
    y_pos = H + V0 .* sin(it) .* time - 0.5 .* G .* time.^2;
    plot(x_pos, y_pos, 'Color', [0.5, 0.7, 0.9]);
    hold on;
end
x_max = distance;
y_max = V0^ 2 / (2 * G);


function [x_max, y_max, best_theta] = plot_up_Fcn(handles, H, V0, G)
% �Զ��庯�������������׳�����
axes(handles.draw_axes);

k = tan(get(handles.angle_slider, 'Value') / 180 * pi);
b = -1 * get(handles.distance_slider, 'Value') * k;

[cross_x, cross_y, best_theta] = up_Fcn(H, V0, G, k, b);
move_time = cross_x / (V0 * cos(best_theta));
time = linspace(0, move_time, 1000);
x_pos = V0 .* cos(best_theta) .* time;
y_pos = H + V0 .* sin(best_theta) .* time - 0.5 .* G .* time.^2;
plot(x_pos, y_pos, '.',  'Color', [0.93, 0.69, 0.13]);
hold on;
% �������������Ƕȹ켣
for it = linspace(0, pi/2, 20)
    d = V0 .* cos(it) .* ((V0 .* sin(it) + ((V0 .* sin(it)).^2 + 2 .* G .* H).^(1/2)) ./ G);
    move_time = d / (V0 * cos(it));
    time = linspace(0, move_time, 1000);
    x_pos = V0 .* cos(it) .* time;
    y_pos = H + V0 .* sin(it) .* time - 0.5 .* G .* time.^2;
    plot(x_pos, y_pos, 'Color', [0.5, 0.7, 0.9]);
    hold on;
end
x_max = cross_x;
y_max = cross_y;


function [x_max, y_max, best_theta] = plot_down_Fcn(handles, H, V0, G)
% �Զ��庯�������������׳�����
axes(handles.draw_axes);

% ���µ�б�Ⱥͽؾ�
k = -1 * tan(get(handles.angle_slider, 'Value') / 180 * pi);
b = get(handles.height_slider, 'Value');

[cross_x, cross_y, best_theta] = down_Fcn(H, V0, G, k, b);
move_time = cross_x / (V0 * cos(best_theta));
time = linspace(0, move_time, 1000);
x_pos = V0 .* cos(best_theta) .* time;
y_pos = H + V0 .* sin(best_theta) .* time - 0.5 .* G .* time.^2;
plot(x_pos, y_pos, '.',  'Color', [0.93, 0.69, 0.13]);
hold on;
% �������������Ƕȹ켣
for it = linspace(0, pi/2, 20)
    d = V0 .* cos(it) .* ((V0 .* sin(it) + ((V0 .* sin(it)).^2 + 2 .* G .* H).^(1/2)) ./ G);
    move_time = d / (V0 * cos(it));
    time = linspace(0, move_time, 1000);
    x_pos = V0 .* cos(it) .* time;
    y_pos = H + V0 .* sin(it) .* time - 0.5 .* G .* time.^2;
    plot(x_pos, y_pos, 'Color', [0.5, 0.7, 0.9]);
    hold on;
end
x_max = cross_x;
y_max = cross_y;
