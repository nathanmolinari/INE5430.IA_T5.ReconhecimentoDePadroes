clear all
close all

echo on
path(path,'/home/nathan/Documentos/pessoal/redeNeural/ventilacao')
load exdata.mat % Carrega arquivo com exemplos de treinamento e teste

quantidadeDigitos = 10;
quantidadeAmostras = 500;
porcentagemTreinamento = 0.7;
porcentagemTeste = 0.3;

dadoTreinamentoEntrada = zeros(400,quantidadeAmostras * porcentagemTreinamento * 10);
dadoTreinamentoSaida = zeros(1,quantidadeAmostras * porcentagemTreinamento * 10);
dadoTesteEntrada = zeros(400,quantidadeAmostras * porcentagemTeste * 10);
dadoTesteSaida = zeros(1,quantidadeAmostras * porcentagemTeste * 10);

for i=0:quantidadeDigitos-1
    inicioOrigemTreinamento = i * quantidadeAmostras + 1;
    fimOrigemTreinamento = (i * quantidadeAmostras) + (quantidadeAmostras * porcentagemTreinamento);
    inicioOrigemTeste = fimOrigemTreinamento + 1;
    fimOrigemTeste = (i * quantidadeAmostras) + quantidadeAmostras;

    inicioDestinoTreinamento = i * quantidadeAmostras * porcentagemTreinamento + 1;
    fimDestinoTreinamento = quantidadeAmostras * porcentagemTreinamento * (i + 1);
    inicioDestinoTeste = i * quantidadeAmostras * porcentagemTeste + 1;
    fimDestinoTeste = quantidadeAmostras * porcentagemTeste * (i + 1);

    dadoTreinamentoEntrada(1:400, inicioDestinoTreinamento:fimDestinoTreinamento) = X(1:400, inicioOrigemTreinamento:fimOrigemTreinamento);
    dadoTreinamentoSaida(1:1, inicioDestinoTreinamento:fimDestinoTreinamento) = y(1:1, inicioOrigemTreinamento:fimOrigemTreinamento);
    dadoTesteEntrada(1:400, inicioDestinoTeste:fimDestinoTeste) = X(1:400, inicioOrigemTeste:fimOrigemTeste);
    dadoTesteSaida(1:1, inicioDestinoTeste:fimDestinoTeste) = y(1:1, inicioOrigemTeste:fimOrigemTeste);
end

pause
displayDigit(X, 501);

[dadoTreinamentoEntrada_N,PS]=mapminmax(dadoTreinamentoEntrada);

dadoTesteEntrada_N=mapminmax('apply',dadoTesteEntrada,PS);
pause % Strike any key to continue...



net = newff(dadoTreinamentoEntrada_N,dadoTreinamentoSaida,10,{'tansig', 'tansig'},'traingdx');
net.trainParam.epochs=10000; % m�ximo de �pocas
net.trainParam.goal=0.01;    % erro m�nimo


net.divideParam.trainRatio=1.0; % Tudo para treino
net.divideParam.valRatio=0;     % Nada para valid
net.divideParam.testRatio=0;    % Nada para teste


%Treine a rede.
net=train(net,dadoTreinamentoEntrada_N,dadoTreinamentoSaida);


%Simule a rede para os dados do treinamento.
Y=sim(net,dadoTreinamentoEntrada_N);

%Simule a rede para os dados do teste.
% Y=sim(net,dadoTesteEntrada_N);



%Visualize o desempenho da rede para aprender os exemplos de treinamento plotando a matriz de confus�o.
% plotconfusion(dadoTreinamentoSaida,Y);
% pause % Strike any key to continue...
%
% clear YClass;
% %Simule  a rede para os dados de teste.
% Y=sim(net,dadoTesteEntrada_N);
% pause % Strike any key to continue...
% echo off
%
% echo on
% %Sature  a sa�da da rede para os mesmos valores de sa�da dos exemplos de teste.
% echo off
% for i=1:size(dadoTesteEntrada_N,2)
% 	if Y(1,i)>Y(2,i)
% 		YClass(1,i)=1;
% 		YClass(2,i)=0;
% 	else
% 		YClass(1,i)=0;
% 		YClass(2,i)=1;
% 	end
% end
% echo on
% pause % Strike any key to continue...
% %echo offzz
%
% echo on
% %Visualize o desempenho da rede para aprender os exemplos de teste plotando a matriz de confus�o.
% plotconfusion(dadoTesteSaida,YClass);
% echo off
