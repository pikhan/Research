%simulations
function sim = mySimulations()
%First, let us generate a uniformly distributed random time series
%time_series = rand(1,1000); % a time series of 100 uniformly distributed random numbers
% Generate Brownian time series
%n = 1000; % number of data points
%increments = randn(1, n); % random increments from a normal distribution
%time_series = cumsum(increments); % Brownian time series
% Generate Fractal (fBm) time series
%H = 0.7; % Hurst exponent (controls fractal behavior)
%n = 1000; % number of data points
%time_series = wfbm(H, n); % Fractional Brownian Motion fBm time series
% Generate time series with a linear trend
%n = 1000; % number of data points
%t = 1:n;
%slope = 0.1; % slope of the linear trend
%intercept = 0.5; % intercept of the linear trend
%linear_trend = slope * t + intercept;
%noise = 0.1 * randn(1, n); % random noise
%time_series = linear_trend + noise; % time series with a linear trend
% Parameters for Lorenz attractor
%sigma = 10;
%beta = 8/3;
%rho = 28;

% Initial conditions
%x0 = 0.1;
%y0 = 0;
%z0 = 20;

% Time steps
%dt = 0.01;
%tspan = 0:dt:10;

% Lorenz attractor equations (dx/dt, dy/dt, dz/dt)
%lorenz_eqns = @(t, Y) [sigma * (Y(2) - Y(1));
%                      Y(1) * (rho - Y(3)) - Y(2);
%                      Y(1) * Y(2) - beta * Y(3)];

% Solve differential equations using ODE45 solver
%[t, Y] = ode45(lorenz_eqns, tspan, [x0; y0; z0]);

% Simulate data by extracting values of x, y, z from Y
%data_lorenz = Y(:, 1);
%time_series = data_lorenz;
%disp("length");
%disp(length(time_series));

levelSetTree = level_set_tree(time_series,[1:1000],0); %our level set tree, code from Zoe Haskell's Ph.D thesis

% Find the indices where the list has the value 0
root_index = find(levelSetTree == 0);
lvlTreeParentPointer = reorder_parent_pointer(levelSetTree, root_index);
lvlTree = tree(lvlTreeParentPointer);
%let's plot the level set tree
%figure();
treeplot(levelSetTree);
figure();
%lvlTree.plot;
%compute some simulations
treelayout = calc_circular_layout(lvlTree,1,120,300,0.75,1);
layout = calc_dual_layout(lvlTree,treelayout,1);
[degree_sequence, unique_degrees, degree_distribution, mean_deg, mean_deg_n] = compute_degrees(layout);
disp("The degree sequence: ");
%disp(degree_sequence);
disp("The unique degrees: ");
%disp(unique_degrees);
disp("The degree dist");
disp(degree_distribution);
disp("the mean degree");
disp(mean_deg);
disp("the mean deg n");
%disp(mean_deg_n);
figure();
plot(mean_deg_n);
title('Mean Degree as a Function of N')
adj = layout_to_adj(layout);
[dist, apl] = floyd_warshall(adj);
disp("the apl:");
disp(apl);
mean_path_length_n = compute_mean_path_length_n(dist);
disp("the mean path length n");
%disp(mean_path_length_n);
mean_path_length_n(isnan(mean_path_length_n))=0;
figure();
plot(mean_path_length_n);
title('The Mean Path Length as a Function of N');
[clustering_coefficients, mean_clustering_coefficient] = compute_clustering_coefficient(adj);
disp("the clustering coefficients:");
%disp(clustering_coefficients);
figure();
plot(clustering_coefficients);
title('Clustering Coefficients in Order of Vertices');
disp("the mean clustering coefficient");
disp(mean_clustering_coefficient);
sim = 1;
