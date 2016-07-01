clear all
close all

echo on
path(path,'/home/nathan/Documentos/pessoal/redeNeural/ventilacao')
load VentAssistida.mat % Carrega arquivo com exemplos de treinamento e teste
pause % Strike any key to continue...

% Transforma as saidas categ�ricas em num�ricas
echo off
for i=1:size(VentTreinDados,2)
    if strcmp(VentTreinSaida{1,i},'sucesso')
        SaidaTrein(1,i)=1;
    else
        SaidaTrein(2,i)=1;
    end
end
for i=1:size(VentTestDados,2)
    if strcmp(VentTestSaida{1,i},'sucesso')
        SaidaTest(1,i)=1;
    else
        SaidaTest(2,i)=1;
    end
end
echo on
pause % Strike any key to continue...

%Normalize os atributos de entrada do conjunto de treinamento...
[VentTreinDados_N,PS]=mapminmax(VentTreinDados);

%Normalize os atributos de entrada do conjunto de teste.
VentTestDados_N=mapminmax('apply',VentTestDados,PS);
pause % Strike any key to continue...

%visualize os dados do seu problema.
echo off
grid on; hold on;
for i=1:size(VentTreinDados_N,2)
	if SaidaTrein(1,i)==1;
		plot3(VentTreinDados_N(1,i),VentTreinDados_N(2,i),...
            VentTreinDados_N(3,i),'k*');
	else
		plot3(VentTreinDados_N(1,i),VentTreinDados_N(2,i),...
            VentTreinDados_N(3,i),'ro');
	end
end
echo on
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


