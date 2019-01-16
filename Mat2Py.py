import numpy as np

def Mat2PyFunc(Vector,Size):
	#Convert Size to int (used for reshaping)
	Size=Size.astype(int)
    #Reshape the vector to a matrix
	Vector=np.reshape(Vector,(Size[0],Size[1])) 
	return Vector;