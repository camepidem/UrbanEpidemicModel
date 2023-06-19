close all
clear variables
%% EDIT TO YOUR LOCAL PATH
TopPath = 'D:/Cerian/OneDrive - University of Cambridge/UrbanTreeModel/ModelCodeForPublic2023/UrbanEpidemicModel2023';
PathToShapeFiles = 'D:/Cerian/OneDrive - University of Cambridge/UrbanTreeModel/ModelCodeForPublic2023/';
MyFileExchangeFiles_m_Map = 'D:/Cerian/OneDrive - University of Cambridge/MatlabFileExchange/m_map';
%%
SaveOutputPath = [TopPath,'/dataPrepare/src_mat'];
addpath(MyFileExchangeFiles_m_Map);
%% Load your tree map data to get extent of data 
TreeLocationShpFile = m_shaperead([PathToShapeFiles,'ntm/SK5639_NTM_Points']); 
LowerXDir = TreeLocationShpFile.MBRx(1)-50; 
UpperXDir = TreeLocationShpFile.MBRx(2)+50; 
LowerYDir = TreeLocationShpFile.MBRy(1)-50; 
UpperYDir = TreeLocationShpFile.MBRy(2)+50; 

%% Load road map data which encompasses locations of your trees
% and want just part that covers the range of the tree data
shp=m_shaperead([PathToShapeFiles,'open_road_SK/SK_RoadLink']);

roadsloc=[];
idx=1;
for i=1:length(shp.ncst)
    for j=1:size(shp.ncst{i},1)-1
        
        if ~isempty(find(isnan(shp.ncst{i}(j,:))))
            disp('NaN found!')
            break;
        end
        
        if ~isempty(find(isnan(shp.ncst{i}(j+1,:))))
            disp('NaN found!')
            break;
        end
        
        xstartpt = shp.ncst{i}(j,1);
        ystartpt = shp.ncst{i}(j,2);
        xendpt = shp.ncst{i}(j+1,1);
        yendpt = shp.ncst{i}(j+1,2);
        InsideXStartPt = (xstartpt >= LowerXDir) & (xstartpt <= UpperXDir);
        InsideXEndPt = (xendpt >= LowerXDir) & (xendpt <= UpperXDir);
        InsideYStartPt = (ystartpt >= LowerYDir) & (ystartpt <= UpperYDir);
        InsideYEndPt = (yendpt >= LowerYDir) & (yendpt <= UpperYDir);
        
        if  (InsideXStartPt + InsideXEndPt + InsideYStartPt+InsideYEndPt) > 3
            
            roadsloc(idx,1) = i-1;
            roadsloc(idx,2) = xstartpt;
            roadsloc(idx,3) = xendpt;
            roadsloc(idx,4) = ystartpt;
            roadsloc(idx,5) = yendpt;
            
            idx=idx+1;
        end
    end
end

roadsloc = round(roadsloc);
%% Extract subset that match the dataset
dlmwrite([SaveOutputPath,'/NTMsample_OpenRoads.txt'], roadsloc, 'delimiter', '\t', 'precision', 10);

xmax = max([roadsloc(:,2);roadsloc(:,3)]);
xmin = min([roadsloc(:,2);roadsloc(:,3)]);
ymax = max([roadsloc(:,4);roadsloc(:,5)]);
ymin = min([roadsloc(:,4);roadsloc(:,5)]);

xcenter = xmin+(xmax-xmin)/2;
ycenter = ymin+(ymax-ymin)/2;
%% plot to illustrate results for one landscape
figure
plot([roadsloc(:,2),roadsloc(:,3)]',[roadsloc(:,4),roadsloc(:,5)]','LineStyle','-','color',[0,0,0]+0.5)
hold on
plot(xcenter, ycenter, 'r.')
axis tight

RdTrees = load([TopPath,'/dataPrepare/SyntheticDatasets/UnknownMaternPoisson/synth_Matern_1_RoadTrees.txt']);
hold on
plot(RdTrees(:,2),RdTrees(:,3),'.')
shg
ParkTrees = load([TopPath,'/dataPrepare/SyntheticDatasets/UnknownMaternPoisson/synth_Matern_1_ParkTrees.txt']);
plot(ParkTrees(:,2),ParkTrees(:,3),'g.')
