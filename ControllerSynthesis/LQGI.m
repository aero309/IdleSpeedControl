%run scripts\parameters.m

%Tuning Parameters
KI = 1; %Larger integral action for larger KI
r1 = 1;
r2 = 1;

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

R = [r1 0;
     0  r2];
Q = C' * C;
K = lqr(A, B, Q, R);

%Observer
q = 0.01;                      
L = lqr(A', C', B*B', q)';      

%Matricies
A_c = [Ae -Be*K;
       zeros(nx,1)   A - B*K - L*C];
B_c = [Be*D;
       -L];
C_c = [Ce -De*K];
D_c = D;

%Discretize
sysC = ss(A_c, B_c, C_c, D_c);
sysD = c2d(sysC, 0.001, 'tustin');

ISCSAd = sysD.A;
ISCSBd = sysD.B;
ISCSCd = sysD.C;
ISCSDd = sysD.D;
