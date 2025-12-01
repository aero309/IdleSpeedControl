%run scripts\parameters.m

%Tuning Parameters
KI = 6; %Larger integral action for larger KI
r1 = 8;
r2 = 4;

%Extension Matrices
Ae = 0;
Be = [1 0];     % throttle input integrates, ignition does not
Ce = [KI ;
      0];
De = [1 0 ;
      0 1];

%Compute Extended Plant Matrices
nx = size(A_lin,1);
nu = size(B_lin,2);

A = [ A_lin         B_lin*Ce ;
      zeros(1,nx)   Ae       ];
B = [ B_lin*De ;
      Be          ];
C = [ C_lin   D_lin*Ce ];
D = D_lin*De;

%Feedback LQR

R_mat = [r1 0;
     0  r2];
Q = C' * C;
K = lqr(A, B, Q, R_mat);

%Observer
q = 1 * 10^(-3);                      
L = lqr(A', C', B*B', q)';      

%Matricies
D_c = zeros(nu, size(C_lin,1));
ISCS_A_c = [Ae -Be*K;
       zeros(nx + 1,1)   A - B*K - L*C];
ISCS_B_c = [Be*D_c;
       -L];
ISCS_C_c = [Ce -De*K];
ISCS_D_c = [De*D_c];

%Discretize
sysC = ss(ISCS_A_c, ISCS_B_c, ISCS_C_c, ISCS_D_c);
sysD = c2d(sysC, 0.001, 'tustin');

ISCS_Ad = sysD.A;
ISCS_Bd = sysD.B;
ISCS_Cd = sysD.C;
ISCS_Dd = sysD.D;

ISCS_Ty = omega_e_nom;                         % output normalization
ISCS_Tu = diag([u_alpha_nom, du_ign_nom]);     % input normalization
Ts   = 0.001;


%%Tuning
%Poles
%Observer
obs= A - L*C;
P_obs = real(eig(obs));
P_obs_max = abs(max(P_obs));

%Controllertf
cont= A - B*K;
P_cont = real(eig(cont));
P_cont_max = abs(max(P_cont));

aa_ratio = P_obs_max / P_cont_max;
disp(['ratio observer/controller speed: ', num2str(aa_ratio)]);

%Crossover
TF_cont = tf(ss(ISCS_A_c, ISCS_B_c, ISCS_C_c, ISCS_D_c ));
TF_plant = tf(ss(A_lin, B_lin, C_lin, D_lin));
TF_L = series(TF_cont, TF_plant);

%TF_L = TF_cont .* TF_plant';
bode(TF_L);
[GM, PM, Wgm, Wpm] = margin(TF_L);
disp(['Phase Margin: ', num2str(PM)]);
disp(['Gain Crossover Freq.: ', num2str(Wpm)]);
info = [KI, r1, r2, q];
disp(['KI, r1 , r2, q: ', num2str(info)]);

save('controllerx.mat', ...
    'ISCS_Ad', 'ISCS_Bd', 'ISCS_Cd', 'ISCS_Dd', ...
    'ISCS_Ty', 'ISCS_Tu');



