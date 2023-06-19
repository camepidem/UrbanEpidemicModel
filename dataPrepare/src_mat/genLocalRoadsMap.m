function localRoadsMap  = genLocalRoadsMap(urban_data, dmax)
%GENLOCALROADSMAP Generates a cell array in with the closest road to each
%road in the road_data.roads cell matrix.
%
% Syntax:  localRoadsMap  = genLocalRoadsMap( road_data, dmax )
%
% Inputs:
%   urban_data   - Urban structure
%   dmax         - Maximum distance
%
% Outputs:
%   localRoadsMap - Cell array with the local roads map. Each cell
%   C_(i=1...n) [where n  is the number of road segments in the landscape]
%   of the array represents one road segment with index i. The index i
%   shows the location of the road in the urban_data.roads cell matrix.
%   Each cell C_i has two columns. The first of these columns is the index
%   of the road that is in the local neighbourhood of road C_i. The second
%   column is the distance to this road from road C_i.
%
% Example:
%   localRoadsMap  = genLocalRoadsMap( urban_data, 400 );
%   This example generates a cell array in which for each road segment
%   links the road segments that are within a distance of 400 from.
%
% Other m-files required: none
% Subfunctions: getLocalRoads
% MAT-files required: none
%
% See also: none
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 17/03/2017
% Version: 1.0

NumRoads=length(urban_data.roads);

localRoadsMap=cell(length(urban_data.roads),1);
for i=1:NumRoads
    closeroads = getLocalRoads(urban_data, zeros(0,2), i, 0, dmax);
    localRoadsMap{i,1}=closeroads;
end
end

function localroadsoutput = getLocalRoads( urban_data, localroads, idx, d, dmax )
%GETLOCALROADS Recursive function which returns a list of indexes and
%distances to the roads within in a specific distance to origin road.
%
% Syntax:  localroadsoutput = getLocalRoads( urban_data, localroads, idx, d, dmax )
%
% Inputs:
%   urban_data  - Structure with all the roads in the urban area
%   localroads  - Structure with the indexes of already found local roads
%   idx         - Index to the initial road
%   d           - Distance search by the algorithm. First call value always be 0
%   dmax        - Maximum distance of roads for the algorithm to search
%
% Outputs:
%   localroadsoutput - Vector with the indexes of the roads closer to idx road.
%
% Example:
%   localroadsoutput = getLocalRoads( allroads, localroads, 21, 0, 300 )
%   This example returns the local roads (within a distance of 300) to
%   road with index 21. The value 0 designates the initial distance
%   searched by the algorithm. This parameter is always 0 at the first
%   call. The distance is calculated by travelling on the road network.
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Date: 14/03/2017
% Version: 1.0
% Copyright: MIT License

localroadsoutput=localroads;
if d < dmax
    Ds=urban_data.roads_length;
    tovisit=[];
    for jj=1:length(urban_data.roads{idx,2})
        j=urban_data.roads{idx,2}(jj);
        
        if find(localroadsoutput(:,1)-j==0)
            continue;
        end
        
        D=Ds(idx)*0.5+Ds(j)*0.5;
        if (d+D)<dmax
            localroadsoutput=[localroadsoutput; [j d+D]];
            tovisit=[tovisit;j];
        end
    end
    
    for jj=1:length(tovisit)
        j=tovisit(jj);
        D=Ds(idx)*0.5+Ds(j)*0.5;
        if (d+D)<dmax
            localroadsoutput=getLocalRoads( urban_data, localroadsoutput, j, d+D, dmax);
        end
    end
end
end
