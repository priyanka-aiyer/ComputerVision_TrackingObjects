clear
clc

% Initialize Bounding box
tracker = [140, 110, 320, 260]; % given: tracker = [160, 120, 300, 260];

video = VideoWriter('../results/car_lk','MPEG-4');  %given: ('../results/car_mb_1.avi');
open(video);

width = abs(tracker(1)-tracker(3));
height = abs(tracker(2)-tracker(4));

% TODO Pick a bounding box in the format [x y w h]
% You can use ginput to get pixel coordinates

%% Initialize the tracker
figure;

prev_frame = imread('../data/car/frame0020.jpg');

for i = 20:250
    prev_frame = imread(sprintf('../data/car/frame%04d.jpg', i));
    new_frame = imread(sprintf('../data/car/frame%04d.jpg', i+1));

    clf;
    imshow(prev_frame);
    title("Frame " + num2str(i));
    hold on;
    rectangle('Position',[tracker(1),tracker(2),width,height], 'LineWidth',2, 'EdgeColor', 'y');
    drawnow; % Added line

    F = getframe;
    writeVideo(video,F);
    
    rect = [tracker(1), tracker(2), width, height]; % Added line
    [u,v] = LucasKanade(prev_frame, new_frame, rect); % Updated
    
    tracker(1) = round(tracker(1)+u);
    tracker(2) = round(tracker(2)+v);
    tracker(3) = round(tracker(3)+u);
    tracker(4) = round(tracker(4)+v);
   
    width = abs(tracker(1)-tracker(3)); % Added line 
    height = abs(tracker(2)-tracker(4)); % Added line
    
end

close(video);
