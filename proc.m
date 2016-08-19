in_root = 'in/';
out_root = 'out/';

Ts = load('T/T2.mat');
fs = 1./(Ts.T2);
Nf = length(fs);

m = zeros(Nf,1);
ph = zeros(Nf,1);

for(k=1:Nf)
	disp(k)
	str1 = strcat(in_root,'i',num2str(k),'.mat');
	a = load(str1);
	s1 = a.s';

	str2 = strcat(out_root,'i',num2str(k),'.mat');
	a = load(str2);
	s2 = a.s';

	s1 = s1-mean(s1);
	s2 = s2-mean(s2);

	ft1 = fft(s1,64*1024);
	ft2 = fft(s2,64*1024);
	[amp1,idx1] = max(abs(ft1(1:32*1024)));
	[amp2,idx2] = max(abs(ft2(1:32*1024)));
	m(k) = amp2/amp1;
	ph(k) = -angle(ft1(idx1)) + angle(ft2(idx1));
	am(k) = max(s2);
	vr = am(k)*cos(ph(k));
	vi = am(k)*sin(ph(k));
	vm(k) = vr + j*vi;
end

f1 = 1e3;
f2 = 1000e3;
hf = 1e3;
f = [f1:hf:f2];

Ve = 2.5;
R = 127;
Z = Ve./vm;

subplot(2,1,1)
plot(f/1e3,am/R)
xlabel('f (kHz)')
ylabel('Amplitud (A)')
title('Corriente')
grid
subplot(2,1,2)
plot(f/1e3,ph*180/pi)
xlabel('f (kHz)')
ylabel('Fase (grados)')
grid

figure
subplot(2,1,1)
semilogy(f/1e3,abs(Z))
xlabel('f (kHz)')
ylabel('Amplitud')
title('Impedancia (Ohm)')
grid
subplot(2,1,2)
plot(f/1e3,angle(Z)*180/pi)
xlabel('f (kHz)')
ylabel('Fase (grados)')
grid



