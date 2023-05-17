clc; clear; close all;
X = [0 5.7 10.03 14.983 20.00 25.07 30.00 35.07 40.00 45.01 50.00] %padrao de medicao
Y = [0 5.77 10.52 15.17 22.87 25.54 30.42 35.44 40.28 45.24 50.12] %modulo em calibracao
n = length(X);
infinito=100000;
FE=50;     %fundo de escala do instrumento de medicao - pressao
erroCLP=0.106;  %incerteza do clp
erroFluke=0.145;   %incerteza da massa

% Reta de calibracao
Xm =[X;ones(1,n)];
params=Xm'\Y';
a = params(1,1)   %sensibilidade do sistema
b = params(2,1)    %erro sistematico
Yhat = a*X+b;
plot(X,Y,'o',X,Yhat,'');
legend('Dados medidos','Reta de Calibracao');
xlabel('X (Padrão Medicao)');
ylabel('Y (Módulo em calibracao)');
title(['Y = ' num2str(a) 'X + ' num2str(b)]);

%Indicacao corrigida
Xhat=(Y-b)/a

%Incerteza
e=X-Xhat  %erro para indicação corrigida
sy=sqrt((1/(n-2))*sum(e.^2))    %incerteza padrao do instrumento
uyc=sy*sqrt(1+(1/n)+(n*((Y-mean(Y)).^2))/(a^2*(n*sum(X.^2)-sum(X)^2)))   
%incerteza do instrumento com o erro de estimação dos parametros a e b

%a incerteza obtida do manual eh dividida por 1,96 (t-student para vef=infinito),
%para transformar a incerteza expandida em padrao
upr1=erroCLP/tinv((0.95+1)/2,infinito)   
upr2=erroFluke/tinv((0.95+1)/2,infinito)

uc=sqrt(uyc.^2+upr1^2+upr2^2)  % incerteza padrao combinada
vef=uc.^4./((uyc.^4)/(n-2))    %graus de libertade
k=tinv((0.95+1)/2,vef)      %t-student para os graus de liberdade encontrados
Uy=k.*uc      %incerteza expandida
Umax=max(Uy)     %maxima incerteza
EF=Umax/FE     %erro fiducial
linearidade=max(abs(e))   %nao linearidade do sistema

figure(2);
plot(X,Y,'o',X,Xhat,'^',X,Xhat,'k',X,Xhat+Uy,'r--',X,Xhat+uc,'b-.',X,Xhat-Uy,'r--',X,Xhat-uc,'b-.');
legend('Indicacoes nao corrigidas','Indicacoes corrigidas','Reta de Calibracao corrigida',
'Regiao de incertezas expandidas','Regiao de incertezas padrao');
xlabel('X (Padrao Medicao)');
ylabel('Y (Instrumento em calibracao)');
title(['X = (Y - ' num2str(b) ')/' num2str(a)]);
