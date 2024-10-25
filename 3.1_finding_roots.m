clear all; close all; % Start fresh

%Organizing Inputs%
f = @(x) sin(3*pi*cos(2*pi*x).*sin(pi*x));
a = -3; b = 5; n = 4^9;
x0 = linspace(a,b,n); % Vector containing initial starting points
q = zeros(size(x0)); % Preallocate a vector for storing roots.

%Calculating the time consumed using sequential processing
tic
for i=1:n
    q(i) = fzero(f,x0(i));
end
t_sequential = toc

%Processing Outputs%
q1 = unique(q); % keep roots with unique values only.

%Calculating using parallel / Initiating the parpool 
if isempty(gcp())
    parpool();
end

n_workers = gcp().NumWorkers 

%Calculating the time using parallel processing
tic
parfor i=1:n
    q(i) = fzero(f,x0(i));
end
t_parallel = toc

%Processing Outputs%
q2 = unique(q); % keep roots with unique values only.

%Calculating the speedup 
S_P = t_sequential/ t_parallel

%Calculating the effeciency 
E_F = (S_P/ n_workers) * 100 