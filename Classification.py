from scipy.io import loadmat
import numpy as np

chan = ['Fz','C3','Cz','C4','CP1','CPz','CP2','Pz']
srate = 256
negTime = 100 
posTime = 600
negPnts = round(negTime/(1000/srate));
posPnts = round(posTime/(1000/srate));
L = 3840

data = [{}] * 8
data[0] = loadmat('P2_high1.mat')
data[1] = loadmat('P2_high2.mat')
data[2] = loadmat('P2_low1.mat')
data[3] = loadmat('P2_low2.mat')

data[4] = loadmat('P1_high1.mat')
data[5] = loadmat('P1_high2.mat')
data[6] = loadmat('P1_low1.mat')
data[7] = loadmat('P1_low2.mat')

X = np.zeros((L,negPnts+posPnts,8))
Y = np.zeros((L,8))

for i in range(8):
    targetIdx     = np.where(data[i]['trig'] == 2)[0]
    nontargetIdx  = np.where(data[i]['trig'] == 1)[0]
    distractorIdx = np.where(data[i]['trig'] == -1)[0]
    
    for chan in range(8):
        pntTarget = 0 + i*480
        pntnonTarget = 60 + i*480
        pntDistractor = 120 + i*480
        
        for trial in targetIdx:
            X[pntTarget,:,chan] = data[i]['y'][trial-negPnts:trial+posPnts,chan]
            Y[pntTarget,chan] = 2
            pntTarget = pntTarget + 1
            
        for trial in nontargetIdx:
            X[pntnonTarget,:,chan] = data[i]['y'][trial-negPnts:trial+posPnts,chan]
            Y[pntnonTarget,chan] = 1
            pntnonTarget = pntnonTarget + 1
            
        for trial in distractorIdx:
            X[pntDistractor,:,chan] = data[i]['y'][trial-negPnts:trial+posPnts,chan]
            Y[pntDistractor,chan] = -1
            pntDistractor = pntDistractor + 1
            
#Classification based on each channels

            
    
    
