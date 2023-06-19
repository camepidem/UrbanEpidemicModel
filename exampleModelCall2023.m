% Example run of urban epidemic model
%
% Syntax:  exampleModelCall2023
%
% This is the master file which calls all files required to run the model 
% Read through the file to see where you can make changes
%
% Outputs:
%   .mat file containing model inputs and outputs required for plotting
%
% Example:
%   exampleModelCall2023
%   This example calls the urbanTreesMgr function for one simulation.
%
% Other m-files required: urbanTreesMgr.m
% Subfunctions: none
% MAT-files required: A synthetic landscape
%
%
% Author: Eleftherios Avramidis
% Update: Cerian Webb
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 07/06/2023
% Version: 2.1



TopPath = 'D:/Cerian/OneDrive - University of Cambridge/UrbanTreeModel/ModelCodeForPublic2023/UrbanEpidemicModel2023';
addpath(TopPath);
addpath([TopPath,'/core']);
addpath([TopPath,'/plotting']);
addpath([TopPath,'/dataPrepare/SyntheticLandscapes']);
addpath([TopPath,'/code_functions']);


%% These four parameters determine the specific model run and filename stored in
% clear variables % commented out if using multirun script
ParameterGroup = 1; % select set of parameters using in simulation see parameterSets.mlx - if no road spread need to start in garden ann vice versa
InputSet = 1;  % choose 1 to 4 if following example instructions
StartPositionMethod  = 3; %4; % 4 is a road cell, 5 is a park/garden cell
NumReps = 1; % number of times to run model for given set of inputs
%%  Load landscape
LandscapeType = 'Matern'; % 'Matern' or 'Random' or 'All'
HostLandscapeNumber = InputSet; 

RoadSegment = 298;
GardenCell = 40;

landscapeName = ['synth_',LandscapeType,'_',num2str(HostLandscapeNumber),'_UrbanLandscape'];
load([landscapeName '.mat'])
%mkdir([LocalPath,'SimulationOutput']) % only required once
cd([TopPath,'/SimulationOutput'])



%% Plot landscape
plotUrbanLandscape(landscapeName)

%% Set epidemiological model parameters
% Please see core/urbanTreesSet.m for description of each parameter
% opts = urbanTreesSet();
% Either create own or use the following function containing different parameter combinations
opts = parameterSets(ParameterGroup);
% add record of landscape name to output file
opts.LandscapeName = landscapeName;

opts.tSpan = 500; % time to run model over
opts.tInterval = 1;
opts.roadsideTreesON=1;
opts.parkbackyardTreesON=1;

    
%% create a directory in which to store model output

if opts.roadsideTreesON == 1 & opts.parkbackyardTreesON ==1
mkdir(['ParGp',num2str(ParameterGroup),LandscapeType,num2str(HostLandscapeNumber), 'Start_',num2str(StartPositionMethod)])
cd(['ParGp',num2str(ParameterGroup),LandscapeType,num2str(HostLandscapeNumber),'Start_',num2str(StartPositionMethod)])
elseif opts.roadsideTreesON == 1 & opts.parkbackyardTreesON ==0
mkdir(['ParGp',num2str(ParameterGroup),LandscapeType,num2str(HostLandscapeNumber),'ParkOff'])
cd(['ParGp',num2str(ParameterGroup),LandscapeType,num2str(HostLandscapeNumber),'ParkOff'])
elseif opts.roadsideTreesON == 0 & opts.parkbackyardTreesON ==1
mkdir(['ParGp',num2str(ParameterGroup),LandscapeType,num2str(HostLandscapeNumber),'RoadOff'])
cd(['ParGp',num2str(ParameterGroup),LandscapeType,num2str(HostLandscapeNumber),'RoadOff'])
else
   disp('Check parameter settings for opts.roadsideTreesON, opts.parkbackyardTreesON');
end    
%%  Choose the start of the epidemic simulation
% can either start in a garden patch or a road patch or in multiple
% locations.
% set method by choosing case and assigning value to StartPositionMethod
% cases
% 1 = random park cell
% 2 = random road segment
% 3 = random both
% 4 = specified road segment
% 5 = specified park segment
% e.g. StartPositionMethod  = 5; Assigned before create directory so can
% use info in directory name

% Create list of all road segments with trees
populatedroads = find(urbanLandscape.roadpopulation);
% Create list of all garden patches with trees
populatedtiles = find(urbanLandscape.parkpopulation);

% randomly generate location of introduction of disease/pest from all
% possible locations with trees: 
startPopulatatedRoadSegment = randi(numel(populatedroads)); % pick a position from the list of population roads 
StartRoadID = populatedroads(startPopulatatedRoadSegment);
startPopulatedCell = randi(numel(populatedtiles));
StartCellID = populatedtiles(startPopulatedCell);


    switch StartPositionMethod
        case 1
    % Start on random park cell
    opts.startCell = StartCellID;
    opts.startRoadSegment = 0;
        case 2
            % start on random road patch
              opts.startRoadSegment = StartRoadID;
              opts.startCell = 0;
        case 3
            % seed on road and park cell (randomly selected)
            opts.startCell = StartCellID;
            opts.startRoadSegment = StartRoadID;
        case 4
            % specify start road cell, no park cell
            opts.startCell = 0;
            opts.startRoadSegment = RoadSegment; % specified in start case statement
        case 5
            % specify start park cell, no road cell
            opts.startCell = GardenCell; %specified in start case statement
            opts.startRoadSegment = 0;
    end

%% set up normalising values
% tic
C_air=0;    % if C_air==0 then it will be calculated by the simulator and stored in C_air.mat
C_road=0;   % if C_air==0 then it will be calculated by the simulatorand stored in C_road.mat
% to save time if running code repeatedly on large data set can pre-calculate normalising constants - need to do for each new landscape
% used;
% function in .../core/normalise_kernels.m
cell_size = abs(urbanLandscape.gridcenters(1,2)-urbanLandscape.gridcenters(2,2));

[C_air, C_road]=normalise_kernels(urbanLandscape.G, ...
opts.p_air, opts.p_road, opts.alpha_air, opts.alpha_road, ...
opts.d_max_air, opts.d_max_road, cell_size, opts.max_roadSegment_length);

%  load('C_air.mat')     % load C_air values
%  load('C_road.mat')    % load C_road values
%% call the model: to run multiple times uncomment for and associated end.

for i=1:NumReps
    % replicates on one landscape
    %i = 5000; % comment out this line for multiple runs
    urbanTreesMgr( [landscapeName '.mat'], opts, ['simOut_' num2str(i)], C_air, C_road);
end

