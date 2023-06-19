function m=normalise_cell_kernel(p, a, dmax, cellsize)

m = 1;
% Example inputs
% p = 0.1; % proportion of inoculum that stays within source cell
% a = 0.003; % rate of decay of exponential dispersion kernel
% dmax = 500; % maximum dispersal distance
% cellsize = 100; % width of each cell in raster (width=height)
% create a grid of cells with the number of cells in the grid the maximum
% distance spores can travel from source * 2 (as can go any direction) + 1
% for the center cell
% For example parameters grid is 11 by 11
area = zeros(ceil(2 * dmax / cellsize)+1, ceil(2 * dmax / cellsize)+1);
% Get cell number of center cell: for example parameters this is cell in
% location (6,6) (counting from 1)
xcentre = ceil(dmax / cellsize)+1;
ycentre = ceil(dmax / cellsize)+1;

% loop through each cell in grid
for i=1:ceil(2 * dmax / cellsize)+1
    for j=1:ceil(2 * dmax / cellsize)+1
        % cell is the center cell i.e. the source cell then a proportion p
        % (user input) of the inoculum lands there
        if i==xcentre && j==ycentre
            area(i,j) = p;
        else
        % otherwise the amount that lands there is based on an exponentially decaying function of distance from source.    
            d = ((i - xcentre)*cellsize)^2;
            d = d + ((j - ycentre)*cellsize)^2;
            d = sqrt(d);
            area(i,j) = dispersal(d, p, a, m, dmax);
        end
    end
end
% imagesc(area)
% scale values so 
% proportion lands outside source cell/ area of all other cells added
% note area includes the source cell (at position(i,i)) which is given area
% as p so need to subtract p from sum(sum(area)) so does not include source
% cell.
m = (1-p)/(sum(sum(area))-p); 

% areanorm = area.*m;
% areanorm(xcentre,ycentre)=area(xcentre,ycentre);
% areanormplot=areanorm;
% areanormplot(xcentre,ycentre)=0;
% imagesc(areanormplot)

% sum(sum(areanorm))

return
end

function k=dispersal(d, p, a, m, dmax)

if d == 0
    k=p;
    return
end

if d > 0 && d <= dmax
    k=m * exp(-a * d);
    return
end

if d > dmax
    k=0;
    return
end
end
