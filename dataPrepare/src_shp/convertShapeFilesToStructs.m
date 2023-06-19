function [urbanTreesP, urbanTreesR] = convertShapeFilesToStructs(pathToNTMRoadsideShapeFile, pathToNTMParkGardenShapeFile)
% Returns the information of the ARBORtrack and NTM data in structs.
% A struct for roadside trees and one for park/garden trees.
%
% Inputs:
%   pathToNTMRoadsideShapeFile - Path to NTM shapefile
%   pathToNTMParkGardenShapeFile - Path to NTM shapefile with the
%
% Outputs:
%   urbanTreesP - Struct with the park/garden trees
%   urbanTreesR - Struct with the roadside trees
%
% Example:
%   [urbanTreesP, urbanTreesR] = convertShapeFilesToStructs('NTM/NTM_RoadTrees', 'NTM/NTM_ParTrees')
%
% Other m-files required: none
% Subfunctions: extractData
% MAT-files required: none
%
% See also: none
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 21/05/2018
% update to only include NTM data
% Version: 1.2

%% Roadside trees
[ntm_roadside_trees,ntm_roadside_species,ntm_roadside_dataset]=extractData(pathToNTMRoadsideShapeFile);

urbanTreesR=struct();
urbanTreesR.uuid = char(java.util.UUID.randomUUID);
urbanTreesR.dategenerated=datetime('now');
urbanTreesR.treetype='roadside';

urbanTreesR.locations=[ntm_roadside_trees];
urbanTreesR.species=[ntm_roadside_species];
urbanTreesR.dataset=[ntm_roadside_dataset];

%% Park/garden trees
[ntm_park_trees,ntm_park_species,ntm_park_dataset]=extractData(pathToNTMParkGardenShapeFile);


urbanTreesP=struct();
urbanTreesP.uuid = char(java.util.UUID.randomUUID);
urbanTreesP.dategenerated=datetime('now');
urbanTreesP.treetype='parkbackyard';

urbanTreesP.locations=[ntm_park_trees];
urbanTreesP.species=[ntm_park_species];
urbanTreesP.dataset=[ntm_park_dataset];

end

function [trees,species,dataset]=extractData(shapeFilename)
shp=m_shaperead(shapeFilename);
trees = zeros(10,2);
species = strings(10,1);
dataset = strings(10,1);

idx=1;
for k=1:length(shp.ncst)
    trees(idx,1) = shp.ncst{k}(:,1);
    trees(idx,2) = shp.ncst{k}(:,2);
        species(idx) = "UNKNOWN";
        dataset(idx) = "NTM";
    idx=idx+1;
end
end