function play_frame(working_directory_frame,exposure_time,x)
tic; 

working_directory = working_directory_frame; 

imagefiles = dir(fullfile(working_directory, '*.png'));
baseFileNames = natsortfiles({imagefiles.name});
fullFileName = fullfile(working_directory, baseFileNames);

fprintf(x,1); 

nfiles = length(fullFileName); 

exposure_time = exposure_time/(2*nfiles); 


 hFig = gcf;
 hAx  = gca;
 % set the figure to full screen
 set(hFig,'units','normalized','outerposition',[0 0 1 1]);
 % set the axes to full screen
 set(hAx,'Unit','normalized','Position',[0 0 1 1]);
 % hide the toolbar
 set(hFig,'menubar','none')
 % to hide the title
 set(hFig,'NumberTitle','off');
 set(hFig,'WindowState','fullscreen'); 
 set(gcf,'color','black');

 black_image = zeros(1000,1000); 
 imshow(black_image); 

waitfor(msgbox('PRESS OK WHEN WINDOW IS SET')); 



 
for ii=1:nfiles
   % Read the image file in the loop
   currentfilename = fullFileName{ii};
   currentimage = imread(currentfilename);
  currentimage = padarray(currentimage, [500,500], 0,'both');
   
imshow(currentimage); 
drawnow; 
pause(exposure_time); 
imshow(zeros(1000,1000)); 
drawnow;
pause(0.4); 
fprintf(x,8); 

end 

for ii=1:nfiles
   % Read the image file in the loop
   currentfilename = fullFileName{ii};
   currentimage = imread(currentfilename);
   currentimage = flipdim(currentimage ,2);  
  currentimage = padarray(currentimage, [500,500], 0);
   
imshow(currentimage); 
drawnow; 
pause(exposure_time); 
imshow(zeros(1000,1000)); 
drawnow;
pause(0.4); 
fprintf(x,8); 

end 


imshow(zeros(1000,1000)); 
fprintf(x,3); 
t = toc; 

msgbox(sprintf('Time taken was %.2f s',t)); 
end

