clear; close all;
warning off;

% Sample Time [s]
Ts = 5;

% Time
time = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24]';
H = 24 * 60 * 60;

%%% Greenhouse Modules Data

% Number of Modules
N = 3;

% Base Dimension of each Module [m]
B = zeros(N, 1);
b = zeros(N, 1);

B(1) = 50;
b(1) = 10;

B(2) = 10;
b(2) = 10;

B(3) = 10;
b(3) = 10;

% Height of each Module [m]
h = zeros(N, 1);
h(1) = 3;
h(2) = 4;
h(3) = 4;

% Surface Areas [m^2]
S = B .* b;

% Surface Areas between Modules [m^2]
Sm = zeros(N, N);
Sm(1, 2) = B(2) * h(1);
Sm(1, 3) = b(3) * h(1);
%Sm(2, 3) = 0;
Sm = Sm + triu(Sm, 1)'; % Mirror the values ​​to make the matrix symmetrical

% Total (Exposed) Surface Area of each Module [m^2]
St = S + 2 * (B .* h + b .* h);
for i = 1:N
    St = St - Sm(:, i);
end

% Volumes [m^3]
V = S .* h;

% Min/Max Heat Pump (Electric!) Power [W]
Max_q = zeros(N, 1);
Min_q = zeros(N, 1);

Max_q(1) = 25000;
Min_q(1) = -Max_q(1);

Max_q(2) = 10000;
Min_q(2) = -Max_q(2);

Max_q(3) = 10000;
Min_q(3) = -Max_q(3);

% Conversion to Min/Max Heat Pump Thermal Power [W]
% Note: usually the COP (Coefficient Of Performance) is around 3.5-4.0
COP = 4;
Max_q = Max_q * COP;
Min_q = Min_q * COP;

% Max error tollerance (1: External, 2: Internal)
vec_eps = zeros(N, 3);
% 2 Relays
vec_eps(1, 1) = 0.4; % Switch ON first relay M1
vec_eps(2, 1) = 0.2; % Switch ON first relay M2
vec_eps(3, 1) = 0.2; % Switch ON first relay M3
vec_eps(1, 2) = 0.3; % Switch OFF second relay M1
vec_eps(2, 2) = 0.1; % Switch OFF second relay M2
vec_eps(3, 2) = 0.1; % Switch OFF second relay M3
% 1 Relay
vec_eps(1, 3) = 0.25; % Switch ON/OFF relay M1
vec_eps(2, 3) = 0.2; % Switch ON/OFF relay M2
vec_eps(3, 3) = 0.2; % Switch ON/OFF relay M3

% Optimal Relay Control
rel_perc = zeros(N, 2);
rel_perc(:, 1) = [0.93; 0.6; 0.6]; % 2 Relays
rel_perc(:, 2) = [0.95; 0.7; 0.7]; % 1 Relay
q_star_p = Max_q .* rel_perc;
q_star_n = Min_q .* rel_perc;

%%% Temperature and Solar Radiation Data

% Outside Temperature [C]->[K]
% Note: 22 April 2024 data
Ta = [10 10 9 9 8 8 8 7 7 7 7 8 8 8 9 9 9 8 8 8 8 8 8 8 8] + 273.15;
tsTa = timeseries(Ta, time.*(60*60)');

% Sun Radiation Temperature [W/m^2]
% Note: 22 April 2024 data
Tr = [0 0 0 0 0 0 0 5 44 101 175 283 290 269 341 378 404 229 166 40 1 0 0 0 0];
tsTr = timeseries(Tr, time.*(60*60)');

% Desired Temperature for each Module [C]->[K]
Tc = zeros(N, 25);
Tc(1, :) = [20 20 20 20 20 20 20 20 20 20 25 25 30 30 30 30 30 30 24 23 22 22 20 20 20]' + 273.15;
Tc(2, :) = [20 20 20 20 20 20 20 20 20 20 18 18 25 25 25 23 24 24 18 18 15 14 20 20 20]' + 273.15;
Tc(3, :) = [20 20 20 20 20 20 20 20 20 20 18 18 25 25 25 23 24 24 18 18 15 14 20 20 20]' + 273.15;

% Initial Temperature of each Module [K]
Ti = Tc(:, 1);

% Timeseries of each Module
% Note: vector and cell cannot be used because they are not easily compatible with Simulink demux
tsTc1 = timeseries(Tc(1, :), time.*(60*60)');
tsTc2 = timeseries(Tc(2, :), time.*(60*60)');
tsTc3 = timeseries(Tc(3, :), time.*(60*60)');

%%% System Modules Data

% (Average) Thermal Transmittance [W/(m^2*K)]
AvgK = 5.7;

% Overall Thermal Transmittance [W/K]
Kf = AvgK * (diag(St) + Sm);

% Air Mass of each Module [kg]
mf = 1.225 * V;

% Average Thermal Capacity of the Air of each Module [J/K]
Cf = 1003.5 * mf;

% Perceived Surface Area of each Module for Solar Radiation [m^2]
Sp = [0.95; 0.95; 0.95] .* S;