clc
clear
close all

x1=0;
x2=1;
y1=0;
y2=1;



time_steps = 10; 
intensity_steps = 11; 



figure(1);
axis([0 10 0 11]); 

writerObj = VideoWriter('myVideo.avi');
  writerObj.FrameRate = 3;
  writerObj.Quality = 90;
  % set the seconds per image
% open the video writer
open(writerObj);

for i = 1:time_steps 

    i = i-1; 
    
    for j = 1:intensity_steps
        j = j-1; 
        
        q = (1-(1/(intensity_steps-1))*j);
       
    rectangle('Position',[x1+i,y1+j,1,y2+j],'FaceColor',[0,q*(169/255),q])
    
    end
    

set(gca,'visible','off') 
set(gcf,'color','white');


% F = getframe(gcf);
% [image, Map] = frame2im(F);

writeVideo(writerObj, getframe(gcf));

%imwrite(image,sprintf('Cure_Calibration_%d.png',i)); 

hold on 
pause(1);
end

close(writerObj); 


% 
% 
% for k = 1:time_steps
%     
%   black_image_size = size(black_cure_image(:,:,j));
%   
%   blank_image = zeros(black_image_size);
%   
%   rbgImage = cat(3,black_cure_image(:,:,j),black_cure_image(:,:,j),1- black_cure_image(:,:,j));
%     
%     
%    
%     baseFileName = sprintf('Curing_Calibration_Image_%d.png',k);
%     fullFileName = fullfile(output_directory, baseFileName);
%     
%     imwrite( black_cure_image,fullFileName);
%     
% end
% 
% close all
% 


