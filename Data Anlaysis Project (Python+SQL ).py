#importing pandas and reading data from csv file 

import pandas as pd

df=pd.read_csv('orders.csv')

# get column which holds NAN/Null values
print(df.isnull().any())

# read data from file and handle null values
print(df['Ship Mode'].unique())

# from Ship Mode column ,treat Not avalibale and unknown data as null
df=pd.read_csv('orders.csv',na_values=['Not Available','unknown'])
print(df['Ship Mode'].unique())

#column names are not in standard format ,Rename column --make lower case and replace space with underscore
df.columns=df.columns.str.lower()
df.columns=df.columns.str.replace(' ','_')
print(df.columns)

#create new column discount ,sale price and profit and discount
df['discount']=df['discount_percent']*df['list_price']*0.01
df['sale_price']=df['list_price']-df['discount']
df['profit']=df['sale_price']-df['cost_price']

#data conversion
print(df['order_date'].dtypes)   #object data for ordate date before conversion
df['order_date']=pd.to_datetime(df['order_date'],format='%Y-%m-%d')
print(df['order_date'].dtypes)   #converted to datetime

#creating connection and loading data into sql server

import pyodbc
import sqlalchemy  as db
engine=db.create_engine('mssql://DESKTOP-KSJMIAH/practiceDB?driver=ODBC Driver 17 for SQL Server')
conn=engine.connect()

#load data to SQL server
#df.to_sql('df_orders',con=conn,index=False,if_exists='replace')
df.to_sql('df_orders',con=conn,index=False,if_exists='append')









