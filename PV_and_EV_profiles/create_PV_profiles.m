% Prepare PV profiles for analysis in OpenDSS
% This file extracts a 5-min PV profile randomly from a 288x100 matrix
% It creates a 1-min profile and writes this to a .txt file
clear all

% Set directory and percentage of PV buses
mydir = 'C:\OpenDSS\Matlab_IEEEtestEU\PV_and_EV_profiles'; 
load('SummerPVProfiles.mat')
percent_PV=50;% define percentage of loads with PV
num_loads=round(55*(percent_PV/100)); 
pv_buses=zeros(num_loads,1);

% for num_loads
for n=1:55
%for n=1:num_loads
    int=randi([0 100],1,1); % create random integer between 0 and 1
    pv_buses(n)=int;
    pv5=SummerPVProfiles(:,int);
    % Interpolation and noise
    x=(1:288)';
    y=pv5;
    xi=(0.2:0.2:288)';
    pv1=interp1(x,y,xi,'cubic');  % interpolate 5 min vales
    noise_level=0.1; % Add 10% noise
    for i=1:length(pv1)
        if pv1(i)>0
            pv1(i)=pv1(i)+noise_level*pv1(i)*randn(1);
        else
            pv1(i)=0;
        end
    end
    % Write to text files
    filename = sprintf('PV_profile_%d.txt', n);
    fid = fopen(filename, 'w');
    fprintf(fid, '%f \n', pv1(:));
    fclose(fid);
end
