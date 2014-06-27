function [out] = binarize_image(image, whitethresh, step)
% [out] = binarize_image(image, whitethresh, step) returns binarized image
%
% Inputs:
%   image       --   grayscale image (uint8 2D matrix). Required.
%   whitethresh --   try to reduse this number if backgroud is not pure
%                    white. Default: 0.9.
%   step        --   edge length of 'sliding window' in px. Default: 16.
%
% Outputs:
%   out         --   binarized image (logical matrix);
%
% Using:
%   [out] = binarize_image(image)
%   [out] = binarize_image(image, 0.96)
%   [out] = binarize_image(image, [], 20)
%               
% Author: 
%   Bogdan Vaneev (warchantua@gmail.com)
%
%% set default input options
if ~exist('whitethresh','var') || ...
        isempty(whitethresh)   || ...
        nargin < 2
    whitethresh = 0.9;
end

if ~exist('step','var') || ...
        isempty(step)   || ...
        nargin < 3
    step = 16;
end

%% check for the valid input
if ~ismatrix(image)
    error('Input: "image" is not matrix.');
end

if ~isscalar(whitethresh) || ...
        whitethresh < 0   || ...
        whitethresh > 1
    error('Input: "whitethresh" should be scalar, [0:1].');
end

if ~isscalar(step)        || ...
        step <= 0         || ...
        floor(step) ~= step % isinteger 
    error('Input: "step" should be scalar, positive and integer.');
end
% step bigger than width or height of image
b = max([size(image,1) size(image,2)]);
if step >= b
    step = b;
end

%% do the action
%% is image divisible to blocks STEPxSTEP?
% height and width before resize
height = size(image,1);
width  = size(image,2);

% height and width after resize
imheight = height;
imwidth  = width;

if mod(height,step) ~= 0
    margin_bot = step - mod(height,step);
    image = [image; 255*ones(margin_bot, width)];
    imheight = size(image,1);
end
if mod(width,step) ~= 0
    margin_right = step - mod(width,step);
    image = [image 255*ones(imheight, margin_right)];
    imwidth = size(image,2);
end

% divide image into blocks STEPxSTEP
N1 = step * ones(1, imheight/step);
N2 = step * ones(1, imwidth /step);
blocks  = mat2cell(image,N1,N2);

%% for each block calculate threshold (T)
% {0, if s(x,y) <= T
% {1, if s(x,y) >  T
for i=1:size(blocks,1)*size(blocks,2)
    part = blocks{i};
    T    = graythresh(part);
    if(T > whitethresh)
        part = ones(step);
    else
        part = im2bw(part,T);
    end
    blocks{i} = logical(part);
end
% restore image from blocks
out = cell2mat(blocks);
out = imcrop(out,[1 1 width height]);