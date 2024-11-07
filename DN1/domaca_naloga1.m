filename1 = "naloga1_1.txt";
delimiterIn = '';
headerlinesIn = 2;
podatki1 = importdata(filename1, delimiterIn, headerlinesIn);
t = podatki1.data;
%Naloga2
filename2 = "naloga1_2.txt";
fid = fopen(filename2);
vrstica1 = fgetl(fid);
vrstica1_split = split(vrstica1, ':');
st_vrstic = str2double(vrstica1_split(2));
P = zeros(1,st_vrstic);
for i = 1:st_vrstic
    vrstica1 = fgetl(fid); 
    P(i) = str2double(vrstica1);
end
%Narisat graf
figure;
plot(t,P);
xlabel('t[s]');
ylabel('P[w]');
title('Graf P(t)');
grid on;
%Naloga 3
delta_t = t(2) - t(1);
vsota_integrala = 0;

vsota_integrala = vsota_integrala + P(1) + P(end);

for i = 2:length(P) - 1
    vsota_integrala = vsota_integrala + 2 * P(i);
end

vsota_integrala = vsota_integrala * (delta_t / 2);

fprintf('Vrednost integrala z uporabo trapezne metode: %.4f\n', vsota_integrala);

trapz_result = trapz(t, P);
fprintf('Vrednost integrala z MATLAB funkcijo trapz: %.4f\n', trapz_result)