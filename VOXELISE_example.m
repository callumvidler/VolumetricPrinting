clc
close all 
clear all 

load Purple_Colormap
%figure(1)
 %k = gca
 
% stl_array = ["Cube.stl","Hollow_lattice_cube.stl","Hyperboloid2.stl","yoda.stl"]; 



%filename = stl_array(m);  
% %Plot the original STL mesh:
% [stlcoords] = READ_stl(filename);
% xco = squeeze( stlcoords(:,1,:) )';
% yco = squeeze( stlcoords(:,2,:) )';
% zco = squeeze( stlcoords(:,3,:) )';
% [hpat] = patch(xco,yco,zco,'white');
% %axis equal
 %k.CameraViewAngleMode = 'manual'
     %set(gca,'visible','off')
     
     

% Voxelise the STL:
 [OUTPUTgrid] = VOXELISE(300,300,300,'cube.stl','xyz');

 angle  = 144; 
 
 for i = 1:300
     R = radon(OUTPUTgrid(:,:,i),angle);
     IR = iradon(R,angle); 
     
     IR = IR(1,:); 
     
     
     for j = 1:length(IR)
         
        Image(i,j) = IR(j);  
         
     end
     
     
     
     
 end
 
Image = imrotate(Image,180);
imshow(Image,[]); 
colormap(mymap)


 
 
 
% I = OUTPUTgrid(:,:,40);
% 
% counter = 0; 
% 
% %for i = 180:-0.5:0.5
%     
% counter = counter + 1; 
% step = 180/i;    
% tic;     
% R = radon(I,1:180:180);
% IR = iradon(R,1:180:180,'linear','Ram-Lak',1,500);
% 
% %IR(find(IR < 0)) = 0;  
% 
% %imshow(IR,[]); 
% %colormap(mymap)
% %drawnow;
% 
% 
%  %ax = gca;
%   %mymap = colormap(ax);
%  %save('MyColormap','mymap')
%  
%  Error = toc;%sum(sum(abs(I - IR)));
%  
%  errorArray(counter) = Error; 
%  freq(counter) = step; 
%  
% %end
% 
% %factor = errorArray(counter); 
% 
% %errorArray = 100 - (1/factor)*errorArray; 
% 
% figure('Renderer', 'painters', 'Position', [10 10 1000 500])
% plot(freq,errorArray); 
% hold on; 
% xlabel('Projection Number'); 
% ylabel('CPU Time'); 
% set(gca,'FontUnits','points','FontSize',12,'FontName','CMU Serif Roman');
% 
% legend('Cube','Lattice','Hyperboloid','Yoda'); 
% 
% 
% 
% [x,y,z] = ndgrid(1:size(OUTPUTgrid, 1), 1:size(OUTPUTgrid, 2), 1:size(OUTPUTgrid, 3)); %get coordinates of all points
% xx = x(OUTPUTgrid == 1); %keep only coordinates for A == 1 
% yy = y(OUTPUTgrid == 1); %these 3 lines also reshape the 3d array
% zz = z(OUTPUTgrid == 1); %into column vectors
% plot3(xx, yy, zz, '*');
% 
% 
% xv = linspace(min(xx), max(xx), 500);
% yv = linspace(min(yy), max(yy), 500);
% [X,Y] = meshgrid(xv, yv);
% Z = griddata(xx,yy,zz,X,Y);
% figure(2)
% surf(X, Y, Z);

