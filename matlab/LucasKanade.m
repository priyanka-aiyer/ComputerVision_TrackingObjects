function [u, v] = LucasKanade(It, It1, rect)
% img is a greyscale image with a bounding box rect
 
    %Extract the template from the frame using rect
    [m,n] = size(It);
    x = rect(1); y = rect(2); w = rect(3); h = rect(4);
    t = y; t1 = y+h-1; 
    l = x; l1 = x+w-1;
    
    % Initialize p and deltaP
    p_init = zeros(6,1);
    deltaP = ones(6,1)*100; % Initial arbitrary number 
    p = p_init;
    threshhold = 3;
    
    max = 30;
    i = 0;
    while (norm(deltaP) > threshhold) && (i < max)

        W = [1+p(1), p(3), p(5);
    	       p(2), 1+p(4), p(6);
       	       0,      0,    1];
        
        warpedIt1 = warpH(It1, W, [m,n], 0); % Warp Image 
    
        I = double(warpedIt1(t:t1, l:l1));
        T = double(It(t:t1, l:l1));
        E = (T-I); % compute Error  
    
        % compute gradient 
        [dIt1_x, dIt1_y] = gradient(I); 
        dIt1_x = dIt1_x(:); 
        dIt1_y = dIt1_y(:); 
    
        % compute Jacobian  
        [xj, yj] = meshgrid(t:t1, l:l1);
        xj = xj(:); 
        yj = yj(:);         
        J = [xj.*dIt1_x, xj.*dIt1_y, yj.*dIt1_x, yj.*dIt1_y, dIt1_x, dIt1_y]; 
        
        H = J'*J; % compute Hessian 
        
        deltaP = H\(J'*E(:)); % compute deltaP
           
        p = p - deltaP; % Update 
        
        i = i+1;
    end

    u = p(5);
    v = p(6);

end 