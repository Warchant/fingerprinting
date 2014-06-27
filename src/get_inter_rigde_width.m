function D = get_inter_rigde_width(th)
% [D] = get_inter_ridge_width(th) returns fingerprint inter-ridge width 
%
% Inputs:
%   th   --  logical matrix of thinned fingerprint image
%
% Outputs:
%   D    --  value of inter-ridge width
%
% Author: 
%   Bogdan Vaneev (warchantua@gmail.com)
%
%% check for the valid input
if ~ismatrix(th) && ~islogical(th)
    error('input must be logical matrix')
end
%% do the action
D = size(th,1)/max(sum(th,1)); % average inter-ridge width
D = mean([D; size(th,2)/max(sum(th,2))]); % average inter-ridge width