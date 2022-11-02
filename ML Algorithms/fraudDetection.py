import pandas as pd 
import numpy as np 
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import test_train_split

df = pd.read_csv("/content/")

cat_cols=['SEX','EDUCATION','MARRIAGE','default.payment.next.month']

fig,ax=plt.subplots(1,4,figsize=(25,5))

for cols,subplots in zip(cat_cols,ax.flatten()):
    sns.countplot(x=df[cols],ax=subplots)

yes = (((df['default.payment.next.method']==1).sum())/len(df['default.payment.next.method']))*100;
no = (((df['default.payment.next.method']==0).sum())/len(df['default.payment.next.method']))*100;

x = [yes, no]

plt.pie(x, labels=['yes','no'], colors = ['red','white'], radius = 2, autopct = '%1.0f%%')
plt.title('default.payment.next.month')
plt.show()

df['default.payment.next.month'].values_count(normalize = True)
X = df.drop('default.payment.next.month', axis = 1)
y = df['default.payment.next.month']


X_train, X_test, y_train, y_test = train_test_split(X,y,test_size = 0.30, random_state = 42)

from sklearn.ensemble import RandomForestClassifier
rfc = RandomForestClassifier()

model = rfc.fit(X_train, y_test)
prediction = model.predict(X_test)

from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
print(classification_report(y_test, prediction))

