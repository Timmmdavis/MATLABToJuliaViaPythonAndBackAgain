%Requires that you have used package compiler and precompiled the functions
%you need (with correct input types) before running this script. Slower
%than Pycall as you need to read and write all data to and from MATLAB and
%require julia startup EACH time its called. Reduces the dependancies though. 


clear

%Define MATLAB matricies
a=2;
save('Matricies.mat','a')

%Run Julia script (with precomp image)
exeloc='C:\Users\user\AppData\Local\Julia-1.1.0\bin\julia.exe';
new_image='C:\\Users\\user\\.julia\\dev\\PackageCompiler\\sysimg\\sys.dll';
str=[exeloc,' --startup-file=no --quiet -J ',new_image,' JuliaCallFromMATLAB.jl >> Log.txt 2>&1'];
%To prove that the precompile has worked, call this and spot longer run 
%times in the output Log.txt file:
%str=[exeloc,' JuliaCallFromMATLAB.jl >> Log.txt 2>&1'];

tic
system(str) 
toc
%Remove temp matricies
delete Matricies.mat

%Clear results
clear

%Load Python results
load('JuliaOutput.mat')

% %Remove temp matrix
delete JuliaOutput.mat
