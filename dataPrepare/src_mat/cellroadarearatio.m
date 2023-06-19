function ppArea = cellroadarearatio(urbanLandscape)

ppArea=zeros(size(urbanLandscape.gridcenters,1),1);

% For each cell
for i=1:size(urbanLandscape.gridcenters,1)
    
    % get roads that are in the cell
    idx=find(urbanLandscape.cellsonroad==i);
    
    if isempty(idx)
        ppArea(i)=1;
    else
        ppArea(i)=0.5;
    end
end