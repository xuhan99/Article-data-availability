
%% 1. load the data
% 1=subid,2=trial,3=choice, 4=outcome,5= targets, 6=trial_type
[design,~,~] = xlsread('data_adult.xlsx');
subs         = unique(design(:,1),'stable'); %%%VERY IMPORTANT,not to change the original orders. Need to check manually!!!!!!!!!!!!!
nsub         = length(subs); % number of subjects.
%samples      =6000; % number of samplings.
%maxT         =192; % max number of trials for each subject.

%% 2. load the parameters
[par,~,~]=xlsread('IndPars_fitm4a_adult.xlsx');
par = par(:,2:end); %excluding the subid column
paras = struct('alpha11',par(:,1)','alpha12',par(:,2)','alpha21',par(:,3)','alpha22',par(:,4)','beta11',par(:,5)','beta12',par(:,6)','beta21',par(:,7)','beta22',par(:,8)','tau',par(:,9)');
%paras = load('m4b3_subwise_para.mat'); % for approach 1

%% 3. simulation output
%sim_data  = NaN(samples,maxT,11);
%sim_data2 = NaN(samples,maxT,12);

%% 4. simulation for each subject: absolute fit methods
for n=1:nsub
    clear design_sub
    design_sub = design((design(:,1)==subs(n)),:); %data for a given subj. There is no missing trials in this exp, so we do not need to exclude missing trials
    if n==1
        sim_data   = abs_fit_m4(paras,design_sub,n,1);
%         sim_data2  = sim_fit_m4b3_1(paras,design_sub,n,1);
    else
        sim_data   = [sim_data;abs_fit_m4(paras,design_sub,n,1)];
%         sim_data2  = [sim_data2;sim_fit_m4b3_1(paras,design_sub,n,1)];
    end
    
end

%% 5. integer the choices and feedbacks for approach 
% sim_data: 
% 1=subid,2=trial,3=choice, 4=outcome,5= target, 6=trial_type,7=ev,8=choice_sim,9=choice_prob_sim,10=PE,11=PE_c,

% sim_data2:
% 1=subid,2=trial,3=choice, 4=outcome,5= target, 6=trial_type,7=ev,8=choice_sim,9=choice_prob_sim,10=PE,11=PE_c,12=feedback,

%mean_sim_data(:,12)   = round(mean_sim_data(:,8));% make the choice_sim an integer/sim_data 12=choice_sim_int

%mean_sim_data2(:,13)  = round(mean_sim_data2(:,8));% make the choice_sim an integer / sim_data2 13=choice_sim_int

%mean_sim_data2(:,14)  = NaN;% make the outcome_sim an integer (feedback) / sim_data2 14=outcome_sim_int
%mean_sim_data2(mean_sim_data2(:,12)>=0,14)=1;
%mean_sim_data2(mean_sim_data2(:,12)<0,14)=-1;



%% 5. add combinations (8 conditions)
% sim_data((sim_data(:,5)==1 & sim_data(:,6)==1) ,12) =1;%s_pspo
% sim_data((sim_data(:,5)==2 & sim_data(:,6)==1) ,12) =2;%s_nspo
% sim_data((sim_data(:,5)==3 & sim_data(:,6)==1) ,12) =3;%s_psno
% sim_data((sim_data(:,5)==4 & sim_data(:,6)==1) ,12) =4;%s_nsno
% sim_data((sim_data(:,5)==1 & sim_data(:,6)==2) ,12) =5;%o_pspo
% sim_data((sim_data(:,5)==2 & sim_data(:,6)==2) ,12) =6;%o_nspo
% sim_data((sim_data(:,5)==3 & sim_data(:,6)==2) ,12) =7;%o_psno
% sim_data((sim_data(:,5)==4 & sim_data(:,6)==2) ,12) =8;%o_nsno
% 
% sim_data2((sim_data2(:,5)==1 & sim_data2(:,6)==1) ,13) =1;%s_pspo
% sim_data2((sim_data2(:,5)==2 & sim_data2(:,6)==1) ,13) =2;%s_nspo
% sim_data2((sim_data2(:,5)==3 & sim_data2(:,6)==1) ,13) =3;%s_psno
% sim_data2((sim_data2(:,5)==4 & sim_data2(:,6)==1) ,13) =4;%s_nsno
% sim_data2((sim_data2(:,5)==1 & sim_data2(:,6)==2) ,13) =5;%o_pspo
% sim_data2((sim_data2(:,5)==2 & sim_data2(:,6)==2) ,13) =6;%o_nspo
% sim_data2((sim_data2(:,5)==3 & sim_data2(:,6)==2) ,13) =7;%o_psno
% sim_data2((sim_data2(:,5)==4 & sim_data2(:,6)==2) ,13) =8;%o_nsno


%% 6. save data
% sim_data: 
% 1=subid,2=trial,3=choice, 4=outcome,5= target,6=trial_type,7=ev,8=choice_sim,9=choice_prob_sim,10=PE,11=PE_c,12=choice_sim_int,13=conditions
names={'subid',	'gender','trial','pool','rate_s','rate_o','choice_raw','outcome_s','outcome_o','conds','party','frame','choice ','choice_sim','choice_allo'};
commaheader = [names;repmat({','},1,numel(names))];
commaheader=commaheader(:)';
textheader=cell2mat(commaheader);

fid = fopen('sim_data_m4_abs_fit_adult.csv','w');
fprintf(fid,'%s\n',textheader);
%write out data to end of file
dlmwrite('sim_data_m4_abs_fit_all_adult(1).csv',sim_data,'-append');
%%%writematrix(sim_data,'sim_data_m5b_abs_fit_all.csv','WriteMode','append');

fclose('all');



% % sim_data2:
% % 1=subid,2=trial,3=choice, 4=outcome,5= target,6=trial_type,7=ev,8=choice_sim,9=choice_prob_sim,10=PE,11=PE_c,12=feedback,13=chioce_sim_int;14=outcome_sim_int,15=conditions
% 
% names={'subid',	'trial','choice','outcome','targets','trial_type','ev','choice_sim','choice_prob_sim','PE','PE_c','outcome_sim','conditions'};
% commaheader = [names;repmat({','},1,numel(names))];
% commaheader=commaheader(:)';
% textheader=cell2mat(commaheader);
% 
% fid = fopen('sim_data_m4b3_sim_fit.csv','w');
% fprintf(fid,'%s\n',textheader);
% %write out data to end of file
% dlmwrite('sim_data_m4b3_sim_fit_all.csv',sim_data2,'-append');
% %%%writematrix(sim_data2,'sim_data_m5b_sim_fit_all.csv','WriteMode','append');
% 
% fclose('all');

%% 正式情况下需要！！！！！！
%save sim_data_abs_and_sim2.mat sim_data 

%% 8. calculating some overall performance index
% sim_data: 
% 1=subid,2=trial,3=choice, 4=outcome,5= target,6=trial_type,7=ev,8=choice_sim,9=choice_prob_sim,10=PE,11=PE_c,12=conditions
%for status stage
% display(['abs_fit: Overall ACC   is: ',num2str(mean(sim_data(:,3)==sim_data(:,8)))]);
% display(['abs_fit: ACC for con1 is: ',num2str(mean(sim_data(sim_data(:,12)==1,3)==sim_data(sim_data(:,12)==1,8)))]);
% display(['abs_fit: ACC for con2 is: ',num2str(mean(sim_data(sim_data(:,12)==2,3)==sim_data(sim_data(:,12)==2,8)))]);
% display(['abs_fit: ACC for con3 is: ',num2str(mean(sim_data(sim_data(:,12)==3,3)==sim_data(sim_data(:,12)==3,8)))]);
% display(['abs_fit: ACC for con4 is: ',num2str(mean(sim_data(sim_data(:,12)==4,3)==sim_data(sim_data(:,12)==4,8)))]);
% display(['abs_fit: ACC for con5 is: ',num2str(mean(sim_data(sim_data(:,12)==5,3)==sim_data(sim_data(:,12)==5,8)))]);
% display(['abs_fit: ACC for con6 is: ',num2str(mean(sim_data(sim_data(:,12)==6,3)==sim_data(sim_data(:,12)==6,8)))]);
% display(['abs_fit: ACC for con7 is: ',num2str(mean(sim_data(sim_data(:,12)==7,3)==sim_data(sim_data(:,12)==5,8)))]);
% display(['abs_fit: ACC for con8 is: ',num2str(mean(sim_data(sim_data(:,12)==8,3)==sim_data(sim_data(:,12)==6,8)))]);
% 
% 
% % sim_data2:
% % 1=subid,2=trial,3=choice, 4=outcome,5= target,6=trial_type,7=ev,8=choice_sim,9=choice_prob_sim,10=PE,11=PE_c,12=feedback,13=conditions
% 
% display(['sim_fit: Overall ACC   is: ',num2str(mean(sim_data2(:,3)==sim_data2(:,8)))]);
% display(['sim_fit: ACC for con1 is: ',num2str(mean(sim_data2(sim_data2(:,13)==1,3)==sim_data2(sim_data2(:,13)==1,8)))]);
% display(['sim_fit: ACC for con2 is: ',num2str(mean(sim_data2(sim_data2(:,13)==2,3)==sim_data2(sim_data2(:,13)==2,8)))]);
% display(['sim_fit: ACC for con3 is: ',num2str(mean(sim_data2(sim_data2(:,13)==3,3)==sim_data2(sim_data2(:,13)==3,8)))]);
% display(['sim_fit: ACC for con4 is: ',num2str(mean(sim_data2(sim_data2(:,13)==4,3)==sim_data2(sim_data2(:,13)==4,8)))]);
% display(['sim_fit: ACC for con5 is: ',num2str(mean(sim_data2(sim_data2(:,13)==5,3)==sim_data2(sim_data2(:,13)==5,8)))]);
% display(['sim_fit: ACC for con6 is: ',num2str(mean(sim_data2(sim_data2(:,13)==6,3)==sim_data2(sim_data2(:,13)==6,8)))]);
% display(['sim_fit: ACC for con7 is: ',num2str(mean(sim_data2(sim_data2(:,13)==7,3)==sim_data2(sim_data2(:,13)==5,8)))]);
% display(['sim_fit: ACC for con8 is: ',num2str(mean(sim_data2(sim_data2(:,13)==8,3)==sim_data2(sim_data2(:,13)==6,8)))]);
% 
% 
% %% 9. sanity check
% %the following values should be the same: 984
% %for sim_fit
% display(['sim_fit: Trial number for comb1 is: ',num2str(sum(sim_data2(:,13)==1))]);
% display(['sim_fit: Trial number for comb2 is: ',num2str(sum(sim_data2(:,13)==2))]);
% display(['sim_fit: Trial number for comb3 is: ',num2str(sum(sim_data2(:,13)==3))]);
% display(['sim_fit: Trial number for comb4 is: ',num2str(sum(sim_data2(:,13)==4))]);
% display(['sim_fit: Trial number for comb5 is: ',num2str(sum(sim_data2(:,13)==5))]);
% display(['sim_fit: Trial number for comb6 is: ',num2str(sum(sim_data2(:,13)==6))]);
% display(['sim_fit: Trial number for comb7 is: ',num2str(sum(sim_data2(:,13)==7))]);
% display(['sim_fit: Trial number for comb8 is: ',num2str(sum(sim_data2(:,13)==8))]);
% %for abs_fit
% display(['abs_fit: Trial number for comb1 is: ',num2str(sum(sim_data(:,12)==1))]);
% display(['abs_fit: Trial number for comb2 is: ',num2str(sum(sim_data(:,12)==2))]);
% display(['abs_fit: Trial number for comb3 is: ',num2str(sum(sim_data(:,12)==3))]);
% display(['abs_fit: Trial number for comb4 is: ',num2str(sum(sim_data(:,12)==4))]);
% display(['abs_fit: Trial number for comb5 is: ',num2str(sum(sim_data(:,12)==5))]);
% display(['abs_fit: Trial number for comb6 is: ',num2str(sum(sim_data(:,12)==6))]);
% display(['abs_fit: Trial number for comb7 is: ',num2str(sum(sim_data(:,12)==7))]);
% display(['abs_fit: Trial number for comb8 is: ',num2str(sum(sim_data(:,12)==8))]);




