function preproc_setup()
% run from runMIBmeg_analysis

if ismac
  basepath = '/Users/kloosterman/gridmaster2012/projectdata/zapline-plus';
  backend = 'local';
  compile = 'no';
else
  basepath = '/home/mpib/kloosterman/projectdata/zapline-plus';
  backend = 'backend';
  compile = 'no';
end
stack = 1;
timreq = 240; %in minutes per run
memreq = 40000; % in MB
overwrite = 1;

linenoise_rem = 'zapline-plus'; % bandstop zapline zapline-plus DFT

datasets = {'MEG_Hagoort' 'CamCan'};
cfglist = {};

for idata = 1:2
  datapath = fullfile(basepath, datasets{idata});
  
  PREIN = fullfile(datapath, 'raw');
  % PREOUT = fullfile(basepath, 'preproczap');
  % PREOUT = fullfile(basepath, 'preproczap-plus');
  % PREOUT = fullfile(basepath, 'preprocDFT');
  PREOUT = fullfile(datapath, sprintf('preproc_%s_50Hz', linenoise_rem));
  
  mkdir(PREOUT)
  mkdir(fullfile(PREOUT, 'figures'))
  
  
  %make cells for each subject, to analyze in parallel
  cfg = [];
  cfg.PREIN = PREIN;
  cfg.PREOUT = PREOUT;
  cfg.linenoise_rem = linenoise_rem;
  
  cd(PREIN)
  if idata == 1
    meglist = dir('*.ds');
  else
    meglist = dir('sub-*');
  end
  for isub = 1:length(meglist)
    if idata == 1
      cfg.infile = fullfile(meglist(isub).folder, meglist(isub).name);
    else
      infile = dir(fullfile(meglist(isub).folder, meglist(isub).name, 'ses-smt', 'meg', '*.fif' ));
      cfg.infile = fullfile(infile.folder, infile.name);
    end      
    [~,filename]=fileparts(cfg.infile);
    
    cfg.outfile = fullfile(PREOUT, sprintf('%s.mat', filename )); % runno appended below
    
    if ~exist(cfg.outfile, 'file') || overwrite
      cfglist = [cfglist cfg];
    end
  end
end

% cfglist = cfglist(6)
cfglist = cfglist(randsample(length(cfglist),length(cfglist)));

selectrun = 0;
if selectrun && ismac
  c = cell2mat(cfglist)
  ind = [c.subjno] == 11 & [c.ses] == 'D' & [c.irun] == 4;
  cfglist = cfglist(ind);
end

fprintf('Running preproc for %d cfgs\n', length(cfglist))

if strcmp(backend, 'slurm')
  options = '-D. -c2' ; % --gres=gpu:1
else
  options =  '-l nodes=1:ppn=3'; % torque %-q testing or gpu
end

setenv('TORQUEHOME', 'yes')
mkdir('~/qsub'); cd('~/qsub');
if strcmp(compile, 'yes')
  ft_hastoolbox('ctf', 1); % for loading ctf data
  ft_hastoolbox('eeglab', 1); % for ica
  fun2run = qsubcompile({@preproc @sortTrials_MEGhh_2afc @interpolate_blinks}, 'toolbox', {'signal', 'stats'}); %
  %   fun2run = qsubcompile({@preproc @sortTrials_MEGhh_2afc @interpolate_blinks}, ...
  %       'executable', 'run_kloosterman_master_p10908_b18.sh'); % compiled function
else
  fun2run = @preproc;
end

if strcmp(backend, 'local')
  cellfun(fun2run, cfglist)
  return
end

qsubcellfun(fun2run, cfglist, 'memreq', memreq*1e6, 'timreq', timreq*60, 'stack', stack, ...
  'StopOnError', true, 'backend', backend, 'options', options);

