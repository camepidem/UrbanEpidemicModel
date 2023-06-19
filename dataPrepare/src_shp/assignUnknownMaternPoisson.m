function [urbanTreesP, urbanTreesR]=assignUnknownMaternPoisson(urbanTreesP, urbanTreesR, PARKTREES,ProportionSpeciesXPark,ProportionSpeciesXRoad)
rng('shuffle')



%% Load landscape data and get species for each tree
parkTrees=urbanTreesP.locations;
parkSpecies=urbanTreesP.species;

roadTrees=urbanTreesR.locations;
roadSpecies=urbanTreesR.species;

%% Calculate number of Oaks
if PARKTREES
numSpeciesX = floor(ProportionSpeciesXPark.*numel(parkSpecies));
else
    numSpeciesX = floor(ProportionSpeciesXRoad.*numel(roadSpecies));
end

%% Get axis limits
xmax=max([parkTrees(:,1); roadTrees(:,1)]);
ymax=max([parkTrees(:,2); roadTrees(:,2)]);
xmin=min([parkTrees(:,1); roadTrees(:,1)]);
ymin=min([parkTrees(:,2); roadTrees(:,2)]);


%% Assign trees as host species: EDIT MATERN POISSON PARAMETERS HERE
%Extended simulation windows parameters
if PARKTREES
radiusCluster_P=200;%radius of cluster disk (for daughter points) % default 500
QuadrantDensity_P = 25; % density per entire quadrant % default 25
lambdaDaughter_P= 700;%mean number of points in each cluster % default 700
[xx_P, yy_P] = matern(radiusCluster_P,QuadrantDensity_P, lambdaDaughter_P, numSpeciesX,xmin,xmax,ymin,ymax);
Y = [xx_P yy_P];
else
radiusCluster_R = 300; % radius of cluster for road
%Parameters for the parent and daughter point processes 
QuadrantDensity_R = 50;
lambdaDaughter_R =400;
[xx_R,yy_R]  = matern(radiusCluster_R,QuadrantDensity_R, lambdaDaughter_R, numSpeciesX,xmin,xmax,ymin,ymax);
Y = [xx_R yy_R];

end

%%
if PARKTREES
    % Park/Garden trees
    idxSpeciesParkUnknowOB=find((parkSpecies=="UNKNOWN" | parkSpecies=="Other Broadleaf"));
    disp('Assigning oaks...')
    while(~isempty(Y))
        [Idx,~]=knnsearch(parkTrees(idxSpeciesParkUnknowOB,:),Y);
        temp=[1:length(Idx); Idx']';
        [uIdx, ia, ~] = unique(Idx);
        Y(temp(ia,1),:)=[];
        parkSpecies(idxSpeciesParkUnknowOB(uIdx))='SpeciesX';
        idxSpeciesParkUnknowOB(uIdx)=[];
    end
    disp('Assigning SpeciesX done.')
    parkSpeciesNew=parkSpecies;
    idxSpX = find(parkSpeciesNew == 'SpeciesX');
else
    % Roadside trees
    idxSpeciesRoadUnknowOB=find((roadSpecies=="UNKNOWN" | roadSpecies=="Other Broadleaf"));
    disp('Assigning SpeciesX...')
    while(~isempty(Y))
        [Idx,~]=knnsearch(roadTrees(idxSpeciesRoadUnknowOB,:),Y);
        temp=[1:length(Idx); Idx']';
        [uIdx, ia, ~] = unique(Idx);
        Y(temp(ia,1),:)=[];
        roadSpecies(idxSpeciesRoadUnknowOB(uIdx))='SpeciesX';
        idxSpeciesRoadUnknowOB(uIdx)=[];        
    end
    disp('Assigning SpeciesX done.')
    roadSpeciesNew=roadSpecies;
    idxSpX = find(roadSpeciesNew == 'SpeciesX');
end

%% Plot distribution of species X

figure
if PARKTREES
    unkTrees = setdiff(1:length(parkTrees(:,1)),idxSpX);
    plot(parkTrees(idxSpX,1),parkTrees(idxSpX,2),'r.')
    hold on
    plot(parkTrees(unkTrees,1),parkTrees(unkTrees,2),'b.')
    legend('Species X','Other')
else
    unkTrees = setdiff(1:length(roadTrees(:,1)),idxSpX);
    plot(roadTrees(idxSpX,1),roadTrees(idxSpX,2),'g.')
    hold on
    plot(roadTrees(unkTrees,1),roadTrees(unkTrees,2),'m.')
    legend('Species X','Other')
end

%% Delete SpeciesX and replace it with new SpeciesX

% Park/Garden trees
if PARKTREES
    urbanTreesP.species=parkSpeciesNew;
else
    % Roadside trees
    urbanTreesR.species=roadSpeciesNew;
end
end

function [xx,yy] = matern(radiusCluster,QuadrantDensity, lambdaDaughter, numSpeciesX,xMin,xMax,yMin,yMax)
rExt=radiusCluster; %extension parameter -- use cluster radius
xMinExt=xMin-rExt;
xMaxExt=xMax+rExt;
yMinExt=yMin-rExt;
yMaxExt=yMax+rExt;
%rectangle dimensions
xDeltaExt=xMaxExt-xMinExt;
yDeltaExt=yMaxExt-yMinExt;
areaTotalExt=xDeltaExt*yDeltaExt; %area of extended rectangle

lambdaParent=QuadrantDensity/areaTotalExt;%density per unit area of parent Poisson point process

%Simulate Poisson point process for the parents
numbPointsParent=poissrnd(areaTotalExt*lambdaParent,1,1);%Poisson number 
%x and y coordinates of Poisson points for the parent
xxParent=xMinExt+xDeltaExt*rand(numbPointsParent,1);
yyParent=yMinExt+yDeltaExt*rand(numbPointsParent,1);

%Simulate Poisson point process for the daughters (ie final point process)
numbPointsDaughter=poissrnd(lambdaDaughter,numbPointsParent,1); 
numbPoints=sum(numbPointsDaughter); %total number of points

%Generate the (relative) locations in polar coordinates by 
%simulating independent variables.
theta=2*pi*rand(numbPoints,1); %angular coordinates 
rho=radiusCluster*sqrt(rand(numbPoints,1)); %radial coordinates 

%Convert from polar to Cartesian coordinates
[xx0,yy0]=pol2cart(theta,rho);

%replicate parent points (ie centres of disks/clusters) 
xx=repelem(xxParent,numbPointsDaughter);
yy=repelem(yyParent,numbPointsDaughter);
%translate points (ie parents points are the centres of cluster disks)
xx=xx(:)+xx0;
yy=yy(:)+yy0;

%thin points if outside the simulation window
booleInside=((xx>=xMin)&(xx<=xMax)&(yy>=yMin)&(yy<=yMax));
%retain points inside simulation window
xx=xx(booleInside); 
yy=yy(booleInside); 

numOutsideBoundary = numSpeciesX - numel(find(booleInside==0));
numbPoints = numel(xx);

if numbPoints > numSpeciesX
    disp(['removing ',num2str(numbPoints-numSpeciesX),' excess points'])
    while numbPoints > numSpeciesX
        SelectRandCut = randi(numbPoints,1);
        xx(SelectRandCut) = [];
        yy(SelectRandCut) = [];
        numbPoints = numel(xx);
    end
elseif numbPoints < numSpeciesX
    disp(['Not enough new SpeciesX need ',num2str(numSpeciesX-numbPoints)])
end
%Plotting
%scatter(xx,yy,'.');
%shg;
end
