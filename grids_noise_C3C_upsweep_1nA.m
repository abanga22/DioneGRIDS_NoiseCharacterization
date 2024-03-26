%% Housekeeping
clearvars;
clc;

%% Collect data into arrays
% Read the data file for C3 1nA on Upsweep
fileName = "GRIDS_DIONE_CALIBRATION_12082022_3_C_1nA_U.xlsx";
rpaSheet = "RPA Data (arrays)";
rpaData = readmatrix(fileName, "Sheet", rpaSheet);
% Get the nA currents on all collectors
currentC1_nA = rpaData(:,7).*(10^9);
currentC2_nA = rpaData(:,8).*(10^9);
currentC3_nA = rpaData(:,9).*(10^9);
currentC4_nA = rpaData(:,10).*(10^9);
% Create time axis taxis
timestamps = rpaData(:,1);
numSeconds = 29;
tInterval = numSeconds/size(timestamps, 1);
t = [0:tInterval:numSeconds];
taxis = t(2:end);
% Calculate mean and standard deviation of currents on channel of interest: C3
meanC3Current = mean(currentC3_nA, 'all');
stdC3Current = std(currentC3_nA);

%% Create plots
% Plot histogram of C3 current w/ vertical bar for mean, +- one std dev
numbins = 500;
figure(1);
subplot(2,1,1);
histogram(currentC3_nA, numbins);
hold on;
meanLine = xline(meanC3Current, "-r", {"\mu", "= " + num2str(meanC3Current) + " nA"}, FontSize=15);
meanLine.LabelOrientation = "horizontal";
meanLine.FontWeight = 'bold';
meanLine.LineWidth = 2;
hold on;
plusOneStdDev = xline(meanC3Current + stdC3Current, "-b", {"\mu + \sigma", "= " + num2str(meanC3Current + stdC3Current) + " nA"}, FontSize=15);
plusOneStdDev.LabelOrientation = "horizontal";
plusOneStdDev.FontWeight = 'bold';
plusOneStdDev.LineWidth = 2;
hold on;
minusOneStdDev = xline(meanC3Current - stdC3Current, "-b", {"\mu - \sigma", "= " + num2str(meanC3Current - stdC3Current) + " nA"}, FontSize=15);
minusOneStdDev.LabelOrientation = "horizontal";
minusOneStdDev.FontWeight = 'bold';
minusOneStdDev.LineWidth = 2;
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
xlabel("Current (nA) on Collector C");
ylabel("Number of Measurements");
title("Distribution of Collector C Currents with 1 nA Stimulation");
subtitle("\mu = " + num2str(meanC3Current) + " nA, \sigma = " + num2str(stdC3Current) + " nA");
xlim([meanC3Current - 2*stdC3Current meanC3Current + 2*stdC3Current]);
hold off;
% Plot QQ for C3
subplot(2,1,2);
qqplot(currentC3_nA);
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
title("QQ Plot of Collector C Current with 1 nA Stimulation");
ylabel("Collector C Current (nA)");
ylim([min(currentC3_nA) max(currentC3_nA)]);
hold off;
% Plot moving average of current levels on other channels
figure(2);
plot(taxis, movmean(currentC1_nA, (1/10)*size(currentC3_nA, 1)), "LineWidth", 2);
hold on;
plot(taxis, movmean(currentC2_nA, (1/10)*size(currentC3_nA, 1)), "LineWidth", 2);
hold on;
plot(taxis, movmean(currentC4_nA, (1/10)*size(currentC3_nA, 1)), "LineWidth", 2);
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
title("Moving Average of Collectors A, B, and D Currents for 1 nA Stimulation on Collector C");
subtitle("n = " + num2str((1/10)*size(currentC3_nA, 1)));
xlabel("Time (s)");
ylabel("Moving Average Current (nA)");
legend("Collector A Current", "Collector B Current", "Collector D Current");
xlim([0 numSeconds]);
hold off;

%% Generate Time-Average Offset Data
avg_A = mean(currentC1_nA);
avg_B = mean(currentC2_nA);
avg_D = mean(currentC4_nA);

disp("Unstimulated collector currents for 1 nA on Coll. C: ");
disp(strcat("Collector A: ", string(avg_A), " nA"));
disp(strcat("Collector B: ", string(avg_B), " nA"));
disp(strcat("Collector D: ", string(avg_D), " nA"));