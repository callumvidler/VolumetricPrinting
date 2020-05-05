%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Callum Vidler
%Deakin University - Computed Axial Lithography Project
%START 18/02/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Computed_Axial_Lithography(file,output_directory,slice_height,exposure_time,cross_section_resolution,output_image_resolution,output_image_height,output_image_width,thresh_val,area_scaling,black_color)

clc
clear vars
close all

f = waitbar(0,'Loading Data From STL... Please Wait'); 

counter = 0;

tic;

[OUTPUTgrid] = VOXELISE(cross_section_resolution,cross_section_resolution,slice_height,file,'xyz');


for i = 1:slice_height
   scale_matrix(i) = length(find(OUTPUTgrid(:,:,i) == 1));  
end

avg_value = mean(scale_matrix); 
for i = 1:slice_height
   scale_matrix(i) = avg_value / scale_matrix(i);
end


frame_rate = 60; 

angle_frequency = 360/(exposure_time*frame_rate)

interpolation_type = 'linear';
filter_type = 'shepp-logan';


f = waitbar(100,'Data Loaded From STL..'); 

for i = 1:slice_height
    
        index_value = 0;
    for angle_loop = 1:angle_frequency:181
        index_value = index_value +1;
        
        image = OUTPUTgrid(:,:,i); 
        
        %This computes the back projected image via an inverse radon transform of
        %the radon transformed image.
        
        p = radon(image,angle_loop-1);
        d = iradon(p,angle_loop-1,interpolation_type,filter_type);
        zeros_index = find(d < 0); 
        d(zeros_index) = 0; 
        
        if area_scaling == 1
        
        d = scale_matrix(i)*d(1,:);
        end
        
        if area_scaling == 0
            d = d(1,:);
        end
     
        
        for k = 1:length(d)
   
            virtual_image(k,i,index_value) = d(k);
        end
        
    end
    

    
     f = waitbar(i/slice_height,f,sprintf('Layer Complete %d / %d',i,slice_height)); 
    
    
    disp(sprintf('Layer %d',i)); 
    
    %disp(sprintf('Layer %d/%d || Percentage Complete %.2f %% ',i,h,(i/h)*100));
end

dimensions_of_image = size(virtual_image);
virtual_image = im2uint8(virtual_image);

% for i = 1:dimensions_of_image(3)
%    
%     img_new = virtual_image(:,:,i); 
%     index_img = find(0.05 < virtual_image(:,:,i) < 0.4);
%     
%     img_new(index_img) = 0.6; 
%     
%     virtual_image(:,:,i) = img_new; 
%     
%     
% end


%This for loop takes the virtual_image and rotates, resizes, sharpens and
%converts the grey scale image to an RGB blue light image. The image is
%then saved to the directory.

video_name = sprintf('reconstructed_video_%s',file); 

v = VideoWriter(video_name,'MPEG-4');
v.Quality = 90; 
v.FrameRate = frame_rate; % Number of frames per second
open(v)

waitbar(0,f,'Writting Video...'); 

counter = 0; 


for output_loop = 1:dimensions_of_image(3)
    
    counter = counter + 1; 
    
  waitbar(counter/(2*dimensions_of_image(3)),f,sprintf('Writting Video.. %.2f %% Complete',(100*counter)/(2*dimensions_of_image(3)))); 
    
    output_image = imrotate(virtual_image(:,:,output_loop),90);
    
    if thresh_val > 0
    
    img_size = size(output_image); 
    img_size = img_size(2)/2; 
    
    
    for h = 1:img_size
        output_image(:,h) = output_image(:,h)*(1+(h*(thresh_val-1)/img_size));
    end
    
    output_image = imrotate(output_image,180); 
    
     for h = 1:img_size
        output_image(:,h) = output_image(:,h)*(1+(h*(thresh_val-1)/img_size));
     end
    
     output_image = imrotate(output_image,180); 
    
    end
    
    
    
    output_image = imresize(output_image,[output_image_height output_image_width]);
    output_image = imsharpen(output_image,'Radius',1,'Amount',5);
    
    if black_color == 1
          
         %output_image = 1 - output_image;
          
       rgbImage = cat(3, output_image, output_image, output_image);
    end
    
    if black_color == 0
         rgbImage = cat(3, zeros(size(output_image)) , (169/255)*output_image, output_image);
    end
    
    
    writeVideo(v,rgbImage);
    
    

end

for output_loop = 1:dimensions_of_image(3)
    
    counter = counter + 1; 
 
 waitbar(counter/(2*dimensions_of_image(3)),f,sprintf('Writting Video.. %.2f %% Complete',(100*counter)/(2*dimensions_of_image(3)))); 

    output_image = imrotate(virtual_image(:,:,output_loop),90);
    
    
    if thresh_val > 0
    
    
        img_size = size(output_image); 
    img_size = img_size(2)/2; 
    
    
    for h = 1:img_size
        output_image(:,h) = output_image(:,h)*(1+(h*(thresh_val-1)/img_size));
    end
    
    output_image = imrotate(output_image,180); 
    
     for h = 1:img_size
        output_image(:,h) = output_image(:,h)*(1+(h*(thresh_val-1)/img_size));
     end
    
     output_image = imrotate(output_image,180); 
    
    end
    
    
    output_image = imresize(output_image,[output_image_height output_image_width]);
    output_image = imsharpen(output_image,'Radius',1,'Amount',5);
    output_image = flipdim(output_image ,2);
    
    if black_color == 1
        %output_image = 1 - output_image;
       rgbImage = cat(3, output_image, output_image, output_image);
    end
    
    if black_color == 0
         rgbImage = cat(3, zeros(size(output_image)) , (169/255)*output_image, output_image);
    end
    
   
    writeVideo(v,rgbImage);

    
    
    
    

end


close(v)

disp('DONE!')
final_time = toc;

msgbox(sprintf('Time taken for reconstruction: %s',duration(0,0,final_time)))
pause(3); 
close all; 

end
