import csv
import networkx as nx
import numpy as np
import time
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

if __name__ == "__main__":
   generateRandomTestData()