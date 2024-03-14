%% Housekeeping
clearvars;
clc;

%% Collect data into arrays
% Read the data file for C1 100nA on Upsweep
fileName = "GRIDS_DIONE_CALIBRATION_12132022_1_A_100nA_U.xlsx";
rpaSheet = "RPA Data (arrays)";
rpaData = readmatrix(fileName, "Sheet", rpaSheet);
% Get the nA currents on all collectors
currentC1_nA = rpaData(:,7).*(10^9);
currentC2_nA = rpaData(:,8).*(10^9);
currentC3_nA = rpaData(:,9).*(10^9);
currentC4_nA = rpaData(:,10).*(10^9);
% Create time axis taxis
timestamps = rpaData(:,1);
numSeconds = 51;
tInterval = numSeconds/size(timestamps, 1);
t = [0:tInterval:numSeconds];
taxis = t(2:end);
% Calculate mean and standard deviation of currents on channel of interest: C1
meanC1Current = mean(currentC1_nA, 'all');
stdC1Current = std(currentC1_nA);

%% Create plots
% Plot histogram of C1 current w/ vertical bar for mean, +- one std dev
numbins = 500;
figure(1);
subplot(2,1,1);
histogram(currentC1_nA, numbins);
hold on;
meanLine = xline(meanC1Current, "-r", {"\mu", "= " + num2str(meanC1Current) + " nA"}, FontSize=15);
meanLine.LabelOrientation = "horizontal";
meanLine.FontWeight = 'bold';
meanLine.LineWidth = 2;
hold on;
plusOneStdDev = xline(meanC1Current + stdC1Current, "-b", {"\mu + \sigma", "= " + num2str(meanC1Current + stdC1Current) + " nA"}, FontSize=15);
plusOneStdDev.LabelOrientation = "horizontal";
plusOneStdDev.FontWeight = 'bold';
plusOneStdDev.LineWidth = 2;
hold on;
minusOneStdDev = xline(meanC1Current - stdC1Current, "-b", {"\mu - \sigma", "= " + num2str(meanC1Current - stdC1Current) + " nA"}, FontSize=15);
minusOneStdDev.LabelOrientation = "horizontal";
minusOneStdDev.FontWeight = 'bold';
minusOneStdDev.LineWidth = 2;
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
xlabel("Current (nA) on Collector A");
ylabel("Number of Measurements");
title("Distribution of Collector A Currents with 100 nA Stimulation");
subtitle("\mu = " + num2str(meanC1Current) + " nA, \sigma = " + num2str(stdC1Current) + " nA");
xlim([meanC1Current - 2*stdC1Current meanC1Current + 2*stdC1Current]);
hold off;
% Plot QQ for C1
subplot(2,1,2);
qqplot(currentC1_nA);
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
title("QQ Plot of Collector A Current with 100 nA Stimulation");
ylabel("Collector A current (nA)");
ylim([min(currentC1_nA) max(currentC1_nA)]);
hold off;
% Plot moving average of current levels on other channels
figure(2);
plot(taxis, movmean(currentC2_nA, (1/10)*size(currentC1_nA, 1)));
hold on;
plot(taxis, movmean(currentC3_nA, (1/10)*size(currentC1_nA, 1)));
hold on;
plot(taxis, movmean(currentC4_nA, (1/10)*size(currentC1_nA, 1)));
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
title("Moving Average of Collectors B, C, and D Currents for 100 nA Stimulation on Collector A");
subtitle("n = " + num2str((1/10)*size(currentC1_nA, 1)));
xlabel("Time (s)");
ylabel("Moving Average Current (nA)");
legend("Collector B Current", "Collector C Current", "Collector D Current");
xlim([0 numSeconds]);
hold off;

%% Generate Time-Average Offset Data
avg_offset_B = mean(currentC1_nA - currentC2_nA);
avg_offset_C = mean(currentC1_nA - currentC3_nA);
avg_offset_D = mean(currentC1_nA - currentC4_nA);

disp("Offsets for 1 nA on Coll. A: ");
disp(strcat("Collector B: ", string(avg_offset_B), " nA"));
disp(strcat("Collector C: ", string(avg_offset_C), " nA"));
disp(strcat("Collector D: ", string(avg_offset_D), " nA"));