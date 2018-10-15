% Prepare PV profiles for analysis in OpenDSS
% This file extracts a 5-min EV profile randomly from a 288x100 matrix
% It creates a 1-min profile and writes this to a .txt file
clear all

% Set directory and percentage of EV buses
mydir = 'C:\OpenDSS\Matlab_IEEEtestEU\PV_and_EV_profiles'; 
load('WinterEVProfiles.mat')
load('PV50_and_EV50_buses.mat','EV_buses');
percent_EV=100;% define percentage of loads with PV
num_loads=round(55*(percent_EV/100)); 
ev_inputs=zeros(1440,55);

for n=1:55
%for n=1:num_loads
    int=randi([1 100],1,1); % create random integer between 0 and 1
    ev_buses(n)=int;
    ev5=WinterEVProfiles(:,int);
    % Interpolation and noise
    x=(1:288)';
    y=ev5;
    xi=(0.2:0.2:288)';
    ev1=interp1(x,y,xi,'PCHIP');  % interpolate 5 min values

     % Write to text files
     filename = sprintf('SummerEV_profile_%d.txt', n);
     fid = fopen(filename, 'w');
     fprintf(fid, '%f \n', ev1(:));
     fclose(fid);
     
    % Write to ev_inputs array for plotting
    if EV_buses(n)>0
        ev_inputs(:,n)=ev1;
    end
end

% Sum PV inputs
total_ev_input=(sum(ev_inputs')');

figure(1)
plot(ev_inputs)
xlabel('Time step [mins]')
ylabel('EV charging demand [kW]')
grid on

figure(2)
plot(total_ev_input)
xlabel('Time step [mins]')
ylabel('EV charging demand [kW]')
grid on

