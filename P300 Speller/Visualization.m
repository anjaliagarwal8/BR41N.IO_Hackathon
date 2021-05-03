clear
clc

%% Extracting and defining the data
data = load('S4.mat');

trig = data.trig;
signal = data.y;
srate = 250;

%% Plotting the raw signal in time domain
figure(1),clf
plot(signal)
xlabel('Time'),ylabel('Amplitude')
title('Raw EEG')
legend

%% Plotting the raw signal in frequency domain
amp = 2*abs(fft(signal))/length(signal);
hz = linspace(0,srate/2,(length(amp)/2)+1);
figure(1),clf
plot(hz,amp(1:length(hz),:))
xlabel('Frequency'),ylabel('Amplitude')
title('Raw EEG')
legend

%%                                          Time-Domain Analysis
%% Extracting the epochs from the raw signal

trigIdx = find(trig ~= 0);
epochTime = 800; %ms
epochPnts = round(epochTime/(1000/srate));

% Representing in standard format (channels X data X trials)
epochData = zeros(8,epochPnts+1,length(trigIdx));
for chani=1:8
    for triali=1:length(trigIdx)
        epochData(chani,:,triali) = signal(trigIdx(triali):trigIdx(triali)+epochPnts,chani);
    end
end

%% Calculating P300 
p3 = mean(epochData,3);
time = linspace(0,800,length(p3));

%% Plotting P300 signal for various channels
figure(2),clf
plot(time,p3)
xlabel('Time'),ylabel('P300 Amplitude')
title('P300 signal')
legend

%%                                      Frequency-Domain Analysis
%% Visualizing the frequency spectrum of P300
amp = 2*abs(fft(p3)/length(p3));
hz = linspace(0,srate/2,(length(amp)/2)+1);
figure(4),clf
plot(hz,amp(:,1:length(hz)))
xlabel('Frequency'),ylabel('Amplitude')
title('Amplitude Spectrum')
legend


%%                                        Time-Frequency Analysis
%% Visualizing the power of signal in time-frequency plot for each channel
figure(5),clf
pspectrum(p3(3,:),srate,'spectrogram')