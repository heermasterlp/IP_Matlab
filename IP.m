function varargout = IP(varargin)
% IP M-file for IP.fig
%      IP, by itself, creates a new IP or raises the existing
%      singleton*.
%
%      H = IP returns the handle to a new IP or the handle to
%      the existing singleton*.
%
%      IP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IP.M with the given input arguments.
%
%      IP('Property','Value',...) creates a new IP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IP_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help IP

% Last Modified by GUIDE v2.5 09-Jul-2010 03:40:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IP_OpeningFcn, ...
                   'gui_OutputFcn',  @IP_OutputFcn, ...
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


% --- Executes just before IP is made visible.
function IP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IP (see VARARGIN)

% Choose default command line output for IP
handles.output = hObject;

% Define parameters by myself--@YLJ@

% In future may be a better auto-defination for this
handles.Tseperate = 160;    
handles.Tdenoise = 30;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes_img, 'reset');

[filename,filepath] = uigetfile({'*.jpg;*.bmp'});

if ~isequal(filename, 0)
    
    handles.dir = filepath;
    handles.imgfile = filename;
    
    file = sprintf('%s/%s',filepath,filename);
    
    BW = imread(file);
    
    handles.BW = BW;
    
    axes(handles.axes_img);
    imshow(BW);
    hold on;
    
    guidata(hObject,handles);
end

% --------------------------------------------------------------------
function ExitMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to ExitMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection = questdlg(['Close' get(handles.figure1,'Name') '?'], ...
                     ['Close' get(handles.figure1,'Name') '...'], ...
                     'Yes','No','Yes');
                 
if strcmp(selection,'No')
    return;
end

delete(handles.figure1);

% --------------------------------------------------------------------
function ThresholdsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ThresholdsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function TSeperationMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to TSeperationMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Threshold S:'};
dlg_title = 'Threshold for Seperation';
num_lines = 1;
Tseperate = handles.Tseperate;
def = int2str(Tseperate);
def = cellstr(def);

options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg(prompt,dlg_title,num_lines,def); % the handle of dialog is a cell array

[m,n] = size(answer);

if (m ~= 0 && n ~= 0)
    number = str2num(answer{1,1});
else
    number = Tseperate;
end

handles.Tseperate = number;

guidata(hObject, handles);

% --------------------------------------------------------------------
function TDenoiseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to TDenoiseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Threshold D:'};
dlg_title = 'Threshold for Denoise';
num_lines = 1;
Tdenoise = handles.Tdenoise;
def = int2str(Tdenoise);
def = cellstr(def);

options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg(prompt,dlg_title,num_lines,def); % the handle of dialog is a cell array

[m,n] = size(answer);

if (m ~= 0 && n ~= 0)
    number = str2num(answer{1,1});
else
    number = Tdenoise;
end

handles.Tdenoise = number;

guidata(hObject, handles);

% --------------------------------------------------------------------
function PreprocessMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PreprocessMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function BinaryMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to BinaryMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes_img, 'reset');
axes(handles.axes_img);

BW = handles.BW;

bw = im2bw(BW,graythresh(BW));
handles.bw = bw;

imshow(bw);
hold on;

guidata(hObject,handles);

% --------------------------------------------------------------------
function DenoiseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to TDenoiseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes_img, 'reset');

Tdenoise = handles.Tdenoise;
bw = handles.bw;

bw = ~bw;
[L,nm] = bwlabel(bw,8);

stats = regionprops(L,'Area');

% Delete areas with less than 'Tdenoise' of pixels 
for i = 1:nm
    a = stats(i).Area;
    if a <= Tdenoise
        [r,c] = find(L == i);
        np = length(r);
        for t = 1:np
            bw(r(t,1),c(t,1)) = 0;
        end
    end
end

handles.bw = bw;

axes(handles.axes_img);
imshow(bw);
hold on;

guidata(hObject,handles);

% --------------------------------------------------------------------
function MergeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to MergeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ContainMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to ContainMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes_img, 'reset');
axes(handles.axes_img);

bw = handles.bw;

rbw = MergeContainArea(bw);

handles.rbw = rbw;

imshow(rbw);
hold on;

guidata(hObject,handles);

[L,nm] = bwlabel(rbw,8);
stats = regionprops(L,'BoundingBox');

for i = 1:nm    
    rt = stats(i).BoundingBox;
    v = [rt(1),rt(2),rt(3),rt(4)];
    
    showrt(v,'y');
end

% --------------------------------------------------------------------
function CrossMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CrossMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes_img, 'reset');

Tseperate = handles.Tseperate;

rbw = handles.rbw;
bw = handles.bw;

axes(handles.axes_img);
imshow(bw);
hold on;

MergeCrossArea(rbw,Tseperate);

% --------------------------------------------------------------------
function CutMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CutMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CutImageMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CutImageMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes_img, 'reset');
cla(handles.axes_subimg, 'reset');
axes(handles.axes_img);

imgfile = handles.imgfile;
[pathstr,name,ext] = fileparts(imgfile);
dirname = name;

if exist(dirname,'dir') == 0
    mkdir(dirname);
end
    
BW = handles.BW;
imshow(BW);
hold on;

rfile = 'r.dat';
file = textread(rfile,'%s','delimiter','\n','whitespace','','bufsize',4095);
nline = length(file);

narea = nline/2;

for i = 1:narea
    
    cla(handles.axes_subimg, 'reset');
    
    lid = (i-1)*2+1;
    icen = strread(file{lid},'%s');
    irt = strread(file{lid+1},'%s');

    cen = [str2num(icen{1,1});str2num(icen{2,1})];

    rt = [];
    for j = 1:4
        t = str2num(irt{j,1});
        rt = [rt,t];
    end
    
    axes(handles.axes_img);
    showrt(rt,'b');
    
    Bi = imcrop(BW,rt);
    
    axes(handles.axes_subimg);
    imshow(Bi);
    hold on;
    
    subimf = sprintf('%s\\%d.bmp',dirname,i);
    
    imwrite(Bi,subimf,'bmp');
    
    pause(1.2);
end

