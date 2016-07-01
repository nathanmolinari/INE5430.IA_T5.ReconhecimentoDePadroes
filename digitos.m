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

%Normalize os atributos de entrada do conjunto de treinamento...
[VentTreinDados_N,PS]=mapminmax(X);

%Normalize os atributos de entrada do conjunto de teste.
VentTestDados_N=mapminmax('apply',VentTestDados,PS);
pause % Strike any key to continue...


%Crie a rede neural que ser� usada no problema.
%(uma rede feed forward, com 10 neur�nios na camada intermedi�ria,
%fun��es de sa�da tangente hiperb�lica, treinamento usando
%levemberg-marquadt
net = newff(VentTreinDados_N,SaidaTrein,10,{'tansig', 'tansig'},'traingdx');
net.trainParam.epochs=10000; % m�ximo de �pocas
net.trainParam.goal=0.01;    % erro m�nimo
pause % Strike any key to continue...

%como j� temos um conjunto separado para teste, devemos dizer para o MATLAB
%que todos os exemplos ser�o utilizados para treinar a rede �
%neste caso tamb�m n�o iremos parar o treinamento por in�cio de
%sobretreinamento e portanto tamb�m n�o teremos conjunto de valida��o
net.divideParam.trainRatio=1.0; % Tudo para treino
net.divideParam.valRatio=0;     % Nada para valid
net.divideParam.testRatio=0;    % Nada para teste
pause % Strike any key to continue...

%Treine a rede.
net=train(net,VentTreinDados_N,SaidaTrein);
pause % Strike any key to continue...

%Simule a rede para os dados do treinamento.
Y=sim(net,VentTreinDados_N);
pause % Strike any key to continue...

%Sature a sa�da da rede para os mesmos valores de sa�da dos exemplos de treinamento.
echo off
for i=1:size(VentTreinDados_N,2)
	if Y(1,i)>Y(2,i)
		YClass(1,i)=1;
		YClass(2,i)=0;
	else
		YClass(1,i)=0;
		YClass(2,i)=1;
	end
end
echo on
pause % Strike any key to continue...

%Visualize o desempenho da rede para aprender os exemplos de treinamento plotando a matriz de confus�o.
plotconfusion(SaidaTrein,YClass);
pause % Strike any key to continue...

clear YClass;
%Simule  a rede para os dados de teste.
Y=sim(net,VentTestDados_N);
pause % Strike any key to continue...
echo off

echo on
%Sature  a sa�da da rede para os mesmos valores de sa�da dos exemplos de teste.
echo off
for i=1:size(VentTestDados_N,2)
	if Y(1,i)>Y(2,i)
		YClass(1,i)=1;
		YClass(2,i)=0;
	else
		YClass(1,i)=0;
		YClass(2,i)=1;
	end
end
echo on
pause % Strike any key to continue...
%echo offzz

echo on
%Visualize o desempenho da rede para aprender os exemplos de teste plotando a matriz de confus�o.
plotconfusion(SaidaTest,YClass);
echo off
