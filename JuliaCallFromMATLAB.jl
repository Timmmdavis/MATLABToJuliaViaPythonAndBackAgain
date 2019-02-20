using MAT
file = matopen("Matricies.mat")
a=read(file, "a")

#Convert if needed
a=convert(Int,a)

using TravisTest
@time d=TravisTest.MrFunc(a)	
	
file = matopen("JuliaOutput.mat", "w")
write(file, "d", d)
close(file)

exit() #leave precomp