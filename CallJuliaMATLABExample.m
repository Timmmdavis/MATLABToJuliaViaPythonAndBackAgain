%Create Arrays and convert to NumPy
clear

%Define MATLAB matricies
a=[[1,2,3,4];[0,0,0,0];[0,1,1,1];[0,0,0,0]];
b=[[1,2,3,4];[0,0,0,0];[0,1,1,1];[0,0,0,0]];

%Convert to Python mats; If you need floats/ ints etc use: "x=py.int(x);" or "x=py.float(x);"
[a,b] = ConvertMatriciesToNumPy(a,b);

%Run Python script
py.RunJulia.script(a,b);

%Clear results
clear

%Load Python results
load('PythonOutput.mat')