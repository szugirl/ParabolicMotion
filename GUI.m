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
guidata(hObject, handles);  % 更新Object

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
% 确定加速度
if get(handles.earth_radiobutton, 'Value') 
    G = 9.80;
end

if get(handles.moon_radiobutton, 'Value') 
    G = 1.62;
end

if get(handles.mars_radiobutton, 'Value') 
    G = 3.72;
end

% 清除绘制内容
clear_axes_Fcn(handles); 
% 平地--绘制斜抛曲线
if get(handles.flat_radiobutton, 'Value') 
    [x_max, y_max, best_theta] = plot_flat_Fcn(handles, H, V0, G);
    text(x_max + 8, 5, ['抛出最远距离为：', num2str(x_max), '米']);
    text(10, get(handles.height_slider, 'Value') + 10, ['最优抛出角度为：', num2str(best_theta), 'π']);
end


% 上坡--绘制斜抛曲线
if get(handles.up_radiobutton, 'Value') 
    [x_max, y_max, best_theta] = plot_up_Fcn(handles, H, V0, G);
    % 更新绘制斜坡
    plot_up_slope_Fcn(handles);
    % 标注最远点
    plot([x_max, 0], [y_max, y_max],'--', 'linewidth', 1);
    plot([x_max, x_max], [0, y_max],'--', 'linewidth', 1);
    text(x_max + 8, y_max + 5, ['抛出最远距离为：', num2str(x_max), '米']);
    text(0, get(handles.height_slider, 'Value') + 10, ['最优抛出角度为：', num2str(best_theta), 'π']);
end

% 下坡--绘制斜抛曲线
if get(handles.down_radiobutton, 'Value') 
    [x_max, y_max, best_theta] = plot_down_Fcn(handles, H, V0, G);
    % 更新绘制斜坡
    plot_down_slope_Fcn(handles);
    % 标注最远点
    plot([x_max, 0], [y_max, y_max], '--', 'linewidth', 1);
    plot([x_max, x_max], [0, y_max], '--', 'linewidth', 1);
    text(x_max + 8, y_max + 5, ['抛出最远距离为：', num2str(x_max), '米']);
    text(0, get(handles.height_slider, 'Value') + 10, ['最优抛出角度为：', num2str(best_theta), 'π']);
end
% 更新绘制小球
plot_ball_Fcn(handles);

% 更新坐标轴范围
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

% 清除绘制区内容
clear_axes_Fcn(handles);
% 判断当前是否在上坡模式下
if get(handles.up_radiobutton, 'Value')
    % 绘制斜坡直线
    plot_up_slope_Fcn(handles);
end 
% 判断当前是否在下坡模式下
if get(handles.down_radiobutton, 'Value')
    % 绘制斜坡直线
    plot_down_slope_Fcn(handles);
end 
% 更新绘制小球
plot_ball_Fcn(handles);
% 更新坐标轴范围
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
% 清空绘制区
clear_axes_Fcn(handles);
% 绘制斜坡直线
plot_up_slope_Fcn(handles);
% 更新绘制小球
plot_ball_Fcn(handles);
% 更新坐标轴范围
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
% 清空绘制区
clear_axes_Fcn(handles);
% 更新绘制下坡
plot_down_slope_Fcn(handles);
% 更新绘制小球
plot_ball_Fcn(handles);
% 更新坐标轴范围
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
% 清空绘制区内容
clear_axes_Fcn(handles);
% 更新绘制小球
plot_ball_Fcn(handles);
% 更新坐标轴范围
plot_axes_Fcn(handles, 100, 100);


function angle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_edit as text
%        str2double(get(hObject,'String')) returns contents of angle_edit as a double
angle_slider = handles.angle_slider;
set(angle_slider, 'Value', str2double(hObject.String));
% 清除绘制区内容
clear_axes_Fcn(handles);
% 更新绘制小球
plot_ball_Fcn(handles);
% 判断当前是否在上坡模式下
if get(handles.up_radiobutton, 'Value')
    % 绘制斜坡直线
    plot_up_slope_Fcn(handles);
end 
% 判断当前是否在下坡模式下
if get(handles.down_radiobutton, 'Value')
    % 绘制斜坡直线
    plot_down_slope_Fcn(handles);
end 
% 更新坐标轴范围
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
% 清除绘制区内容
clear_axes_Fcn(handles);
% 更新绘制小球
plot_ball_Fcn(handles);
% 判断当前是否在上坡模式下
if get(handles.up_radiobutton, 'Value')
    % 绘制斜坡直线
    plot_up_slope_Fcn(handles);
end 
% 判断当前是否在下坡模式下
if get(handles.down_radiobutton, 'Value')
    % 绘制斜坡直线
    plot_down_slope_Fcn(handles);
end 
% 更新坐标轴范围
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
% 更新编辑器文本
distance_edit_value = ceil(hObject.Value);
set(distance_edit, 'String', num2str(distance_edit_value));
% 情况绘制内容区
clear_axes_Fcn(handles);
% 判断当前是否在斜坡模式下
if get(handles.up_radiobutton, 'Value')
    % 绘制斜坡直线
    plot_up_slope_Fcn(handles);
end 
% 更新绘制小球
plot_ball_Fcn(handles);
% 更新坐标轴范围
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

% 更新滑动条值
distance_slider = handles.distance_slider;
set(distance_slider, 'Value', str2double(hObject.String));
% 清除绘制区内容
clear_axes_Fcn(handles);
% 更新绘制小球
plot_ball_Fcn(handles);
% 判断当前是否在斜坡模式下
if get(handles.up_radiobutton, 'Value')
    % 绘制斜坡直线
    plot_up_slope_Fcn(handles);
end 
% 更新坐标轴范围
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

% 默认选择平地
set(handles.flat_radiobutton,'value',1);
set(handles.up_radiobutton,'value',0);
set(handles.down_radiobutton,'value',0);
% 默认选择地球
set(handles.earth_radiobutton,'value',1);
set(handles.moon_radiobutton,'value',0);
set(handles.mars_radiobutton,'value',0);
% 设置默认参数
set(handles.distance_slider, 'Value', 10);
set(handles.distance_edit, 'String', '10');
set(handles.angle_slider, 'Value', 45);
set(handles.angle_edit, 'String', '45');
set(handles.speed_slider, 'Value', 10);
set(handles.speed_edit, 'String', '10');
% 清除绘制区内容
clear_axes_Fcn(handles);
% 更新绘制小球
plot_ball_Fcn(handles);
% 更新坐标轴范围
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
% 自定义函数：更新小球绘制
% handles    structure with handles and user data (see GUIDATA)
% draw_axes = handles.draw_axes;
draw_axes = handles.draw_axes;
axes(draw_axes);
height_slider = handles.height_slider;
plot(1, height_slider.Value,'r-o', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
% 显示高度文本
text(5, height_slider.Value, [num2str(height_slider.Value), '米']);
hold on;


function plot_up_slope_Fcn(handles)
% 自定义函数：上坡模式 -> 更新斜面方程绘制
% handles    structure with handles and user data (see GUIDATA)

% 定义求点斜式的直线方程
line_function = @(x, k, x0, y0) k*(x-x0)+y0; 
% 获取斜面直线倾斜角 -> 求解斜率
angle_slider = handles.angle_slider;
k = tan(angle_slider.Value/180*pi);
% 获取斜面定点坐标
distance_slider = handles.distance_slider;
x0 = distance_slider.Value;
y0 = 0;
% 生成斜坡三角区域，并填充
x1 = 5000;
y1 = line_function(x1, k, x0, y0);
axes(handles.draw_axes);
fill([x1, x0, x1], [0, y0, y1], [0.9, 0.9, 0.9]);
hold on;

function plot_down_slope_Fcn(handles)
% 自定义函数：下坡模式 -> 更新斜面方程绘制
% handles    structure with handles and user data (see GUIDATA)

% 获取斜面直线倾斜角 -> 求解斜率
angle_slider = handles.angle_slider;
k = tan(angle_slider.Value/180*pi);
% 获取斜面定点坐标
height_slider = handles.height_slider;
x0 = 0;
y0 = height_slider.Value;
% 生成斜坡三角区域，并填充
y1 = 0;
x1 = y0 / k; 
axes(handles.draw_axes);
fill([0, x0, x1], [0, y0, y1], [0.9, 0.9, 0.9]);
hold on;


function plot_axes_Fcn(handles, x_max, y_max)
% 自定义函数：更新坐标轴范围
% handles    structure with handles and user data (see GUIDATA)
draw_axes = handles.draw_axes;
set(draw_axes, 'XLim', [0, x_max]);
set(draw_axes, 'YLim', [0, y_max]);
set(draw_axes, 'YAxisLocation', 'right');
grid on;


function clear_axes_Fcn(handles)
% 自定义函数：清空绘制区内容
% handles    structure with handles and user data (see GUIDATA)
axes(handles.draw_axes);
cla;


function [x_max, y_max, theta] = plot_flat_Fcn(handles, H, V0, G)
% 自定义函数：绘制平地抛出曲线
axes(handles.draw_axes);
[theta, distance] = flat_Fcn(H, V0, G);
move_time = distance / (V0 * cos(theta));
time = linspace(0, move_time, 1000);
x_pos = V0 .* cos(theta) .* time;
y_pos = H + V0 .* sin(theta) .* time - 0.5 .* G .* time.^2;
plot(x_pos, y_pos, '.',  'Color', [0.93, 0.69, 0.13]);
hold on;
% 绘制其他辅助角度轨迹
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
% 自定义函数：绘制上坡抛出曲线
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
% 绘制其他辅助角度轨迹
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
% 自定义函数：绘制下坡抛出曲线
axes(handles.draw_axes);

% 下坡的斜度和截距
k = -1 * tan(get(handles.angle_slider, 'Value') / 180 * pi);
b = get(handles.height_slider, 'Value');

[cross_x, cross_y, best_theta] = down_Fcn(H, V0, G, k, b);
move_time = cross_x / (V0 * cos(best_theta));
time = linspace(0, move_time, 1000);
x_pos = V0 .* cos(best_theta) .* time;
y_pos = H + V0 .* sin(best_theta) .* time - 0.5 .* G .* time.^2;
plot(x_pos, y_pos, '.',  'Color', [0.93, 0.69, 0.13]);
hold on;
% 绘制其他辅助角度轨迹
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
