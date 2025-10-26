function V = ModelError(par, data, options)

    % Extract parameter
    p_initial = data.p_m.signals.values(1);
    Vm = par(1);

    % Make Vm visible to the model
    assignin('base','Vm',Vm)

    % Run simulation
    simOut = sim('ModelForIM', data.u_alpha.time, options.sim_options);

    % Extract model output (assuming a variable named 'psim' is logged)
    psim = simOut.get('yout');
    tsim = simOut.get('tout');
    psim_values = psim{1}.Values.Data;

    % Compute squared error
    V = sum((data.p_m.signals.values - psim_values).^2);

    % Optional plotting
    if options.enablePlot
        figure(options.fig_num);
        plot(data.p_m.time, data.p_m.signals.values, 'b'); hold on; grid on;
        plot(tsim, psim_values, '-r'); hold off;
        xlabel('Time [s]');
        ylabel('Model Output [-]');
        legend({'Measurements','Simulation'},'Location','NorthEast');
        set(gca,'XLim',[data.p_m.time(1) data.p_m.time(end)]);
        set(gca,'YLim',[min(data.p_m.signals.values)-0.1*mean(data.p_m.signals.values) ...
                        max(data.p_m.signals.values)+0.1*mean(data.p_m.signals.values)]);
        drawnow;
    end
end
