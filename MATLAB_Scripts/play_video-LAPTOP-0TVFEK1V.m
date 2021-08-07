function play_video(file,path,x,video_duration)

fprintf(x,3); 

vid = VideoReader(cat(2,path,file));
fprintf(x,1); 


    
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
    
    
    
    
    imshow(zeros(1000,1000)); 




waitfor(msgbox('PRESS OK WHEN PRINTER IS SET')); 

fprintf(x,6);
pause(10); 


% Set up video figure window
videofig(vid.NumberOfFrames, @(frm) redraw(frm, vid));

pause(vid.NumberOfFrames/24 + 5)

pause(20); 
fprintf(x,7); 
fprintf(x,3); 
pause(20); 
close all; 


end


