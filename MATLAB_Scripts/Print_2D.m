
function Print_2D(working_directory,exposure_time)


working_directory = working_directory; 

imagefiles = dir(fullfile(working_directory, '*.png'));
baseFileNames = natsortfiles({imagefiles.name});
fullFileName = fullfile(working_directory, baseFileNames);



nfiles = length(fullFileName); 

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
  %currentimage = padarray(currentimage, [500,500], 0);
   
imshow(currentimage); 
drawnow; 
pause(exposure_time); 

 

end 



black_image = zeros(size(currentimage)); 
imshow(black_image); 



end



