

       
    simOut = sim('ControllerTest.slx', 0:0.001:meas.time(end), options.sim_options);
    
    tsim = simOut.get('tout');
    yout = simOut.get('yout');
    
    omega_e_sim = yout{1}.Values.Data;
    u_alpha_sim = yout{2}.Values.Data;
    du_ign_sim = yout{3}.Values.Data;
    omega_e_ref_sim = yout{4}.Values.Data;

    du_alpha_dt = abs(diff(u_alpha_sim));

    error = abs(omega_e_ref_sim - omega_e_sim);
    kmax = 1/(1 - k_eta * du_ign_nom^2);
    dt = 0.001;

    J =( 0.2 * kmax^2.5 * sum(error) * dt + (sum(du_alpha_dt)));

    disp("J = " + J);
    disp("-----------------------------")

    
    du_alpha_dt = abs(diff(meas.u_alpha.signals.values));

    error = abs(meas.omega_e_desired.signals.values - meas.omega_e.signals.values);
    kmax = 1/(1 - k_eta * du_ign_nom^2);
    dt = 0.001;

    J = (0.2 * (kmax^2.5) * sum(error) * dt + (sum(du_alpha_dt)));

    disp("J_real = " + J);
    disp("-----------------------------")
