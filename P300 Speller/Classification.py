import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.metrics import f1_score
from sklearn.metrics import roc_auc_score
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from scipy.io import loadmat
from imblearn.over_sampling import SVMSMOTE
from sklearn.metrics import plot_confusion_matrix
from sklearn.svm import SVC
    
srate = 250
#negTime = 100 
posTime = 800
#negPnts = round(negTime/(1000/srate));
posPnts = round(posTime/(1000/srate));
L = 6000

data = [{}] * 5
data[0] = loadmat('S1.mat')
data[1] = loadmat('S2.mat')
data[2] = loadmat('S3.mat')
data[3] = loadmat('S4.mat')
data[4] = loadmat('S5.mat')

X = np.zeros((L,posPnts,8))
Y = np.zeros((L,8))

for i in range(5):
    targetIdx     = np.where(data[i]['trig'] == 1)[0]
    nontargetIdx  = np.where(data[i]['trig'] == -1)[0]
    
    for chan in range(8):
        pntTarget = i*1200
        pntnonTarget = 150 + i*1200
        
        for trial in targetIdx:
            X[pntTarget,:,chan] = data[i]['y'][trial:trial+posPnts,chan]
            Y[pntTarget,chan] = 1
            pntTarget = pntTarget + 1
            
        for trial in nontargetIdx:
            X[pntnonTarget,:,chan] = data[i]['y'][trial:trial+posPnts,chan]
            Y[pntnonTarget,chan] = -1
            pntnonTarget = pntnonTarget + 1
            
#Classification based on each channels

model = LinearDiscriminantAnalysis()
model = SVC()
#for chan in range(8):
#    print("############# Channel: ",chan+1," ######################")
#    X_ch = X[:,:,chan]
#    Y_ch = Y[:,chan]
#    classify(X_ch,Y_ch,model)

#Classification using all the channels
X_all = np.concatenate((X[:,:,0],X[:,:,1],X[:,:,2],X[:,:,3],X[:,:,4],X[:,:,5],X[:,:,6],X[:,:,7]),axis=1)
#Y_all = np.concatenate((Y[:,0],Y[:,1],Y[:,2],Y[:,3],Y[:,4],Y[:,5],Y[:,6],Y[:,7]))
Y = Y[:,0]

X_train, X_test, y_train, y_test = train_test_split(X_all, Y, test_size=0.3,random_state=42)
oversample = SVMSMOTE(random_state=42)
X_train, y_train = oversample.fit_resample(X_train,y_train)
model.fit(X_train,y_train)
cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=3)
scores = cross_val_score(model, X_train, y_train, cv=cv, n_jobs=-1)
print('Mean Validation Score: %.3f' % np.mean(scores))
y_predict = model.predict(X_test)
test_score = f1_score(y_test,y_predict)
roc_score = roc_auc_score(y_test,y_predict,average='weighted')
print("Test F1 score: %.3f" % test_score)
print("Test ROC_AUC score: %.3f" % roc_score)
plot_confusion_matrix(model,X_test, y_test)
