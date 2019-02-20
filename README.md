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

### Two options
These files allow for two options:
1. Using PyCall, this requires python hooked up to MATLAB correctly but does less reading and writing of data passed to Julia. 
2. Using a precompiled image, this requires that your module can precompile with Julias 'PackageCompiler' and that the test scripts in this module use the same function input types as will be passed with MATLAB. 

### Workflow 1
MATLAB calls Python, Data is written into the Python format and stored on disk
Python calls Julia and sends data over directly without writing data
Julia runs and sends the resulting data back to Python without writing the data
Python which writes results as a .mat file
MATLAB then loads the .mat file 

This workflow has some overhead due to:
Converting MATs to Python arrays
PyCall running Julia
Writing and reading the Julia results as .mat files in Python. 
This overhead is small if your code is repeatadly called, runs for long times and Julia is 100x faster that MATLAB would be... :)

### Workflow 2
MATLAB calls Julia precomplied image, Data is written in .mat format.
Julia Image loads the data, runs and writes the resulting data in .mat format
MATLAB then loads the .mat file (result)

This workflow has some overhead due to:
Opening a new Julia session each call
Writing the MAT arrays in MATLAB
Reading and writing the MAT arrays in Julia, note that precompiling the module MAT is not possible (20/2/2019) as the tests error. This means each call its recompiling (but doesnt take long). Pass small files through this first if its very slow.  
As with PyCall there is some overhead (larger than using PyCall) but this is is still small if your code is repeatadly called and has long run times.

## Workflow 1: Installing PyCall etc windows:
Note that PyCall can just be build normally (defualt settings) if you dont mind that MATLAB will not have error reporting from your python scripts. 
In this case you will need to be able to call python from the cmd/terminal of your machine using the cmd 'python'.

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
```
julia> ENV["PYTHON"]=raw"C:\Users\UserName\AppData\Local\Programs\Python\Python37\python.exe"  
```
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


### MATLAB 2 Python 2 Julia
Now download this Repo, unzip and and in MATLAB go to this path (and add to Path). 
In MATLAB terminal call:
```
>> pyversion
```
This should output your version of Python. This must match the one PyCall in Julia uses. 
If this doesnt work I have added work around through the system command but there will be no python outputs in the MATLAB console. 
Note some comments below assume you have MATLAB hooked up to python correctly.

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
Comparing this speed to Julia the overhead is presumably due to PyCall. If you get errors make sure you are inside this scripts folder when running the script in MATLAB.

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
>> CallJuliaMATLABWithPyCallExample
Undefined variable "py" or class "py.RunJulia.script".

Error in CallJuliaMATLABWithPyCallExample (line 12)
py.RunJulia.script(a,b);
```

## Workflow 2: Precompiling Julia and calling from MATLAB
#Open julia 1.1.0 with admin rights.
```
julia> ] add TravisTest
julia> ] dev PackageCompiler
julia> using PackageCompiler
julia> new_image,old_image=PackageCompiler.compile_package("TravisTest", force = false)
```
note if there are errors use 
```
julia> revert()
```
Write down the resulting location of the sys.dll that is printed to the console. e.g.
```
"C:\\Users\\user\\.julia\\dev\\PackageCompiler\\sysimg\\sys.dll"
```
Now in the MATLAB script CallJuliaMATLABExampleWithPrecompImage.m change the variable new_image to this file path.
Change the variable exeloc to the path of the julia executable. 
Then run the script. It should give a result. 

### Installing/Running on a server (No sudo access)
Installing on a server (amd-64 Linux Redhat, CentOS release 6.7 (Final))
Julia-1.0.2
Matlab 2015a
Python-3.6.1

Download Julia and put onto server 
To run Julia go to the containing folders /julia-x.x.x/bin and call
```
$ ./julia
```
to exit julia (and python later) call Cntl+d

Now install Python, for me I ran into this issue 
https://bugs.python.org/issue27979
so downloaded the Gzipped source tarball from 
https://www.python.org/downloads/release/python-361/
place on the server and extract:
```
$ tar -xvzf Python-3.6.1.tgz 
```
to build go into the containing folder /Python-x.x.x and call
```
$ ./configure
$ make
```
now to install pip  without rights access download get-pip.py from https://pip.pypa.io/en/stable/installing/
paste this into your python dir and install
``` 
cp get-pip.py Python-3.6.1
$ ./python get-pip.py --user
$ ./python -m pip install julia numpy scipy matplotlib ipython jupyter panda --user
```
you should get some path warnings as you have added this locally. Note the path and add this. 
https://serverfault.com/questions/102932/adding-a-directory-to-path-in-centos#303824
https://serverfault.com/questions/102932/adding-a-directory-to-path-in-centos


in Julia
```
julia> ]add PyCall
] build PyCall
```
Check it built. 
```
julia> using PyCall 
julia> PyCall.pyprogramname
```

Now we add Julia to the path, you will need to do this line each time you log onto the server (or add to your path permanently)
```
$ export PATH=/home/user/julia-1.0.2/bin/:$PATH
```
check it worked
```
$ printenv PATH
```
make sure you do this outside the MATLAB console
to add permanently create a new file in home dir
```
$ vi .profile
```
add to file (top line)
```
export PATH=/home/user/julia-1.0.2/bin/:$PATH
```
save logout and in. 

in /home/user/.local/bin #The julia PyCall dir that was added to the path. If we had admin rights it would be in /usr/bin change the top line of this to point to your installed local PyDir with Python built and Julia module installed
```
$ vi python-jl 
```
top line to:
```
#!/home/user/Python-3.6.1/python
```
the following cmd should work (show the julia banner)
```
$ ./python-jl -c 'from julia.Base import banner; banner()'
```
copy this file over to the folder containing the files of, I called the folder MATLAB2Julia
https://github.com/Timmmdavis/MATLABToJuliaViaPythonAndBackAgain...
using 
```
cp python-jl /home/user/MATLAB2Julia/python-jl
```

and the run CallJuliaMATLABExampleWithPyCall but change the line:
```
system('python -c "from RunJuliaWithLoadVars import script; script()" >> Log.txt 2>&1') 
```
to
```
system('/home/user/MATLAB2Julia/python-jl RunJuliaWithLoadVars.py >> Log.txt 2>&1')
```
This should run

Assuming we have https://github.com/Timmmdavis/JuliaTravisTest installed in julia. 
If you have MATLAB running and want to do a "vi" command to edit the file put a ! infront. E.g. >> !vi CallJuliaMATLABWithPyCallExample.m
If you get errors check the Log.txt
exit MATLAB with >> exit
