# MATLABToJuliaViaPythonAndBackAgain...
A repo showing an example of how to call Julia from MATLAB and read the results. 

Tested using:  
Windows 10:  
Julia 1.0.3  
	TravisTest v0.1.0 -> [a9463a40]  
	PyCall v1.18.5 -> [438e738f]  
Python 3.7.2  
	numpy==1.16.0  
	scipy==1.2.0  
	matplotlib==3.0.2  
	ipython==7.2.0  
	jupyter==1.0.0  
	panda==0.3.1  
	julia==0.2.0  
MATLAB R2018a  
On The 16th January 2019.  

## Workflow
MATLAB calls
Python calls
Julia sends data back to
Python which writes results as a .mat file
MATLAB then loads the .mat file 

This workflow has some overhead due to:
Converting MATs to Python arrays
PyCall running Julia
Writing and reading the Julia results as .mat files in Python. 
This overhead is small if your code is repeatadly called, runs for long times and Julia is 100x faster that MATLAB would be... :)


## Installing PyCall etc windows:

Install Julia 1.0.3 64 bit (https://julialang.org/downloads/)
Make sure you can call from cmd.exe, i.e. 
```
> julia.exe 
```
runs it. Do this by setting the julia.exe dir as a path enviroment variable. 

Install Python Windows 64-x86 (https://www.python.org/downloads/release/python-372/). 
Again make sure its callable from cmd, i.e. 
```
> python 
```
Install the correct packages from cmd:
```
> python -m pip install --user numpy scipy matplotlib ipython jupyter panda
```
find the path to your python installation in cmd
```
> python -c "import sys; print('\n'.join(sys.path))"
```
This should be something like:
C:\\Users\\UserName\\AppData\\Local\\Programs\\Python\\Python37\\python.exe

Open julia and call 
```
julia> ] add PyCall
julia> ENV["PYTHON"]=PATH2PYTHON
```
where PATH2PYTHON is something like (make sure this is in quotes) :
"C:\\Users\\UserName\\AppData\\Local\\Programs\\Python\\Python37\\python.exe"
note on Windows you may need to use:  
julia> ENV["PYTHON"]=raw"C:\\Users\\UserName\\AppData\\Local\\Programs\\Python\\Python37\\python.exe"  
if you are getting the 'invalid escape sequence' error  
then in julia use  
```
julia> ] build PyCall
```
check this is correct by closing and opening Julia then calling
```
julia> using PyCall 
julia> PyCall.pyprogramname
```
The output should match your python directory (not some path to Conda)

Now in cmd call - 
```
> python -m pip install julia
```

Now:
In cmd call python
```
> python
```
In Python call (assuming you have already installed TravisTest Package in Julia)
```
>>> import julia
>>> j = julia.Julia()
>>> from julia import Base
>>> Base.sind(90)
>>> from julia import TravisTest #https://github.com/Timmmdavis/JuliaTravisTest
>>> TravisTest.MrsFunc(2)
```
The result:
1.0


## MATLAB 2 Python 2 Julia
Now download this Repo, unzip and and in MATLAB go to this path (and add to Path). 
In MATLAB terminal call:
```
>> pyversion
```
This should output your version of Python. This must match the one PyCall in Julia uses. 

In MATLAB terminal call:
```
CallJuliaMATLABexample
```
The MATLAB terminal output should be:
```
NumPy Sum result
[[2. 4. 6. 8.]
 [0. 0. 0. 0.]
 [0. 2. 2. 2.]
 [0. 0. 0. 0.]]
Julia Sum result
[[2. 4. 6. 8.]
 [0. 0. 0. 0.]
 [0. 2. 2. 2.]
 [0. 0. 0. 0.]]
```
and 4 matricies should load in your workspace (your inputs and outputs c and d). 

The function ConvertMatriciesToNumPy converts MATLAB matricies to the right format for Python (see documentation in func). 
The function py.RunJulia.script(a,b); does the work (runJulia.py). Note how simple the script is.   

Note that if you wrap the line d=j.SumArrays(a,b) in RunJulia.py with
```
	t = time.time() #Start timing
	d=j.SumArrays(a,b)
	elapsed = time.time() - t #Finish timing
	print(elapsed)
```
You see the time reduces on the 2nd call. I.e. Julia has compiled and will do for the rest of the MATLAB session. 
Comparing this speed to Julia the overhead is presumably due to PyCall. 

An example using imported modules in Julia, for example if you have added #https://github.com/Timmmdavis/JuliaTravisTest in Julia. You could use in the Python script: 
```
	j = julia.Julia()
	from julia import TravisTest
	Half=TravisTest.MrsFunc(2.);
	print(Half)
```

Dont edit the Python scripts in MATLAB as its tab/space adding is rubbish. Notepad++ or another Py editor is better. 
If you do you will get errors in MATLABs terminal such as: 
```
>> CallJuliaMATLABExample
Undefined variable "py" or class "py.RunJulia.script".

Error in CallJuliaMATLABExample (line 12)
py.RunJulia.script(a,b);
```
