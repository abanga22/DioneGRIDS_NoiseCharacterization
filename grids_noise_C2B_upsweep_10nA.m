%% Housekeeping
clearvars;
clc;

%% Collect data into arrays
% Read the data file for C2 10nA on Upsweep
fileName = "GRIDS_DIONE_CALIBRATION_12142022_2_B_10nA_U.xlsx";
rpaSheet = "RPA Data (arrays)";
rpaData = readmatrix(fileName, "Sheet", rpaSheet);
% Get the nA currents on all collectors
currentC1_nA = rpaData(:,7).*(10^9);
currentC2_nA = rpaData(:,8).*(10^9);
currentC3_nA = rpaData(:,9).*(10^9);
currentC4_nA = rpaData(:,10).*(10^9);
% Create time axis taxis
timestamps = rpaData(:,1);
numSeconds = 22;
tInterval = numSeconds/size(timestamps, 1);
t = [0:tInterval:numSeconds];
taxis = t(2:end);
% Calculate mean and standard deviation of currents on channel of interest: C2
meanC2Current = mean(currentC2_nA, 'all');
stdC2Current = std(currentC2_nA);

%% Create plots
% Plot histogram of C2 current w/ vertical bar for mean, +- one std dev
numbins = 500;
figure(1);
subplot(2,1,1);
histogram(currentC2_nA, numbins);
hold on;
meanLine = xline(meanC2Current, "-r", {"\mu", "= " + num2str(meanC2Current) + " nA"}, FontSize=15);
meanLine.LabelOrientation = "horizontal";
meanLine.FontWeight = 'bold';
hold on;
plusOneStdDev = xline(meanC2Current + stdC2Current, "-b", {"\mu + \sigma", "= " + num2str(meanC2Current + stdC2Current) + " nA"}, FontSize=15);
plusOneStdDev.LabelOrientation = "horizontal";
plusOneStdDev.FontWeight = 'bold';
hold on;
minusOneStdDev = xline(meanC2Current - stdC2Current, "-b", {"\mu - \sigma", "= " + num2str(meanC2Current - stdC2Current) + " nA"}, FontSize=15);
minusOneStdDev.LabelOrientation = "horizontal";
minusOneStdDev.FontWeight = 'bold';
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
xlabel("Current (nA) on Collector B", FontSize=20);
ylabel("Number of Measurements", FontSize=20);
title("Distribution of Collector B Currents with 10 nA Stimulation", FontSize=20);
subtitle("\mu = " + num2str(meanC2Current) + " nA, \sigma = " + num2str(stdC2Current) + " nA", FontSize=15);
xlim([meanC2Current - 2*stdC2Current meanC2Current + 2*stdC2Current]);
hold off;
% Plot QQ for C2
subplot(2,1,2);
qqplot(currentC2_nA);
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
title("QQ Plot of Collector B Current with 10 nA Stimulation", FontSize=20);
ylabel("Collector B current (nA)", FontSize=20);
xlabel("Standard Normal Quantities", FontSize=20);
ylim([min(currentC2_nA) max(currentC2_nA)]);
hold off;
% Plot moving average of current levels on other channels
figure(2);
plot(taxis, movmean(currentC1_nA, (1/10)*size(currentC2_nA, 1)));
hold on;
plot(taxis, movmean(currentC3_nA, (1/10)*size(currentC2_nA, 1)));
hold on;
plot(taxis, movmean(currentC4_nA, (1/10)*size(currentC2_nA, 1)));
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
title("Moving Average of Collectors A, C, and D Currents for 10 nA Stimulation on Collector B", FontSize=20);
subtitle("n = " + num2str((1/10)*size(currentC2_nA, 1)), FontSize=15);
xlabel("Time (s)", FontSize=20);
ylabel("Moving Average Current (nA)", FontSize=20);
legend("Collector A Current", "Collector C Current", "Collector D Current", FontSize=20);
xlim([0 numSeconds]);
hold off;

%% Generate Time-Average Offset Data
avg_offset_A = mean(currentC2_nA - currentC1_nA);
avg_offset_C = mean(currentC2_nA - currentC3_nA);
avg_offset_D = mean(currentC2_nA - currentC4_nA);

disp("Offsets for 1 nA on Coll. B: ");
disp(strcat("Collector A: ", string(avg_offset_A), " nA"));
disp(strcat("Collector C: ", string(avg_offset_C), " nA"));
disp(strcat("Collector D: ", string(avg_offset_D), " nA"));