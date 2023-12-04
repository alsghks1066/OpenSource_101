import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeRegressor
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVR
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error

def sort_dataset(dataset_df):
	sort_df = dataset_df.sort_values(by='year', ascending=True)
     
	return sort_df

def split_dataset(dataset_df):	
    dataset_df['salary'] = dataset_df['salary'] * 0.001
    
    train_df = dataset_df.iloc[:1718]
    test_df = dataset_df.iloc[1718:]

    X_train = train_df.drop(['salary'], axis=1)
    Y_train = train_df['salary']
    
    X_test = test_df.drop(['salary'], axis=1)
    Y_test = test_df['salary']
    
    return X_train, X_test, Y_train, Y_test

def extract_numerical_cols(dataset_df):
    cols = ['age', 'G', 'PA', 'AB', 'R', 'H', '2B', '3B', 'HR', 'RBI', 'SB', 'CS', 'BB', 'HBP', 'SO', 'GDP', 'fly', 'war']
    num_df = dataset_df[cols].copy()

    return num_df

def train_predict_decision_tree(X_train, Y_train, X_test):
    model = DecisionTreeRegressor()
    model.fit(X_train, Y_train)
    
    prediction = model.predict(X_test)
    
    return prediction

def train_predict_random_forest(X_train, Y_train, X_test):
    model = RandomForestRegressor()
    model.fit(X_train, Y_train)
    
    prediction = model.predict(X_test)
    
    return prediction

def train_predict_svm(X_train, Y_train, X_test):
    pipeline = make_pipeline(StandardScaler(), SVR())
    pipeline.fit(X_train, Y_train)
    
    prediction = pipeline.predict(X_test)
    
    return prediction

def calculate_RMSE(labels, predictions):
    mse = mean_squared_error(labels, predictions)
    
    rmse = np.sqrt(mse)

    return rmse

if __name__=='__main__':
	#DO NOT MODIFY THIS FUNCTION UNLESS PATH TO THE CSV MUST BE CHANGED.
	data_df = pd.read_csv('2019_kbo_for_kaggle_v2.csv')
	
	sorted_df = sort_dataset(data_df)	
	X_train, X_test, Y_train, Y_test = split_dataset(sorted_df)
	
	X_train = extract_numerical_cols(X_train)
	X_test = extract_numerical_cols(X_test)

	dt_predictions = train_predict_decision_tree(X_train, Y_train, X_test)
	rf_predictions = train_predict_random_forest(X_train, Y_train, X_test)
	svm_predictions = train_predict_svm(X_train, Y_train, X_test)
	
	print ("Decision Tree Test RMSE: ", calculate_RMSE(Y_test, dt_predictions))	
	print ("Random Forest Test RMSE: ", calculate_RMSE(Y_test, rf_predictions))	
	print ("SVM Test RMSE: ", calculate_RMSE(Y_test, svm_predictions))
