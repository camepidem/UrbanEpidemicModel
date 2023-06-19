%% Implementation of add_road_connections function
function urban_environment_update=add_road_connections(urbanLandscape)
%Add connections (i.e. link) road segments that are spacially connected.
%
% Syntax:  urban_environment_update = add_road_connections( urban_environment, printing )
%
% Inputs:
%   urban_environment - Data struct with the urban environment data
%   printing - True for ploting
%
% Outputs:
%   urban_environment_update - Vector with the length of each road segment
%
% Example:
%   urban_environment_update = add_road_connections( urban_environment, false )
%   This example adds connections between road segments that are next to
%   each other.
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
% Date: 17/04/2018/05/03
% Version: 1.0

% If printing==true plot the connection points with red.
for i=1:length(urbanLandscape.roads)
    for j=(i+1):length(urbanLandscape.roads)
        if (abs(urbanLandscape.roads{i,1}(1,1)-urbanLandscape.roads{j,1}(1,1))+abs((urbanLandscape.roads{i,1}(1,3)-urbanLandscape.roads{j,1}(1,3))))==0
            
            if isempty(urbanLandscape.roads{i,2})
                urbanLandscape.roads{i,2}=j;
            else
                urbanLandscape.roads{i,2}=[urbanLandscape.roads{i,2} j];
            end
            if isempty(urbanLandscape.roads{j,2})
                urbanLandscape.roads{j,2}=i;
            else
                urbanLandscape.roads{j,2}=[urbanLandscape.roads{j,2} i];
            end
        end
        
        if (abs(urbanLandscape.roads{i,1}(1,1)-urbanLandscape.roads{j,1}(1,2))+abs((urbanLandscape.roads{i,1}(1,3)-urbanLandscape.roads{j,1}(1,4))))==0

            
            if isempty(urbanLandscape.roads{i,2})
                urbanLandscape.roads{i,2}=j;
            else
                urbanLandscape.roads{i,2}=[urbanLandscape.roads{i,2} j];
            end
            if isempty(urbanLandscape.roads{j,2})
                urbanLandscape.roads{j,2}=i;
            else
                urbanLandscape.roads{j,2}=[urbanLandscape.roads{j,2} i];
            end
        end
        
        if (abs(urbanLandscape.roads{i,1}(1,2)-urbanLandscape.roads{j,1}(1,1))+abs((urbanLandscape.roads{i,1}(1,4)-urbanLandscape.roads{j,1}(1,3))))==0

            
            if isempty(urbanLandscape.roads{i,2})
                urbanLandscape.roads{i,2}=j;
            else
                urbanLandscape.roads{i,2}=[urbanLandscape.roads{i,2} j];
            end
            if isempty(urbanLandscape.roads{j,2})
                urbanLandscape.roads{j,2}=i;
            else
                urbanLandscape.roads{j,2}=[urbanLandscape.roads{j,2} i];
            end
        end
        
        if (abs(urbanLandscape.roads{i,1}(1,2)-urbanLandscape.roads{j,1}(1,2))+abs((urbanLandscape.roads{i,1}(1,4)-urbanLandscape.roads{j,1}(1,4))))==0

            
            if isempty(urbanLandscape.roads{i,2})
                urbanLandscape.roads{i,2}=j;
            else
                urbanLandscape.roads{i,2}=[urbanLandscape.roads{i,2} j];
            end
            if isempty(urbanLandscape.roads{j,2})
                urbanLandscape.roads{j,2}=i;
            else
                urbanLandscape.roads{j,2}=[urbanLandscape.roads{j,2} i];
            end
        end
    end
end
urban_environment_update=urbanLandscape;

end