import numpy as np
import julia
import scipy.io
import time

def script(a,b):

	#############Python bit#############
	#Testing we can actually use python (not needed)
	c=np.add(a, b)

	print('NumPy Sum result')
	print(c)

	#############Julia bit#############
	#Compute something in Julia (from a module)
	j = julia.Julia()
	j.include("SumArrays.jl")
	d=j.SumArrays(a,b)
	
	print('Julia Sum result')
	print(d)
	
	#############Save bit#############
	#Now save as MATLAB matricies. 
	scipy.io.savemat('PythonOutput.mat', dict(a=a,b=b,c=c,d=d))