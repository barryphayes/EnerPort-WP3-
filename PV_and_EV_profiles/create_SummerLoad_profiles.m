% Prepare Summer Load profiles for analysis in OpenDSS
% This file extracts a 5-min summer load profile randomly from a 288x100 matrix
% It creates a 1-min profile and writes this to a .txt file
clear all

% Set directory and percentage of PV buses
mydir = 'C:\OpenDSS\Matlab_IEEEtestEU\PV_and_EV_profiles'; 
load('SummerLoadProfiles.mat');
num_loads=55;
summer_loads=zeros(1440,55);

% for num_loads
for n=1:num_loads
    load=SummerLoadProfiles(:,n).*0.75;
    % Interpolation and noise
    x=(1:288)';
    y=load;
    xi=(0.2:0.2:288)';
    load1=interp1(x,y,xi,'cubic');  % interpolate 5 min vales
    load1(load1<0)=0;
%     % Write to text files
%     filename = sprintf('summer_profile_%d.txt', n);
%     fid = fopen(filename, 'w');
%     fprintf(fid, '%f \n', load1(:));
%     fclose(fid);

    % Write to summer_loads array for plotting
    summer_loads(:,n)=load1;
end

% Sum PV inputs
total_load=(sum(summer_loads')');

figure(1)
plot(summer_loads)
xlabel('Time step [mins]')
ylabel('Demand [kW]')
grid on

figure(2)
plot(total_load)
xlabel('Time step [mins]')
ylabel('Demand [kW]')
grid on
