%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UNIVERSIDAD AUTÓNOMA DE OCCIDENTE
% GRUPO DE MEC�?NICA DE FLUIDOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Caracterización en frecuencia de
% sensores/actuadores piezoeléctricos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % borrando variables
clc;
clear all;
close all;

% Rango de frecuencias a analizar
% f1 = 1e3;
% f2 = 10e3;
% hf = 1e3;
f1 = 10e3;
f2 = 2e6;
hf = 100;

f = [f1:hf:f2];
Nf = length(f);

% Generador de señales
gen = tcpip('192.168.1.100','RemotePort',5025)
fopen(gen)
%fprintf(gen,'APPL:SIN 10 KHZ, 3.0 VPP, 0.0 V');

% osciloscopio
osc = tcpip('192.168.1.102','RemotePort',5025)
set(osc,'InputBufferSize',200000)
set(osc,'OutputBufferSize',81920) 
set(osc,'Timeout',200)
set(osc,'TransferDelay','off')
fopen(osc)


dir_root=pwd;
% cont = 501

T = zeros(Nf,1);

for(k=1:Nf)

	% --------signal generator------- 
	disp(char(strcat('Acq:',{' ' },num2str(k),'/',num2str(Nf))))
	str1 = strcat('APPL:SIN ',{' '},num2str(f(k)),' HZ, 10.0 VPP, 0.0 V');
	fprintf(gen,char(str1));
	
	% --------- acq in -------
	[s,Ts]=readOsc1(osc,1/f(k));
	str2=strcat(dir_root,'/in/i',num2str(f(k)),'.mat');
	T(k) = Ts;
	save(str2,'s')

	% --------- acq out -------
	s=readOsc2(osc,1/f(k));
	str2=strcat(dir_root,'/out/i',num2str(f(k)),'.mat');
	save(str2,'s')

% 	cont = cont + 1;

end

str3=strcat(dir_root,'/T/T2.mat');
save(str3,'T')

% Cierra las conexiones
fclose(gen)
fclose(osc)


