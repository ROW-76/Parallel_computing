clear; close all;   
%Series
time_span = [0 10];         
x0 = [0.5; 0];           
epsilon_values = 0.1;  

tic;
vdp = @(t, y) [y(2); 0.1 * (1 - y(1)^2) * y(2) - y(1)];
[t_serial, y_serial] = ode45(vdp, time_span, x0);
time_serial = toc; 
disp(['Time taken for serial execution: ', num2str(time_serial), ' seconds']);
 
%Plotting Series
figure; 
plot(t_serial, y_serial(:,1), '-k', 'linewidth', 2);
title('Serial Solution for \epsilon = 0.1'); xlabel('Time (t)'); ylabel('x(t)');
grid on; print('VanDerPol_Serial', '-dpng');

%Parallel
epsilon_values1 = linspace(0.01, 4, 5000);
if isempty(gcp()), parpool(); end
results_parallel = cell(length(epsilon_values1), 1);
tic; 
parfor i = 1:length(epsilon_values1)
    vdp = @(t, y) [y(2); epsilon_values1(i) * (1 - y(1)^2) * y(2) - y(1)];
    results_parallel{i} = ode45(vdp, time_span, x0);
end
parallel_time = toc; 
disp(['Parallel Execution Time: ', num2str(parallel_time), ' seconds']);

%Plotting parallel
epsilon_subset = [0.01, 0.9, 1.2, 2.7, 4.0];
colors = lines(length(epsilon_subset));
figure; 
hold on;
legend_entries = {};  % Store legend entries only for valid plots

for i = 1:length(epsilon_subset)
    idx = find(abs(epsilon_values1 - epsilon_subset(i)) < 1e-3, 1);
    if isempty(idx) || isempty(results_parallel{idx})
        warning('No valid result for epsilon = %.2f', epsilon_subset(i));
        continue;
    end
    y_values = results_parallel{idx}.y;
    plot(linspace(time_span(1), time_span(2), size(y_values, 2)), y_values(1, :), ...
        'Color', colors(i, :), 'linewidth', 2);
    legend_entries{end+1} = sprintf('\\epsilon = %.2f', epsilon_subset(i));  % Store valid entry
end

title('Parallel Solutions for Selected Epsilon Values'); 
xlabel('Time (t)'); ylabel('x(t)');
legend(legend_entries);  % Only add valid legend entries
grid on; print('VanDerPol_Parallel_5_Epsilons', '-dpng');

% Speedup and Efficiency
Speedup = time_serial / parallel_time
Efficiency = Speedup / gcp().NumWorkers * 100