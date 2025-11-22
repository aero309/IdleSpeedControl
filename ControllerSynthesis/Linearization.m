
u_alpha_nom = 2;

p_m_nom = 23519.6; 
omega_e_nom = 100.43; 

p_m_initial = p_m_nom;
omega_e_initial = omega_e_nom;

ratio_nom = 30.1967e-6;
du_ign_nom = -25;

pade_order = 4;

tau_IPS_nom = 2 * pi / (omega_e_nom );
tau_seg_nom = 4 * pi / (5 * omega_e_nom);

fprintf('Nominal delays: tau_IPS = %.4f s, tau_seg = %.4f s\n', tau_IPS_nom, tau_seg_nom);

[num_IPS, den_IPS] = pade(tau_IPS_nom, pade_order);
[num_seg, den_seg] = pade(tau_seg_nom/2, pade_order);

[A_pade_IPS, B_pade_IPS, C_pade_IPS, D_pade_IPS] = tf2ss(num_IPS, den_IPS);
[A_pade_seg, B_pade_seg, C_pade_seg, D_pade_seg] = tf2ss(num_seg, den_seg);

fprintf('Pade matrix sizes:\n');
fprintf('A_pade_IPS: %dx%d, B_pade_IPS: %dx%d\n', size(A_pade_IPS), size(B_pade_IPS));
fprintf('A_pade_seg: %dx%d, B_pade_seg: %dx%d\n', size(A_pade_seg), size(B_pade_seg));



assignin('base', 'A_pade_IPS', A_pade_IPS);
assignin('base', 'B_pade_IPS', B_pade_IPS);
assignin('base', 'C_pade_IPS', C_pade_IPS);
assignin('base', 'D_pade_IPS', D_pade_IPS);
assignin('base', 'A_pade_seg', A_pade_seg);
assignin('base', 'B_pade_seg', B_pade_seg);
assignin('base', 'C_pade_seg', C_pade_seg);
assignin('base', 'D_pade_seg', D_pade_seg);

[A_lin, B_lin, C_lin, D_lin] = linmod('NonLinearModelNorm', [1, 1, (-inv(A_pade_IPS)*B_pade_IPS)', (-inv(A_pade_seg)*B_pade_seg)'], ones(1,2));

sys_linear = ss(A_lin, B_lin, C_lin, D_lin);
save('LinearizedModel.mat', 'A_lin', 'B_lin', 'C_lin', 'D_lin', 'sys_linear');


fprintf('System order: %d states\n', size(A_lin, 1));


%%
load("..\TAData\quasistatic_0001.mat")
% Run a simulation with the identified optimal variable values
    simOut = sim('NonLinearModelNoPade.slx', 0:0.001:60, options.sim_options);
    simOutLinear = sim('LinearizedModel.slx', 0:0.001:60, options.sim_options);


    omega_e_sim = simOut.get('yout');
    tsim = simOut.get('tout');
    omega_e_sim_values = omega_e_sim{1}.Values.Data;

    omega_e_sim_lin = simOutLinear.get('yout');
    tsim_linear = simOutLinear.get('tout');
    omega_e_sim_lin_values = omega_e_sim_lin{1}.Values.Data;

% Graphically represent the quality of the optimization routine
    figure;
    plot(tsim, omega_e_sim_values, tsim_linear, omega_e_sim_lin_values);
        xlabel('Time [s]');
        ylabel('Outputs');
        legend('Nonlinear speed','Linear Speed')
    title("Validation of the Linear model")