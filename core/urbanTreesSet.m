function out_struct = urbanTreesSet()
% Creates a struct with the urban epidemic simulation options
% and default parameter values.
%
% Syntax:  out_struct = urbanTreesSet()
%
% Inputs: none
%
% Outputs:
%   out_struct - Struct with the city epidemic simulation options and
%   default parameter values.
%
% Example:
%   out_struct = urbanTreesSet()
%   This example creates the urban epidemic simulation options using the
%   default parameter values.
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 12/04/2017
% Version: 1.0

%% Create output struct
out_struct=struct();

%% Flags that set if the park/backyard or roadside trees will be considered by the epidemic model.
out_struct.parkbackyardTreesON = 1;
out_struct.roadsideTreesON = 1;

%% Simulation length and output interval parameters
out_struct.tSpan=10;               % Time span to run the simulation
out_struct.tInterval=1;            % Time interval to save the simulation state

%% Infection rate parameters
out_struct.beta_air=50;             % Scale of the infection rate from a cell to a road segment or another cell
out_struct.beta_road=50;           % Scale of the infection rate from a road segment to another road segment

out_struct.max_roadSegment_length=100;          % Maximum length of road segments.


%% Fraction of produced inoculum that falls in the tile of the event
out_struct.p_air=0.2;                      % The proportion of inoculum to be deposited in the cell that was generated from
out_struct.p_road=0.2;               % The proportion of inoculum to be deposited in the road segment that was generated from

%% Dispersal kernel scaling parameter
out_struct.alpha_air=0.0001;
out_struct.alpha_road=0.0001;          % Rate parameter of the exponential distribution for a road segment to a road segment dispersal kernel

%% Dispersal kernel cut-off distance
out_struct.d_max_air=500;                 % From a cell to another cell
out_struct.d_max_road=500;   % From a road segment to another road segment

%% Other parameters
out_struct.startRoadSegment=0;        % Index of the road segment for the start of the epidemic
out_struct.startCell=0;        % Index of the cell for the start of the epidemic
out_struct.dofig=false;         % Boolean variable for plotting

end
