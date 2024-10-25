close all, clearvars, clc % Start fresh 

function timeconsumingfun
random = randi ([1,5]);
pause(random)
end

n = input('itration =');

tic
timeconsumingfun
toc

tic
for i = 1:n
    timeconsumingfun
end
t_sequential = toc 

if isempty(gcp())
    parpool();
end

tic
parfor i=1:n
    timeconsumingfun
end
t_parallel = toc

%calculating the speed up 
S_P = t_sequential/ t_parallel

%Calculating the effeciency 
E_F = (S_P/ gcp(). NumWorkers) * 100




