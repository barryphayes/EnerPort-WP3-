% Set directory and percentage of PV buses
mydir = 'C:\OpenDSS\Matlab_IEEEtestEU\PV_and_EV_profiles'; 

% Create Voltage monitors for OpenDSS
filename = sprintf('Monitors2.txt');  % Write to text file
fid = fopen(filename, 'w');
for n = 1:905
    bus=n;
    fprintf(fid,'new monitor.V%d\n element=LINE.LINE%d\n terminal=2 mode=0\r\n', bus,bus); 
end
fclose(fid);

% Create Voltage monitors for MatLab
filename = sprintf('Monitors2_Matlab.txt');  % Write to text file
fid = fopen(filename, 'w');
for n = 1:905
    bus=n;
    fprintf(fid,'V%d\n = ExtractMonitorData(DSSCircuit,''V%d\n''); V%d\n(:,[3:2:7]) = V%d\n(:,[3:2:7]) / (416 / sqrt(3)); V%d\n(:,2) = [];\r', bus,bus,bus,bus,bus); 
end
fclose(fid);
