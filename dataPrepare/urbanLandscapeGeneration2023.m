close all
clear variables
%% EDIT TO YOUR LOCAL PATH
TopPath = 'D:/Cerian/OneDrive - University of Cambridge/UrbanTreeModel/ModelCodeForPublic2023/UrbanEpidemicModel2023';
%% EDIT TO DIRECT TO YOUR DOWNLOADED COPY OF M_MAP Available from https://www.eoas.ubc.ca/~rich/mapug.html
MyFileExchangeFiles_m_Map = 'D:/Cerian/OneDrive - University of Cambridge/MatlabFileExchange/m_map';
addpath(MyFileExchangeFiles_m_Map);
%% add other paths required for this code to run: make sure you have created the required directories
addpath([TopPath,'/dataprepare/src_mat']);
addpath([TopPath,'/dataprepare/SyntheticDatasets']);
addpath([TopPath,'/dataprepare/SyntheticDatasets/UnknownRandom/']);
addpath([TopPath,'/dataprepare/SyntheticDatasets/UnknownMaternPoisson/']);
addpath([TopPath,'/dataprepare/SyntheticDatasets/AllTrees/']);
%% EDIT IF YOU WANT TO REDUCE MAXIMUM EXTENT OF 
% Road seqments length threshold
roadSeqmentMaxLength=100;
% Maximun road travel distance
maxRoadTravelDistance=5000;
% Cell size
cellSize=100;

outputFolder='SyntheticLandscapes';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read urban data (i.e. road network, trees close to road, park trees)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
roadNetworkFile = 'NTMsample_OpenRoads.txt';
urbanLandscape = generateRoadStruct(roadNetworkFile, roadSeqmentMaxLength);
toc
%%
tic
%names = {'synth_Matern_'};
NumLandscapes = 4; % this is how many you generated using callGenerateSyntheticDatasets2023.m      

 names = {'synth_Matern_';
     'synth_Random_'};
% NumLandscapes = 1; names = {'synth_All_'};

localRoadsMap = genLocalRoadsMap(urbanLandscape, maxRoadTravelDistance);
toc
%%
tic

for n=1:length(names)
    for i=1:NumLandscapes
        outputFilePrefix = [names{n} num2str(i) '_'];
        
        roadsideTreesFile = [outputFilePrefix 'RoadTrees.txt'];
        parkBackyardTreesFile = [outputFilePrefix 'ParkTrees.txt'];
        
        roadsideSpeciesFile = [outputFilePrefix 'RoadSpecies.txt'];
        parkBackyardSpeciesFile = [outputFilePrefix 'ParkSpecies.txt'];
        
        roadsideDatasetFile = [outputFilePrefix 'RoadDatabase.txt'];
        parkBackyardDatasetFile = [outputFilePrefix 'ParkDatabase.txt'];
        
        outputMatFilename = [outputFolder '/' names{n} num2str(i) '_UrbanLandscape'];

        generateUrbanLandscapeMatFile(urbanLandscape, localRoadsMap, ...
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
            cellSize);
    end
end


toc
%% uncomment if you want a warning when code finished (slower for larger landscapes)
%load chirp
%sound(y,Fs/3)