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

% Last Modified by GUIDE v2.5 09-Oct-2017 17:46:35

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
handles.Tdenoise = 100;
handles.Trectarea = 200;

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
    cla(handles.axes_subimg, 'reset');
    set(handles.list_names,'String',{});
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


% --- Executes on button press in btn_grayscale.
function btn_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to btn_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes_img, 'reset');
axes(handles.axes_img);

RGB = handles.RGB;
if length(size(RGB)) == 2
    GRAY = RGB;
elseif length(size(RGB)) == 3
    GRAY = rgb2gray(RGB);
end

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

threshold_denoise = get(handles.sld_threshold_denoise, 'Value');

binary_img = ~handles.binary_img;

[L, nm] = bwlabel(binary_img, 8);
stats = regionprops(L, 'Area');

% Delete areas with less than threshold denoise of pixels
for i = 1:nm
    a = stats(i).Area;
    if a <= threshold_denoise
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

disp('denoise end');

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

Trectarea = handles.Trectarea;
Tseperate = handles.Tseperate;

RGB = handles.RGB;
denoise_img = handles.denoise_img;

[L, nm] = bwlabel(denoise_img, 8);
stats = regionprops(L, 'BoundingBox', 'Centroid', 'Area');

rt_list = {};
rt_cent_list = {};
for i = 1:nm
    rt = stats(i).BoundingBox;
    area = stats(i).Area;
    ct = stats(i).Centroid;
    if area < Trectarea
        continue;
    end
    v = [rt(1), rt(2), rt(3), rt(4)];
    rt_list{end+1} = v;
    rt_cent_list{end+1} = [ct(1), ct(2)];
end

len = length(rt_list);
fprintf('len rt: %d \n', len);

rt_results = {};
rt_index = {};
for i = 1:len
    
    if ~isempty(find([rt_index{:}] == i))
        continue;
    end
    rta = rt_list{i};
    va = [rta(1) rta(2) rta(3) rta(4)];
    cta = [va(1)+va(3)/2 va(2)+va(4)/2];
    ax = [va(1) va(1)+va(3) va(1)+va(3) va(1) va(1)];
    ay = [va(2) va(2) va(2)+va(4) va(2)+va(4) va(2)];
    
    new_rt = va;
    for j = 1:len
        if j == i
            continue;
        end
        rtb = rt_list{j};
        vb = [rtb(1) rtb(2) rtb(3) rtb(4)];
        ctb = [vb(1)+vb(3)/2 vb(2)+vb(4)/2];
        
        bx = [vb(1) vb(1)+vb(3) vb(1)+vb(3) vb(1) vb(1)];
        by = [vb(2) vb(2) vb(2)+vb(4) vb(2)+vb(4) vb(2)];
        
        in1 = inpolygon(bx, by, ax, ay);
        in1 = in1(1:4);
        id1 = find(in1==1);
        
        in2 = inpolygon(ax, ay, bx, by);
        in2 = in2(1:4);
        id2 = find(in2==1);
        
        % b in a
        if length(id1) == 4
            rt_index{end+1} = j;
            continue;
        end
        
        % a in b
        if length(id2) == 4
            rt_index{end+1} = j;
            continue;
        end
        % Near by with border
        ct_new = [new_rt(1)+new_rt(3)/2 new_rt(2)+new_rt(4)/2];
        distance = sqrt((ct_new(1)-ctb(1))^2 + (ct_new(2) - ctb(2))^2);
        
        
        if distance < Tseperate
            new_x = min(new_rt(1), vb(1));
            new_y = min(new_rt(2), vb(2));
            new_w = max(new_rt(1)+new_rt(3), vb(1)+vb(3)) - new_x;
            new_h = max(new_rt(2)+new_rt(4), vb(2)+vb(4)) - new_y;
            
            new_rt = [new_x new_y new_w new_h];
            rt_index{end+1} = j;
        end
        
    end
    rt_results{end+1} = new_rt;
    rt_index{end+1} = i;
end

handles.rt_results = rt_results;

imshow(RGB);
for i = 1:length(rt_results)
    v = rt_results{i};
    showrt(v, 'g');
end

% rbw = MergeContainArea(denoise_img, Trectarea);
% 
% handles.rbw = rbw;
%  
% imshow(rbw);
% hold on;
% guidata(hObject, handles);
% 
% [L, nm] = bwlabel(rbw, 8);
% stats = regionprops(L, 'BoundingBox'); 
% for i = 1:nm
%     rt = stats(i).BoundingBox;
%     v = [rt(1), rt(2), rt(3), rt(4)];
%     showrt(v, 'g');
% end

guidata(hObject, handles);
fprintf('contain end\n');



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
[H, W, Z] = size(RGB);

rt_results = handles.rt_results;
if isempty(rt_results)
    disp('rt_results is empty! \n');
end

len = length(rt_results);
for i = 1:len
    
    rt = rt_results{i};
    
    % add 5 pixels
    new_x = max(0, rt(1)-5);
    new_y = max(0, rt(2)-5);
    new_w = min(rt(1)+rt(3)+5, W)-rt(1)+5;
    new_h = min(rt(2)+rt(4)+5, H)-rt(2)+5; 
    new_rt = [new_x, new_y, new_w, new_h];
    
    Bi = imcrop(RGB, new_rt);
    
    axes(handles.axes_subimg);
    imshow(Bi);
    hold on;
    
    subimf = sprintf('%s/%d.bmp', dirname, i);
    subimg_names{i} = sprintf('%d.bmp',i);
    
    imwrite(Bi, subimf, 'bmp');
end

fprintf('cut end\n');

set(handles.list_names,'String',subimg_names);

handles.Bi = Bi;

guidata(hObject, handles);

% --- Executes on button press in btn_bgchange.
function btn_bgchange_Callback(hObject, eventdata, handles)
% hObject    handle to btn_bgchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes_img, 'reset');
axes(handles.axes_img);

gray = handles.GRAY;

gray = 255-gray;

handles.GRAY = gray;
imshow(gray);

hold on;

guidata(hObject, handles);

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


% --- Executes on slider movement.
function sld_threshold_denoise_Callback(hObject, eventdata, handles)
% hObject    handle to sld_threshold_denoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sld_threshold_denoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_threshold_denoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
