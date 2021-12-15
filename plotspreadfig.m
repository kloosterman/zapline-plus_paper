function ax = plotspreadfig(data, Fontsize, condlabels, SUBJ)
%% plot bars + lines
% lines between pts
line([ones(1,size(data,1)); ones(1,size(data,1))+1], [data(:,1) data(:,2)]', 'Color',[0.66 0.66 0.66 ], 'Linewidth', 0.5)

% handle = plotSpread( {data(:,1) data(:,2)}, 'distributionMarkers', 'o', 'distributionColors', [1 0.5 0.5; 0.5 0.5 1] );% b r circles
handle = plotSpread( {data(:,1) data(:,2)}, 'distributionMarkers', 'o', 'distributionColors', [0 0 0; 0.6 0.7 0.72] );% b r circles
set(handle{1}(1:2), 'MarkerSize', 3, 'Linewidth', 0.5)
% text(data(:,1)', data(:,2)', num2cell(SUBJ), 'Fontsize', Fontsize)

ax=gca;
ax.FontSize = Fontsize;
ax.XTickLabel = condlabels;

% mean lines
line([0.75 1.25]', [mean(data(:,1)) mean(data(:,1))]',  'Color', [0 0 0], 'Linewidth', 2)
line([1.75 2.25]', [nanmean(data(:,2)) nanmean(data(:,2))]',  'Color', [0.6 0.7 0.72] , 'Linewidth', 2)

% % stats
% [~,p] = ttest(data(:,1), data(:,2));
% text(1, ax.YLim(2), sprintf('p=%1.3f', p), 'Fontsize', Fontsize)
text(0.5, mean(data(:,1)), sprintf('mean=\n%1.1f', mean(data(:,1))), 'Fontsize', Fontsize)
text(2, mean(data(:,2)), sprintf('mean=%1.1f', mean(data(:,2))), 'Fontsize', Fontsize)

xlim([0.5 2.5])


