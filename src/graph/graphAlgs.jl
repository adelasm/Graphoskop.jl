#=

Started by Dan Spielman.
Other contributors: xiao.shi@yale.edu,

Provides
  components :computes connected components, returns as a vector
  vecToComps : turns into an array with a list of vertices in each
  shortestPaths(mat, start) : returns an array of distances,
    and pointers to the node closest (parent array)


  kruskal(mat; kind=:min) : to get a max tree, use kind = :max
    returns it as a sparse matrix.

  sparsecut_cond(a, v[, k=1]) : sparse cut by conductance. given an
  adjacency matrix and an arbitrary vector, returns (val, S) pair,
  where val is the conductance of S, which is the sparsest cut found
  according to the procedure similar to the proof of Cheeger's
  Inequality. Does not consider vertex sets with fewer than k
  vertices.

  sparsecut_isop(a, v[, k=1]) : similar to above, but by isoperimetric
  number.

Internal:
  intHeap : used by shortestPaths,
    it is a heap in which the items are ints, and so can
    be removed quickly.



Unused:
  componentsSlow
  shortestPathsSlow

=#



"""Computes the connected components of a graph.
Returns them as a vector of length equal to the number of vertices.
The vector numbers the components from 1 through the maximum number.
For example,

~~~julia
gr = ErdosRenyi(10,11)
c = components(gr)

10-element Array{Int64,1}:
 1
 1
 1
 1
 2
 1
 1
 1
 3
 2
~~~

"""
function components(mat::SparseMatrixCSC{Tv,Ti}) where {Tv,Ti}
  n = mat.n

  order = Array{Ti}(undef, n)
  comp = zeros(Ti,n)

  # note that all of this casting is unnecessary.
  # but, some of it speeds up the code
  # I have not figured out the minimal necessary
  c::Ti = 0

  colptr = mat.colptr
  rowval = mat.rowval

  @inbounds for x in 1:n
    if (comp[x] == 0)
      c = c + 1
      comp[x] = c

      if colptr[x+1] > colptr[x]
        ptr::Ti = 1
        orderLen::Ti = 2
        order[ptr] = x

        while ptr < orderLen
          curNode = order[ptr]

          for ind in colptr[curNode]:(colptr[curNode+1]-1)
            nbr = rowval[ind]
            if comp[nbr] == 0
              comp[nbr] = c
              order[orderLen] = nbr
              orderLen += 1
            end # if
          end # for
          ptr += 1
        end # while
      end # if
    end

  end

  return comp
end # function

"""This turns a component vector, like that generated by components,
into an array of arrays of indices of vertices in each component.  For example,

~~~julia
comps = vecToComps(c)

3-element Array{Array{Int64,1},1}:
 [1,2,3,4,6,7,8]
 [5,10]
 [9]
~~~

"""
function vecToComps(compvec::Vector{Ti}) where Ti
    nc = maximum(compvec)
    comps = Vector{Vector{Ti}}(undef, nc)

    sizes = zeros(Ti,nc)
    for i in compvec
        sizes[i] += 1
    end

     for i in 1:nc
         comps[i] = zeros(Ti,sizes[i])
     end

    ptrs = zeros(Ti,nc)
     for i in 1:length(compvec)
        c = compvec[i]
        ptrs[c] += 1
        comps[c][ptrs[c]] = i
    end
    return comps
end # vecToComps