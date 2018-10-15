% Prepare PV profiles for analysis in OpenDSS
% This file extracts a 5-min PV profile randomly from a 288x100 matrix
% It creates a 1-min profile and writes this to a .txt file
clear all

% Set directory and percentage of PV buses
mydir = 'C:\OpenDSS\Matlab_IEEEtestEU\PV_and_EV_profiles'; 
load('SummerPVProfiles.mat');
load('PV50_and_EV50_buses.mat','PV_buses');
pv_inputs=zeros(1440,55);

% for num_loads
for n=1:55
    pv5=SummerPVProfiles(:,n);
    % Interpolation and noise
    x=(1:288)';
    y=pv5;
    xi=(0.2:0.2:288)';
    pv1=interp1(x,y,xi,'cubic');  % interpolate 5 min vales
    noise_level=0.1; % Add 10% noise
    for i=1:length(pv1)        
        pv1(i)=pv1(i)-0.35*(max(pv1));  % Substract 35% of peak to account for shorter day
        pv1(i)=pv1(i)*0.25; % Reduce ouput for winter conditions
        if pv1(i)>0
            pv1(i)=pv1(i)+noise_level*pv1(i)*randn(1);
        else
            pv1(i)=0;
        end
    end
    pv1(pv1<0)=0;
    % Write to text files
    filename = sprintf('WinterPV_profile_%d.txt', n);
    fid = fopen(filename, 'w');
    fprintf(fid, '%f \n', pv1(:));
    fclose(fid);
    % Write to pv_inputs array for plotting
    if PV_buses(n)>0
        pv_inputs(:,n)=pv1;
    end
end
% Sum PV inputs
total_pv_input=(sum(pv_inputs')');