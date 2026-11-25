function sinal_saida = filtro(sinal_entrada)
% FILTRO Filtra um sinal de entrada fornecido (filtro passa-altas)
%
% Uso:
%     filtro(sinal_entrada) - Filtra e retorna o sinal filtrado
%     filtro() - Apenas plota as características deste filtro
%
% Parâmetros:
%     sinal_entrada - Vetor do sinal em tempo discreto a filtrar
%
% Saída:
%     Um vetor com o sinal filtrado. Se não fornecido um sinal de
%     entrada, será plotada a resposta em frequência e o diagrama
%     de tolerâncias do filtro.

%% Definição do filtro
% Constantes básicas (cf. memorial de cálculo)
    f_s = 16000;         % Frequência de amostragem em Hz
    f_c = 1000;          % Frequência de corte em Hz
    M = 297; 			% Número de amostras do filtro
    w_c = pi/8;			% Frequência de corte normalizada
    n = 0:M-1;			% n variando de 0 a M-1

% Janela de Hamming
    w = 0.54 - 0.46 * cos((2 * pi .* n) / (M-1));

% Adaptação do filtro passa-altas ideal
    n_desloc = n - (M-1)/2; % Deslocamento n => n - (M-1)/2
    h_d = -sin(w_c .* n_desloc) ./ (pi .* n_desloc); % De 0 até M-1
    % Caso especial n = (M-1)/2. OBS.: somar 1 pois vetores matlab começam
    % no índice 1
    idx = 1 + (M-1)/2; 
    h_d(idx) = 1 - (w_c / pi); 

% Filtro passa altas
    h = h_d .* w;

%% Filtra o sinal de entrada (se houver) e encerra o algoritmo
if (nargin > 0)
    % Filtrar é convoluir o sinal com o filtro
    sinal_saida = convolucao(h, 0, sinal_entrada, 0);    
    return;
end

%% Plota informações do filtro se não houver sinal de entrada
% Plotar resposta em frequẽncia do filtro
    figure(100);
    freqz(h, 1, 1600, f_s);

% Verificação gráfica das tolerâncias
    % Obter dados
    [magnitude, frequencia] = freqz(h, 1, 1600, f_s);
    magDB = 20*log10(abs(magnitude)); % Magnitude em dB
    delP = 0.7; % Ganho na faixa de passagem (em dB)
    delS = -50; % Atenuação na faixa de rejeição (em dB)
    delW = 200; % Largura da faixa de transição (em Hz)
    % Criar plotagem
    figure(101); hold on;
    plot(frequencia, magDB, 'blue', 'LineWidth', 2);
    title('Diagrama de tolerâncias');
    xlabel('Frequência (Hz)');
    ylabel('Magnitude (dB)');
    grid on;
    % Linhas de tolerâncias
    yline(delP, '--magenta');     % Ripple
    yline(-delP, '--magenta');    % Ripple
    yline(delS, '--magenta');     % Atenuação
    xline(f_c, '--black');      % Largura transição
    xline(f_c+delW/2, '--red'); % Largura transição
    xline(f_c-delW/2, '--red'); % Largura transição
    % Limitar escala eixos aos dados principais
    xlim([0, f_c+1000]);
    ylim([delS-10, delP+5]);
    hold off;
end