function G = genRoadGraph(urbanLandscape)

roads = urbanLandscape.roads;
% G = graph;
Ds=urbanLandscape.roads_length;

% Test the graph creation algorithm in a subset of the road network.
roadsloc=zeros(length(roads),4);
for i=1:length(roads)
    roadsloc(i,:)=roads{i,1};
end

xmax = max([roadsloc(:,1);roadsloc(:,2)]);
xmin = min([roadsloc(:,1);roadsloc(:,2)]);
ymax = max([roadsloc(:,3);roadsloc(:,4)]);
ymin = min([roadsloc(:,3);roadsloc(:,4)]);

xcenter = xmin+(xmax-xmin)/2;
ycenter = ymin+(ymax-ymin)/2;

roadsloc_temp = roadsloc;

% Remove roads cutoff from center
cutoff = 9000;
idxs=find(roadsloc(:,1)<xcenter-cutoff);
roadsloc(idxs,:)=[];
% roads(idxs,:)=[];
% Ds(idxs)=[];

idxs=find(roadsloc(:,1)>xcenter+cutoff);
roadsloc(idxs,:)=[];
% roads(idxs,:)=[];
% Ds(idxs)=[];

idxs=find(roadsloc(:,3)<ycenter-cutoff);
roadsloc(idxs,:)=[];
% roads(idxs,:)=[];
% Ds(idxs)=[];

idxs=find(roadsloc(:,3)>ycenter+cutoff);
roadsloc(idxs,:)=[];
% roads(idxs,:)=[];
% Ds(idxs)=[];

roadsloc = roadsloc_temp;
% clear roadsloc_temp

s = [];
t = [];
w = [];
for i=1:length(roads)
    %     i
    if checkRoad(roadsloc, i, xcenter, ycenter, cutoff)
        continue;
    end
    
    if Ds(i)<1
        continue;
    end
    
    for j=1:length(roads{i,2})
        
        if Ds(roads{i,2}(j))<1
            continue;
        end
        
        % Check if the edge is already defined
        idxs1 = find(s==roads{i,2}(j));
        idxs2 = find(t==i);
        if ~isempty(idxs1) && ~isempty(idxs2)
            if ~isempty(find(ismember(idxs1,idxs2)))
                continue;
            end
        end
        
        idxs1 = find(t==roads{i,2}(j));
        idxs2 = find(s==i);
        if ~isempty(idxs1) && ~isempty(idxs2)
            if ~isempty(find(ismember(idxs1,idxs2)))
                continue;
            end
        end
        
        try
            D=Ds(i)*0.5+Ds(roads{i,2}(j))*0.5;  %Ds(i) is road length of road i so distance between roads is distance between road midpoints.
            w = [w D];
            s = [s i];
            t = [t roads{i,2}(j)];
            %             G = addedge(G,i,roads{i,2}(j), D);
        catch
        end
    end
end
G = graph(s,t,w); % specifies graph edges in node pairs (s,t and edge weights w)

end

%% Subfunctions
function x = checkRoad(roadsloc, i, xcenter, ycenter, cutoff)

x = false;

if roadsloc(i,1)<xcenter-cutoff
    x = true;
    return
end

if roadsloc(i,1)>xcenter+cutoff
    x = true;
    return
end

if roadsloc(i,3)<ycenter-cutoff
    x = true;
    return
end

if roadsloc(i,3)>ycenter+cutoff
    x = true;
    return
end

end
