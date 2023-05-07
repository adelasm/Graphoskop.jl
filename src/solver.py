import random
import networkx as nx
import numpy as np
import pandas as pd
import time
import scipy.sparse.csgraph as csgraph
import os

absolute_path = os.path.dirname(__file__)
relative_path = "../test/data/reddit_11_2016_line_node_attributes.csv"
full_path = os.path.join(absolute_path, relative_path)
# load data
df = pd.read_csv(full_path, delim_whitespace=True)
G = nx.from_pandas_edgelist(df, 'src', 'trg', ['ideology_difference','offensiveness'])

def ge(G, b): 
   # get largest connected component
   largest_cc = max(nx.connected_components(G), key=len)
   G_cc = G.subgraph(largest_cc)

   A = nx.adjacency_matrix(G_cc).todense().astype(float)
   Q = np.linalg.pinv(csgraph.laplacian(np.matrix(A), normed = False))
   
   # get indices of nodes in largest connected component
   indices = [list(G.nodes).index(n) for n in largest_cc]

   return np.sqrt(b[indices].T.dot(
      np.array(Q)
      .dot(b[indices])))

# solve systems of equations
start = time.time()

b = df['offensiveness'].values
result_ideology_difference = ge(G,b)

b = df['ideology_difference'].values
result_offensiveness = ge(G,b)

end = time.time()

print("ideology_difference Result: ", result_ideology_difference)
print("Offensiveness Result: ", result_offensiveness)
print("Time taken: ", end - start, "seconds")

total = 0.0

for i in range(1,200):
   G2 = nx.random_graphs.gnp_random_graph(1000,0.5)
   b2 = np.random.default_rng().uniform(low=0, high=1, size=1000)
   start = time.time()
   print("Result", ge(G2,b2))
   end = time.time()
   total += end - start

print("Average time: ", total/200)