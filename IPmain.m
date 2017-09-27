function varargout = IPmain(varargin)
% IPMAIN MATLAB code for IPmain.fig
%      IPMAIN, by itself, creates a new IPMAIN or raises the existing
%      singleton*.
%
%      H = IPMAIN returns the handle to a new IPMAIN or the handle to
%      the existing singleton*.
%
%      IPMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IPMAIN.M with the given input arguments.
%
%      IPMAIN('Property','Value',...) creates a new IPMAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IPmain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IPmain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IPmain

% Last Modified by GUIDE v2.5 21-Sep-2017 22:09:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IPmain_OpeningFcn, ...
                   'gui_OutputFcn',  @IPmain_OutputFcn, ...
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


% --- Executes just before IPmain is made visible.
function IPmain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IPmain (see VARARGIN)

% Choose default command line output for IPmain
handles.output = hObject;

handles.Tseperate = 160;
handles.Tdenoise = 30;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IPmain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IPmain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    cla(handles.axes_img, 'reset');
    [filename, filepath] = uigetfile({'*.jpg;*.bmp'});
    if ~isequal(filename, 0)
        handles.dir = filepath;
        handles.imgfile = filename;
        
        file = sprintf('%s/%s', filepath, filename);
        
        RGB= imread(file);
        handles.RGB = RGB;
        
        axes(handles.axes_img);
        imshow(RGB);
        hold on;
        
        axes(handles.axes_subimg);
        imshow(RGB);
        hold on;
        
        guidata(hObject, handles);
    end
    


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    selection = questdlg(['Close' get(handles.figure1, 'Name') '?'],...
                        ['Close' get(handles.figure1, 'Name') '...'], ...
                        'Yes', 'No', 'Yes');
    if strcmp(selection, 'No')
        return;
    end


% --- Executes on button press in btn_binary.
function btn_binary_Callback(hObject, eventdata, handles)
% hObject    handle to btn_binary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes_img, 'reset');
axes(handles.axes_img);

RGB = handles.RGB;

GRAY = rgb2gray(RGB);

handles.GRAY = GRAY;
imshow(GRAY);

hold on;

guidata(hObject, handles);



% --- Executes on slider movement.
function sld_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to sld_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
cla(handles.axes_img, 'reset');
axes(handles.axes_img);

GRAY = handles.GRAY;

threshold = get(handles.sld_threshold, 'Value');
% threshold = uint16(255 * threshold);
% fprintf('slider value %d \n', threshold);

binary_img = im2bw(GRAY, threshold);

handles.binary_img = binary_img;
imshow(binary_img);

hold on;

guidata(hObject, handles);


% --- Executes on button press in btn_denoise.
function btn_denoise_Callback(hObject, eventdata, handles)
% hObject    handle to btn_denoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes_img, 'reset');

Tdenoise = handles.Tdenoise;

binary_img = handles.binary_img;
binary_img = ~binary_img;
[L, nm] = bwlabel(binary_img, 8);

stats = regionprops(L, 'Area');

% Delete areas with less than Tdenoise of pixels
for i = 1:nm
    a = stats(i).Area;
    if a <= Tdenoise
        [r,c] = find(L == i);
        np = length(r);
        for t = 1:np
            binary_img(r(t,1), c(t,1)) = 0;
        end
    end
end

handles.denoise_img = binary_img;

axes(handles.axes_img);
imshow(binary_img);
hold on;

guidata(hObject, handles);





% --- Executes on button press in btn_seperate.
function btn_seperate_Callback(hObject, eventdata, handles)
% hObject    handle to btn_seperate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Tseperate = get(handles.edit_seperate, 'String');
Tseperate = str2double(Tseperate);

handles.Tseperate = Tseperate;

fprintf('Seperate: %d \n', Tseperate);

guidata(hObject, handles);


% --- Executes on button press in btn_contain.
function btn_contain_Callback(hObject, eventdata, handles)
% hObject    handle to btn_contain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes_img, 'reset');
axes(handles.axes_img);

denoise_img = handles.denoise_img;
rbw = MergeContainArea(denoise_img);

handles.rbw = rbw;

imshow(rbw);
hold on;

guidata(hObject, handles);

[L, nm] = bwlabel(rbw, 8);
stats = regionprops(L, 'BoundingBox');

for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1), rt(2), rt(3), rt(4)];
    showrt(v, 'y');
end



% --- Executes on button press in btn_cross.
function btn_cross_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cross (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes_img, 'reset');

Tseperate = handles.Tseperate;

rbw = handles.rbw;
bw = handles.denoise_img;

axes(handles.axes_img);
imshow(bw);
hold on;

MergeCrossArea(rbw, Tseperate);

% show the original with rectangles.
cla(handles.axes_img, 'reset');
axes(handles.axes_img);

RGB = handles.RGB;
imshow(RGB);
hold on;

rfile = 'r.dat';
file = textread(rfile, '%s', 'delimiter', '\n', 'whitespace', '', ...
        'bufsize', 4095);
nline = length(file);
narea = nline/2;

for i = 1:narea

    lid = (i - 1) * 2 + 1;
    icen = strread(file{lid}, '%s');
    irt = strread(file{lid+1}, '%s');
    
    % center of rectangle
    r_x0 = str2num(irt{1,1});
    r_y0 = str2num(irt{2,1});
    r_w = str2num(irt{3,1});
    r_h = str2num(irt{4,1});
    
    % center of gravity
    rt_lx = ceil(r_x0);
    rt_ly = ceil(r_y0);
    rt_rx = ceil(r_x0 + r_w);
    rt_ry = ceil(r_y0 + r_h);
    
    chx_goc_data = get(handles.chx_add_goc, 'Value');
    if chx_goc_data == 1.0
        % add goc
        rect_area = bw(rt_ly:rt_ry, rt_lx:rt_rx);
    
        [row_indices, col_indices, values] = find(rect_area == 1);
    
        goc_x = mean(col_indices) + rt_lx;
        goc_y = mean(row_indices) + rt_ly;
        goc_point = [goc_x; goc_y;];
      
        showpt(goc_point, 'go');
    end
    
    % intersected figure
    chx_add_intersected_data = get(handles.chx_add_intersected, 'Value');
    if chx_add_intersected_data == 1.0
        % add intersected lines
        % left-up to right-bottom
        showline([rt_ly, rt_lx], [rt_ry, rt_rx]);
        % right_up to left-bottom
        showline([rt_ly, rt_rx], [rt_ry, rt_lx]);
        
        % left-middle to right-middle
        rt_x_mid = rt_lx + ceil((rt_rx - rt_lx) / 2);
        rt_y_mid = rt_ly + ceil((rt_ry - rt_ly) / 2);
        
        showline([rt_y_mid, rt_lx], [rt_y_mid, rt_rx]);
        % up-middle to down-middle
        showline([rt_ly, rt_x_mid], [rt_ry, rt_x_mid]);
    end
    
    rt = [];
    for j = 1:4
        t = str2num(irt{j, 1});
        rt = [rt, t];
    end
    
    showrt(rt, 'b')
    
    Bi = imcrop(RGB, rt);

end

handles.Bi = Bi;
% handles.Bi_goc = Bi_goc;


guidata(hObject, handles);


% --- Executes on button press in btn_cut.
function btn_cut_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% cla(handles.axes_img, 'reset');
cla(handles.axes_subimg, 'reset');
% axes(handles.axes_img);

imgfile = handles.imgfile;
[pathstr, name, ext] = fileparts(imgfile);

dirname = name;

if exist(dirname, 'dir') == 0
    mkdir(dirname);
end

RGB = handles.RGB;

rfile = 'r.dat';
file = textread(rfile, '%s', 'delimiter', '\n', 'whitespace', '', ...
        'bufsize', 4095);
nline = length(file);

fprintf('r.dat length %d', nline);

narea = nline/2;

subimg_names = {};
for i = 1:narea
    cla(handles.axes_subimg, 'reset');
    
    lid = (i - 1) * 2 + 1;
    icen = strread(file{lid}, '%s');
    irt = strread(file{lid+1}, '%s');
    
    cen = [str2double(icen{1,1}); str2double(icen{2,1})];
    showpt(cen,'ro');
    
    rt = [];
    for j = 1:4
        t = str2num(irt{j, 1});
        rt = [rt, t];
    end
    
    Bi = imcrop(RGB, rt);
    
    axes(handles.axes_subimg);
    imshow(Bi);
    hold on;
    
    subimf = sprintf('%s/%d.bmp', dirname, i);
    subimg_names{i} = sprintf('%d.bmp',i);
    
    imwrite(Bi, subimf, 'bmp');
end

set(handles.list_names,'String',subimg_names);

handles.Bi = Bi;

guidata(hObject, handles);

% --- Executes on button press in btn_bgchange.
function btn_bgchange_Callback(hObject, eventdata, handles)
% hObject    handle to btn_bgchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in list_names.
function list_names_Callback(hObject, eventdata, handles)
% hObject    handle to list_names (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_names contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_names

index_selected = get(hObject, 'Value');
list = get(hObject, 'String');
item_selected = list{index_selected};
fprintf('item: %s\n', item_selected);

% open selected image in axes_subimg
dir = handles.dir;

imgfile = handles.imgfile;
[pathstr, name, ext] = fileparts(imgfile);

cla(handles.axes_subimg, 'reset');
axes(handles.axes_subimg);

subimg_path = sprintf('%s/%s/%s', dir, name, item_selected);

subimg = imread(subimg_path);
imshow(subimg);

hold on;

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function list_names_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_names (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function sld_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in chx_add_goc.
function chx_add_goc_Callback(hObject, eventdata, handles)
% hObject    handle to chx_add_goc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chx_add_goc





% --- Executes on button press in chx_add_intersected.
function chx_add_intersected_Callback(hObject, eventdata, handles)
% hObject    handle to chx_add_intersected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chx_add_intersected


function edit_seperate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_seperate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_seperate as text
%        str2double(get(hObject,'String')) returns contents of edit_seperate as a double


% --- Executes during object creation, after setting all properties.
function edit_seperate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_seperate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chx_backgroundchange.
function chx_backgroundchange_Callback(hObject, eventdata, handles)
% hObject    handle to chx_backgroundchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chx_backgroundchange



