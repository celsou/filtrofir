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
    fprintf('(1/6) Arquivo de áudio carregado.\n');
    y2 = y(:,1); % Extrai a primeira faixa do áudio (mono)
    % Alterar frequência de amostragem
    sinal = resample(y2, fs_nova, fs_original);
    fprintf('(2/6) Frequência de amostragem alterada para %dHz.\n', fs_nova);
    

% Filtrar sinal com o algoritmo de filtro passa-altas
    fprintf('(3/6) Iniciando filtragem.\n');    
    sinal_filtrado = filtro(sinal);
    fprintf('(4/6) Filtragem concluída.\n');

% Salvar áudio filtrado em novo arquivo
    fprintf('(5/6) Salvando arquivo...\n');
    audiowrite(filename_out, sinal_filtrado, fs_nova);

% Plotar espectros de frequência    
    fprintf('(6/6) Plotando espectro dos sinais...\n');
    N = length(sinal);
    NFFT = 2^nextpow2(N);
    f = fs_nova/2*linspace(0, 1, NFFT/2+1);    
    % Sinal original
    X1f = fft(sinal,NFFT)/N;
    figure(1);
    plot(f, 2*abs(X1f(1:NFFT/2+1)));
    title('Espectro de Magnitude do sinal original');
    xlabel('f(Hz)'); ylabel('|X(f)|');
    % Limitar a escala em Y à maior amplitude de X1
    % (iguala o eixo Y em ambos os gráficos)
    ylim([0 max(2*abs(X1f(1:NFFT/2+1))) ]);
    
    % Sinal filtrado
    X2f = fft(sinal_filtrado,NFFT)/N;
    figure(2);    
    plot(f, 2*abs(X2f(1:NFFT/2+1)));
    title('Espectro de Magnitude do sinal filtrado');
    xlabel('f(Hz)'); ylabel('|X(f)|');
    % Limitar a escala em Y à maior amplitude de X1
    % (iguala o eixo Y em ambos os gráficos)
    ylim([0 max(2*abs(X1f(1:NFFT/2+1))) ]);
