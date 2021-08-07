clc
clear
close all 


I = imread('Image_Angle.png');
I = I(:,:,3);


[height,width] = size(I); 

numbercells = height*width; 

x = zeros(1,numbercells); 
y = zeros(1,numbercells); 
z = zeros(1,numbercells); 

counter = 1; 

angle = pi/2;     

for i = 1:height
   
    for j = 1:width
        
        if I(i,j) > 0
            z(1,counter) =  1000;  
        end
       
       
        x(1,counter) = i; 
        y(1,counter) = j;
      
        counter = counter+1; 
    end
    
    
end

x1 = x*cos(angle) - y*sin(angle);
y1 = x*sin(angle) + y*cos(angle); 

plot3(x,y,z);
hold on; 
plot3(x1,y1,z); 





