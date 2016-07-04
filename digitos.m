clear all
close all

echo on
load train_data.mat
load test_data.mat % Carrega arquivo com exemplos de treinamento e teste

% Normaliza os dados de entrada de treinamento
[dadoTreinamentoEntrada_N,PS]=mapminmax(dadoTreinamentoEntrada);

% Normaliza os dados de entrada de teste
dadoTesteEntrada_N=mapminmax('apply',dadoTesteEntrada,PS);


%Crie a rede neural que será usada no problema.
%(uma rede feed forward, com 10 neuronios na camada intermediária,
%funções de saída tangente hiperbólica, treinamento usando
%levemberg-marquadt
net = newff(dadoTreinamentoEntrada_N,saidaTrein,10,{'tansig', 'tansig'},'traingdx');
net.trainParam.epochs=10000; % máximo de épocas
net.trainParam.goal=0.01;    % erro mínimo

%como já temos um conjunto separado para teste, devemos dizer para o MATLAB
%que todos os exemplos serão utilizados para treinar a rede
%neste caso também não iremos parar o treinamento por início de
%sobretreinamento e portanto também não teremos conjunto de validação
net.divideParam.trainRatio=1.0; % Tudo para treino
net.divideParam.valRatio=0;     % Nada para valid
net.divideParam.testRatio=0;    % Nada para teste

%Treine a rede.
net=train(net,dadoTreinamentoEntrada_N,saidaTrein);

pause
%Simule a rede para os dados do treinamento.
Y=net(dadoTreinamentoEntrada_N);

plotconfusion(saidaTrein,Y);
pause
%Simule a rede para os dados do teste.
Y=net(dadoTesteEntrada_N);

echo on
%Visualize o desempenho da rede para aprender os exemplos de teste plotando a matriz de confusão.
plotconfusion(saidaTeste,Y);
echo off

pause
% Refina o treinamento da rede com os dados de teste de entrada
net=train(net,dadoTesteEntrada_N,saidaTeste);
%Simule a rede para os dados do treinamento.
Y=net(dadoTesteEntrada_N);

plotconfusion(saidaTeste,Y);
pause
