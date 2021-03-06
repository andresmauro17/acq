% DSO6052A.M
% 
% Programa de ejemplo para adquir una forma de onda desde el DSO6052 utilizando la red LAN
% 
% Nico 8/5/08

% Primero hay que obtener la direccion ip del osciloscopio.
% Para ello presionar la tecla [utility]
% Presionar el [I/O]
% Alli aparece la ip del equipo.
% Hay que verificar que este configurado para tener la interfase remota LAN
%
% La ip cambia si esta configurado el DHCP, en este ejemplo es la "192.168.0.109"
% El puerto es 5025

% Para abrir el instrumento TCP:
osc = tcpip('192.168.1.102','RemotePort',5025)

% Debe verse algo como:
%
%    TCP/IP Object : TCP/IP-192.168.0.109
%
%    Communication Settings 
%       RemotePort:         5025
%       RemoteHost:         192.168.0.109
%       Terminator:         'LF'
% 
%    Communication State 
%       Status:             closed
%       RecordStatus:       off
% 
%    Read/Write State  
%       TransferStatus:     idle
%       BytesAvailable:     0
%       ValuesReceived:     0
%       ValuesSent:         0
      
% configura el tamanio del bufer de entrada y salida, aqui esta para 8k puntos      
set(osc,'InputBufferSize',200000)
set(osc,'OutputBufferSize',81920)
set(osc,'Timeout',200)
set(osc,'TransferDelay','off')

% Ya esta difido el instrumento TCP
% Ahora se abre como un archivo
fopen(osc)

% Los comando se envian utilizando fprintf
% Por ejemplo pedimos identificacion del equipo
fprintf(osc,'*IDN?')

% Las respuestas se leen con fscanf
fscanf(osc)

% configura para tener los datos en ascii y medir en el canal uno
    fprintf(osc,':WAVEFORM:SOURCE CHAN1');
    fprintf(osc,':ACQUIRE:TYPE NORM');
    fprintf(osc,':ACQUIRE:COMPLETE 100');
    fprintf(osc,':WAVEFORM:FORMAT ASCII');
    
    fprintf(osc,':WAV:POIN:MODE RAW ');
    fprintf(osc,':DIGITIZE CHAN1');
    fprintf(osc,':TIM:RANG 2E-4')
    fprintf(osc,':TIM:SCAL 2E-4')
    
    fprintf(osc,':ACQ:POIN 10000');
    fprintf(osc,':WAVEFORM:POINTS 10000');
     
% lee las escalas de timpo y voltaje
    fprintf(osc,':WAV:XINC?');
    xinc = str2num(fscanf(osc))
    
    fprintf(osc,':WAV:XOR?');
    xor = str2num(fscanf(osc))
    
    fprintf(osc,':WAV:XREF?');
    xref = str2num(fscanf(osc))
    
    fprintf(osc,':WAV:YINC?');
    yinc = str2num(fscanf(osc));
    
    fprintf(osc,':WAV:YOR?');
    yor = str2num(fscanf(osc));
    
    fprintf(osc,':WAV:YREF?')
    yref = str2num(fscanf(osc));
     
% Digitaliza y manda aquirir
fprintf(osc,':DIGITIZE CHAN1');
fprintf(osc,':WAV:DATA?');

% Lee los datos y hace la escala de tiempo y voltaje
datos = fscanf(osc);
datos = str2num(datos(11:length(datos)));
%senial=(datos-yref)*yinc; %equipamentos novos n�o precisam mais desse comando 
%(usar comando abaixo)
senial=datos;
senial=senial-mean(senial);
t=0:xinc:xinc*(length(senial)-1);

 % Pone el osciloscopio en run  
fprintf(osc,':RUN')

close all
plot(t,senial)
% cierra la comunicacion con el instrumento
fclose(osc)
