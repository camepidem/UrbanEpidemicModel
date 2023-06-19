function urbanLandscape  = createUrbanLandscapeStruct(urbanLandscape, ...
    roads_filename, ...
    road_trees_filename, ...
    park_trees_filename, ...
    roadsideSpeciesFile, ...
    parkBackyardSpeciesFile, ...
    roadsideDatasetFile, ...
    parkBackyardDatasetFile, ...
    roadSeqmentMaxLength, ...
    cellSize, ...
    printing)
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
% Other m-files required: none
% Subfunctions: calculate_length, split_road_segments, add_road_connections
% MAT-files required: none
%
% See also: none
%
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 17/04/2018
% Version: 1.0 $



urbanLandscape.roadsideDataset=importdata(roadsideDatasetFile);
urbanLandscape.parkBackyardDataset=importdata(parkBackyardDatasetFile);

%% Load data for trees that are located next to roads (e.g. distance from road<20m)
T = importdata(road_trees_filename,'\t');
if printing
    % Plot trees
    plot(T(:,2),T(:,3),'k+')
end
urbanLandscape.T=T(:,2:3);

%% Load data for species for the trees that are located next to roads (e.g. distance from road<20m)
urbanLandscape.roadsideSpecies = string(importdata(roadsideSpeciesFile));

%% Load data for species for the trees that are not located next to roads (e.g. distance from road<20m)
urbanLandscape.parkBackyardSpecies = string(importdata(parkBackyardSpeciesFile));

%% Find and store unique species names
urbanLandscape.speciesNames=unique([urbanLandscape.parkBackyardSpecies; urbanLandscape.roadsideSpecies]);

%% Link trees to roads
roads=urbanLandscape.roads;

% Calculate the middle point for each road segment
pt=zeros(size(urbanLandscape.roads,1),2);
for i=1:size(urbanLandscape.roads,1)
    pt(i,:)=[(sum(roads{i,1}(1:2))/2), (sum(roads{i,1}(3:4))/2)];
end
% For each near road tree find the closest road segment
for i=1:size(urbanLandscape.T,1)
    [~,idx(i)] = min(pdist2(pt,urbanLandscape.T(i,:)));
    %     [~,idx(i)] = min(pdist2(urban_environment.T(i,:),pt));
end
% Store the road segment index for each tree
urbanLandscape.RoadSideTreeRoadIdx=idx;

roadpopulation=zeros(length(urbanLandscape.roads),1);
roadpopulationSpecies=zeros(length(urbanLandscape.roads),length(urbanLandscape.speciesNames));

for i=1:size(urbanLandscape.T,1)
    % Increase the population size for the road segment that the tree
    % belongs to
    roadpopulation(idx(i))=roadpopulation(idx(i))+1;
    
    % Get the species for the i tree
    treeSpecies = urbanLandscape.roadsideSpecies(i);
    
    % Get the column index for the i tree species
    sp = find(urbanLandscape.speciesNames==treeSpecies);
    % Increase the population size for the road segment and the species
    % that the tree belongs to
    roadpopulationSpecies(idx(i), sp)=roadpopulationSpecies(idx(i), sp)+1;
end

urbanLandscape.roadpopulation=roadpopulation;
urbanLandscape.roadpopulationSpecies=roadpopulationSpecies;


%% Park trees
P = importdata(park_trees_filename,'\t');
if printing
    plot(P(:,2),P(:,3),'g+')
end
urbanLandscape.P=P(:,2:3);

%% Create grid
roads=zeros(size(urbanLandscape.roads,1),4);
for i=1:size(urbanLandscape.roads,1)
    roads(i,:)=urbanLandscape.roads{i,1};
end
left=min([roads(:,1);roads(:,2)]);
right=max([roads(:,1);roads(:,2)]);
bottom=min([roads(:,3);roads(:,4)]);
top=max([roads(:,3);roads(:,4)]);
% there was an error in that the linspace function is leading to cells
% which are not exactly 100 meters so have changed boundary
EdgeBoundary = 0; %original value in code by Eleftharios 25;
left=left-EdgeBoundary;
right=right+EdgeBoundary;
top=top+EdgeBoundary;
bottom=bottom-EdgeBoundary;

x=linspace(left,right,1+(right-left)/cellSize);
y=linspace(bottom,top,1+(top-bottom)/cellSize);

centers=zeros(length(x)*length(y),2);
count=1;
for i=1:length(x)
    for j=1:length(y)
        centers(count,:)=[x(i) y(j)];
        count=count+1;
    end
end

urbanLandscape.gridcenters=centers;

%% Assign park trees to cells
X = P(:,2:3);
Y = centers;

% For each tree find the grid with the smallest distance to it.
% We do not use the pdist2 MATLAB function because in the case of a large
% amount of trees could cause out of memory error.
idx=zeros(size(X,1),1);
for i=1:size(X,1)
    mindist=1e100;
    for j=1:size(Y,1)
        d=sqrt((X(i,1)-Y(j,1)).^2+(X(i,2)-Y(j,2)).^2);
        if (mindist>d)
            mindist=d;
            idx(i)=j;
        end
    end
end

% Set the number of trees for each cell (i.e. parkpopulation vector)
parkpopulation=zeros(size(centers(:,1),1),1);
parkBackyardPopulationSpecies=zeros(length(parkpopulation),length(urbanLandscape.speciesNames));
for i=1:length(idx)
    parkpopulation(idx(i))=parkpopulation(idx(i))+1;
    
    treeSpecies = urbanLandscape.parkBackyardSpecies(i);
    sp = find(urbanLandscape.speciesNames==treeSpecies);
    parkBackyardPopulationSpecies(idx(i), sp)=parkBackyardPopulationSpecies(idx(i), sp)+1;
end
urbanLandscape.parkpopulation=parkpopulation;
clear parkpopulation;    % Clear parkpopulation since it will be not use again.
urbanLandscape.parkBackyardPopulationSpecies=parkBackyardPopulationSpecies;

%% Assign road trees to cells
X = T(:,2:3);
Y = centers;

% For each tree find the grid with the smallest distance to it.
% We do not use the pdist2 MATLAB function because in the case of a large
% amount of trees could cause out of memory error.
idx=zeros(size(X,1),1);
for i=1:size(X,1)
    mindist=1e100;
    for j=1:size(Y,1)
        d=sqrt((X(i,1)-Y(j,1)).^2+(X(i,2)-Y(j,2)).^2);
        if (mindist>d)
            mindist=d;
            idx(i)=j;
        end
    end
end

% Set the number of trees for each cell (i.e. roadpopulationgrid vector)
roadpopulationgrid=zeros(size(centers(:,1),1),1);
roadBackyardPopulationSpeciesGrid=zeros(length(roadpopulationgrid),length(urbanLandscape.speciesNames));
for i=1:length(idx)
    roadpopulationgrid(idx(i))=roadpopulationgrid(idx(i))+1;
    
    treeSpecies = urbanLandscape.roadsideSpecies(i);
    sp = find(urbanLandscape.speciesNames==treeSpecies);
    roadBackyardPopulationSpeciesGrid(idx(i), sp)=roadBackyardPopulationSpeciesGrid(idx(i), sp)+1;
end
urbanLandscape.roadpopulationgrid=roadpopulationgrid;
clear roadpopulationgrid;    % Clear roadpopulationgrid since it will be not use again.
urbanLandscape.roadBackyardPopulationSpeciesGrid=roadBackyardPopulationSpeciesGrid;

% %% Assign road trees to cells
% X = T(:,2:3);
% Y = centers;
% roads_length = pdist2(X,Y,'euclidean'); % TODO: Change to simple method. In case of large amount of data there is out of memory error.
% 
% idx=zeros(size(roads_length,1),1);
% for i=1:size(roads_length,1)
%     [~,idx(i)]=min(roads_length(i,:));
% end
% 
% roadpopulationcells=zeros(size(centers(:,1),1),1);
% for i=1:length(idx)
%     roadpopulationcells(idx(i))=roadpopulationcells(idx(i))+1;
% end
% urbanLandscape.roadpopulationtiles=roadpopulationcells;
% clear roadpopulationcells;    % Clear roadpopulationcells since it will be not use again.


%% Find the grid which each road occupies
cellsonroad=zeros(size(urbanLandscape.roads,1),1);
for i=1:size(urbanLandscape.roads,1)
    x=(urbanLandscape.roads{i,1}(2)+urbanLandscape.roads{i,1}(1))/2;
    y=(urbanLandscape.roads{i,1}(4)+urbanLandscape.roads{i,1}(3))/2;
    
    X = [x y];
    Y = urbanLandscape.gridcenters;
    [~,cellsonroad(i)] = min(pdist2(X,Y,'euclidean'));
end
urbanLandscape.cellsonroad=cellsonroad;
clear cellsonroad;    % Clear cellsonroad since it will be not use again.


%% Generate road graph
urbanLandscape.G = genRoadGraph(urbanLandscape);

% %% Find the connection between neighboring cells.
% tempLoc=zeros(3,3);
% tempLoc(1,1)=1;
% tempLoc(1,2)=2;
% tempLoc(1,3)=3;
% tempLoc(2,3)=4;
% tempLoc(3,3)=5;
% tempLoc(3,2)=6;
% tempLoc(3,1)=7;
% tempLoc(2,1)=8;
% 
% tempLocR = fliplr(tempLoc);
% tempLocR = flipud(tempLocR);
% 
% G=create_landscape_graph(90);
% 
% cellsEdges=zeros(size(urbanLandscape.gridcenters,1),8);
% Y = urbanLandscape.gridcenters;
% for i=1:size(urbanLandscape.roads,1)
%     % For each road segment
%     
%     % find the cells where the start and finish of the road are located
%     xs=[urbanLandscape.roads{i}(1) urbanLandscape.roads{i}(3)] ;
%     [~,ii] = min(pdist2(xs,Y,'euclidean'));
%     
%     xe=[urbanLandscape.roads{i}(2) urbanLandscape.roads{i}(4)] ;
%     [~,jj] = min(pdist2(xe,Y,'euclidean'));
%     
%     if ii==jj
%         % In the same cell - do nothing
%         %         disp(ii)
%         continue
%     end
%     
%     % get coordinates of ii and jj cells
%     xi=ceil(ii/sqrt(size(urbanLandscape.gridcenters,1)));
%     yi=ii-(xi-1)*sqrt(size(urbanLandscape.gridcenters,1));
%     
%     xj=ceil(jj/sqrt(size(urbanLandscape.gridcenters,1)));
%     yj=jj-(xj-1)*sqrt(size(urbanLandscape.gridcenters,1));
%     
%     xc=2+max(xi,xj)-min(xi,xj);
%     yc=2+max(yi,yj)-min(yi,yj);
%     
%     idxOut = findedge(G,ii,jj);
%     G.Edges.Weight(idxOut)=G.Edges.Weight(idxOut)+1;
%     
%     % j should be one of the 8 around cells
%     cellsEdges(ii,tempLoc(yc,xc))=cellsEdges(ii,tempLoc(yc,xc))+1;
%     cellsEdges(jj,tempLocR(yc,xc))=cellsEdges(jj,tempLocR(yc,xc))+1;
% end
% urbanLandscape.G=G;
% clear G;
% urbanLandscape.cellsEdges=cellsEdges;
% clear cellsEdges;    % Clear cellsonroad since it will be not use again.
% 
% end

%% Calculate p for cells
% ppArea=zeros(size(urbanLandscape.gridcenters,1),1);
% % prArea=zeros(size(urbanLandscape.gridcenters,1),1);
% 
% % For each cell
% for i=1:size(urbanLandscape.cellsonroad,1)
%     
%     % get roads that are in the cell
%     idx=find(urbanLandscape.cellsonroad==i);
%     
%     if isempty(idx)
%         ppArea(i)=1;
% %         prArea(i)=0;
%     else
%         ppArea(i)=0.5;
% %         prArea(i)=0.5;
%     end
% end
% 
% urbanLandscape.ppArea=ppArea;
% urbanLandscape.prArea=prArea;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SUBFUNCTIONS SECTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% function G=create_landscape_graph(N)
% %Creates a square graph for the rasterised landscape. Only neighbouring
% %nodes are connected.
% %
% % Syntax:  G=create_landscape_graph(N)
% %
% % Inputs:
% %   N - Size of the size of the landscape raster
% %
% % Outputs:
% %   G - The created graph
% %
% % Example:
% %   G=create_landscape_graph(90)
% %   This example creeates a graph with 8100 nodes (90*90). Only
% %   neighbouring nodes are connected.
% %
% % Other m-files required: none
% % Subfunctions: none
% % MAT-files required: none
% %
% % See also: none
% %
% % Author: Eleftherios Avramidis
% % Email: el.avramidis@gmail.com
% % Copyright: MIT License
% % Date: 06/07/2018
% % Version: 1.0
% 
% G = graph;
% for i=1:N
%     for j=1:N
%         for ii=i-1:i+1
%             if (ii>=1 && ii<=N)
%                 for jj=j-1:j+1
%                     
%                     if (ii==i && jj==j)
%                         continue;
%                     end
%                     
%                     if (jj>=1 && jj<=N)
%                         index1=(i-1)*N+j;
%                         index2=(ii-1)*N+jj;
%                         
%                         try
%                             G = addedge(G,index1,index2,0);
%                             
%                         catch e
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% end





