clc;
clear all;
close all;
addpath '/Users/huseyinelmas/Downloads/eeglab2019_1-2'
data_path = '/Users/huseyinelmas/Desktop/CCN-Lab/data/';
out_path = '/Users/huseyinelmas/Desktop/CCN-Lab/CCN-RSA/AnovaSubject/ERP_files/';
binlister_path = '/Users/huseyinelmas/Desktop/CCN-Lab/CCN-RSA/AnovaSubject/' ;
% Paramters
exp_types = {'Prior','Naive'};
stimuli_types = {'Video','Still'}; 

for i = 1:length(exp_types)
    for j = 1:length(stimuli_types)
        if(strcmp(stimuli_types(j),'Video'))
            key='video';
        else
            key='ff';
        end
        % create a new folder with for .erp files, 2 folders for naive and prior and each subject should have two
        % erp files (for 2 conditions) than these files will be merged to one ,
        % Get the set files to a list
        binlister_path = strcat(binlister_path,exp_types{i},'_',stimuli_types{j},'_binlister.txt');
        if(strcmp(exp_types{i}, 'Naive'))
            in_pth = strcat(data_path,exp_types{i},'/setFiles/');
        else
            in_pth = strcat(data_path,exp_types{i},'/',stimuli_types{j},'/');
        end
        out_path = strcat(out_path,exp_types{i});
        folders = dir(in_pth);

        %iterate that list and create a .erp file for each set file
        for k=1:length(folders)
            % If it is a subject folder
            if(folders(k).isdir && ~strcmp(folders(k).name,'.') && ~strcmp(folders(k).name,'..') )
                folder_name = folders(k).name;
                subj_no = folder_name(8:9);
                fprintf('Runnning for subject %s\n',subj_no);
                subj_folder_path = strcat(in_pth,folder_name,'/' );
                files = dir(subj_folder_path);
                noOfCorrectFiles = 0;
                    % Works if there is a .set file and only one .set file
                
                for k=1:length(files)
                    if((strcmp(exp_types(i),'Prior') && isempty(strfind(files(k).name, '.set')) == 0) || (isempty(strfind(files(k).name, '.set'))==0 && isempty(strfind(files(k).name, key)) == 0))
                        set_file_name = files(k).name;
                        noOfCorrectFiles = noOfCorrectFiles + 1;
                    end
                end
                dset_no=0;
                fprintf('Runnning for file %s\n',set_file_name);

                % ERPLAB history file generated on 14-Nov-2020
                % --------------------------------------------
                [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
                EEG = pop_loadset('filename',set_file_name,'filepath',subj_folder_path);
                [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, dset_no ,'overwrite','on');
                dset_no = dset_no+1;
                if(strcmp(exp_types{i}, 'Prior'))
                    EEG = pop_select(EEG,'nochannel',{'TP9','TP10','pulse','GSR'});
                    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, dset_no ,'overwrite','on');
                    dset_no = dset_no+1;
                end

                EEG = pop_chanedit(EEG, 'lookup','/Users/huseyinelmas/Downloads/eeglab2019_1-2/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp');
                [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, dset_no ,'overwrite','on');
                dset_no = dset_no+1;

                % Make eeg data continuous
                EEG = pop_epoch2continuous(EEG,'Warning','off'); % GUI: 14-Nov-2020 23:15:19
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, dset_no,'gui','off');
                dset_no = dset_no+1;

                % Eventlist
                EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } ); % GUI: 14-Nov-2020 23:17:11
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, dset_no,'gui','off'); 
                dset_no = dset_no+1;

                % Remove -99
                EEG = pop_eraseventcodes( EEG, '==-99' ); % GUI: 14-Nov-2020 23:17:46
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, dset_no,'gui','off'); 
                dset_no = dset_no+1;

                % EEG event list again
                EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } ); % GUI: 14-Nov-2020 23:18:11
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, dset_no,'gui','off');
                dset_no = dset_no+1;

                % Binlister
                EEG  = pop_binlister( EEG , 'BDF', binlister_path, 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' ); % GUI: 14-Nov-2020 23:18:57
                [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

                %  epoch on bins
                EEG = pop_epochbin( EEG , [-200.0  600.0],  'pre'); % GUI: 14-Nov-2020 23:19:32
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, dset_no,'gui','off');

                %Create ERP
                ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DQ_flag', 1, 'DSindex', dset_no, 'ExcludeBoundary', 'on', 'SEM', 'on');

                % Save ERP,
                % create folder with subject name and save erps
                if ~exist( strcat(out_path,'/',folder_name), 'dir')
                   mkdir( strcat(out_path,'/',folder_name))
                end
                erp_file_name = strcat('subject',subj_no,'_',exp_types{i},'_',stimuli_types{j});
                ERP = pop_savemyerp(ERP, 'erpname', erp_file_name, 'filename', strcat(erp_file_name,'.erp'), 'filepath', strcat(out_path,'/',folder_name), 'Warning', 'off');% GUI: 14-Nov-2020 23:24:02
           end
        end
    end
end
