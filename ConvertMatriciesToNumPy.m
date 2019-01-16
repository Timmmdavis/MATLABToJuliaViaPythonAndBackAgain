function [varargout] = ConvertMatriciesToNumPy(varargin)
%ConvertMatriciesToNumPy Assuming the input matricies are the same shape.
%   Pass in MATLAB matricies and this will convert these to Numpy format
%   with the right shape and size. Requires a linked working version of
%   Python in your MATLAB build. 

%Assign correct size (Make sure you have the same number of input args as
%outputs).
varargout=varargin;

%Convert to Python (Need to be vectors to convert)
Size=size(varargin{1}); %Get size for reshaping in python
Size = py.numpy.array(Size);

InputsSize=numel(varargin);
for i=1:InputsSize
    %Assign 2 temp array
    temp=varargin{i};
    %Transpose
    temp=temp';
    %Make a vector (MATLAB requires these are vectors before conversion. 
    temp = py.numpy.array(temp(:).');
    %Call Python function that reshapes the matricies
    temp=py.Mat2Py.Mat2PyFunc(temp,Size);
    %Assign arg to outputs 
    varargout{i}=temp;
end

end

