clear
clc

%% Extracting and defining the data
data = load('P2_high1.mat');

trig = data.trig;
signal = data.y;
chan = {'Fz','C3','Cz','C4','CP1','CPz','CP2','Pz'};
srate = 256;

%% Extracting separate epochs for each trigger
negTime = 100; %ms
posTime = 600; %ms
negPnts = round(negTime/(1000/srate));
posPnts = round(posTime/(1000/srate));

targetIdx = find(trig == 2);
non_targetIdx = find(trig == 1);
distractorIdx = find(trig == -1);

% Representing in standard format (channels X data X trials)
targetEpoch = zeros(8,negPnts+posPnts+1,length(targetIdx));
non_targetEpoch = zeros(8,negPnts+posPnts+1,length(non_targetIdx));
distractorEpoch = zeros(8,negPnts+posPnts+1,length(distractorIdx));

for chani=1:8
    for triali=1:length(targetIdx)
        targetEpoch(chani,:,triali) = signal(targetIdx(triali)-negPnts:targetIdx(triali)+posPnts,chani);    
    end
    for triali=1:length(non_targetIdx)
        non_targetEpoch(chani,:,triali) = signal(non_targetIdx(triali)-negPnts:non_targetIdx(triali)+posPnts,chani);
    end
    for triali=1:length(distractorIdx)
        distractorEpoch(chani,:,triali) = signal(distractorIdx(triali)-negPnts:distractorIdx(triali)+posPnts,chani);
    end
end

%% Calculating P300 for each trigger
targetP3 = mean(targetEpoch,3);
non_targetP3 = mean(non_targetEpoch,3);
distractorP3 = mean(distractorEpoch,3);
time = linspace(-100,600,length(targetP3));

%% Plotting each trigger for all channels
figure(1),clf
plot(time,targetP3)
xline(0)
xlabel('Time'),ylabel('P300 Amplitude')
title('P300 signal for Target Stimulus')
legend(chan)

figure(2),clf
plot(time,non_targetP3)
xline(0)
xlabel('Time'),ylabel('P300 Amplitude')
title('P300 signal for Non-Target Stimulus')
legend(chan)

figure(3),clf
plot(time,distractorP3)
xline(0)
xlabel('Time'),ylabel('P300 Amplitude')
title('P300 signal for Distractor Stimulus')
legend(chan)