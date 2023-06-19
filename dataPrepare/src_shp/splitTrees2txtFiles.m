% close all
% clear variables

function splitTrees2txtFiles(urbanTreesP, urbanTreesR, outputFilePrefix)

% Park trees
treeLocation = [outputFilePrefix 'ParkTrees.txt'];
treeSpecies = [outputFilePrefix 'ParkSpecies.txt'];
treeDatabase = [outputFilePrefix 'ParkDatabase.txt'];
mat2txtTrees(urbanTreesP, treeLocation, treeSpecies, treeDatabase);

% Roadside trees
treeLocation = [outputFilePrefix 'RoadTrees.txt'];
treeSpecies = [outputFilePrefix 'RoadSpecies.txt'];
treeDatabase = [outputFilePrefix 'RoadDatabase.txt'];
mat2txtTrees(urbanTreesR, treeLocation, treeSpecies, treeDatabase);

end

function mat2txtTrees(urbanTrees, treeLocation, treeSpecies, treeDatabase)

%% Load data
trees = [(1:length(urbanTrees.locations))' urbanTrees.locations];

%% Store tree locations to text file
dlmwrite(treeLocation,trees,'delimiter','\t', 'precision',50);

%% Write species of each tree in a file
fileID = fopen(treeSpecies,'w');
for i=1:length(urbanTrees.species)
    fprintf(fileID,'%s\n', urbanTrees.species(i));
end
fclose(fileID);

%% Write database origin of each tree in a file
fileID = fopen(treeDatabase,'w');
for i=1:length(urbanTrees.dataset)
    fprintf(fileID,'%s\n', urbanTrees.dataset(i));
end
fclose(fileID);
end