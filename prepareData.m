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

numColunasTrein = quantidadeAmostras * porcentagemTreinamento * 10;
saidaTrein = zeros(quantidadeDigitos,numColunasTrein);
for i=1:numColunasTrein
  saidaTrein(dadoTreinamentoSaida(1,i), i) = 1;
end

numColunasTeste = quantidadeAmostras * porcentagemTeste * 10;
saidaTeste = zeros(quantidadeDigitos,numColunasTeste);
for i=1:numColunasTeste
  saidaTeste(dadoTesteSaida(1,i), i) = 1;
end
