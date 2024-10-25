clear all, clearvars, close all

%checking the availability of parpool and creating one
if isempty(gcp('nocreate'))
    parpool()
end

%checking the number of workers available. 
workers_n = gcp().NumWorkers 

%defining the range 
a = 5, b = 5; %defining the values of X
c = 5, d = 5; %defining the values of Y

%Defining the functions to be integrated
fun = @(x, y) x.^5 + y.^5

%Defining the subdomain/ intervals 
x_intervals = linspace(a, b, workers_n + 1)
y_intervals = linspace(c, d, workers_n + 1)

%Assigning the workers to work on each part
tic;
spmd
    x_begin = x_intervals(labindex);
    x_end = x_intervals((labindex) + 1);
    y_begin = y_intervals (labindex);
    y_end = y_intervals((labindex) + 1);
    
    %Calulating the integral values of subdomain/ intervals.
    subdomain_integral = integral2(fun, x_begin, x_end, y_begin, y_end)
    
    %summing up the results from eachworker.
    total_value = gplus(subdomain_integral)

end
time_paral=toc;

%retrieving the result outside of the spmd block
integral_parll = total_value{2}
%Sequential integration

tic;
integral_seq=integral2(fun,a,b,c,d)
if integral_parll ==integral_seq
    disp 'Sequential and Parallel integrals values are equal'
end
time_seq=toc;

speedup=time_seq/time_paral
efficiency=speedup/workers_n*100

