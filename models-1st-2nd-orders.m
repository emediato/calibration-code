
tau = [11 13.48 12.23 10.5 14.01];
tauM = mean(tau);
k = [1.0135 1.0045 1.0545 1.0375 1.0125];
kM = mean(k);

MP = [0.13 0.1 0.08 0.11]
MPm = mean(MP);
zeta = (1-MPm)*0.6;
ts = [84 82 77 94 85 105];
tsM = mean(ts);
wn = 4.6/(tsM*zeta);

num1 = [kM];
den1 = [tauM 1];
prim = tf(num1, den1);
degr = tf(20,1);

num2 = [wn*wn];
den2 = [1 2*zeta*wn wn*wn];
seg = tf(num2, den2);

segn = tf(1, [1/wn^2 2*zeta/wn 1])

denComp = [2 1];
primComp = tf(den1,denComp)

tcom = linspace(0,50,1);
step(20*prim)
hold on;
ref = step(degr);
step(degr)
hold on;
step(20*seg);

legend('Primeira Ordem','Degrau', 'Segunda Ordem');
