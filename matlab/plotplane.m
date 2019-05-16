function plotplane(pc,plane)
% PLOTPLANE Plot results of function PCEXTRPLN.
%   PLOTPLANE(PC,RES) plots the results RES that PCEXTRPLN extracted from
%   the point cloud PC.

% Compute the radii and normalized direction vectors of all rays.
np = pc.Count;
l = reshape(pc.Location, np, 3, 1);
v = l ./ vecnorm(l, 2, 2);

% Create a colormap of different colors.
npln = numel(plane);
ngt = sum((unique(pc.Intensity) >= 10));
rng(0);
cmgt = rand(ngt,3);
cmms = rand(npln,3);

% Plot the point cloud.
cdata = ones(size(l)) / 2;
for ip = 1 : npln
    cdata([plane(ip).index],:) ...
        = repmat(cmms(ip,:),numel(plane(ip).index),1);
end
scatter3(l(:,1), l(:,2), l(:,3), np^(1/3), cdata, '.');

% Configure plot.
axis equal
labelaxes

% Plot the planes.
h = ishold;
hold on
spc = [size(pc.Location,1), size(pc.Location,2)];
for ip = find(cellfun(@(i) numel(i)>=3, {plane.index}))
    % Determine the subscript indices of the points of the plane.
    [ox,oy] = ind2sub(spc, plane(ip).index);
    
    % Determine the indices of the points that form the boundary of the
    % plane.
    k = boundary(ox(:), oy(:));
    
    % Determine the 3-D coordinates of the boundary.
    r = vecnorm(plane(ip).param,2,2);
    vp = plane(ip).param ./ r;
    lk = v(plane(ip).index(k),:) .* rayxpln(vp(1,:),vp(2,:),vp(3,:),...
        r(1),r(2),r(3),v(plane(ip).index(k),:));

    % Plot the boundary.
    fill3(lk(:,1), lk(:,2), lk(:,3), cmms(ip,:), 'FaceAlpha', 0.8)
end
if ~h
    hold off
end
campos([0 0.2 0]);

end

function [r,j] = rayxpln(in1,in2,in3,r1,r2,r3,in7)
% RAYXPLN Radius of ray intersecting plane.
%   R = RAYXPLN(V1,V2,V3,R1,R2,R3,V) computes the radius R of a ray
%   intersecting a plane. The ray is defined by the direction vector V. The
%   plane is defined by the three points R1*V1, R2*V2, R3*V3. All rays
%   originate in the same point with arbitrary coordinates.
%
%   R is a scalar. V1, V2, and V3 are 3-element row vectors. V is an Nx3
%   matrix of direction vectors.
%
%   [R,J] = RAYXPLN(...) also computes the Nx3 Jacobian of R with respect
%   to R1, R2, R3.
%
%   Example:
%      [r,j] = rayxpln([1,0,0],[1,1,0],[1,0,1],3,4,5,rand(10,3))
%
%   See also LINXPLN.
  
% Copyright 2018 Alexander Schaefer

%    This function was generated by the Symbolic Math Toolbox version 8.1.

v11 = in1(:,1);
v12 = in1(:,2);
v13 = in1(:,3);
v21 = in2(:,1);
v22 = in2(:,2);
v23 = in2(:,3);
v31 = in3(:,1);
v32 = in3(:,2);
v33 = in3(:,3);
v41 = in7(:,1);
v42 = in7(:,2);
v43 = in7(:,3);
t2 = v11.*v22.*v33;
t3 = v12.*v23.*v31;
t4 = v13.*v21.*v32;
t17 = v11.*v23.*v32;
t18 = v12.*v21.*v33;
t19 = v13.*v22.*v31;
t5 = t2+t3+t4-t17-t18-t19;
t6 = r1.*r2.*v11.*v22.*v43;
t7 = r1.*r2.*v12.*v23.*v41;
t8 = r1.*r2.*v13.*v21.*v42;
t9 = r1.*r3.*v11.*v33.*v42;
t10 = r1.*r3.*v12.*v31.*v43;
t11 = r1.*r3.*v13.*v32.*v41;
t12 = r2.*r3.*v21.*v32.*v43;
t13 = r2.*r3.*v22.*v33.*v41;
t14 = r2.*r3.*v23.*v31.*v42;
t20 = r1.*r2.*v11.*v23.*v42;
t21 = r1.*r2.*v12.*v21.*v43;
t22 = r1.*r2.*v13.*v22.*v41;
t23 = r1.*r3.*v11.*v32.*v43;
t24 = r1.*r3.*v12.*v33.*v41;
t25 = r1.*r3.*v13.*v31.*v42;
t26 = r2.*r3.*v21.*v33.*v42;
t27 = r2.*r3.*v22.*v31.*v43;
t28 = r2.*r3.*v23.*v32.*v41;
t15 = t6+t7+t8+t9+t10+t11+t12+t13+t14-t20-t21-t22-t23-t24-t25-t26-t27-t28;
r = (r1.*r2.*r3.*t5)./t15;
if nargout > 1
    t16 = r3.^2;
    t29 = 1.0./t15.^2;
    t30 = r1.^2;
    t31 = r2.^2;
    j = [t5.*t16.*t29.*t31.*(v21.*v32.*v43-v21.*v33.*v42-v22.*v31.*v43+v22.*v33.*v41+v23.*v31.*v42-v23.*v32.*v41),-t5.*t16.*t29.*t30.*(v11.*v32.*v43-v11.*v33.*v42-v12.*v31.*v43+v12.*v33.*v41+v13.*v31.*v42-v13.*v32.*v41),t5.*t29.*t30.*t31.*(v11.*v22.*v43-v11.*v23.*v42-v12.*v21.*v43+v12.*v23.*v41+v13.*v21.*v42-v13.*v22.*v41)];
end

end