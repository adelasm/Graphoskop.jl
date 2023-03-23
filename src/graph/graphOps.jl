"""
    l = lap(a)

Create a Laplacian matrix from an adjacency matrix. We might want to do this differently, say by enforcing symmetry
"""
lap(a) = sparse(Diagonal(a*ones(size(a)[1]))) - a