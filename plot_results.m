%% load data

% PREIN = '/Users/kloosterman/gridmaster2012/projectdata/zapline-plus/MEG_Hagoort/preproc_zapline-plus_anyfreq';
% cd(PREIN)
% 
% subjlist = dir('*50Hz.mat');
% 
% clear results
% for isub = 1:length(subjlist)
%   load(subjlist(isub).name)
%   disp(subjlist(isub).name)
%   results(isub).analyticsResults = analyticsResults;
%   results(isub).config = zaplineConfig;
%   clear analyticsResults zaplineConfig
% end

PREIN = '/Users/kloosterman/gridmaster2012/projectdata/zapline-plus/CamCan/preproc_zapline-plus_anyfreq';
cd(PREIN)

subjlist = dir('*XXHz.mat');

clear results
for isub = 1:length(subjlist)
  load(subjlist(isub).name)
  disp(subjlist(isub).name)
  results(isub).analyticsResults = analyticsResults;
  results(isub).config = zaplineConfig;
  clear analyticsResults zaplineConfig
end

% % load results_SR
% load /Users/kloosterman/Dropbox/tardis_code/MATLAB/zapline-plus/results_donders/results_donders.mat


% titleprefix = 'MEG study I, '; % also adapt the export at the bottom!
titleprefix = 'MEG study II, '; % also adapt the export at the bottom!

%% process
spec_raw = [];
spec_clean = [];
ratiosLineRaw = [];
ratiosLineClean = [];
proportionRemoved = [];
proportionRemovedNoise = [];
proportionRemovedBelowNoise = [];

for i = 1:length(results)
  
  spec_raw(i,1:length(results(i).analyticsResults.frequencies)) = mean(results(i).analyticsResults.rawSpectrumLog,2);
  spec_clean(i,1:length(results(i).analyticsResults.frequencies)) = mean(results(i).analyticsResults.cleanSpectrumLog,2);
  
  i_linenoise = find(results(i).config.noisefreqs > 49 & results(i).config.noisefreqs < 51);
  if isempty(i_linenoise)
    disp(i)
    continue
  else
    i_linenoise = i_linenoise(1);
  end
  
  ratiosLineRaw(i) = results(i).analyticsResults.ratioNoiseRaw(i_linenoise);
  ratiosLineClean(i) = results(i).analyticsResults.ratioNoiseClean(i_linenoise);
  proportionRemoved(i) = results(i).analyticsResults.proportionRemoved(i_linenoise);
  proportionRemovedNoise(i) = results(i).analyticsResults.proportionRemovedNoise(i_linenoise);
  proportionRemovedBelowNoise(i) = results(i).analyticsResults.proportionRemovedBelowNoise(i_linenoise);
end

%% plot

red = [230 100 50]/256;
green = [0 97 100]/256;
grey = [0.2 0.2 0.2];
lightgreen = [0.6 0.7 0.72];


figure('color','w');
set(gcf,'position',[1 100 round(142.4/171*2480) 650]) % this should mean that we use exactly the correct pixel amount for textwidth images
% set(gcf,'position',[1 100 1240 400])
subplot(1,24,[1:17]);
h1 = shadedErrorBar(results(1).analyticsResults.frequencies,mean(spec_raw),std(spec_raw)/sqrt(19),...
  {'Color',grey,'Linewidth', 3});
hold on
h2 = shadedErrorBar(results(1).analyticsResults.frequencies,mean(spec_clean),std(spec_clean)/sqrt(19),...
  {'color',green,'Linewidth', 3}); % 'lineprops',
% delete(h1.edge)
% delete(h2.edge)
xlim([0 max(results(1).analyticsResults.frequencies)])
xlim([1 101])

set(gca, 'Ticklength', get(gca, 'Ticklength')/2.5) 
set(gca,'ygrid','on','xgrid','on');
set(gca,'yminorgrid','on')
set(gca,'fontsize',20)
xlabel('frequency [Hz]');
ylabel('power [10*log10 \muV^2/Hz]');
legend([h1.mainLine h2.mainLine],{'raw data (SEM)','cleaned data (SEM)'},...
  'edgecolor',[0.8 0.8 0.8]);
box off
title([titleprefix 'frequency spectra, N=' num2str(length(results))])

scale = 0.9;
pos = get(gca, 'Position');
pos(4) = scale * pos(4);
pos(2)=pos(2)+(1-scale)*pos(4);
set(gca, 'Position', pos);

subplot(1,24,[20:24])
data = [ratiosLineRaw' ratiosLineClean'];
Fontsize = 12;
condlabels = {'raw data' 'clean data'};
l = raincloud_plot(data,'plot_vertical',1,...
  'connecting_lines',1,'cloud_edge_col','none',...
  'box_on',0,'box_dodge',1,'plot_means',0,'color',[grey],'alpha',0.00001);
l{1,2}.SizeData = 50;
l{2,2}.SizeData = 50;
yticks([1 2])
yticklabels({'raw' 'clean'})

xlabel('ratio 50 Hz noise / surroundings')
title('noise removal')
ax=gca;
ax.XScale = 'log';
ylim([0.5 2.5])
hold on
plot([1 1], ax.YLim, '--', 'Linewidth', 4, 'Color', grey)
set(gca,'fontsize',20)

xlims = get(gca,'XLim');
set(gca,'xlim',[0.8 xlims(2)])
set(gca,'xgrid','on');
% set(gca,'yminorgrid','on')

pos = get(gca, 'Position');
pos(4) = scale * pos(4);
pos(2)=pos(2)+(1-scale)*pos(4);
set(gca, 'Position', pos);


%% export

export_fig(gcf, 'MEG_study-I', '-png', '-tif', '-eps', '-pdf', '-p0.05', '-a4', '-q101', '-transparent')

saveas(gcf, 'MEG_study-II.tif')