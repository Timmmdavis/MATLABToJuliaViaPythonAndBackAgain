import numpy as np
import julia
import scipy.io
import time
import os as OpSys

def script():

	print('in script')

	#############Load Vars#############
	#If we saved the vars in MATLAB then we load them here. 
	a=np.load('a.npy')
	b=np.load('b.npy')
	
	#If you want a as ints or floats for your julia scripts use the conversions below,
	#(provided these inputs are single no's when defined and converted to numpy arrays in MATLAB e.g. "a=1")
	#a=int(a);
	#a=float(a);

	#############Python bit#############
	#Testing we can actually use python (not needed)
	c=np.add(a, b)

	print('NumPy Sum result')
	print(c)

	#############Julia bit#############
	#Compute something in Julia (from a module)
	from julia import Main
	print('Make sure you cd to correct dir here')
	Main.include(string(pwd(),"SumArrays.jl"))
	d=Main.SumArrays(a,b)

	print('Julia Sum result')
	print(d)
	
	#############Save bit#############
	#Now save as MATLAB matricies. 
	scipy.io.savemat('PythonOutput.mat', dict(a=a,b=b,c=c,d=d))
	
#if __name__ == "__main__":
#	script(1,2)
