# using these is a little slower than the way we do it in the code, but ok
# can say:
# for i in 1:deg(mat, v)
#   nbr = nbri(mat, v, i)
#   wt = weighti(mat, v, i)
#
# but, it is faster to write:
#  for ind in colptr[curNode]:(colptr[curNode+1]-1)
#    nbr = rowval[ind]

""" For a symmetric matrix, this gives the correspondance between pairs of entries in an ijv.
So, ai[ind] = aj[flip[ind]].  For example, 

~~~
(ai,aj,av) = findnz(a);
fl = flipIndex(a)
ind = 10
@show backind = fl[10]
@show [ai[ind], aj[ind], av[ind]]
@show [ai[backind], aj[backind], av[backind]];

backind = fl[10] = 4
[ai[ind],aj[ind],av[ind]] = [2.0,4.0,0.7]
[ai[backind],aj[backind],av[backind]] = [4.0,2.0,0.7]
~~~
"""
function flipIndex(a::SparseMatrixCSC{Tval,Tind}) where {Tval,Tind}

  b = SparseMatrixCSC(a.m, a.n, copy(a.colptr), copy(a.rowval), collect(UnitRange{Tind}(1,nnz(a))) );
  bakMat = copy(b');
  return bakMat.nzval

end