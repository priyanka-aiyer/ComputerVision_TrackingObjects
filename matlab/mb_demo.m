clear
clc

% Initialize Bounding box
x_center = 230;     %given: 240
y_center = 192;  
width = 210;  
height = 175;       %given: 170

l = x_center-floor(width/2);
t = y_center-floor(height/2);
tracker = [l t width height]; % Initial Bounding box

video = VideoWriter('../results/car_mb.mp4', 'MPEG-4'); %given: ('../results/car_mb_2.avi');
open(video);

% Initialize the tracker
figure;

% TODO run the Matthew-Baker alignment in both landing and car sequences
prev_frame = imread('../data/car/frame0020.jpg');
template = prev_frame(t:(t+height-1),l:(l+width-1));   

%implement your code here
%---------------------------------------
p = zeros(6,1); %
Win = [1+p(1), p(3), p(5);
       p(2), 1+p(4), p(6);
       0,      0,    1];

rect = tracker; 
context = initAffineMBTracker(prev_frame, rect);

%--------------------------------------- 
% Start tracking
for i = 21:250      
    
    imgdir = sprintf('../data/car/frame%04d.jpg', i);
    if (~exist(imgdir,'file'))
        continue;
    end
    im = imread(imgdir);

    Wout = affineMBTracker(im, template, rect, Win, context);

    %implement your code here
    %---------------------------------------
    new_c = Wout*[x_center;y_center;1];

    % calculate the newidth bounding rectangle
    new_tracker = [round(new_c(1)-floor(width /2)), round(new_c(2)-floor(height/2)), width , height]; 
    rect = new_tracker;
    %---------------------------------------

    clf;
    hold on;
    imshow(im);   
    rectangle('Position', rect, 'LineWidth', 1, 'EdgeColor', [1 1 0]);
    title("Frame " + num2str(i));
    drawnow;

    F = getframe;
    writeVideo(video,F);

    
end
close(video);
