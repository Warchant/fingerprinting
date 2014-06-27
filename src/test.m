function test(path)
%% TODO:
%  2) Markers Filter
%  3) Extract markers angle
%  4) Minutiae matching

%%
tic
clf;
figure(1);
axes;

if ~exist('path','var') || ...
        isempty(path)   || ...
        nargin < 1
    path = 'E:\WORK\Fingerprint\imgs\DB1_B\101_1.tif';
end

if ~ischar(path)
    error('Path to image must be a string!');
end

rgb = imread(path);
gr  = uint8(mean(rgb,3));

%% BINARIZATION
bin = binarize_image(gr);

%% THINNING
th = ~(bin);
th = bwmorph(th,'thin','inf'); % logical array

%% CROP IMAGE
m = mean(th);
fx = find(m>0.0026,1,'first');
lx = find(m>0.0026,3,'last');
m = mean(th,2);
fy = find(m>0.0026,2,'first');
ly = find(m>0.0026,1,'last');
th = imcrop(th,[fx(1) fy(2)   (lx(1)-fx(1)) ly(1)]);
bin = imcrop(bin,[fx(1) fy(2)   (lx(1)-fx(1)) ly(1)]);
% gr = imcrop(gr,[fx(1) fy(2)-1 (lx(1)-fx(1)) ly(1)]);

%% INTER-RIDGE WIDTH
D = ceil(get_inter_rigde_width(th));

%% ROI
ROI = get_roi(th, 1, 10);

%% BEGIN MINUTIAE MARKING
[markers, th] = get_markers(th);

%% MINUTIAE FILTERING
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% rm - ridge map
[rm, rnum] = bwlabel(th);
delmap.lt = zeros(1,numel(markers.lt.x));
delmap.bi = zeros(1,numel(markers.bi.x));
for j = 1:numel(markers.bi.x)
    % m2 case H, m3 case -<>-
    for o = j+1:numel(markers.bi.x)
        dx = abs(markers.bi.x(j) - markers.bi.x(o));
        dy = abs(markers.bi.y(j) - markers.bi.y(o));
        if dx > D || dy > D
            continue;
        end
        dist = sqrt(dx*dx + dy*dy);
        if dist < D && ...
                rm(markers.bi.y(o),markers.bi.x(o)) == ...
                rm(markers.bi.y(j),markers.bi.x(j))
            delmap.bi(o) = 1;
            delmap.bi(j) = 1;
        end
    end
    
    for i = 1:numel(markers.lt.x)
        % m1 case |-
        dx = abs(markers.lt.x(i) - markers.bi.x(j));
        dy = abs(markers.lt.y(i) - markers.bi.y(j));
        if dx > D || dy > D
            continue;
        end
        dist = sqrt(dx*dx + dy*dy);
        if dist < D && ...
                rm(markers.lt.y(i),markers.lt.x(i)) == ...
                rm(markers.bi.y(j),markers.bi.x(j))
            delmap.lt(i) = 1;
            delmap.bi(j) = 1;
        end
        % m4, m5 case |¦|, m6 =---=
        % ?
        
    end
    % m7 case -
    % ? 
end
delmap.lt = logical(delmap.lt);
delmap.bi = logical(delmap.bi);

% markers.lt.x(delmap.lt) = [];
% markers.lt.y(delmap.lt) = [];
% markers.bi.x(delmap.bi) = [];
% markers.bi.y(delmap.bi) = [];
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% % delete line terminations outside ROI
% markers.lt = apply_roi(markers.lt,ROI);
% % delete bifurcations outside ROI
% markers.bi = apply_roi(markers.bi,ROI);

%% PLOT 

% imagesc(th);
% imagesc((th + ROI)./2);
imagesc((th + ~bin)./2);
hold on;
% plot(markers.lt.x, markers.lt.y,'ro');
plot(markers.bi.x, markers.bi.y,'r*');
markers.lt.x(delmap.lt) = [];
markers.lt.y(delmap.lt) = [];
markers.bi.x(delmap.bi) = [];
markers.bi.y(delmap.bi) = [];
plot(markers.bi.x, markers.bi.y,'y*');

% END
colormap(gray);
set(gca,'DataAspectRatio',[1 1 1]);
toc
