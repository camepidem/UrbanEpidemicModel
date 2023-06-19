function idx  = roulettewheelselection( f )
%ROULETTEWHEELSELECTION Randomly chooses a element using the roulette wheel
%selection method.
%
% Syntax:  idx = roulettewheelselection( f )
%
% Inputs:
%   f - Vector with the elements from which the algorithm has to select one
%   from.
%
% Outputs:
%   idx - Location of the selected item in the input vector.
%
% Example:
%   idx  = roulettewheelselection( [1 5 3 15 8 1] )
%   This example returns the location of the randomly selected element in
%   the input vector [1 5 3 15 8 1].
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% $Author: Eleftherios Avramidis, Department of Plant Sciences, Cambridge $
% $Email: el.avramidis@gmail.com, ea461@cam.ac.uk $
% $Date: 2017/03/17 $
% $Version: 1.0 $

pos=find(f); % finds the location of all non-zero values in the vector f
fs=f(pos); % finds the position of all non-zero values in the vector f

fsum=sum(fs); % sum of all non-zero values
r=rand*fsum; %rand - uniform random value between 0 and 1 scaled by length of fsum

% locate the random value based on the value of f
for i=1:length(fs)
    r = r - fs(i);
    if(r <= 0)
        idx=pos(i);
        return; % leave function and return to UrbanTrees.m script as index found.
    end
end
% if index not found in for loop then must be a tree in last position that
% gets infected
idx=pos(length(fs));

end

