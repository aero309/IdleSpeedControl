function [alpha0, alpha1] = IdentifyThrottleParams(data)
    u_alpha = data.u_alpha.signals.values;
    m_dot_alpha = data.m_dot_alpha.signals.values;
    p_a = data.p_a.signals.values;
    T_a = data.T_a.signals.values;
    R = 287; 
    y = m_dot_alpha .* sqrt(2 * R .* T_a) ./ p_a;
    M = [ones(length(u_alpha), 1), u_alpha];
    params = M\y;
    alpha0 = params(1);
    alpha1 = params(2);
    fprintf('  alpha0 = %.4e [m^2]\n', alpha0);
    fprintf('  alpha1 = %.4e [m^2]\n', alpha1);
    A_model = alpha0 + alpha1 * u_alpha;
    figure; hold on;
    plot(u_alpha, y, 'kx', 'DisplayName', 'Measurements');
    plot(u_alpha, A_model, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Model Fit');
    xlabel('Throttle command u_\alpha [%]');
    ylabel('Equivalent area term');
    legend('show');
    grid on;
    title('Throttle Parameter Identification');
    % A_model = alpha0 + alpha1 * u_alpha;
    % figure; hold on;
    % plot(u_alpha, y, 'kx', 'DisplayName','Measurements');
    % plot(u_alpha, A_model, 'r-', 'LineWidth', 1.5, 'DisplayName','Model Fit');
    % xlabel('Throttle command u_\alpha [%]');
    % ylabel('Equivalent area term');
    % legend('show');
    % grid on;
    % title('Throttle Parameter Identification');
end

