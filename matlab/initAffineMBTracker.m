function [affineMBContext] = initAffineMBTracker(img, rect)
% img is a greyscale image with a bounding box rect
% affineMBContext is a Matlab structure that contains the Jacobian of the
% affine warp with respect to the 6 affine warp parameters and the inverse
% of the approximated Hessian matrix (J and H^-1)

%Extract the template from the frame using rect
x = rect(1); y = rect(2); w = rect(3); h = rect(4);
t = y; t1 = y+h-1; 
l = x; l1 = x+w-1;

% compute Gradient 
T = double(img(t:t1, l:l1));
[dT_x,dT_y] = gradient(T);
dT_x = dT_x(:);   
dT_y = dT_y(:);  

% compute Jacobian  
[xj, yj] = meshgrid(t:t1, l:l1);
xj = xj(:);  
yj = yj(:);  
J = [xj.*dT_x, xj.*dT_y, yj.*dT_x, yj.*dT_y, dT_x, dT_y];  

H = J'*J; % compute Hessian 

affineMBContext = struct('J', J, 'invH', H^(-1));

end

