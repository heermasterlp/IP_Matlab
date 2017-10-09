function varargout = IPcomparation(varargin)
% IPCOMPARATION MATLAB code for IPcomparation.fig
%      IPCOMPARATION, by itself, creates a new IPCOMPARATION or raises the existing
%      singleton*.
%
%      H = IPCOMPARATION returns the handle to a new IPCOMPARATION or the handle to
%      the existing singleton*.
%
%      IPCOMPARATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IPCOMPARATION.M with the given input arguments.
%
%      IPCOMPARATION('Property','Value',...) creates a new IPCOMPARATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IPcomparation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IPcomparation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IPcomparation

% Last Modified by GUIDE v2.5 09-Oct-2017 10:59:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IPcomparation_OpeningFcn, ...
                   'gui_OutputFcn',  @IPcomparation_OutputFcn, ...
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


% --- Executes just before IPcomparation is made visible.
function IPcomparation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IPcomparation (see VARARGIN)

% Choose default command line output for IPcomparation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IPcomparation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IPcomparation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
