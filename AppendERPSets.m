clc;
clear all;
close all;
% Paramters
exp_types={'Prior','Naive'};

%iterate that list and create a .erp file for each set file
for i=1:length(exp_types)
    in_pth = strcat("/Users/huseyinelmas/Desktop/CCN-Lab/CCN-RSA/AnovaSubject/ERP_files/",exp_types{i},'/');
    folders = dir(in_pth);
    fileID = fopen(strcat(in_pth,'ERPList.txt'),'w');
    
    for k=1:length(folders)
        % If it is a subject folder
        if(folders(k).isdir && ~strcmp(folders(k).name,'.') && ~strcmp(folders(k).name,'..') )
            folder_name = folders(k).name;
            subj_no = folder_name(8:9);
            fprintf('Appending files of subject %s\n',subj_no);
            subj_folder_path = strcat(in_pth,folder_name,'/' );
            files = dir(subj_folder_path);
            still_erp_file_name = strcat('subject',subj_no,'_',exp_types{i},'_','still','.erp');
            video_erp_file_name = strcat('subject',subj_no,'_',exp_types{i},'_','video','.erp');
            [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
            [ERP, ALLERP] = pop_loaderp( 'filename', {still_erp_file_name, video_erp_file_name}, 'filepath', subj_folder_path{1});                                                                                                                                                                                                                                                                         
            ERP = pop_appenderp( ALLERP , 'Erpsets', [ 1 2] );
            final_erp_file_name = strcat('subject',subj_no,'_',exp_types{i},'.erp');
            ERP = pop_savemyerp(ERP, 'erpname',final_erp_file_name , 'filename', final_erp_file_name, 'filepath', subj_folder_path{1}, 'Warning', 'off');
            fprintf(fileID, strcat(subj_folder_path{1},final_erp_file_name,'\n'));
        end
    end
end
        
        