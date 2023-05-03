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

def ge(b, G): 
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
result_ideology_difference = ge(b,G)

b = df['ideology_difference'].values
result_offensiveness = ge(b,G)

end = time.time()
print("ideology_difference Result: ", result_ideology_difference)
print("Offensiveness Result: ", result_offensiveness)
print("Time taken: ", end - start, "seconds")
