function [C_air, C_road]=normalise_kernels(G, p_air, p_road, alpha_air, alpha_road, d_max_air, d_max_road, cellsize, max_roadSegment_length)

% cellsize=100;
% max_roadSegment_length=100;
% p_air = 0.8;
% alpha_air = 0.005;
% d_max_air = 1000;
% p_road = 0.8;
% alpha_road = 0.005;
% d_max_road = 1000;

C_air=normalise_cell_kernel(p_air, alpha_air, d_max_air, cellsize);

C_road=normalise_road_kernel(p_road, alpha_road, d_max_road, G, max_roadSegment_length);

end
