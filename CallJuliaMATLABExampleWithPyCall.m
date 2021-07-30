%Create Arrays and convert to NumPy
clear

%Define MATLAB matricies
a=[[1,2,3,4];[0,0,0,0];[0,1,1,1];[0,0,0,0]];
b=[[1,2,3,4];[0,0,0,0];[0,1,1,1];[0,0,0,0]];
a=1; disp('first get this working, then try with matricies above...')
b=2;

%Convert to Python mats; If you need floats/ ints etc use: "x=py.int(x);" or "x=py.float(x);"
[a,b] = ConvertMatriciesToNumPy(a,b);

%Run Python script
try 
    %If python is hooked up to MATLAB
	if numel(a)==1
		py.RunJulia.script(a,b);
	else
		py.RunJuliaWithLoadVars.script;
	end
catch
    disp('Python not loaded correctly with MATLAB')
    %Calling system command instead. You wont get good outputs in the
    %console with this. This also requires julia to compile EVERY time, if
    %you cannot hook up PyCall try using
    %'CallJuliaMATLABExampleWithPrecompImage.m'
    tic
    system('python RunJuliaWithLoadVars.py >> Log.txt 2>&1') 
    toc
    %Remove temp matricies
    delete a.npy b.npy
end

%Clear results
clear

%Load Python results
load('PythonOutput.mat')

%Remove temp matrix
delete PythonOutput.mat
