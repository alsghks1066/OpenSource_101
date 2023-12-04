import numpy as np
import pandas as pd

data_df = pd.read_csv('2019_kbo_for_kaggle_v2.csv')

#problem_1
print("problem_1")
data_df_1 = data_df[(data_df['year'] >= 2015) & (data_df['year'] <= 2018)]

for year in range(2015, 2019):
    year_data = data_df_1[data_df_1['year'] == year]
    print(f"[    {year} Top 10    ]")
    for i in ['H', 'avg', 'HR', 'OBP']:
        top_players = year_data.nlargest(10, i)[['batter_name', i]]
        print(f"{i} Top 10 player")
        print(top_players.to_string(index=False, justify='left'))
        print("\n")
    print("---------------------------\n")

#problem_2
print("problem_2")
data_df_2 = data_df[data_df['year'] == 2018]
positions = ['포수', '1루수', '2루수', '3루수', '유격수', '좌익수', '중견수', '우익수']
print(f"[    2018 Top player by position    ]")
for pos in positions:
    position_df = data_df_2[data_df_2['cp'] == pos]
    top_player = position_df.nlargest(1, 'war')[['batter_name', 'war']]
    print(f"player with highest war by {pos}")
    print(top_player.to_string(index=False, justify='left'))
    print("\n")

#problem_3
print("problem_3")
data_df_3 = data_df
items = ['R', 'H', 'HR', 'RBI', 'SB', 'war', 'avg', 'OBP', 'SLG']
corr = data_df_3[items + ['salary']].corr()['salary'].drop('salary')
high_corr_item = corr.idxmax()
high_corr_value = corr.max()
print(f"highestr correlation with salary : {high_corr_item}\ncorr_value : {high_corr_value}")