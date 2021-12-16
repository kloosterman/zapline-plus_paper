% function runHH_meganalysis

% restoredefaultpath
if ismac
    basepath = '/Users/kloosterman/Documents/GitHub'; % /zapline-plus_paper
    backend = 'none'; % local torque
%     addpath(fullfile(basepath, 'tools', 'custom_tools')) % needed?
    addpath(genpath(fullfile(basepath, 'plotting-tools')))
    addpath(fullfile(basepath, 'stats-tools'))
else
    basepath = '/home/mpib/kloosterman/GitHub'; % on the cluster
%     addpath(fullfile(basepath, 'tools'))
    backend = 'slurm'; % local torque slurm
end
addpath(fullfile(basepath, 'zapline-plus_paper')) 
addpath(fullfile(basepath, 'zapline-plus')) 
addpath(fullfile(basepath, 'fieldtrip')) 
ft_defaults
addpath(fullfile(basepath, 'qsub-tardis'))
% addpath(fullfile(basepath, 'tools', 'NoiseTools')) 

%% preprocessing
preproc_setup()

