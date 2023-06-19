function simout = setup_output_struct(roadpopulation,parkpopulation,randomseedinfo,roadSegments,start_position,startRoadSegment,startCell)
%SETUP_OUTPUT_STRUCT Summary of this function goes here
%   Detailed explanation goes here

simout = struct();

simout.roadpopulation=roadpopulation;
simout.parkpopulation=parkpopulation;
simout.randomseedinfo=randomseedinfo;

for i=1:size(roadSegments,1)
    ptA(i,:)=[roadSegments{i,1}(1), roadSegments{i,1}(3)];
    ptB(i,:)=[roadSegments{i,1}(2), roadSegments{i,1}(4)];
end

simout.roadpoints.ptA=ptA;
simout.roadpoints.ptB=ptB;
simout.toutput=[];
simout.start_position=start_position;
simout.startRoadSegment=startRoadSegment;
simout.startCell=startCell;
simout.nothinghappened=0;

end

