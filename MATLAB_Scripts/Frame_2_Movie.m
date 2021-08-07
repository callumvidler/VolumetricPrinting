tic; 

clear 
clc
close all


working_dir = uigetdir(); 



imagefiles = dir(fullfile(working_dir, '*.png'));


baseFileNames = natsortfiles({imagefiles.name});
fullFileName = fullfile(working_dir, baseFileNames);

nfiles = length(imagefiles); 
v = VideoWriter('Groot','MPEG-4');
v.Quality = 100; 

% INPUT ARGUMENTS:
%---------------------------------------------------------------
%---------------------------------------------------------------
v.FrameRate = 20; % Number of frames per second
open(v)

disp('Writting Video.....');

for ii=1:nfiles
   % Read the image file in the loop
   currentfilename = fullFileName{ii};
   currentimage = imread(currentfilename);
   
   [height,width,channel] = size(currentimage); 
   
   % Create a black image 
   black_image = zeros(height,width,3); 
   
   %Write current frame to video   
   writeVideo(v,currentimage)
   
 
end 

for ii=1:nfiles
   % Read the image file in the loop
   currentfilename = fullFileName{ii};
   currentimage = imread(currentfilename);
   currentimage = flipdim(currentimage ,2);  
   
   [height,width,channel] = size(currentimage); 
   
   % Create a black image 
   black_image = zeros(height,width,3); 
   
   %Write current frame to video   
   writeVideo(v,currentimage)
   
  
end 

 writeVideo(v,black_image)

close(v)



disp('DONE!');
toc; 



