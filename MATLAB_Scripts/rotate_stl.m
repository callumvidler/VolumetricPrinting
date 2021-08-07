function [tri] = rotate_stl(tri,ax,theta)
%%%rotates the stl file in along x, y or z axis by an angle theta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Author: Sunil Bhandari%%%%%%%%
%%%%Date: Mar 12, 2018 %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ax == 'x'
        rotmat = [1, 0, 0; 0, cosd(theta),-sind(theta); 0, sind(theta),cosd(theta)];
    elseif ax == 'y'
        rotmat = [cosd(theta), 0 , sind(theta); 0,1,0; -sind(theta) 0, cosd(theta)];
    elseif ax == 'z'
        rotmat = [cosd(theta), -sind(theta), 0; sind(theta), cosd(theta),0; 0, 0,1];
    else
        error('axis should be x y or z')
    end
    tri(:,1:3) = tri(:,1:3) * rotmat;
    tri(:,4:6) = tri(:,4:6) * rotmat;
    tri(:,7:9) = tri(:,7:9) * rotmat;
    tri(:,1:3:end) = tri(:,1:3:end) - min(min(tri(:,1:3:end)));
    tri(:,2:3:end) = tri(:,2:3:end) - min(min(tri(:,2:3:end)));
    tri(:,3:3:end) = tri(:,3:3:end) - min(min(tri(:,3:3:end)));
end