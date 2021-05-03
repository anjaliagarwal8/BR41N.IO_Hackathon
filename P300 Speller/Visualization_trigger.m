clear
clc

%% Extracting and defining the data
data = load('S1.mat');

trig = data.trig;
signal = data.y;
srate = 250;
signal = signal - mean(signal,1);
%% Extracting separate epochs for each trigger

epochTime = 800; %ms
epochPnts = round(epochTime/(1000/srate));

targetIdx = find(trig == 1);
non_targetIdx = find(trig == -1);

% Representing in standard format (channels X data X trials)
targetEpoch = zeros(8,epochPnts+1,length(targetIdx));
non_targetEpoch = zeros(8,epochPnts+1,length(non_targetIdx));

for chani=1:8
    for triali=1:length(targetIdx)
        targetEpoch(chani,:,triali) = signal(targetIdx(triali):targetIdx(triali)+epochPnts,chani);    
    end
    for triali=1:length(non_targetIdx)
        non_targetEpoch(chani,:,triali) = signal(non_targetIdx(triali):non_targetIdx(triali)+epochPnts,chani);
    end
end

%% Calculating P300 for each trigger
targetP3 = mean(targetEpoch,3);
non_targetP3 = mean(non_targetEpoch,3);
time = linspace(0,800,length(targetP3));

%% Plotting each trigger for all channels
figure(1),clf
plot(time,targetP3)
xlabel('Time'),ylabel('P300 Amplitude')
title('P300 signal for Target Stimulus')
legend

figure(2),clf
plot(time,non_targetP3)
xlabel('Time'),ylabel('P300 Amplitude')
title('P300 signal for Non-Target Stimulus')
legend
