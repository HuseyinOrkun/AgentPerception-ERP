clear all;
close all;
clc;
naive_in_pth = '/Users/huseyinelmas/Desktop/CCN-Lab/CCN-RSA/AnovaSubject/ERP_files/Naive/';
naive_folders = dir(naive_in_pth);
naive_erp_files = cell(1,length(naive_folders)-3);

%iterate that list and create a .erp file for each set file
for k=1:length(naive_folders)
    if(naive_folders(k).isdir && ~strcmp(naive_folders(k).name,'.') && ~strcmp(naive_folders(k).name,'..') )
        subj_folder_path = strcat(naive_in_pth,naive_folders(k).name,'/' );
		files = dir(subj_folder_path);
        
		for i=1:length(files)
            file_name = files(i).name;
			if(~strcmp(file_name,'.') && ~strcmp(file_name,'..') && strcmp(file_name(end-3:end),'.erp'))
                if((~strcmp(file_name(16),'_')) && (strcmp(file_name(11:15),'Naive')))
                        naive_erp_files{k-3} = strcat(subj_folder_path,file_name);
                end
            end 
        end
    end
end
prior_in_pth = '/Users/huseyinelmas/Desktop/CCN-Lab/CCN-RSA/AnovaSubject/ERP_files/Prior/';
prior_folders = dir(prior_in_pth);
prior_erp_files = cell(1,length(prior_folders)-3);
for k=1:length(prior_folders)
    if(prior_folders(k).isdir && ~strcmp(prior_folders(k).name,'.') && ~strcmp(prior_folders(k).name,'..') )
        subj_folder_path = strcat(prior_in_pth,prior_folders(k).name,'/' );
		files = dir(subj_folder_path); 
		for i=1:length(files)
            file_name = files(i).name;
			if(~strcmp(file_name,'.') && ~strcmp(file_name,'..') && strcmp(file_name(end-3:end),'.erp'))
                if((~strcmp(file_name(16),'_'))&& (strcmp(file_name(11:15),'Prior')))
                        prior_erp_files{k-3} = strcat(subj_folder_path,file_name);
                end
            end
        end
    end
end

%Make sure all EEGLAB functions are on the MATLAB path
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
%ERP sets to include in GND

%Create a GND structure
GND_N = erplab2GND(naive_erp_files, ...
                   'use_bins', 1:6, ...
                   'exclude_chans',{'HEOG'}, ...
                   'exp_name','StimulusAgent', ...
                   'out_fname', 'StimulusAgent_naive.GND');
'y';
 
%Add bins for following up main effects of Frequency
GND_N = bin_mean(GND_N, 1, 4, 'Robot'); %bin 7
GND_N = bin_mean(GND_N, 2, 5, 'Human'); %bin 8
GND_N = bin_mean(GND_N, 3, 6, 'Android'); %bin 9

%Downsample the data in the GND from 512Hz to 128 Hz using boxcar filter
%Filter averages together each time point with the surrounding 2 time
%points
%GND_N = decimateGND(GND_N, 4, 'boxcar', [-200 -1], 'yes', 0);

% Visually examine data
%gui_erp(GND_N)


%%Prior GND

%Create a GND structure
GND_P = erplab2GND(prior_erp_files, ...
                   'use_bins', 1:6, ...
                   'exclude_chans',{'HEOG','pulse','GSR'}, ...
                   'exp_name','StimulusAgent', ...
                   'out_fname', 'StimulusAgent_prior.GND');
 
%Add bins for following up main effects of Frequency
GND_P = bin_mean(GND_P, 1, 4, 'Robot'); %bin 7
GND_P = bin_mean(GND_P, 2, 5, 'Human'); %bin 8
GND_P = bin_mean(GND_P, 3, 6, 'Android'); %bin 9

%Downsample the data in the GND from 512Hz to 128 Hz using boxcar filter
%Filter averages together each time point with the surrounding 2 time
%points
%GND_P = decimateGND(GND_P, 4, 'boxcar', [-200 -1], 'yes', 0);

% Visually examine data
%gui_erp(GND_P)

%% Make GRP
[GND_P.chanlocs(1:62).ref] = deal([]);
GRP = GNDs2GRP({'StimulusAgent_prior.GND','StimulusAgent_naive.GND'},'group_desc',{'Prior','Naive'}, 'out_fname', 'StimulusAgent.GRP');