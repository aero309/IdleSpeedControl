


options.sim_options = simset('Solver','ode1','FixedStep',1e-3,'SrcWorkspace','base');


figure;
    subplot(2,1,1);
    plot(meas.m_dot_alpha.time, meas.m_dot_alpha.signals.values);
        xlabel('Time [s]');
        legend({'mdot_in'},'Location','NorthWest');
    subplot(2,1,2);
    plot(meas.p_m.time, meas.p_m.signals.values);
        xlabel('Time [s]');
        legend({'p_m'},'Location','NorthWest');

fh=findall(0,'type','figure');
options.fig_num = length(fh)+1;
options.enablePlot = 1;

par0 = Vm_guess;
load ../../TAData/dynamic_0002.mat;
errorfnc_fminsearch = @(par0) ModelErrorIM(par0, meas, options);
iter = 10;
opt_options = optimset('Algorithm','sqp','display','iter','Maxit', 10);
optpar = fminsearch(errorfnc_fminsearch, par0, opt_options);

Vm = optpar(1);
%%
% Load validation data
    load('../../TAData/dynamic_0003.mat');
    p_initial = meas.p_m.signals.values(1);
% Run a simulation with the identified optimal variable values
    simOut = sim('ModelForIM.slx', meas.T_m.time, options.sim_options);


    psim = simOut.get('yout');
    tsim = simOut.get('tout');
    psim_values = psim{1}.Values.Data;

% Graphically represent the quality of the optimization routine
    figure;
    subplot(2,1,1);
    plot(tsim, meas.u_alpha.signals.values);
        xlabel('Time [s]');
        ylabel('Inputs');
        legend('mdot_in');
    subplot(2,1,2);
    plot(tsim, meas.p_m.signals.values, tsim, psim_values);
        xlabel('Time [s]');
        ylabel('Outputs');
        legend('Measured pm','Modelled pm')
    title("Validation of the IM")