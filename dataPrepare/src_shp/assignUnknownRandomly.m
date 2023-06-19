function [urbanTreesP, urbanTreesR]=assignUnknownRandomly(urbanTreesP, urbanTreesR,PARKTREES,ProportionSpeciesXPark,ProportionSpeciesXRoad)

rng('shuffle')


%% Load landscape data and get species for each tree
parkTrees=urbanTreesP.locations;
parkSpecies=urbanTreesP.species;
parkDataset=urbanTreesP.dataset;

roadTrees=urbanTreesR.locations;
roadSpecies=urbanTreesR.species;
roadDataset=urbanTreesR.dataset;

%% Get axis limits
xmax=max([parkTrees(:,1); roadTrees(:,1)]);
ymax=max([parkTrees(:,2); roadTrees(:,2)]);
xmin=min([parkTrees(:,1); roadTrees(:,1)]);
ymin=min([parkTrees(:,2); roadTrees(:,2)]);


%% Calculate number of Oaks
if PARKTREES
numSpeciesX = floor(ProportionSpeciesXPark.*numel(parkSpecies));
else
    numSpeciesX = floor(ProportionSpeciesXRoad.*numel(roadSpecies));
end
%% Assign to closest tree
tic
if PARKTREES
    idxSpeciesParkUnknowOB=find((parkSpecies=="UNKNOWN" | parkSpecies=="Other Broadleaf"));
    SelectSpX = randperm(length(idxSpeciesParkUnknowOB));
    SelectSpX = SelectSpX(1:numSpeciesX);
    
    parkSpecies(idxSpeciesParkUnknowOB(SelectSpX))='SpeciesX';
    
    disp('Assigning  Species X done.')
    parkSpeciesNew=parkSpecies;
else
    idxSpeciesRoadUnknowOB=find((roadSpecies=="UNKNOWN" | roadSpecies=="Other Broadleaf"));
    SelectSpX = randperm(length(idxSpeciesRoadUnknowOB));
    SelectSpX = SelectSpX(1:numSpeciesX);
    roadSpecies(idxSpeciesRoadUnknowOB(SelectSpX))='SpeciesX';
    disp('Assigning Species X done.')
    roadSpeciesNew=roadSpecies;
end
toc


%% Plot distribution of species X
idxSpX=SelectSpX;
figure
if PARKTREES
    unkTrees = setdiff(1:length(parkTrees(:,1)),idxSpX);
    plot(parkTrees(idxSpX,1),parkTrees(idxSpX,2),'r.')
    hold on
    plot(parkTrees(unkTrees,1),parkTrees(unkTrees,2),'b.')
else
    unkTrees = setdiff(1:length(roadTrees(:,1)),idxSpX);
    plot(roadTrees(idxSpX,1),roadTrees(idxSpX,2),'g.')
    hold on
    plot(roadTrees(unkTrees,1),roadTrees(unkTrees,2),'m.')
end

%% Attach species info to urban Trees structure

% Park/Garden trees
if PARKTREES
    urbanTreesP.species=parkSpeciesNew;
else
    % Roadside trees
    urbanTreesR.species=roadSpeciesNew;
end