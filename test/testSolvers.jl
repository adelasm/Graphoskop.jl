using Laplacians
mats = []
rhss = []
solver = Main.Graphoskop.wrapCapture(approxchol_lap, mats, rhss)
a = chimera(10,1)
as = shortIntGraph(a)
f = solver(a);
fs = solver(as);
size(mats[1])
b = randn(10)
x = f(b);
xs = fs(b);

# note: this will fail if the graph is not connected
solver = Main.Graphoskop.approxchol_lapChol(a,verbose=true)
x = solver(b);

# testing approxChol internals
a = rand_regular(20,3)
llp = Main.Graphoskop.LLmatp(a)
Main.Graphoskop.print_ll_col(llp,1)
llo = Main.Graphoskop.LLMatOrd(a);
Main.Graphoskop.print_ll_col(llo,1)

a = wted_chimera(1111,1);
llp = Main.Graphoskop.LLmatp(a)
Random.seed!(1)
ldli = Main.Graphoskop.approxChol(llp);
@test Main.Graphoskop.condNumber(a, ldli, verbose=true) < 20
