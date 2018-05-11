function C = BLX(p1,p2)

alpha = 0.25;

%Calc D
for i = 1:size(p1,2)
   D(i) = abs(p1(i) - p2(i));
end

%Calc Q
for i = 1:size(p1,2)
   
    if p1(i) < p2(i)
        
        Q(i) = p1(i) - (alpha * D(i));
        
    else
        
        Q(i) = p2(i) - (alpha * D(i));
    
    end
end

%Calc R
for i = 1:size(p1,2)
   
    if p1(i) < p2(i)
        
        R(i) = p2(i) + (alpha * D(i));
        
    else
        
        R(i) = p1(i) + (alpha * D(i));
    
    end
end

%Calc Child
%C = zeros(size(p1,2));
for i = 1:size(p1,2)
   
    C(i) = (R(i) - Q(i)) * rand() + Q(i);
    
end

end