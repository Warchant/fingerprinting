function marker = apply_roi(marker, ROI)
% [marker] = apply_roi(marker, ROI) returns a structure with fields x, y
%   with markers inside region of interest
%
% Inputs:
%   marker   -- structure with same size fields x,y
%   ROI      -- logical matrix - region of interest
%
% Outputs:
%   marker   --   structure with same size fields x and y.
%               
% Author: 
%   Bogdan Vaneev (warchantua@gmail.com)
%
%% check for the valid input
if ~isfield(marker,'x') || ~isfield(marker,'y') && ...
        numel(marker.x) == numel(marker.y)
    error('marker: must be a structure with same size fields x,y');
end
if ~ismatrix(ROI) || ~islogical(ROI)
    error('input ROI must be logical matrix')
end
%% do the action
for i = numel(marker.x):-1:1
    if ROI(marker.y(i),marker.x(i)) == 0 
        marker.x(i) = [];
        marker.y(i) = [];
        i = i - 1;
    end
end