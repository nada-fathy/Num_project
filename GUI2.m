function varargout = GUI2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI2_OutputFcn, ...
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

function GUI2_OpeningFcn(hObject, eventdata, handles, varargin)
global xData;
xData.MyData = [];
global yData;
yData.MyData = [];
 
handles.output = hObject;
guidata(hObject, handles);
function varargout = GUI2_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
 
function [myString]=result(method,str1,str2)
  global xData;
global yData;global flag; global A;

if (flag==1)                           %reading from file
    x=zeros;y=zeros;
    for i=1:length(A)
        x(i)=A(i,1);
        y(i)=A(i,2);
    end
   % x = str2double(xstring);
%y = str2double(ystring);
if (((length(x))==(length(y)))&&(length(x)>1))
        order=str2double(str1);
        xre=str2double(str2);
         if(isnan(order) || isnan(xre))
           msgbox('you should enter only digits');  
           return ;  
         end
        if(strcmp(method,'Newton'))
            [answer,time,equ] = Newton(order, x, y, xre);
        else
            [time,answer,equ] = LagrangeInterpolating(xre,order,x,y);
        end
        myString = sprintf('Time=%fSec\nequation=\n%s\nSolution=%f\n',time,equ,answer);
        fplot(equ,[xre-2,xre+2])
        grid();
  
else
    msgbox('please enter X&Y correctly');  
    return ;
end  
else 
x = str2double(xData.MyData);
y = str2double(yData.MyData);
if (((length(x))==(length(y)))&&(length(x)>1))
    if(isempty(str1))
         msgbox('please enter the order');  
         return ;
    elseif(isempty(str2))
        msgbox('please enter the X wanted to compute');  
         return ;
    else
        order=str2double(str1);
        xre=str2double(str2);
         if(isnan(order) || isnan(xre))
           msgbox('you should enter only digits');  
           return ;  
         end
        if(strcmp(method,'Newton'))
            [answer,time,equ] = Newton(order, x, y, xre);
        else
            [time,answer,equ] = LagrangeInterpolating(xre,order,x,y);
        end
        myString = sprintf('Time=%fSec\nequation=\n%s\nSolution=%f\n',time,equ,answer);
        fplot(equ,[xre-2,xre+2])
        grid();
    end
else
    msgbox('please enter X&Y correctly');  
    return ;
end  
end
 
% --- Executes on button press in newton.
function newton_Callback(hObject, eventdata, handles)
global flag;global order;global xrequire;
if flag==1
    str1 = order;
    str2= xrequire;
    myString=result('Newton',str1,str2);
    set(handles.solution, 'String', myString);
    flag=0;
else
    str1 = get(handles.order,'string');
    str2= get(handles.xreq,'string');
    myString=result('Newton',str1,str2);
    set(handles.solution, 'String', myString);
end
 
% --- Executes on button press in lagrange.
function lagrange_Callback(hObject, eventdata, handles)
global flag;global order;global xrequire;
if flag==1
    str1 = order;
    str2= xrequire;
    myString=result('Lagrange',str1,str2);
    set(handles.solution, 'String', myString);
    flag=0;
else
    str1 = get(handles.order,'string');
    str2= get(handles.xreq,'string');
    myString=result('Lagrange',str1,str2);
    set(handles.solution, 'String', myString);
end
 
function Xfield_Callback(hObject, eventdata, handles) 
 
% --- Executes during object creation, after setting all properties.
function Xfield_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end 
 
function Yfield_Callback(hObject, eventdata, handles) 
 
% --- Executes during object creation, after setting all properties.
function Yfield_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
% --- Executes on button press in filling.
function filling_Callback(hObject, eventdata, handles)
global xData;
global yData;
x = get ( handles.Xfield,'string');
y = get ( handles.Yfield,'string');
if (length(x)>0)
    if(isnan(str2double(x)))
       msgbox('you should enter only digits');  
           return ;  
    end  
xData.MyData = [xData.MyData; [{x}]];
set (handles.Xtable,'Data',xData.MyData);
end
if(length(y)>0)
    if(isnan(str2double(y)))
     msgbox('you should enter only digits');  
           return ;  
    end
yData.MyData = [yData.MyData; [{y}]];
set (handles.Ytable,'Data',yData.MyData);
end
set ( handles.Xfield,'string','');
set ( handles.Yfield,'string','');
 
 
% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
global xData;
global yData;
set(handles.Xtable, 'Data', {});
set(handles.Ytable, 'Data', {});
set ( handles.Xfield,'string','');
set ( handles.Yfield,'string','');
xData.MyData = [];
yData.MyData = [];
set(handles.solution, 'String', '');
set(handles.solution, 'String', '');
cla(handles.axes1);

function order_Callback(hObject, eventdata, handles)

function order_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xreq_Callback(hObject, eventdata, handles)
function xreq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function axes1_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in Delete.
function Delete_Callback(hObject, eventdata, handles)
global xData;
global yData;
xData.MyData(end)=[];
set (handles.Xtable,'Data',xData.MyData);
yData.MyData(end)=[];
set (handles.Ytable,'Data',yData.MyData);


% --- Executes on button press in readfile.
function readfile_Callback(hObject, eventdata, handles)
% hObject    handle to readfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag; global A; global order;global xrequire;
flag=0;
[A,order,xrequire,counter] =ReadFromFile2();

if(counter~=3)
    msgbox('Wrong input');
else
    flag=1;
end
