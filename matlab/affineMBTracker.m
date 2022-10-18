function [W_out] = affineMBTracker(img, tmp, rect, W_in, context)
% img is a greyscale image
% tmp is the template image
% rect is the bounding box
% W_in is the previous frame
% context is the precomputed J and H^-1 matrices
%
% W_out should be 3 by 3 that contains the new affine warp matrix updated so
% that it aligns the CURRENT frame with the TEMPLATE

    %Extract the template from the frame using rect
    x = rect(1); y = rect(2); w = rect(3); h = rect(4);
    t = y; t1 = y+h-1; 
    l = x; l1 = x+w-1;
    
    [m,n] = size(img);        
    W = W_in;
    threshold = 1.6;
    thresh = 0.05*threshold;
    deltaP = ones(6,1)*100; % Initial arbitrary number
    J1 = context.J;
    invH1 = context.invH;
    max = 30;
    i = 0;

    while (norm(deltaP) > threshold) && (i < max)
        dp_prev = deltaP;

        warpedI = warpH(img, W, [m,n], 0); % Warp image  
        
        T = double(tmp);
        I = double(warpedI(t:t1, l:l1));
        E = (I-T);  % compute Error
   
        deltaP = invH1 * J1' * E(:);  % compute deltaP
    
        % Update parameters  
        W_deltaP = [1+deltaP(1), deltaP(3), deltaP(5);
                 deltaP(2), 1+deltaP(4), deltaP(6);
                 0,      0,    1];
   
        if norm(deltaP - dp_prev) > thresh
            i = 0;
        end
        
        W = W/inv(W_deltaP);    
        
        i = i+1;
    end
    
    W_out = W;

end
