
function [gamma0, gamma1] = EngineMassFlowIdent(data, params)
   
    pm   = data.p_m.signals.values;      
    pe   = data.p_e.signals.values;      
    Tm   = data.T_m.signals.values;      
    mdot_alpha = data.m_dot_alpha.signals.values; 
    we   = data.omega_e.signals.values;  
    lambda  = data.lambda.signals.values;   
    
    %We have a file parameters.m
    %Just provide it to the fuction when calling
    Vd = params.Vd;         
    Vc = params.Vc;         
    k  = params.kappa;      
    sigma0 = params.sigma0; 
    lamb
    %compute lambda_lp(pm) 
    % could also take from model but would probably be a pain for debugging right?
    lambda_lp = (Vc+Vd)/Vd - (Vc/Vd) .* (pe./pm).^(1./k);
    
    %build y from lamda_lw
    y = (4*pi*R/Vd) .* (Tm .* mdot_alpha) ./ (pm .* we .* lambda_lp) .* (1 + 1./(lambda.*sigma0));
    
    %regression matrix
    M = [ones(size(we)), we];
    
    %do Linear regression and print vars
    params = (M' * M) \ (M' * y);
    gamma0 = params(1);
    gamma1 = params(2);
    fprintf('  gamma0 = %.6f [-]\n', gamma0);
    fprintf('  gamma1 = %.6e [s/rad]\n', gamma1);
    lw_model = gamma0 + gamma1*we;
    
    % figure; 
    % subplot(2,1,1);
    % plot(we, y, 'k.'); hold on; plot(we, M*params_ls, '-');
    % xlabel('\omega_e [rad/s]'); ylabel('\lambda_{l\omega} [-]');
    % legend('data','affine fit'); grid on; title('Volumetric efficiency (speed part) fit');
    % 
    % subplot(2,1,2);
    % ll = y .* lambda_lp;                 
    % plot(we, ll, 'k.');
    % xlabel('\omega_e [rad/s]'); ylabel('\lambda_l [-]');
    % grid on; title('Total volumetric efficiency check');
    end
