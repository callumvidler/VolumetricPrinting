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


%videofig(vid.NumberOfFrames, @(frm) redraw(frm, vid));

% winopen(cat(2,path,file));
% pause(1); 
% 
% import java.awt.Robot
% import java.awt.event.*
% keys = Robot;
% keys.setAutoDelay(1000)  
% keys.keyPress(java.awt.event.KeyEvent.VK_F) 
% keys.keyRelease(java.awt.event.KeyEvent.VK_F ) 
% keys.waitForIdle
% 
% 
% pause(vid.NumberOfFrames/60 + 0.5)
% !taskkill -f -im vlc.exe

command_1 = sprintf('mplayer -fs %s -loop 0',file);

disp(command_1); 

system(command_1); 

%!mplayer -fs 10s_Ball_In_Cage.mp4 -loop 0








% %pause(20); 
% fprintf(x,7); 
% fprintf(x,3); 
% pause(20); 



end
