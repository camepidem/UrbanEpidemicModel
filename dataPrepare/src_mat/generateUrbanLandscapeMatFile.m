function generateUrbanLandscapeMatFile( urbanLandscape, localRoadsMap, ...
                                        roadNetworkFile, ...
                                        roadsideTreesFile, ...
                                        parkBackyardTreesFile, ...
                                        roadsideSpeciesFile, ...
                                        parkBackyardSpeciesFile, ...
                                        roadsideDatasetFile, ...
                                        parkBackyardDatasetFile, ...
                                        outputMatFilename, ...
                                        roadSeqmentMaxLength, ...
                                        maxRoadTravelDistance, ...
                                        cellSize)
%Generates the mat file with the urban landscape needed for the Urban
%Epidemic Model.
%
% Syntax: generateUrbanLandscapeMatFile()
%
% Inputs:
%   roadNetworkFile             -
%   roadsideTreesFile           -
%   parkBackyardTreesFile       -
%   roadsideSpeciesFile         -
%   parkBackyardSpeciesFile     -
%   outputMatFilename           -
%   roadSeqmentMaxLength        -
%   maxRoadTravelDistance       -
%   cellSize                    -
%   printing                    -
%
% Outputs:
%   none
%
% Example:
%   generateUrbanLandscapeMatFile()
%   This example setups the data needed for running the simulator. The data
%   are the road grid structure and the generation of the grid with the
%   host landscape.
%
% See also: createUrbanLandscapeStruct, genLocalRoadsMap
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 18/04/2018
% Version: 1.0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate simulation options struct with default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

urbanLandscape = createUrbanLandscapeStruct(urbanLandscape, ...
                                            roadNetworkFile, ...
                                            roadsideTreesFile, ...
                                            parkBackyardTreesFile, ...
                                            roadsideSpeciesFile, ...
                                            parkBackyardSpeciesFile, ...
                                            roadsideDatasetFile, ...
                                            parkBackyardDatasetFile, ...
                                            roadSeqmentMaxLength, ...
                                            cellSize, ...
                                            false);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For each road find the closest roads with distance <= maxRoadTravelDistance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% urbanLandscape.localRoadsMap = genLocalRoadsMap(urbanLandscape, maxRoadTravelDistance);
urbanLandscape.localRoadsMap = localRoadsMap;

ppArea = cellroadarearatio(urbanLandscape);
urbanLandscape.ppArea=ppArea;
urbanLandscape.prArea=[];

save([outputMatFilename '.mat'], 'urbanLandscape')
