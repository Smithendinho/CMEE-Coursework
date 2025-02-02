# Import Packages
import pandas as pd

# Import Data Set
data = pd.read_csv("../data/LogisticGrowthData.csv")
MetaData = pd.read_csv("../data/LogisticGrowthMetaData.csv")

# This code adds an ID column so that that different curves can be used from their ID
data.insert(0, "ID", data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation)
data['ID'].nunique() # There are 285 different growth curves

# replace each ID with respective number using pandas factorize function
data.ID = pd.factorize(data.ID)[0]

# remove the X column
data1 = data.drop(data.columns[1], axis=1, index= None)

# write to csv and remove index colomn with equals false
data1.to_csv("../data/WrangledData.csv", index = False)