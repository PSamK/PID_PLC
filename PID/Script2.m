% clear;
%close all;
warning off;

% Import Variables
e = out.e.Data;
q = out.q.Data;

% Quadratic Deviation from the Desired Temperature in a Day
if size(e, 3) > 1 % Necessary condition because of a simulink bug
    Qd = std(e, 0, 3).^2;
else
    Qd = std(e).^2;
end

% Energy Consumption in a Day [W/d]
%E = trapz(abs(q)) * Ts / (H * COP);
E = sum(abs(q)) * Ts / (H * COP);

% Energy Consumption in a Day [€/d]
% Note: Cost kWh [€/kWh] of 23 April 2024
CostW = 0.12209;
CostE = E * 24 * CostW / 1000;

% Print all Data

figure;
subplot(3, 1, 1);
bar(1:N, Qd); % Bar Graph

xlabel('Module'); ylabel('Quadratic Deviation');
grid on;
ylim([0, max(Qd) * 1.5]);

for i = 1:N
    text(i, Qd(i), sprintf('%3.2f', Qd(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

subplot(3, 1, 2);
bar(1:N, E); % Bar Graph

xlabel('Module'); ylabel('Energy Consumption [W/d]');
grid on;
ylim([0, max(E) * 1.5]);

for i = 1:N
    text(i, E(i), sprintf('%.2e', E(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

subplot(3, 1, 3);
bar(1:N, CostE); % Bar Graph

xlabel('Module'); ylabel('Energy Cost [€/d]');
grid on;
ylim([0, max(CostE) * 1.5]);

for i = 1:N
    text(i, CostE(i), sprintf('%3.2f', CostE(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end