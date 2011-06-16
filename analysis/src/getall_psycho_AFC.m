clear all;
close all;
setenv('GNUTERM', 'x11');

%% AFC_MODE indicates which AFC protocol used
%% if equals 2 then standard 2AFC protocol
%% subject presented with 2 conditions
%% (i.e. true/false, left/right, first/second)
%% if equal to 1, then single condition (e.g. all true)
%% !!!TODO:  implement AFC_MODE > 2 case
AFC_MODE = 2;

%% index of xFactor that corresponds to SOA,
%% used for checking specified SOA against time stamps
%% <= 0 means SOA not used as experimental factor
SOA_INDEX = -1;

%% maximum number of experimental conditions per experimental variable
%% e.g. maximum number of distinct SOAs
global MAX_X_FACTOR_VALS
MAX_X_FACTOR_VALS = [2,3];

%% number of discrete threshold values for constructing ROC curves
global NUM_CONFIDENCE_BINS
NUM_CONFIDENCE_BINS = 4;


remake_AFC_struct = 0;  %% set to 1 to ignore existing anal_struct file

global ROOT_PATH
ROOT_PATH = '/Users/gkenyon/MATLAB/';  %% edit to configure local implementation
if ~exist(ROOT_PATH, 'dir')
  error(['ROOT_PATH does not exist:', ROOT_PATH]);
end

global ANALYSIS_PATH
ANALYSIS_PATH = [ROOT_PATH, 'nAFC/analysis/'];
mkdir(ANALYSIS_PATH); %% does not clobber existing dir

AFC_struct_filename = ...
    [ANALYSIS_PATH, 'results/', 'AFC_struct', '.mat']
read_exp_list = ~exist(AFC_struct_filename, 'file') || remake_AFC_struct

if read_exp_list
  AFC_struct = struct;
  AFC_struct.AFC_mode = AFC_MODE;
  AFC_struct.SOA_index = SOA_INDEX;
else
  load(AFC_struct_filename);
  AFC_MODE = AFC_struct.AFC_mode;
  SOA_INDEX = AFC_struct.SOA_index;
end

%% (re)set paths
AFC_struct.root_path = ROOT_PATH;
AFC_struct.analysis_path = ANALYSIS_PATH;
AFC_struct.exp_results_path = ...
    [AFC_struct.root_path, ...
     'patches/results/official/'];
AFC_struct.analysis_results_path = ...
    [AFC_struct.root_path, ...
     'nAFC/analysis/results/'];
  mkdir(AFC_struct.analysis_results_path); %% does not clobber existing dir
AFC_struct.invalid_path = ...
    [AFC_struct.root_path, ...
     'patches/results/invalid/'];
if ~exist(AFC_struct.exp_results_path, 'dir')
    warning(['exp_results_path does not exist:', ...
	   AFC_struct.exp_results_path]);
  %% if here, experimental data must be
  %% in preexisting AFC_struct
  if ~isfield(AFC_struct, 'exp_list')
    error(['exp_list does not exist in AFC_struct read from:', ...
	   AFC_struct.analysis_results_path]);
  end
end
mkdir(AFC_struct.invalid_path); %% does not clobber existing dir

AFC_struct.filename = ...
    AFC_struct_filename;

%%flip_interval = 5; %% msec, stored in exp_struct, assume 200 Hz

%% get list of subject IDs, build data structs to hold exp data and ROC analysis
fig_list = [];
if read_exp_list
  AFC_dir_struct = dir([AFC_struct.exp_results_path, '*.mat']);
  AFC_num_IDs = size(AFC_dir_struct,1);
  AFC_struct.random_IDs = [];
  AFC_struct.num_IDs = 0;
  AFC_struct.ROC_list = [];
  AFC_struct.exp_list = [];
  for i_AFC_ID = 1 : AFC_num_IDs
    AFC_ID_filename = AFC_dir_struct(i_AFC_ID,1).name;
    AFC_ID_ndx = strfind( AFC_ID_filename, '.mat' );
    AFC_ID_str = AFC_ID_filename(1:AFC_ID_ndx-1);
    AFC_ID = str2num(AFC_ID_str);
    disp(['AFC_ID = ', AFC_ID_str]);
    AFC_filename = [AFC_struct.exp_results_path, AFC_ID_filename];
    load(AFC_filename);
    AFC_exp_struct = exp_struct;
    AFC_exp_struct.AFC_ID = AFC_ID;
    seed_frmt = '%8d'; %%
    if (strcmp( AFC_ID_str, num2str(AFC_exp_struct.seed, seed_frmt)) ~= 1)  %% should be error instead?
      warning(['AFC_ID ~= AFC_exp_struct.seed; ', ...
	       'AFC_ID = ', ...
	       AFC_ID_str, ...
	       '; ', ...
	       'AFC_exp_struct.seed = ', ...
	       num2str(AFC_exp_struct.seed, seed_frmt)]);
    end
    %% check exp_struct to see if official expiment
    if ~AFC_exp_struct.official_flag
      AFC_ROC_struct.valid_flag = 0;
    else
      [AFC_ROC_struct, AFC_exp_struct, fig_list] = ...
	  psycho_AFC(AFC_exp_struct, AFC_struct);
    end
      
    if AFC_ROC_struct.valid_flag == 1
      AFC_struct.num_IDs = ...
	  AFC_struct.num_IDs + 1;
      AFC_struct.random_IDs = ...
	  [AFC_struct.random_IDs, AFC_ID];
      AFC_struct.ROC_list = ...
	  [AFC_struct.ROC_list; AFC_ROC_struct]; 
      AFC_struct.exp_list = ...
	  [AFC_struct.exp_list; AFC_exp_struct]; 
    else
      [STATUS, MSG, MSGID] = movefile(AFC_filename, AFC_struct.invalid_path);
    end
  end %% i_AFC_ID

  psycho_saveFigList( fig_list, AFC_struct.analysis_results_path, 'png');
  close all;
  fig_list = [];
  
end % read_exp_list



%% group trials with same x_factors
%% !!!TODO: merge trial level data as well
%% currently just averages ROC curves and performance

[mean_ROC_struct] = psycho_calcAFC(AFC_struct);
%%AFC_struct.mean_ROC_struct = mean_ROC_struct;
mean_ROC_struct.AFC_AUC

[fig_list_tmp] = psycho_plotAFC(mean_ROC_struct);
fig_list = [fig_list; fig_list_tmp];

[combo_exp_struct] = psycho_comboAFCTrials(AFC_struct);
[combo_ROC_struct, combo_exp_struct, fig_list] = ...
    psycho_AFC(combo_exp_struct, AFC_struct);
combo_ROC_struct.AFC_AUC

%% !!!TODO: the following should plot AUC vs xfactor vals for each xfactor
%%[fig_tmp] = psycho_plotallAFCAUC(AFC_struct);
%%fig_list = [fig_list; fig_tmp];

psycho_saveFigList( fig_list, AFC_struct.analysis_results_path, 'png');
fig_list = [];

AFC_struct.AFC_fieldnames = fieldnames(AFC_struct);
save('-mat', AFC_struct_filename, 'AFC_struct');
