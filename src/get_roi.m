function ROI = get_roi(th, close, erode)
% ROI = get_roi(th, close, erode)
%
% Inputs:
%   th      --  logical matrix with input thinned image
%   close   --  closing radius
%   erode   --  erode radius
%
% Outputs:
%   ROI     --  logical matrix, mask of valid extracted minutiae 
%
% Using:
%   [ROI] = get_roi(th, 10, 10);
%               
% Author: 
%   Bogdan Vaneev (warchantua@gmail.com)
%
%% set default input options
if ~exist('close','var') || ...
        isempty(close)   || ...
        nargin < 2
    close = 10;
end

if ~exist('erode','var') || ...
        isempty(erode)   || ...
        nargin < 3
    erode = 10;
end
%% check for the valid input
if ~isscalar(close) || ~isscalar(erode)
    error('input close and erode must be scalar');
end
if ~ismatrix(th) || ~islogical(th)
    error('input must be logical matrix')
end
%% do the action
x = zeros(1, 2*size(th,1));
y = zeros(1, 2*size(th,1));
k = 0;
for i = 1:size(th,1)
    row = th(i,:);
    f   = find(row > 0, 1, 'first');
    l   = find(row > 0, 1, 'last' );
    if isempty(f) || isempty(l)
        continue;
    end
    y(1 + k) = i;    y(end-k) = i;
    x(1 + k) = f;    x(end-k) = l;
    k = k + 1;
end
x = x(x~=0);
y = y(y~=0);
ROI = roipoly(th,x,y);

if close > 0
    ROI = imclose(ROI,strel('square',close));
else
    disp('to enable ROI:close 2nd argument must be positive');
end
if erode > 0
    ROI = imerode(ROI,strel('square',erode));
else
    disp('to enable ROI:erode 3rd argument must be positive');
end