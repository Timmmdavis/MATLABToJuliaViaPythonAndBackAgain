function SumArrays(X::Array,Y::Array)
Z=zeros(size(X));
for i=1:length(X)
	#Rotate to new axes Ax Ay Az
	Z[i]=X[i]+Y[i];
end
return(Z)
end