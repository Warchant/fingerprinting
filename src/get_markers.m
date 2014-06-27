function [markers, th] = get_markers(th)
% function [markers, th] = get_markers(th) returns structure with line
%   line terminations and bifurcations; returns logical matrix without
%   alone pisels.
%
% Inputs:
%   th      --  logical matrix - thinned fingerprint image
%
% Outputs:
%   markers --  structure with fields: lt (line terminations),
%               bi (bifurcations), each field has 2 fields: 
%               x,y with coordinates of minutiae
%   th      --  input thinned image without single white pixels
%            
% Author: 
%   Bogdan Vaneev (warchantua@gmail.com)
%
%% check for the valid input
if ~ismatrix(th) || ~islogical(th)
    error('th: input must be logical matrix')
end
%% do the action
markers = cell(0);
ltnum = 1;
binum = 1;

for i=2:size(th,1)-1 
    for j=2:size(th,2)-1
        if th(i,j) == 1
           win = [th(i+1,j  );
                  th(i+1,j-1);
                  th(i,j-1  );
                  th(i-1,j-1);
                  th(i-1,j  );
                  th(i-1,j+1);
                  th(i,j+1  );
                  th(i+1,j+1);
                  th(i+1,j  )];
            
            ws = sum(win(1:8));
            % calculate CN
            CN = 0.5 * sum(abs(win(1:8) - win(2:9)));

            % alone pixel. delete it
            if CN == 0
                th(i,j) = 0;
            end

            % line termination
            if CN == 1 && ws == 1
                markers.lt.x(ltnum) = j;
                markers.lt.y(ltnum) = i;
                ltnum = ltnum + 1;
            end

            % line bifurcations
            if CN == 3 && ws >= 3
                markers.bi.x(binum) = j;
                markers.bi.y(binum) = i;
                binum = binum + 1;
            end
        end
    end
end