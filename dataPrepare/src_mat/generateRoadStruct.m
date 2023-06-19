function urbanLandscape = generateRoadStruct(roads_filename, roadSeqmentMaxLength)
%CREATE_URBAN_ENVIRONMENT_STRUCT Forms and stores the struct with the city roads represented as line
%segments in the <roads_filename> text file. Moreover, it links trees that are close
%to roads. The location of these trees are in the <road_trees_filename>
%text file. Also, creates a grid for spatially grouping the park/backyard
%trees. These trees locations are in the <park_trees_filename> text file.
%
% Syntax:  urban_environment = create_urban_environment_struct( roads_filename, road_trees_filename, park_trees_filename, printing )
%
% Inputs:
%   roads_filename - String with the filename of the text file with the roads line
%       segments locations. Each line of the file represents a
%       road segment. The first column of each line is an index and the rest
%       four columns are the coordinates of the two line points. The coordinates
%       of these two points are of the following form: x1,x2,y1,y2. The subscript
%       indexes of x and y represent the 1st and 2nd points.
%   road_trees_filename - String with the filename of the text file with
%       the roads trees locations. Each line of the file represents a tree. The
%       first column of each line is an index and the rest two columns are the
%       coordinates of the tree location. The coordinates are of the following form: x,y.
%   park_trees_filename - String with the filename of the text file with
%       the park/backyard trees locations. Each line of the file represents a tree.
%       The first column of each line is an index and the rest two columns are
%       the coordinates of the tree location. The coordinates are of the following form: x,y.
%   roadsideSpeciesFile -
%   parkBackyardSpeciesFile -
%   printing - Set to true for printing the map.
%
% Outputs:
%   urbanLandscape          - Structure with the data needed by the Urban Epidemic model simulation.
%   The structure of the urbanLandscape is the following:
%   road_segments_raw       Raw data as they are in the input text file
%   roads                   Cell array with the position of each road segment and the indexes of the road segments that are close to each road segment.
%   roads_length            Vector with the length of each road segment
%   roadcenters             Matrix with the centre location of each road segment
%   T                       Matrix with the location of each road tree
%   roadpopulation          Array with the number of trees that are connected to each road segment
%   P                       Matrix with the location of each park/backyard tree
%   gridcenters             Matrix with the centre location of each cell
%   parkpopulation          Array with the number of trees that are connected to each cell
%   roadpopulationtiles     Number of road trees to each cell
%   cellsonroad             Index of the cell which each road occupies
%
% Example:
%   urbanLandscape  = create_urban_environment_struct( 'Roads_test.txt', 'Road_trees_test.txt', 'Park_trees_test.txt', true )
%   This example reads the txt files named 'Roads_test.txt', 'Road_trees_test.txt', and 'Park_trees_test.txt' and
%   creates a MATLAB urban_environment struct with the formated data needed
%   for the sumulation of the Urban Epidemics model. The function prints
%   the map with the link points between roads.
%
% Other m-files required: calculate_length, split_road_segments, add_road_connections
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 12/09/2018
% Version: 1.0 $

%% Initialise output urban_environment struct
urbanLandscape = struct();

%% Import road network data

% Raw data with the road locations and store them in a variable in the urban environment struct
roadNetwork = importdata(roads_filename,'\t');
urbanLandscape.roadSegmentsRaw=roadNetwork;

%% Road network formation

% Initialise road cell array
% This is a two column cell array. The first column has the coordinates of
% the two points that define the road line. The second column has the index
% of the roads in the road cell array that each road is connected to.
urbanLandscape.roads=cell(size(roadNetwork,1),2);

for i=1:size(roadNetwork,1)
    urbanLandscape.roads{i,1}=[roadNetwork(i,2),roadNetwork(i,3),roadNetwork(i,4),roadNetwork(i,5)];
end
clear roadNetwork;% Clear matrix roadNetwork since it will be not use again.

%% Measure the length of each road
urbanLandscape.roads_length=calculate_length(urbanLandscape.roads);
urbanLandscape.roadsLengthRaw=urbanLandscape.roads_length;

%% Split road seqments larger than threshold
urbanLandscape.roads=split_road_segments(urbanLandscape, roadSeqmentMaxLength);

%% Measure again the length of each road after the split of the long ones
urbanLandscape.roads_length=calculate_length(urbanLandscape.roads);

%% Store center of each road segment
roadcenters=zeros(length(urbanLandscape.roads),2);
for idx=1:length(urbanLandscape.roads)
    i=urbanLandscape.roads{idx,1}(1);
    j=urbanLandscape.roads{idx,1}(3);
    k=urbanLandscape.roads{idx,1}(2);
    m=urbanLandscape.roads{idx,1}(4);
    roadcenters(idx,:) = [(i+k)/2 (j+m)/2];
end
urbanLandscape.roadcenters=roadcenters;
clear roadcenters;    % Clear roadcenters since it will be not use again.

%% Add the connections between roads in the urban_environment struct
urbanLandscape=add_road_connections(urbanLandscape);

end

