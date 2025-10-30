function V = ModelErrorTG(par, data, options)

    % Extract parameter
    nu0 = par(1);
    nu1 = par(2);
    beta0 = par(3);
    theta_e = par(4);

    % Make Vm visible to the model
    assignin('base','nu0',nu0)
    assignin('base','nu1',nu1)
    assignin('base','beta0',beta0)
    assignin('base','theta_e',theta_e)
    assignin('base','meas',data)
    % Run simulation
    simOut = sim('ModelforTorqueGen.slx', data.p_m.time, options.sim_options);

    omegasim = simOut.get('yout');
    tsim = simOut.get('tout');
    omegasim_values = omegasim{1}.Values.Data;

    % Compute squared error
    V = sum((data.omega_e.signals.values - omegasim_values).^2);

    % Optional plotting
    if options.enablePlot
        figure(options.fig_num);
        plot(data.omega_e.time, data.omega_e.signals.values, 'b'); hold on; grid on;
        plot(tsim, omegasim_values, '-r'); hold off;
        xlabel('Time [s]');
        ylabel('Model Output [-]');
        legend({'Measurements','Simulation'},'Location','NorthEast');
        set(gca,'XLim',[data.omega_e.time(1) data.omega_e.time(end)]);
        set(gca,'YLim',[min(data.omega_e.signals.values)-0.1*mean(data.omega_e.signals.values) ...
                        max(data.omega_e.signals.values)+0.1*mean(data.omega_e.signals.values)]);
        drawnow;
    end
end
