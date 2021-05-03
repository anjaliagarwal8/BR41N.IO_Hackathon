from scipy.io import loadmat
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.metrics import f1_score
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

#classificaton function
def classify(X,y,model):
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
    model.fit(X_train,y_train)
    cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=3)
    scores = cross_val_score(model, X_train, y_train, cv=cv, n_jobs=-1)
    print('Mean Validation Score: %.3f' % np.mean(scores))
    y_predict = model.predict(X_test)
    test_score = f1_score(y_test,y_predict,average='micro')
    print("Test F1 score: %.3f" % test_score)
    
    
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

model = LinearDiscriminantAnalysis()

for chan in range(8):
    print("############# Channel: ",chan+1," ######################")
    X_ch = X[:,:,chan]
    Y_ch = Y[:,chan]
    classify(X_ch,Y_ch,model)

#Classification using all the channels
X_all = np.concatenate((X[:,:,0],X[:,:,1],X[:,:,2],X[:,:,3],X[:,:,4],X[:,:,5],X[:,:,6],X[:,:,7]),axis=0)
Y_all = np.concatenate((Y[:,0],Y[:,1],Y[:,2],Y[:,3],Y[:,4],Y[:,5],Y[:,6],Y[:,7]))

classify(X_all,Y_all,model)
    
