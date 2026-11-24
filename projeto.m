%% Processamento Digital de Sinais
%  Projeto Filtro Digital - 2026/2
%  Alunos:
%    Celso Dell Anhol Ubaldo
%    Maria Fernanda Schoma Trentim
%
%  NOTAS: 
%  - Este script requer o Signal Processing
%  Toolbox instalado no Matlab, bem como os
%  arquivos convolucao.m e filtro.m
%  - Se o áudio de entrada for estéreo, uma
%  das faixas será descartada
%  - A exportação aceita os formatos: .flac,
%  .oga, .ogg, .opus e .wav somente

% Nome dos arquivos
    filename_in =   'audio_celso.mp3';
    filename_out =  'audio_celso_filtrado.wav';

% Importar MP3 e alterar frequência de amostragem    
    [y, fs_original] = audioread(filename_in);    
    fs_nova = 16000; % Freq. amostragem desejada
    fprintf('(1/5) Arquivo de áudio carregado.\n');
    y2 = y(:,1); % Extrai a primeira faixa do áudio (mono)
    % Alterar frequência de amostragem
    sinal = resample(y2, fs_nova, fs_original);
    fprintf('(2/5) Frequência de amostragem alterada para %dHz.\n', fs_nova);
    

% Filtrar sinal com o algoritmo de filtro passa-altas
    fprintf('(3/5) Iniciando filtragem.\n');    
    sinal_filtrado = filtro(sinal);
    fprintf('(4/5) Filtragem concluída.\n');

% Salvar áudio filtrado em novo arquivo
    fprintf('(5/5) Salvando arquivo...\n');
    audiowrite(filename_out, sinal_filtrado, fs_nova);

% Limpar memória do Matlab após execução do script
input("Pressione ENTER para finalizar");
clear variables;