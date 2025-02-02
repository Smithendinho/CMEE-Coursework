import sys
import pandas as pd
import numpy as np
import os

argument = sys.argv[1]

TreeData = pd.read_csv(argument)

def tree_height(degrees, distance):
    """Function using trigonometry to work out tree height"""
    radians = np.deg2rad(degrees)
    height = distance * np.tan(radians)
    return height

TreeData['Height'] = tree_height(TreeData['Angle.degrees'], TreeData['Distance.m'])

output_name = os.path.splitext(os.path.basename(sys.argv[1]))[0]

output_path = os.path.join("../results", f"{output_name}_treeheights.csv")

TreeData.to_csv(output_path, index=False)

