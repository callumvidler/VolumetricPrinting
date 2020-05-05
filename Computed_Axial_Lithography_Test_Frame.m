%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Callum Vidler
%Deakin University - Computed Axial Lithography Project
%START 18/02/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Computed_Axial_Lithography_Test_Frame(file,output_directory,slice_height,cross_section_resolution,output_image_resolution,output_image_height,output_image_width)

clc
clear vars
close all

counter = 0;


% waitfor(msgbox('PLEASE SELECT STL FILE'));
% 
% [file,path] = uigetfile('*.STL');
% 
% waitfor(msgbox('PLEASE SELECT IMAGE OUTPUT DIRECTORY'));
% 
% output_directory = uigetdir();
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------INPUT PARAMETERS---------------------------%

filename = file;
  angle_loop = 30;
% cross_section_resolution = 400;
% output_image_resolution = 1000;
interpolation_type = 'linear';
filter_type = 'Ram-Lak';


%-----------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


triangles = read_binary_stl_file(filename);
original = triangles;
% angle = 90;
% triangles = rotate_stl(triangles,'z',angle);

[movelist, z_slices] = slice_stl_create_path(triangles, slice_height);


%This resets any previous figure window, in addition to setting the
%resolution of the cross section image, the defult is 1000 x 1000.
% clf('reset');
figure('Renderer', 'painters', 'Position', [400 400 cross_section_resolution cross_section_resolution]);


movelist(1)=[];


%Find the maximum and minimum dimensions of the imported STL, this will be
%used to set the bounds on the figure window.
for h = 1:length(movelist)
    maximum_dimensions = max(movelist{h});
    maximum_dimensions = max(maximum_dimensions);
    
    minimum_dimensions = min(movelist{h});
    minimum_dimensions = min(minimum_dimensions);
    
    max_overall_dimension(h) = maximum_dimensions;
    min_overall_dimension(h) = minimum_dimensions;
end

%This finds the maximum and minimum absolute dimensions of the above
%function, this will be later used to determine figure window size.
max_dimensions = max(max_overall_dimension);
min_dimensions = min(min_overall_dimension);

aspect_ratio  = 1/(max_dimensions/(length(z_slices)*slice_height));



%This initialized the for loop function that loops through the
%cross-sections of the STL file in increments of the slice height shown
%above.
for i = 1:length(movelist)
    
    
    
    
    
    %Define the x and y coordinates for each cross-sectional slice.
    x = movelist{i}(:,1);
    y = movelist{i}(:,2);
    
    
    %This function insets a NaN at the start of the x and y data shown above.
    %This is so that the for loop shown below can then seperate discrete areas
    %within the image for the fill algorithm.
    x=x;
    b=[NaN] ;
    row_no=1;
    x(1:row_no-1,:) = x(1:row_no-1,:) ;
    tp =x(row_no:end,:);
    x(row_no,:)=b;
    x(row_no+1:end+1,:) =tp;
    
    y=y;
    b=[NaN] ;
    row_no=1;
    y(1:row_no-1,:) = y(1:row_no-1,:) ;
    tp =y(row_no:end,:);
    y(row_no,:)=b;
    y(row_no+1:end+1,:) =tp;
    
    
    
    
    %This determines which index values contain a NaN value. The vector formed
    %by this operation is then converted to a row vector for the for loop
    %shown below.
    xnan =  find(isnan(x));
    xnan = xnan.';
    
    %This function loops through the x and y values, seperating them into
    %discrete chunks that can then be individually plotted and filled.
    
     clear check_x
    clear check_y
    
    for u = 1:(length(xnan)-1)
        
         x1 = x(xnan(u):xnan(u+1));
        y1 = y(xnan(u):xnan(u+1));
     
       
        x1 = rmmissing(x1);
        y1 = rmmissing(y1);
        
        for t = 1:length(x1)
           
            check_x(:,t,u) = x1(t); 
            check_y(:,t,u) = y1(t); 
            
        end
        
        fill(x1,y1,'black')
      
        
        if u > 1 && (mod(u,2) == 0)
           
            
           for g = 1:u-1 
               
           in = inpolygon(x1,y1,check_x(:,:,g),check_y(:,:,g));
           jj = find(in == 1); 
           
           if length(jj) >0; 
                  fill(x1,y1,'white')
           end
           
           end
        end
     
       
        hold on
        
        set(gca,'visible','off')
        
    end
    
    
    
    %This sets the figure bounds from the dimensions calculated at the start of
    %the code.
    axis([min_dimensions max_dimensions min_dimensions max_dimensions]);
    set(gca,'visible','off')
    
    
    %This function grabs the image formed by the plot and converts and inverts
    %the black and white image, ready for the radon transform.
    F = getframe(gcf);
    [image, Map] = frame2im(F);
    
    image = im2bw(image,0.9);
    image = 1-image;
    
    
    %This for look converts the 180 degree radon transform in increments of
    %angle_frequency and stores them in a variable virtual_image. This virtual
    %image consists of a m*n*[number of angles] array.
    index_value = 0; 
        index_value = index_value +1;
        
        %This computes the back projected image via an inverse radon transform of
        %the radon transformed image.
        
        p = radon(image,angle_loop-1);
        d = iradon(p,angle_loop-1,interpolation_type,filter_type);
        zeros_index = find(d < 0); 
        d(zeros_index) = 0; 
        d = d(1,:);
        
     
        
        for k = 1:length(d)
   
            virtual_image(k,i,index_value) = d(k);
        end
        
    
    
    clf
    
   
    drawnow;
    %disp(sprintf('Layer %d/%d || Percentage Complete %.2f %% ',i,h,(i/h)*100));
end

%virtual_image = 1/(max(max(max(virtual_image))))*virtual_image; 


%This insures that the output image has the same aspect ratio as the
%original STL
% aspect_ratio  = 1/(max_dimensions/(length(z_slices)*slice_height));
% output_image_height = round(output_image_resolution*aspect_ratio);
% output_image_width = round(output_image_resolution);




dimensions_of_image = size(virtual_image);

%This for loop takes the virtual_image and rotates, resizes, sharpens and
%converts the grey scale image to an RGB blue light image. The image is
%then saved to the directory.



    
 
    
    output_image = imrotate(virtual_image(:,:,1),90);
    output_image = imresize(output_image,[output_image_height output_image_width]);
    output_image = imsharpen(output_image,'Radius',1,'Amount',5);
    
    output_image = padarray(output_image, 100, 0);
    
    output_image = im2uint8(output_image); 
    
    %rgbImage = cat(3, zeros(size(output_image)) , (169/255)*output_image, output_image);
    rgbImage = cat(3, output_image , output_image, output_image);
      
    imshow(rgbImage); 
   
    


end
