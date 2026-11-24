function retval = convolucao(sinalA, startA, sinalB, startB)
% CONVOLUCAO Realiza a convolução entre dois sinais
%
% Uso:
%     convolucao() - Modo guiado, pergunta os valores ao usuário
%     convolucao(sinalA, startA, sinalB, startB) - Modo não interativo
%
% Parâmetros:
%     sinalA - Vetor do primeiro sinal a convoluir
%     sinalB - Vetor do segundo sinal a convoluir
%     startA, startB - posição da amostra "n" correspondente ao início do
%                      sinal A ou B, respectivamente
%
% Saída:
%     Um vetor com o sinal convoluído. No modo interativo, o usuário pode
%     plotar uma tabela "n x y[n]" mostrando a relação do sinal convoluído
%     com os instantes de amostragem.
%     Será exibida na tela a porcentagem de avanço da função, para garantir
%     que o código não travou.
    
    % Inicializa variável de resposta
    retval = zeros(length(sinalA)+length(sinalB)-1, 1);
    % Transforma ambos os sinais em vetores-linha
    sinalA = reshape(sinalA,1,[]);
    sinalB = reshape(sinalB,1,[]);
    
    %% 0 - ENTRADA DE DADOS
    % Se a função foi invocada sem argumentos, usar modo interativo
    printRes = 0;
    if (nargin < 4)
        sinalA = input("Insira o primeiro sinal (vetor): ");
        startA = input("Insira o valor de 'n' correspondente ao instante de início deste sinal: ");

        sinalB = input("Insira o segundo sinal (vetor): ");
        startB = input("Insira o valor de 'n' correspondente ao instante de início deste sinal: ");
        
        printRes = input("Exibir tabela com o sinal convoluído? (1-Sim/0-Não): ");
    end
    
    
    
    %% 1 - REFLETIR UM DOS SINAIS NO TEMPO
    % Fazendo sinalB[k] = sinalB[-k]
    sinalBinv = flip(sinalB);
    
    % Limites da sobreposição dos sinais
    limsup = length(sinalA) - 1;
    liminf = length(sinalB) - 1;
    
    k = 1;
    for n = -liminf:limsup    
        %% 2 - DESLOCAR SINAL REFLETIDO "n" POSIÇÕES
        % Desloca-se sinalB[-k] de n unidades resultando em sinalB[n-k]
        sinalBdesloc = desloca(sinalBinv, n);
        
        %% 3 - MULTIPLICAÇÃO DE SINAIS
        % O sinalA[k] e sinalB[n-k] são multiplicados entre si para todos valores de k
        sinalMult = multPontoAPonto(sinalA, sinalBdesloc);
        
        %% 4 - SOMA
        % O produto obtido é somado para todos os valores de k   
        yn = sum(sinalMult);      
        
        % Mostrar porcentagem de progresso de 10% em 10%
        dezPorcento = round(length(retval) / 10);
        if mod(k, dezPorcento) == 0
            txt = strcat('      Progresso convolução...',num2str(10*k/dezPorcento), '%');
            disp(txt);
        end

        % Obtém-se o valor de saída para y[n]
        retval(k) = yn;
        k = k+1;
    end
    
    if (printRes)
        n0 = startA+startB; % Instante inicial
        ns = n0:1:(n0+length(retval)-1); % Valores de n
        % Tabela de resposta
        tb = table(ns(:), retval(:), 'VariableNames', {'n' 'Sinal_convoluido'});
        disp(tb);
    end


    %% FUNÇÃO AUXILIAR PARA MULTIPLICAR SINAIS
    function sinalMultiplicado = multPontoAPonto(sinal1, sinal2)
        endpos = min(length(sinal1), length(sinal2));
        % Iguala o comprimento dos sinais
        sinalMultiplicado = sinal1(1:endpos) .* sinal2(1:endpos);
    end
  
  
    %% FUNÇÃO AUXILIAR PARA DESLOCAR SINAIS
    function sinalDeslocado = desloca(sinal, pos)
        % Valor absoluto das posições a deslocar
        p = abs(pos);
        
        if (pos < 0) % Deslocamento à esquerda
            % Remover "p" elementos à esquerda
            sinalDeslocado = sinal(1+p:end); % Usado "1+p" pois vetores Matlab começam em 1
        
        elseif (pos > 0) % Deslocamento à direita
            % Adicionar "p" zeros à esquerda
            sinalDeslocado = [ zeros(1, p), sinal ];
        
        else % Deslocamento nulo
            sinalDeslocado = sinal; % Retorna o sinal original
        end
    
    end
  
end
