function m=normalise_road_kernel(p, a, dmax, G, max_roadSegment_length)
% inputs
% p_road = proportion of inoculum which lands on inoculum source road (i.e. doesn't leave road segment
%alpha_road = rate of decay of exponential dispersal kernal
% d_max_road = maximum dispersal distance
% G = graph of road network
% max_roadSegment_length = maximum length of a road segment (as created in
% setting up road network)
m = zeros(size(G.Nodes,1),1); %this is C_road in urbantrees.m

for i=1:size(G.Nodes,1) % G.Nodes is the number of road segments
    % Find all nodes (road segments) within maximum dispersal distance of road segment i
    nn = nearest(G,i,dmax,'Method','positive');
    % assign the length of road segement i to variable lgth
    lgth = G.Edges.Weight(i);
    % calculate the distance between road segment i and each of the road
    % segments that are up to a distance dmax apart
    d = distances(G,i,nn);
    % calculate the exponential part of the dispersion kernel for all roads
    % can disperse to
    k=exp(-a.*d);
    if sum(k)==0
        % this is only possible if k is empty i.e. no roads within distance
        % dmax of road i
        m(i)=0;
    else
        % scale the proportion of inoculum that lands within the road segment by the length of the road segment
        % e.g. p = 0.2, length = 14.3m , max_roadSegment_length = 100m,
        % sum(k) = 217 (from 226 nearest neighbours (nn))
        % m(1) = (1- 0.2*0.143)/217 = 0.9714/217 = 0.0045
        m(i)=(1-p*lgth/max_roadSegment_length)/sum(k);
    end 
end

end