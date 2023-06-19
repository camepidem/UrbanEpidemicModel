%% Implementation of calculate_length function
function splitted_roads=split_road_segments(urbanLandscape, threshold)
%Split longer than threshold road segments into smaller parts
%
% Syntax:  splitted_roads = split_road_segments( urban_environment, threshold )
%
% Inputs:
%   urban_environment - Data struct with the urban environment data
%   threshold - Value for cut off distance
%
% Outputs:
%   splitted_roads - Vector with the length of each road segment
%
% Example:
%   splitted_roads = calculate_length( urban_environment, 200 )
%   This example splits to two segments road segments larger than 200
%   length units.
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% TODO:
%       1) Add test units
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 03/05/2017
% Version: 1.0

splitted_roads=cell(length(urbanLandscape.roads),2);
count_idx=1;
maxroadlength=threshold;
for idx=1:length(urbanLandscape.roads)
    if urbanLandscape.roads_length(idx) >= maxroadlength
        rd=ceil(urbanLandscape.roads_length(idx)/maxroadlength);
        
        road=[urbanLandscape.roads{idx,1}(1),urbanLandscape.roads{idx,1}(2),urbanLandscape.roads{idx,1}(3),urbanLandscape.roads{idx,1}(4)];
        
        x=[road(1) road(2)];
        y=[road(3) road(4)];
        if (x(2)-x(1))==0
            yi=y(1):((y(2)-y(1))/rd):y(2);
            xi = interp1(y',x',yi');
        else
            xi=x(1):((x(2)-x(1))/rd):x(2);
            yi = interp1(x',y',xi');
        end
        
        for i=1:size(yi,1)-1
            splitted_roads{count_idx,1}=[xi(i) xi(i+1) yi(i) yi(i+1)];
            count_idx=count_idx+1;
        end
    else
        splitted_roads{count_idx,1}=[urbanLandscape.roads{idx,1}(1),urbanLandscape.roads{idx,1}(2),urbanLandscape.roads{idx,1}(3),urbanLandscape.roads{idx,1}(4)];
        count_idx=count_idx+1;
    end
end

end