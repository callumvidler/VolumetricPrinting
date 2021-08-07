
clear 
clc
close all


working_dir = 'C:\Users\Callum\OneDrive - Deakin University\Computed_Axial_Lithography\Images\White Cure 2D' %uigetdir('C:\Users\Callum\OneDrive - Deakin University\Computed_Axial_Lithography\Images'); 



imagefiles = dir(fullfile(working_dir, '*.png'));


baseFileNames = natsortfiles({imagefiles.name});
fullFileName = fullfile(working_dir, baseFileNames);

nfiles = length(imagefiles); 

view1 = zeros(630,840); 

writerObj = VideoWriter('myVideo.avi');
  writerObj.FrameRate = 3;
  writerObj.Quality = 90;
  % set the seconds per image
% open the video writer
open(writerObj);




   
   
for ii=1:nfiles
   % Read the image file in the loop
   currentfilename = fullFileName{ii};
   currentimage = imread(currentfilename);
   
   I = double(rgb2gray(currentimage)); 
   
   view1 = view1 + I; 

   surf(view1); 
   title('2D Calibration Model'); 
   shading interp
   colormap hot
   view(0,-90)
   caxis([900 2000])
   colorbar
 
   text(400,600,sprintf('Time increment: %.2f s', 3*ii),'Color','white');  
   
   drawnow; 
   
  I = getframe(gcf); 
  
  frames{ii} = I; 
   
   
   pause(0.5); 
 
end

close(writerObj); 





