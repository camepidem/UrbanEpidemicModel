% Returns to the user the index of the start infection location.
%
% Syntax:  chooseStartLocation
%
% Inputs:
%   none
%
% Outputs:
%   none
%
% Example:
%   chooseStartLocation
%   This example plots the landscape and waits from the user a left mouse
%   click in order to return the location of the nearest poputated cell and
%   road segment.
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
% Date: 13/06/2018
% Version: 1.0

%% Choose the infection start location
clear variables
TopLevel = 'D:/Cerian/OneDrive - University Of Cambridge';
LocalPath = [TopLevel,'/UrbanTreeModel/ModelCodeForPublic2023/UrbanEpidemicModel2023'];
addpath([LocalPath,'/dataPrepare/SyntheticLandscapes'])
addpath([LocalPath,'/plotting'])
landscapeFilename = 'synth_Matern_1_UrbanLandscape';
%% Load landscape
load([landscapeFilename '.mat'])

%% Plot landscape
plotUrbanLandscape(landscapeFilename)

%% Find closest populated cell
% Find the road segments and tiles with trees
populatedRoads = find(urbanLandscape.roadpopulation);
populatedRoadsLocs = urbanLandscape.roadcenters(populatedRoads,:);

populatedTiles = find(urbanLandscape.parkpopulation);
populatedTilesLocs = urbanLandscape.gridcenters(populatedTiles,:);

%% Get mouse input
[x,y] = ginput(1);

%% Plot the closest populated cell location
IdxRoad = knnsearch(populatedRoadsLocs,[x,y]);
IdxCell = knnsearch(populatedTilesLocs,[x,y]);


%% Plot closest populated cell location
hold on
plot(populatedRoadsLocs(IdxRoad,1),populatedRoadsLocs(IdxRoad,2),'kx','MarkerSize',20)
plot(populatedTilesLocs(IdxCell,1),populatedTilesLocs(IdxCell,2),'k+','MarkerSize',20)

%% Display results for the user
disp(['Index of the populated road segment selected: ',num2str(IdxRoad)])
disp(['Location of the populated road segment selected: ',num2str(populatedRoadsLocs(IdxRoad,:))])
disp(['Road segment number ',num2str(populatedRoads(IdxRoad))])
disp(['Index of the populated cell selected: ',num2str(IdxCell)])
disp(['Location of the populated cell selected: ',num2str(populatedTilesLocs(IdxCell,:))])
disp(['Cell number ',num2str(populatedTiles(IdxCell))])