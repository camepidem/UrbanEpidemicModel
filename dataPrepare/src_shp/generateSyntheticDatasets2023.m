function generateSyntheticDatasets2023(NumLandscapesToGenerate, a_speciesAssignmentType,  outputPath, a_outputFilePrefix, pathToNTMRoadsideShapeFile, pathToNTMParkGardenShapeFile,ProportionSpeciesXPark,ProportionSpeciesXRoad)
% called by ...\urbanEpidemicModel\dataPrepare\callGenerateSyntheticDatasets.m

for i=1:NumLandscapesToGenerate
    % Assign unknown species to oaks based on selected assignment method
    if strcmp(a_speciesAssignmentType,'speciesAssignmentType.UnknownRandomly')
        % Extract tree data from shape files
        [urbanTreesP, urbanTreesR] = convertShapeFilesToStructs(pathToNTMRoadsideShapeFile, pathToNTMParkGardenShapeFile);
        [urbanTreesP, urbanTreesR] = assignUnknownRandomly(urbanTreesP, urbanTreesR,  false,ProportionSpeciesXPark,ProportionSpeciesXRoad);
        [urbanTreesP, urbanTreesR] = assignUnknownRandomly(urbanTreesP, urbanTreesR,  true,ProportionSpeciesXPark,ProportionSpeciesXRoad);
    elseif strcmp(a_speciesAssignmentType,'speciesAssignmentType.UnknownMaternPoisson')
        % Extract tree data from shape files
        [urbanTreesP, urbanTreesR] = convertShapeFilesToStructs(pathToNTMRoadsideShapeFile, pathToNTMParkGardenShapeFile);
        [urbanTreesP, urbanTreesR] = assignUnknownMaternPoisson(urbanTreesP, urbanTreesR,  false,ProportionSpeciesXPark,ProportionSpeciesXRoad);
        [urbanTreesP, urbanTreesR] = assignUnknownMaternPoisson(urbanTreesP, urbanTreesR,  true,ProportionSpeciesXPark,ProportionSpeciesXRoad);
    elseif strcmp(a_speciesAssignmentType,'speciesAssignmentType.assignAllToSpeciesX')
        [urbanTreesP, urbanTreesR] = convertShapeFilesToStructs(pathToNTMRoadsideShapeFile, pathToNTMParkGardenShapeFile);
        urbanTreesP.species = repmat("SpeciesX",numel(urbanTreesP.species),1);
        urbanTreesR.species = repmat("SpeciesX",numel(urbanTreesR.species),1);
    else
        disp('Unknown method: choose speciesAssignmentType.UnknownRandomly or speciesAssignmentType.UnknownMaternPoisson')
    end
    
    idxSpeciesXRoad = find(urbanTreesR.species=="SpeciesX");
    idsSpeciesXPark = find(urbanTreesP.species=="SpeciesX");
    urbanTreesR.dataset=urbanTreesR.dataset(idxSpeciesXRoad,:) ;
    urbanTreesR.species=urbanTreesR.species(idxSpeciesXRoad,:) ;
    urbanTreesR.locations=urbanTreesR.locations(idxSpeciesXRoad,:);
    
    urbanTreesP.dataset=urbanTreesP.dataset(idsSpeciesXPark,:) ;
    urbanTreesP.species=urbanTreesP.species(idsSpeciesXPark,:) ;
    urbanTreesP.locations=urbanTreesP.locations(idsSpeciesXPark,:);

    % Store results in a struct
    urbanTrees=struct();
    urbanTrees.urbanTreesP = urbanTreesP;
    urbanTrees.urbanTreesR = urbanTreesR;
    save([outputPath '/urbanTrees' num2str(i) '.mat'], 'urbanTrees') %edited to i+16 so doesn't overwrite original 8 landscapes
end
% %% Convert mat files to txt files
% splitTrees2txtFiles
for i=1:NumLandscapesToGenerate
    load([outputPath '/urbanTrees' num2str(i) '.mat'])
    outputFilePrefix = [outputPath '/' a_outputFilePrefix num2str(i) '_'];
    splitTrees2txtFiles(urbanTrees.urbanTreesP, urbanTrees.urbanTreesR, outputFilePrefix)
end

end