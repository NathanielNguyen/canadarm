%{
Canadarm project 
- Nathaniel Nguyen
- Spring 2017

Move the selected arm using the up and down keys]
FIXED the bug with focus. See line 43 for fix. 
%}
function Canadarm

global arm1 arm2 arm3 but1 but2 but3 deg a rot sen c h c1 %declares all global variables
fig = figure('Visible', 'off',... %creates the figure
            'Units', 'normalized',... 
            'Position', [0.2, 0.1, 0.5, 0.7],...
            'name', 'Canadarm',... 
            'KeyPressFcn',@keypress,... %Key Press listener
            'toolbar', 'none',... %hide toolbar and menubar
            'menubar', 'none');
h = 0; %checkbox selected variable
rot = 0; %rotation variable
sen = 1; %sensitivity in rotation slider
a = 1; %current arm selected
deg = 1; %sensitivity of movements

arm1 = [0,0.3420; %position of each arm
        0,0.9397];       
arm2 = [arm1(1,2), 1.2080; 
        arm1(2,2), 1.4397];      
arm3 = [arm2(1,2), 2.0741 ; 
        arm2(2,2), 0.9397];
c =[1 1 1];    %Color
c1 = [1 1 1]; %Color1

%radio group
bg = uibuttongroup(fig, 'Visible', 'off','SelectionChangeFcn', @radioChange, 'BackgroundColor',c);    

%radiobutton with uicontrol
but1 = uicontrol(bg, 'Style', 'radiobutton',...
                'String', 'Arm 1',...
                'Units', 'normalized',...
                'Position', [.025, .55, .1, .05],...
                'HandleVisibility', 'off',... 
                'KeyPressFcn',@keypress,... %brings the focus back to the keypress. 
                'BackgroundColor', c1);
but2 = uicontrol(bg, 'Style', 'radiobutton',...
                'String', 'Arm 2',...
                'Units', 'normalized',...
                'KeyPressFcn',@keypress,...
                'Position', [.025, .5, .1, .05],...
                'HandleVisibility', 'off',...
                'BackgroundColor', c1);            
but3 = uicontrol(bg, 'Style', 'radiobutton',...
                'String', 'Arm 3',...
                'Units', 'normalized',...
                'Position', [.025, .45, .1, .05],...
                'HandleVisibility', 'off',...
                'KeyPressFcn',@keypress,... 
                'BackgroundColor', c1);
        
degText = uicontrol('Style', 'text', 'String', 'Total Degrees of Rotations','Units', 'normalized', 'Position', [.025, .15, .1, .1],'FontWeight', 'bold', 'BackgroundColor', c1);  
slider1 = uicontrol('Style', 'slider','KeyPressFcn',@keypress,'Min', 1, 'Max', 50, 'Value', 1,'Units', 'normalized', 'Position', [.025, .7, .1, .02],'FontWeight', 'bold','Callback', @setDeg, 'BackgroundColor', c1);
sensitivityText = uicontrol('Style', 'text', 'string', 'Sensitivity','KeyPressFcn',@keypress, 'Units', 'normalized', 'Position', [0.025, 0.73, .1, .02], 'BackgroundColor', c1);
horseCheckBx = uicontrol('Style', 'checkbox', 'Units', 'normalized', 'Position', [0.025, 0.39, .1, .02],'KeyPressFcn',@keypress,'string', 'Horsey?','backgroundcolor', c1, 'Callback', @horsey);
bg.Visible = 'on';
fig.Visible = 'on';

%creates container for plot
pan1 = uipanel(fig, 'Units', 'normalized', 'Position', [.15, 0, 1, 1]); 
pan1.BackgroundColor = c;
pan1.ForegroundColor = c;
ax = axes(pan1,'Units', 'normalized',... %builds axis
                'Position', [0.05, 0.05, 0.75, 0.85]);            
%Render Plot function            
render()
xlim([-3 3])
ylim([-3, 3])   

fig.Visible = 'on';
end

function render()
%plots the graph. 
    global arm1 arm2 arm3 rot h c1 yloc
    hold off 
    plot(arm1(1,:), arm1(2,:), '-o');
    hold on
    
    %If checkbox is selected display horse
    if h == 1
        horse = imread('Horsey.png');
        xloc = [arm3(3)-.2, arm3(3)+.2];
        yloc = [arm3(4)+.1, arm3(4)-.4];
        image(xloc, yloc, horse); 

        
    end
    
    axs = gca;
    axs.Color = 'none'; %makes plot transparent to see through color
    axis off
    x = [-0.5,0.5];
    y = [0,0];
    plot(x, y, '-g');
    plot(arm2(1,:), arm2(2,:), '-o'); %plots the arms 
    plot(arm3(1,:), arm3(2,:), '-o');
    plot(arm1(1,:), arm1(2,:), '-o');
    xlim([-3 3])
    ylim([-3, 3])
    %Title of plot
    text(-.955, 3.4, 'Canadarm', 'Color', [.8 .8 .8],'FontSize', 30,'FontWeight', 'bold'); 
    text(-1, 3.4, 'Canadarm', 'Color', 'Red', 'FontSize', 30,'FontWeight', 'bold');
    text(-0.8, 3.1, 'by Nathaniel Nguyen', 'Color', 'black', 'FontSize', 12,'FontWeight', 'bold');
    uicontrol('Style', 'text', 'String', ['' num2str(rot)],'Units', 'normalized', 'Position', [.025, .1, .1, .1],'FontWeight', 'bold', 'BackgroundColor', c1);  

end

function rotate(z, x)
    %rotates arm, z = which arm; x = amount of degrees to rotate

    global arm1 arm2 arm3 rot sen
    x = x * pi()/180; %conversion of deg to radians
    rotation = [cos(x), -sin(x); %standard rotation matrix
                sin(x), cos(x)]; 
    rot = rot + sen;
    if z == 1 %determines which arm selected and performs appropriate rotation
         arm1 = rotation * arm1;
         arm2 = rotation * arm2;
         arm3 = rotation * arm3;
    elseif z == 2

         arm2(1,:) = arm2(1,:) - arm1(3);
         arm2(2,:) = arm2(2,:) - arm1(4);

         arm3(1,:) = arm3(1,:) - arm1(3);
         arm3(2,:) = arm3(2,:) - arm1(4);

         arm2 = rotation * arm2;
         arm3 = rotation * arm3;

         arm2(1,:) = arm2(1,:) + arm1(3);
         arm2(2,:) = arm2(2,:) + arm1(4);

         arm3(1,:) = arm3(1,:) + arm1(3);
         arm3(2,:) = arm3(2,:) + arm1(4);

    elseif z == 3

         arm3(1,:) = arm3(1,:) - arm2(3);
         arm3(2,:) = arm3(2,:) - arm2(4);
         arm3 = rotation * arm3;
         arm3(1,:) = arm3(1,:) + arm2(3);
         arm3(2,:) = arm3(2,:) + arm2(4);   
    end
            
end

function keypress(varargin) 
    %keypress function

    global deg a
    key = get(gcbf, 'CurrentKey');

    if strcmp(key, 'uparrow') 
        rotate(a,deg)  
        render()
    elseif strcmp(key, 'downarrow')
        rotate(a, -deg)
        render()
    elseif strcmp(key, 'rightarrow')
    elseif strcmp(key, 'leftarrow')
    elseif strcmp(key, 'space')        
    end

end

function radioChange(source, event) %radio button selection
    %radio button changes/selection
    global a
    
    newVal = event.NewValue.String;
    if strcmp(newVal, 'Arm 1')
        a = 1;        
    elseif strcmp(newVal, 'Arm 2')
        a = 2;           
    elseif strcmp(newVal, 'Arm 3')
        a = 3;                 
    end

end

function setDeg(source,event) 
%slider options
global deg sen
    
    deg = source.Value;
    sen = source.Value;

end
function horsey(source, event)

global h
%chekcbox selection function
if source.Value == 1
    h = 1;
    render()    
elseif source.Value == 0
    h = 0;
    render()    
end

end
