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
    noise_level=0.05; % Add 10% noise
    for i=1:length(pv1)
        if pv1(i)>0
            pv1(i)=pv1(i)/2+noise_level*pv1(i)*randn(1);
        else
            pv1(i)=0;
        end
    end
    pv1(pv1<0)=0;
%     % Write to text files
%     filename = sprintf('SummerPV_profile_%d.txt', n);
%     fid = fopen(filename, 'w');
%     fprintf(fid, '%f \n', pv1(:));
%     fclose(fid);
    % Write to pv_inputs array for plotting
    if PV_buses(n)>0
        pv_inputs(:,n)=pv1;
    end
    
end
% Sum PV inputs
total_pv_input=(sum(pv_inputs')');
capacities=(round(max(pv_inputs)*10))/10;

% Create maxkvar/minkvar values based on inverter oversize factor, s_factor
maxkvar=zeros(length(capacities),2);
s_factor=1.5;

for n=1:length(capacities)
    temp1=capacities(n);
    temp2=sqrt(((1.5*temp1)^2)-(temp1^2));
    maxkvar(n,1)=temp1;
    maxkvar(n,2)=temp2;
end
