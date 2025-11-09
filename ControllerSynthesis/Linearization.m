function Linearization()
    u_alpha_nom = 2;
    Delta_u_zeta_nom = -25;

    p_m_nom = 23000; 
    omega_e_nom = 128; 
    
    p_m_initial = p_m_nom;
    omega_e_initial = omega_e_nom;
        
    pade_order = 4;
    
    tau_IPS_nom = 2 * pi / omega_e_nom;
    tau_seg_nom = 4 * pi / (5 * omega_e_nom);
    
    fprintf('Nominal delays: tau_IPS = %.4f s, tau_seg = %.4f s\n', tau_IPS_nom, tau_seg_nom);
    
    [num_IPS, den_IPS] = pade(tau_IPS_nom, pade_order);
    [num_seg, den_seg] = pade(tau_seg_nom, pade_order);
    
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
    
    [A_lin, B_lin, C_lin, D_lin] = linmod('NonLinearModelNorm');
    
    sys_linear = ss(A_lin, B_lin, C_lin, D_lin);
    save('LinearizedModel.mat', 'A_lin', 'B_lin', 'C_lin', 'D_lin', 'sys_linear');
    

    fprintf('System order: %d states\n', size(A_lin, 1));
end