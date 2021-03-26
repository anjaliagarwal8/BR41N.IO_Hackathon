clear
clc

%% Extracting and defining the data
data = load('P2_high1.mat');

trig = data.trig;
signal = data.y;
chan = {'Fz','C3','Cz','C4','CP1','CPz','CP2','Pz'};
srate = 256;

%% Plotting the raw signal
figure(1),clf
plot(signal)
xlabel('Time'),ylabel('Amplitude')
title('Raw EEG')
legend(chan)

%%                                          Time-Domain Analysis
%% Extracting the epochs from the raw signal
% data segments of −100 to 600 ms around each stimulus are extracted

trigIdx = find(trig ~= 0);
negTime = 100; %ms
posTime = 600; %ms
negPnts = round(negTime/(1000/srate));
posPnts = round(posTime/(1000/srate));

% Representing in standard format (channels X data X trials)
epochData = zeros(8,negPnts+posPnts+1,length(trigIdx));
for chani=1:8
    for triali=1:length(trigIdx)
        epochData(chani,:,triali) = signal(trigIdx(triali)-negPnts:trigIdx(triali)+posPnts,chani);
    end
end

%% Calculating P300 
p3 = mean(epochData,3);
time = linspace(-100,600,length(p3));

%% Plotting P300 signal for various channels
figure(2),clf
plot(time,p3)
xline(0)
xlabel('Time'),ylabel('P300 Amplitude')
title('P300 signal')
legend(chan)

%%                                      Spectral Analysis
%% Topographical map of P300 for the 8 channels
EEG_format = load('emptyEEG.mat');
chan_locs = EEG_format.EEG.chanlocs;


%%                                      Frequency-Domain Analysis
%% Visualizing the frequency spectrum of P300
amp = 2*abs(fft(p3)/length(p3));
hz = linspace(0,srate/2,(length(amp)/2)+1);
figure(4),clf
plot(hz,amp(:,1:length(hz)))
xlabel('Frequency'),ylabel('Amplitude')
title('Amplitude Spectrum')
legend(chan)


%%                                        Time-Frequency Analysis
%% Visualizing the power of signal in time-frequency plot
power = amp.^2;
figure(5),clf

