clc; clear; close all;

Y = [4.030 8.050 12.930 16.030 20.030];
X = [4.011 8.031 12.230 15.996 19.990];
% Estimacao de parametros
clf
n = length(X);
Aux1 = ones(1,length(X));

% Modelo simulado para geracao dos dados: y=2x+0.2
y = 2*X+0.2;

Xm = [X;Aux1];
ab = Xm'\Y';

Ganho = ab(1,1);
Polarizacao = ab(2,1);

Yest = Ganho*X+Polarizacao;
erro = Y - Yest;

ni = n-2;

S2 = (1/ni)*sum(erro.^2);     % variancia de Y
S = sqrt(S2);                 % desvio padrao de Y (dos erros de ajuste da reta de calibracao)

% Calculo da incerteza da indicacao nao corrigida do instrumento
m = 1;          % m=1 -> um unico experimento com n=10 medidas
uy = S/sqrt(m); % incerteza padrao
k = 3.31;       % Fator tstudent para ni = 3
Uy = k*uy;      % incerteza expandida


%Plotando:reta de calibracao,indicacoes nao corrigidas Y, regiao de incerteza
p=plot(X,Y,'o ', X, Yest, 'r', X,(Yest+Uy),'--', X,(Yest-Uy),'--');
p(1).LineWidth = 1;p(2).LineWidth = 2; p(3).LineWidth = 1.2;p(4).LineWidth = 1.2;
xlabel('X (Padrao de Medicao)');
ylabel('Y (Instrumento em calibracao)');
%gtext(['Yest = ' num2str(Ganho) 'X + ' num2str(Polarizacao)]);
legend('Indicacoes nao corrigidas','Reta de calibracao (Yest)','Yest+Uy','Yest-Uy');

