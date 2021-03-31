clear
clc

%% Extracting and defining the data
data(1).signal = load('P2_high1.mat').y;
data(1).trig   = load('P2_high1.mat').trig;
data(2).signal = load('P2_high2.mat').y;
data(2).trig   = load('P2_high2.mat').trig;
data(3).signal = load('P2_low1.mat').y;
data(3).trig   = load('P2_low1.mat').trig;
data(4).signal = load('P2_low2.mat').y;
data(4).trig   = load('P2_low2.mat').trig;
data(5).signal = load('P1_high1.mat').y;
data(5).trig   = load('P1_high1.mat').trig;
data(6).signal = load('P1_high2.mat').y;
data(6).trig   = load('P1_high2.mat').trig;
data(7).signal = load('P1_low1.mat').y;
data(7).trig   = load('P1_low1.mat').trig;
data(8).signal = load('P1_low2.mat').y;
data(8).trig   = load('P1_low2.mat').trig;

chan = {'Fz','C3','Cz','C4','CP1','CPz','CP2','Pz'};
srate = 256;
negTime = 100; %ms
posTime = 600; %ms
negPnts = round(negTime/(1000/srate));
posPnts = round(posTime/(1000/srate));

%% Making the dataset
L = 3840; %for 60 target, 60 non targets and 360 distractors in each dataset.

%X = zeros(L, negPnts+posPnts+1);
%Y = zeros(1,L);

for datai=1:8
    targetIdx = find(data(datai).trig == 2);
    non_targetIdx = find(data(datai).trig == 1);
    distractorIdx = find(data(datai).trig == -1);
    targetEpoch = zeros(8,negPnts+posPnts+1,length(targetIdx));
    targetLabel = zeros(8,1,length(targetIdx));
    non_targetEpoch = zeros(8,negPnts+posPnts+1,length(non_targetIdx));
    non_targetLabel = zeros(8,1,length(non_targetIdx));
    distractorEpoch = zeros(8,negPnts+posPnts+1,length(distractorIdx));
    distractorLabel = zeros(8,1,length(distractorIdx));
    
    for chani=1:8
        for triali=1:length(targetIdx)
            targetEpoch(chani,:,triali) = data(datai).signal(targetIdx(triali)-negPnts:targetIdx(triali)+posPnts,chani);    
            targetLabel(chani,1,triali) = 2;
        end
        for triali=1:length(non_targetIdx)
            non_targetEpoch(chani,:,triali) = data(datai).signal(non_targetIdx(triali)-negPnts:non_targetIdx(triali)+posPnts,chani);
            non_targetLabel(chani,1,triali) = 1;
        end
        for triali=1:length(distractorIdx)
            distractorEpoch(chani,:,triali) = data(datai).signal(distractorIdx(triali)-negPnts:distractorIdx(triali)+posPnts,chani);
            distractorLabel(chani,1,triali) = -1;
        end
    end 
    
    X = cat(3,targetEpoch,non_targetEpoch,distractorEpoch);
    Y = cat(3,targetLabel,non_targetLabel,distractorLabel);
    
end



