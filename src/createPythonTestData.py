import csv
import os
import networkx as nx
import numpy as np
import time

import pandas as pd
from solver import ge

def generateRandomTestData():
   total = 0.0
   with open('python_out.csv', 'w', newline='') as f:
      writer = csv.writer(f)
      writer.writerow(['Time'])
      for i in range(0,200):
         G2 = nx.random_graphs.fast_gnp_random_graph(1000,0.5)
         b2 = np.random.default_rng().uniform(low=0, high=1, size=1000)
         start = time.time()
         result = ge(G2,b2)
         end = time.time()
         result_time = end - start
         total += result_time
         writer.writerow([total])

   print("Average time: ", total/200)

def testData20kNodes():
   absolute_path = os.path.dirname(__file__)
   attr_relative_path = "../test/data/reddit_11_2016_line_node_attributes.csv"
   attr_full_path = os.path.join(absolute_path, attr_relative_path)
   edge_relative_path = "../test/data/reddit_11_2016_linegraph.csv"
   edge_full_path = os.path.join(absolute_path, edge_relative_path)
   # load data
   attr_df = pd.read_csv(attr_full_path, delim_whitespace=True)
   edge_df = pd.read_csv(edge_full_path, delim_whitespace=True)
   G = nx.Graph()
   for index, row in edge_df.iterrows():
      G.add_edge(row['src'], row['trg'])

   id_vector = {}
   of_vector = {}
   for index, row in attr_df.iterrows():
      id_vector[index] = row['ideology_difference']
      of_vector[index] = row['offensiveness']

   with open('python_out.csv', 'w', newline='') as f:
      writer = csv.writer(f)
      writer.writerow(['Time'])
      total = 0.0
      for i in range(0,100):
         start = time.time()
         result_ideology_difference = ge(G,id_vector)
         result_offensiveness = ge(G,of_vector)

         end = time.time()

         result_time = end - start
         total += result_time
         writer.writerow([total])

if __name__ == "__main__":
   generateRandomTestData()