%% Constants

R = 287;
Vd = 2.48e-3; % Displacement volume [m^3]
Vc = 2.48e-4; % Compression volume [m^4]
sigma0 = 14.67; % [-]
kappa = 1.35; % isentropic coefficient [-]
H_l = 42.5e6; % [Jkg^-1]
k_eta = 2.3345e-4; % [1(CA)^-2]
nu_gen = 0.7; % Generator efficiency
lambda = 1; % A/F ratio

%% Initial guess of parameters to be identified

alpha0 = 3e-6;
alpha1 = 6e-6;
Vm_guess = 7e-3;
gamma0 = 0.6;
gamma1 = 0.002;
nu0 = 0.3;
nu1 = -3e-4;
beta0 = 7;
theta_e = 0.2;


%% Initial conditions
initial_omega_e = meas.omega_e.signals.values(1);
initial_p_m = meas.p_m.signals.values(1);

