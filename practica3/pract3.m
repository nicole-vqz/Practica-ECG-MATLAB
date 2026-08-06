clear all
close all
clc

load ecgdata.mat
ecgdata = double(signals_struct.Channel_1(:));
Fs = 1000;
tiempo_completo = (0:length(ecgdata)-1)/Fs;

t_inicio = 5; % segundo de inicio
t_fin = 8;    % segundo de fin
fragmento_indices = (tiempo_completo >= t_inicio) & (tiempo_completo <= t_fin);

Xin = ecgdata(fragmento_indices); 
tiempo = tiempo_completo(fragmento_indices);

if size(Xin, 2) > 1
    Xin = Xin(:, 1);
end

ventana_tendencia = round(Fs * 0.8); % Ventana de 0.8 segundos
linea_base = movmean(Xin, ventana_tendencia);
Xin_filtrada = Xin - linea_base; 

Xin = Xin_filtrada - mean(Xin_filtrada); 
tiempo = (0:length(Xin)-1) / Fs;

max_val = max(abs(Xin));
Xin_positiva = (Xin / max_val + 1) / 2;
Xin_escalada = Xin_positiva * 65535;

Y_4bit_indx = cuantificador(Xin_escalada, 4);
Y_2bit_indx = cuantificador(Xin_escalada, 2);
Y_1bit_indx = cuantificador(Xin_escalada, 1);

Y_4bit = ((Y_4bit_indx / (2^4 - 1)) * 2 - 1) * max_val;
Y_2bit = ((Y_2bit_indx / (2^2 - 1)) * 2 - 1) * max_val;
Y_1bit = ((Y_1bit_indx / (2^1 - 1)) * 2 - 1) * max_val;

figure('Position', [100, 100, 800, 600]);

subplot(4, 1, 1); 
plot(tiempo, Xin, 'b', 'LineWidth', 1);
title('Señal ECG Original (Filtrada sin Línea Base)'); ylabel('Amplitud'); grid on;

subplot(4, 1, 2); 
plot(tiempo, Y_4bit, 'r', 'LineWidth', 1);
title('Señal ECG Cuantificada a 4 bits (16 niveles)'); ylabel('Amplitud'); grid on;

subplot(4, 1, 3); 
plot(tiempo, Y_2bit, 'g', 'LineWidth', 1);
title('Señal ECG Cuantificada a 2 bits (4 niveles)'); ylabel('Amplitud'); grid on;

subplot(4, 1, 4); 
plot(tiempo, Y_1bit, 'm', 'LineWidth', 1);
title('Señal ECG Cuantificada a 1 bit (2 niveles)'); xlabel('Tiempo (segundos)'); ylabel('Amplitud'); grid on;