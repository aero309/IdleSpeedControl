


options.sim_options = simset('Solver','ode1','FixedStep',1e-3,'SrcWorkspace','base');


figure;
    subplot(2,1,1);
    plot(meas.m_dot_alpha.time, meas.m_dot_alpha.signals.values);
        xlabel('Time [s]');
        legend({'mdot_in'},'Location','NorthWest');
    subplot(2,1,2);
    plot(meas.p_m.time, meas.p_m.signals.values);
        xlabel('Time [s]');
        legend({'p'},'Location','NorthWest');

fh=findall(0,'type','figure');
options.fig_num = length(fh)+1;
options.enablePlot = 1;

par0 = Vm_guess;

errorfnc_fminsearch = @(par0) ModelError(par0, meas, options);

opt_options = optimset('Algorithm','sqp','display','iter','Maxit',30);
optpar = fminsearch(errorfnc_fminsearch, par0, opt_options);

Vm = optpar(1);

% Load validation data
    load('.\TAData\quasistatic_0001.mat');
    p_initial = meas.p_m.signals.values(1);

% Run a simulation with the identified optimal variable values
    data.mdot_in = ValData.mdot_in;
    [tValSim,~,pvalsim] = sim('ModelForIM.slx', meas.T_m.time, options.sim_options);

% Graphically represent the quality of the optimization routine
    figure;
    subplot(2,1,1);
    plot(tValSim, meas.u_alpha.signals.values);
        xlabel('Time [s]');
        ylabel('Inputs');
        legend('mdot_in');
    subplot(2,1,2);
    plot(tValSim, meas.p_m.signals.values, ...
        tValSim, pvalsim);
        xlabel('Time [s]');
        ylabel('Outputs');
        legend('Measured pm','Modelled pm')