%% Implementation of calculate_length function
function roads_length=calculate_length(roads)
%Measure the length of each road
%
% Syntax:  roads_length = calculate_length( urban_environment )
%
% Inputs:
%   roads - A matrix with the start and end points of the roads
%
% Outputs:
%   roads_length - Vector with the length of each road segment
%
% Example:
%   roads_length = calculate_length(roads)
%   This example calculates the road length for each road segment in the
%   roads matrix.
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 03/05/2017
% Version: 1.0

roads_length=zeros(length(roads),1);
for idx=1:size(roads,1)
    i=roads{idx,1}(1);
    j=roads{idx,1}(3);
    k=roads{idx,1}(2);
    m=roads{idx,1}(4);
    roads_length(idx,1) = sqrt( (i-k).^2 + (j-m).^2 );
end

end
