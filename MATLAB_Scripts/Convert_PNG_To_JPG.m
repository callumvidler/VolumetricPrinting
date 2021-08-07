

for i = 1:100
    
    for j = 1:100
        
        outi = 0;
        outj = 0;
        
        
        for numstep = 1:100
            outi =  outi + 1/(numstep^i);
            outj =  outj + 1/(numstep^j);
            
        end
        
        matrix(i,j) = outi+outj;
        
        
        
    end
    
    
    
end

surf(matrix,'EdgeColor','none')
