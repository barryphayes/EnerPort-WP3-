function [Mon_DATA] = ExtractMonitorData(DSSCircuit,name_monitor)
%Signature: 32-bit integer (should be 43756)

    DSSMon=DSSCircuit.Monitors;     
    DSSMon.name=name_monitor;
    d = DSSMon.ByteStream;                                                 %byte stream data
    monitor_information.sig = typecast(d(1:4),'int32');
    if monitor_information.sig ~= 43756, 
        error('ByteStream did not contain expected signature'); 
    end
    monitor_information.ver = typecast(d(5:8),'int32');
    monitor_information.size = typecast(d(9:12),'int32');
    monitor_information.mode = typecast(d(13:16),'int32');
    monitor_information.header = native2unicode(d(17:272));                %Header String: 256-byte ANSI characters (fixed length)
    
    %Reading the data======================================================
    data_monitor= typecast(d(273:end),'single');
    data_monitor= reshape(data_monitor, monitor_information.size+2,[])';   %Channels repeat every m.size + 2 times (+2 for hour and sec records)
    monitor_information.data=data_monitor;
    Mon_DATA=monitor_information.data;
end

