function s=readOsc2(osc,rang)

% configura el tamanio del bufer de entrada y salida, aqui esta para 8k puntos      
%set(osc,'InputBufferSize',200000)
%set(osc,'OutputBufferSize',81920)
%set(osc,'Timeout',200)
%set(osc,'TransferDelay','off')

% Ya esta difido el instrumento TCP
% Ahora se abre como un archivo
%fopen(osc)

% Los comando se envian utilizando fprintf
% Por ejemplo pedimos identificacion del equipo
%fprintf(osc,'*IDN?')

% Las respuestas se leen con fscanf
%fscanf(osc)

% configura para tener los datos en ascii y medir en el canal uno
    fprintf(osc,':WAVEFORM:SOURCE CHAN2');
    fprintf(osc,':ACQUIRE:TYPE NORM');
    fprintf(osc,':ACQUIRE:COMPLETE 100');
    fprintf(osc,':WAVEFORM:FORMAT ASCII');
    fprintf(osc,':WAV:POIN:MODE RAW ');

    fprintf(osc,':DIGITIZE CHAN2');
    str1 = strcat(':TIM:RANG  ',{' '},num2str(rang));
    fprintf(osc,char(str1))
    str2 = strcat(':TIM:SCAL  ',{' '},num2str(2*rang));
    fprintf(osc,char(str2))
    fprintf(osc,':ACQ:POIN 10000');
    fprintf(osc,':WAVEFORM:POINTS 10000');
     
% lee las escalas de timpo y voltaje
    fprintf(osc,':WAV:XINC?');
    xinc = str2num(fscanf(osc));
    
    %fprintf(osc,':WAV:XOR?');
    %xor = str2num(fscanf(osc));
    
    %fprintf(osc,':WAV:XREF?');
    %xref = str2num(fscanf(osc));
    
    %fprintf(osc,':WAV:YINC?');
    %yinc = str2num(fscanf(osc));
    
    %fprintf(osc,':WAV:YOR?');
    %yor = str2num(fscanf(osc));
    
    %fprintf(osc,':WAV:YREF?')
    %yref = str2num(fscanf(osc));
     
% Digitaliza y manda aquirir
fprintf(osc,':DIGITIZE CHAN2');
fprintf(osc,':WAV:DATA?');
% Lee los datos y hace la escala de tiempo y voltaje
datos = fscanf(osc);
datos = str2num(datos(11:length(datos)));
%senial=(datos-yref)*yinc; %equipamentos novos não precisam mais desse comando 
%(usar comando abaixo)
s=datos;
s=s-mean(s);
%t=0:xinc:xinc*(length(senial)-1);

 % Pone el osciloscopio en run  
fprintf(osc,':RUN')

%plot(t,senial)
%size(senial)
