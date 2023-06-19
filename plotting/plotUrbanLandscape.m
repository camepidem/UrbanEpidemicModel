function plotUrbanLandscape(urbanLandscape)
%Plots the urban landscape with roads, near road and park trees.
%
% Syntax:  plotUrbanLandscape(urbanLandscape)
%
% Input arguments:
%   urbanLandscape  - The filename to the mat file with the landscape data.
%
% Return values:
%   none
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: mat file with the urban landscape (e.g. urbanLandscape.mat)
%
% See also: none
%
% Author: Eleftherios Avramidis
% Email: el.avramidis@gmail.com
% Copyright: MIT License
% Date: 19/04/2018
% Version: 1.0

load([urbanLandscape '.mat'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot the urban landscape
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(1)
%set(gcf,'Position',[170 139.5 784 588]);

%% Draw the urban landscape

% Draw roads
roads=zeros(length(urbanLandscape.roads),4);
for ift=1:length(urbanLandscape.roads)
    roads(ift,:)=urbanLandscape.roads{ift,1}(1,:);
end
plot([roads(:,1),roads(:,2)]',[roads(:,3),roads(:,4)]','LineStyle','-','color',[0,0,0]+0.5)
hold on

% Draw nonroad trees
nonroadtrees = urbanLandscape.P;
plot(nonroadtrees(:,1), nonroadtrees(:,2), 'r.', 'MarkerSize', 1)

% Draw road trees
roadtrees = urbanLandscape.T;
plot(roadtrees(:,1), roadtrees(:,2), 'g.', 'MarkerSize', 1)

%% Format figure
% xlim([min(roadtrees(:,1)) max(roadtrees(:,1))])
% ylim([min(roadtrees(:,2)) max(roadtrees(:,2))])
axis tight

set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);

set(gca,'XTick',[]);
set(gca,'YTick',[]);

%% Draw scale bar and message
xloc=min(xlim)+50;
yloc=min(ylim)+40;
barsize=1000;
plot([xloc; xloc+barsize], [yloc; yloc], '-k', 'LineWidth', 2)
% Draw the distance message
text(xloc+barsize/2,yloc-10, '1 km', 'HorizontalAlignment','center')

%% Get figure size - This was used to experiment with different figure sizes
% fig_pos=get(gcf,'Position');
% set(gcf,'Position',[fig_pos(1:2)./4 fig_pos(3:4).*1.4]);
% fig_pos=get(gcf,'Position');