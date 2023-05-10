import networkx as nx
import numpy as np
import pandas as pd
import time
import scipy.sparse.csgraph as csgraph
import os

def ge(G,o):
   if nx.number_connected_components(G) > 1:
      raise ValueError("Node vector distance is only valid if calculated on a network with a single connected component. The network passed has more than one.")
   o = np.array([o[n] if n in o else 0. for n in G.nodes()])
   A = nx.linalg.adjacency_matrix(G).todense().astype(float) # type: ignore
   Q = np.linalg.pinv(csgraph.laplacian(np.matrix(A), normed = False))
   return np.sqrt(o.T.dot(np.array(Q).dot(o)))

def testOn20kNodes():
   absolute_path = os.path.dirname(__file__)
   attr_relative_path = "../test/data/reddit_11_2016_line_node_attributes.csv"
   attr_full_path = os.path.join(absolute_path, attr_relative_path)
   edge_relative_path = "../test/data/reddit_11_2016_linegraph.csv"
   edge_full_path = os.path.join(absolute_path, attr_relative_path)
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

   # solve systems of equations
   start = time.time()

   result_ideology_difference = ge(G,id_vector)
   result_offensiveness = ge(G,of_vector)

   end = time.time()

   print("ideology_difference Result: ", result_ideology_difference)
   print("Offensiveness Result: ", result_offensiveness)
   print("Time taken: ", end - start, "seconds")

if __name__ == "__main__":
   testOn20kNodes()