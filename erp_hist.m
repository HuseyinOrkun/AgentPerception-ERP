% ERPLAB history file generated on 14-Nov-2020
% ---------------------------------------------

EEG = pop_loadbv('/local/analyses/AgentPerceptionEEGNAIVE/Analyses/ERPs/Subjects/150129HO/', '150129HO_ff.vhdr', [1 460800], [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63]);
EEG.setname='150129HO_ff_readin';

EEG=pop_chanedit(EEG, 'load',{'/local/analyses/AgentPerceptionEEGNAIVE/Analyses/ERPs/scripts/65eloc.elp' 'filetype' 'autodetect'});

EEG = pop_saveset( EEG, 'filename','150129HO_ff_1_elocs.set','filepath','/local/analyses/AgentPerceptionEEGNAIVE/Analyses/ERPs/Subjects/150129HO/');

EEG = pop_loadset('filename','150129HO_ff_3_lpf.set','filepath','/local/analyses/AgentPerceptionEEGNAIVE/Analyses/ERPs/Subjects/150129HO/');

EEG=pop_chanedit(EEG, 'load',{'/local/analyses/AgentPerceptionEEGNAIVE/Analyses/ERPs/scripts/63eloc.elp' 'filetype' 'autodetect'});

EEG = pop_saveset( EEG, 'filename','150129HO_ff_4_elocs.set','filepath','/local/analyses/AgentPerceptionEEGNAIVE/Analyses/ERPs/Subjects/150129HO/');

EEG = pop_epoch( EEG, {  'S 51'  'S 52'  'S 53'  'S 54'  'S 55'  'S 56'  'S 57'  'S 58'  'S 61'  'S 62'  'S 63'  'S 64'  'S 65'  'S 66'  'S 67'  'S 68'  'S 71'  'S 72'  'S 73'  'S 74'  'S 75'  'S 76'  'S 77'  'S 78'  }, [-0.2         0.6], 'newname', '150129HO_ff_5_epoch.set ', 'epochinfo', 'yes');

EEG = pop_rmbase( EEG, [-200    0]);

EEG = pop_saveset( EEG, 'filename','150129HO_ff_5_epoch.set','filepath','/local/analyses/AgentPerceptionEEGNAIVE/Analyses/ERPs/Subjects/150129HO/');

EEG = pop_jointprob(EEG,1,[1:62] ,6,5,0,0);
EEG = pop_rejkurt(EEG,1,[1:62] ,6,5,0,0);

EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
EEG = pop_rejepoch( EEG, [5:8 12 32 51 67 108 120 130 163 174 188 222 239 249 270 275 310 311 345 360] ,0);
EEG.setname='150129HO_ff_6_rej.set ';
EEG.etc.eeglabvers = '2019.1'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_loadset('filename','150129HO_ff_6_rej.set','filepath','/Users/huseyinelmas/Desktop/CCN-Lab/CCN-RSA/AnovaSubject/set_files/subject03_150129HO/');

EEG = pop_epoch2continuous(EEG); % GUI: 14-Nov-2020 23:15:19

EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } ); % GUI: 14-Nov-2020 23:17:11

EEG = pop_eraseventcodes( EEG, '==-99' ); % GUI: 14-Nov-2020 23:17:46

EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } ); % GUI: 14-Nov-2020 23:18:11

EEG  = pop_binlister( EEG , 'BDF', '/Users/huseyinelmas/Desktop/CCN-Lab/CCN-RSA/AnovaSubject/still_binlister.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' ); % GUI: 14-Nov-2020 23:18:57

EEG = pop_epochbin( EEG , [-200.0  600.0],  'pre'); % GUI: 14-Nov-2020 23:19:32

ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DQ_flag', 1, 'DSindex', 7, 'ExcludeBoundary', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname', 'deneme_erp', 'filename', 'deneme_erp.erp', 'filepath', '/Users/huseyinelmas/Desktop/CCN-Lab/CCN-RSA/AnovaSubject/set_files/subject03_150129HO/history', 'Warning', 'on');% GUI: 14-Nov-2020 23:24:02
