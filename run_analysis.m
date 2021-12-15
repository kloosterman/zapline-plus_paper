% function runHH_meganalysis

% restoredefaultpath
if ismac
    basepath = '/Users/kloosterman/Dropbox/tardis_code/MATLAB'; % local
    backend = 'none'; % local torque
    addpath(fullfile(basepath, 'tools', 'custom_tools'))
    addpath(genpath(fullfile(basepath, 'tools/custom_tools/plotting')))
    addpath(fullfile(basepath, 'tools/custom_tools/stats'))
else
    basepath = '/mnt/beegfs/home/kloosterman/MATLAB'; % on the cluster
    addpath(fullfile(basepath, 'tools'))
    backend = 'slurm'; % local torque slurm
end
addpath(fullfile(basepath, 'tools', 'fieldtrip')) % cloned on 13 09 19
ft_defaults
addpath(fullfile(basepath, 'zapline-plus')) 
addpath(fullfile(basepath, 'tools', 'zapline-plus')) 
addpath(fullfile(basepath, 'tools/qsub_tardis_slurmpreview'))
addpath(fullfile(basepath, 'tools', 'NoiseTools')) 

%% preprocessing
preproc_setup()

