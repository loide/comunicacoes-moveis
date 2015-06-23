% Comunicacoes Moveis - Modulo 01 - Trabalho 01
% Autor: Loide Mara Verdes
% 28/09/2014

%parametros gerais
n_samples = 512;

%--------- questao 1
% Carrega os arquivos .wav na pasta  portuguese_br
h_file = 'portugues_br/Port_m2.wav';
m_file = 'portugues_br/Port_f2.wav';
[h_y, h_fs, h_nb] = wavread(h_file);
[m_y, m_fs, m_nb] = wavread(m_file);

%--------- questao 2
%plota as curvas para a voz masculina e feminina, respectivamente, em
%função do tempo
h_t = [0:1/h_fs:(length(h_y)-1)/h_fs];
plot(h_t,h_y)
xlabel('tempo (segundos)')
title('Ondas representando a voz masculina')
grid;

m_t = [0:1/m_fs:(length(m_y)-1)/m_fs];
figure;
plot(m_t,m_y)
xlabel('tempo (segundos)')
title('Ondas representando a voz feminina')
grid;

%--------- questao 3
%estima autocorrelacao entre as amostras
[h_corr, h_lag] = xcorr(h_y,n_samples,'coeff');
figure;
stem(h_lag,h_corr)
xlabel('Lag')
title('Autocorrelação da voz masculina')
grid;

[m_corr, m_lag] = xcorr(m_y,n_samples,'coeff');
figure;
stem(m_lag,m_corr)
xlabel('Lag')
title('Autocorrelação da voz feminina')
grid;

%--------- questao 4
%estima DEP usando FFT sobre a autocorrelação
%plota em dB

h_pds_db = abs(fftshift(fft(h_corr)));
h_freq = -h_fs/2:h_fs/length(h_corr):h_fs/2-(h_fs/length(h_corr));
figure;
plot(h_freq, h_pds_db)
ylabel('potência (dB)')
xlabel('frequencia (Hz)')
title('DEP estimada usando FFT sobre a autocorrelação da voz masculina')
grid;

m_pds_db = abs(fftshift(fft(m_corr)));
m_freq = -m_fs/2:m_fs/length(m_corr):m_fs/2-(m_fs/length(m_corr));
figure;
plot(m_freq, m_pds_db)
ylabel('potência (dB)')
xlabel('frequencia (Hz)')
title('DEP estimada usando FFT sobre a autocorrelação da voz feminina')
grid;

%plota em linear
h_pds_linear = db2pow(h_pds_db);
figure;
plot(h_freq, h_pds_linear)
ylabel('potência (W)')
xlabel('frequencia (Hz)')
title('DEP estimada usando FFT sobre a autocorrelação da voz masculina')
grid;

m_pds_linear = db2pow(m_pds_db);
figure;
plot(m_freq, m_pds_linear)
ylabel('potência (W)')
xlabel('frequencia (Hz)')
title('DEP estimada usando FFT sobre a autocorrelação da voz feminina')
grid;

%--------- questao 5
%estima a largura de banda essencial
h_E = sum(abs(h_y.^2));
h_bw = 0.95 * h_E;

m_E = sum(abs(m_y.^2));
m_bw = 0.95 * m_E;

%--------- questao 6
%filtra o sinal em um passa-baixa de frequencia de corte 1kHz
h_dft = fftshift(fft(h_y));
h_index=round(1000/(h_fs/length(h_y)));

h_zeros=zeros(1,length(h_dft)/2-h_index);
h_ones=ones(1,h_index);
h_filter=[h_zeros,h_ones,h_ones,h_zeros];

h_signal_filtered = h_dft.*h_filter';
h_signal_filtered = fftshift(h_signal_filtered);
h_signal_filtered = real(ifft(h_signal_filtered));
% sound(h_signal_filtered);
h_f = 0:h_fs/length(h_y):h_fs-(h_fs/length(h_y));
figure;
plot(h_f,h_y, 'r')
xlabel('frequencias');
hold;
plot(h_f,h_signal_filtered, 'b')
legend('sinal amostrado','sinal filtrado');

m_dft = fftshift(fft(m_y)); 
m_index=round(1000/(m_fs/length(m_y)));

m_zeros=zeros(1,length(m_dft)/2-m_index);
m_ones=ones(1,m_index);
m_filter=[m_zeros,m_ones,m_ones,m_zeros];

m_signal_filtered = m_dft.*m_filter';
m_signal_filtered = fftshift(m_signal_filtered);
m_signal_filtered = real(ifft(m_signal_filtered));
% sound(m_signal_filtered);
m_f = 0:m_fs/length(m_y):m_fs-(m_fs/length(m_y));
figure;
plot(m_f,m_y, 'r')
xlabel('frequencias')
hold;
plot(m_f,m_signal_filtered, 'b')
legend('sinal amostrado','sinal filtrado');

%--------- questao 7
%adiciona ruido branco gaussiano com RSR 3 e 10 dB e plota a DEP com ruido
h_noised_3 = awgn(h_y, 3, 'measured');
%sound(h_noised_3);

h_xcorr_noised_3 = xcorr(h_noised_3, 'coeff');
h_pds_noised_3 = abs(fftshift(fft(h_xcorr_noised_3)));
h_freq_3 = -h_fs/2:h_fs/length(h_xcorr_noised_3):h_fs/2-(h_fs/length(h_xcorr_noised_3));
figure;
plot(h_freq_3, h_pds_noised_3)
ylabel('potência (dB)')
xlabel('frequencia (Hz)')
title('DEP da voz masculina com ruído gaussiano de RSR 3dB')
grid;

h_noised_10 = awgn(h_y, 10, 'measured');
%sound(h_noised_10);

h_xcorr_noised_10 = xcorr(h_noised_10, 'coeff');
h_pds_noised_10 = abs(fftshift(fft(h_xcorr_noised_10)));
h_freq_10 = -h_fs/2:h_fs/length(h_xcorr_noised_10):h_fs/2-(h_fs/length(h_xcorr_noised_10));
figure;
plot(h_freq_10, h_pds_noised_10)
ylabel('potência (dB)')
xlabel('frequencia (Hz)')
title('DEP da voz masculina com ruído gaussiano de RSR 10dB ')
grid;

m_noised_3 = awgn(m_y, 3, 'measured');
%sound(m_noised_3);

m_xcorr_noised_3 = xcorr(m_noised_3, 'coeff');
m_pds_noised_3 = abs(fftshift(fft(m_xcorr_noised_3)));
m_freq_3 = -m_fs/2:m_fs/length(m_xcorr_noised_3):m_fs/2-(m_fs/length(m_xcorr_noised_3));
figure;
plot(m_freq_3, m_pds_noised_3)
ylabel('potência (dB)')
xlabel('frequencia (Hz)')
title('DEP da voz feminina com ruído gaussiano de RSR 3dB')
grid;

m_noised_10 = awgn(m_y, 10, 'measured');
%sound(m_noised_10);

m_xcorr_noised_10 = xcorr(m_noised_10, 'coeff');
m_pds_noised_10 = abs(fftshift(fft(m_xcorr_noised_10)));
m_freq_10 = -m_fs/2:m_fs/length(m_xcorr_noised_10):m_fs/2-(m_fs/length(m_xcorr_noised_10));
figure;
plot(m_freq_10, m_pds_noised_10)
ylabel('potência (dB)')
xlabel('frequencia (Hz)')
title('DEP da voz feminina com ruído gaussiano de RSR 10dB ')
grid;

%--------- questao 8
%implementar um filtro de weiner 
h_w = h_y ./ h_noised_3; %h_noised_3 = h_y + h_noised_3dB
h_filtered = h_w .* h_noised_3;
%sound(h_filtered);

figure;
plot(h_noised_3, 'r')
xlabel('tempo (segundos)')
hold;
plot(h_filtered, 'b')
xlabel('tempo (segundos)')
legend('sinal com ruído de 3dB', 'sinal filtrado');
title('Sinal de voz masculina filtrado usando filtro de Wiener');

m_w = m_y ./ m_noised_3; %h_noised_3 = h_y + h_noised_3dB
m_filtered = m_w .* m_noised_3;
%sound(m_filtered);

figure;
plot(m_noised_3, 'r')
xlabel('tempo (segundos)')
hold;
plot(m_filtered, 'b')
xlabel('tempo (segundos)')
legend('sinal com ruído de 3dB', 'sinal filtrado');
title('Sinal de voz feminina filtrado usando filtro de Wiener');