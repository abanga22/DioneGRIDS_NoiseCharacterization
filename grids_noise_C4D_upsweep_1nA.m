%% Housekeeping
clearvars;
clc;

%% Collect data into arrays
% Read the data file for C4 1nA on Upsweep
fileName = "GRIDS_DIONE_CALIBRATION_12142022_4_D_1nA_U.xlsx";
rpaSheet = "RPA Data (arrays)";
rpaData = readmatrix(fileName, "Sheet", rpaSheet);
% Get the nA currents on all collectors
currentC1_nA = rpaData(:,7).*(10^9);
currentC2_nA = rpaData(:,8).*(10^9);
currentC3_nA = rpaData(:,9).*(10^9);
currentC4_nA = rpaData(:,10).*(10^9);
% Create time axis taxis
timestamps = rpaData(:,1);
numSeconds = 46;
tInterval = numSeconds/size(timestamps, 1);
t = [0:tInterval:numSeconds];
taxis = t(2:end);
% Calculate mean and standard deviation of currents on channel of interest: C4
meanC4Current = mean(currentC4_nA, 'all');
stdC4Current = std(currentC4_nA);

%% Create plots
% Plot histogram of C4 current w/ vertical bar for mean, +- one std dev
numbins = 500;
figure(1);
subplot(2,1,1);
histogram(currentC4_nA, numbins);
hold on;
meanLine = xline(meanC4Current, "-r", {"\mu", "= " + num2str(meanC4Current) + " nA"});
meanLine.LabelOrientation = "horizontal";
meanLine.FontWeight = 'bold';
hold on;
plusOneStdDev = xline(meanC4Current + stdC4Current, "-b", {"\mu + \sigma", "= " + num2str(meanC4Current + stdC4Current) + " nA"});
plusOneStdDev.LabelOrientation = "horizontal";
plusOneStdDev.FontWeight = 'bold';
hold on;
minusOneStdDev = xline(meanC4Current - stdC4Current, "-b", {"\mu - \sigma", "= " + num2str(meanC4Current - stdC4Current) + " nA"});
minusOneStdDev.LabelOrientation = "horizontal";
minusOneStdDev.FontWeight = 'bold';
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
xlabel("Current (nA) on Collector D");
ylabel("Number of Measurements");
title("Distribution of Collector D Currents with 1 nA Stimulation");
subtitle("\mu = " + num2str(meanC4Current) + " nA, \sigma = " + num2str(stdC4Current) + " nA");
xlim([meanC4Current - 2*stdC4Current meanC4Current + 2*stdC4Current]);
hold off;
% Plot QQ for C4
subplot(2,1,2);
qqplot(currentC4_nA);
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
title("QQ Plot of Collector D Current with 1 nA Stimulation");
ylabel("Collector D Current (nA)");
ylim([min(currentC4_nA) max(currentC4_nA)]);
hold off;
% Plot moving average of current levels on other channels
figure(2);
plot(taxis, movmean(currentC1_nA, (1/10)*size(currentC4_nA, 1)));
hold on;
plot(taxis, movmean(currentC2_nA, (1/10)*size(currentC4_nA, 1)));
hold on;
plot(taxis, movmean(currentC3_nA, (1/10)*size(currentC4_nA, 1)));
ax = gca;
ax.FontSize = 15;
grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'GridColor', 'k', 'MinorGridAlpha', 0.4, 'MinorGridLineStyle', '-', ...
         'MinorGridColor', [0.3,0.3,0.3], 'GridAlpha', 0.4, 'LineWidth', 1.2);
title("Moving Average of Collectors A, B, and C Currents for 1 nA Stimulation on Collector D");
subtitle("n = " + num2str((1/10)*size(currentC4_nA, 1)));
xlabel("Time (s)");
ylabel("Moving Average Current (nA)");
legend("Collector A Current", "Collector B Current", "Collector C Current");
xlim([0 numSeconds]);
hold off;

%% Generate Time-Average Offset Data
avg_offset_A = mean(currentC4_nA - currentC1_nA);
avg_offset_B = mean(currentC4_nA - currentC2_nA);
avg_offset_C = mean(currentC4_nA - currentC3_nA);

disp("Offsets for 1 nA on Coll. D: ");
disp(strcat("Collector A: ", string(avg_offset_A), " nA"));
disp(strcat("Collector B: ", string(avg_offset_B), " nA"));
disp(strcat("Collector C: ", string(avg_offset_C), " nA"));