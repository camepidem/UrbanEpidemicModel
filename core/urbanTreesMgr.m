function urbanTreesMgr(urbanLandscape, opts, output_data_filename, C_air, C_road)
% Runs a single urban epidemic simulation.
%
% Syntax:  urbanTreesMgr(urbanLandscape, opts, output_data_filename)
%
% Inputs:
%   urbanLandscape  - The filename to the mat file with the landscape data.
%   opts            - The filename for the output mat file.
%
% Outputs:
%   none
%
% Example:
%   urbanTreesMgr('small_landscape', 'small_landscape_run_1')
%   This example runs a single urban epidemic simulation run.
%
% Other m-files required: urbanTrees.m
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 20/04/2018
% Version: 1.0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input arguments

if strcmp(urbanLandscape, [output_data_filename '.mat'])
    error('urbanLandscape and output_data_filename must be different!')
end

load(urbanLandscape);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single urban epidemic run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run single urbal epidemic simulation
simout = urbanTrees(urbanLandscape, opts, C_air, C_road);
% Add to the output file the simulation parameter values
simout.opts = opts;

if simout.nothinghappened==-1
    disp('Nothing happened!')
    if opts.roadsideTreesON==1
    simout.sumI = sum(simout.Ioutput);
    simout.sumS = sum(simout.Soutput);
end
if opts.parkbackyardTreesON==1
    simout.sumIg = sum(simout.Ioutputg);
    simout.sumSg = sum(simout.Soutputg);
end
    save([num2str(output_data_filename) '.mat'],'simout')
    return
end



if opts.roadsideTreesON==1
    simout.sumI = sum(simout.Ioutput);
    simout.sumS = sum(simout.Soutput);
end
if opts.parkbackyardTreesON==1
    simout.sumIg = sum(simout.Ioutputg);
    simout.sumSg = sum(simout.Soutputg);
end

save([num2str(output_data_filename) '.mat'],'simout')
