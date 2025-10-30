





figure;
    plot(meas.omega_e.time, meas.omega_e.signals.values);
        xlabel('Time [s]');
        legend({'Omega_e'},'Location','NorthWest');

fh=findall(0,'type','figure');
options.fig_num = length(fh)+1;
options.enablePlot = 1;

par0 = [nu0, nu1, beta0, theta_e];
load ../../TAData/dynamic_0002.mat;
options.sim_options = simset('Solver','ode1','FixedStep',1e-3,'SrcWorkspace','base');
errorfnc_fminsearch = @(par0) ModelErrorTG(par0, meas, options);
iter = 20;
opt_options = optimset('Algorithm','sqp','display','iter','Maxit', iter);
optpar = fminsearch(errorfnc_fminsearch, par0, opt_options);

nu0 = optpar(1);
nu1 = optpar(2);
beta0 = optpar(3);
theta_e = optpar(4);
%%
% Load validation data
    load('../../TAData/dynamic_0003.mat');
% Run a simulation with the identified optimal variable values
    options.sim_options = simset('Solver','ode1','FixedStep',1e-3,'SrcWorkspace','base');
    simOut = sim('ModelforTorqueGen.slx', meas.p_m.time, options.sim_options);


    omegasim = simOut.get('yout');
    tsim = simOut.get('tout');
    omegasim_values = omegasim{1}.Values.Data;

% Graphically represent the quality of the optimization routine
    figure;
    plot(tsim, meas.omega_e.signals.values, tsim, omegasim_values);
        xlabel('Time [s]');
        ylabel('Outputs');
        legend('Measured omega_e','Modelled omega_e')