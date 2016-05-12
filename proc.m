in_root = 'in/';
out_root = 'out/';

Ts = load('T/T.mat');
fs = 1./(Ts.T);
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
	ph(k) = angle(ft1(idx1)) - angle(ft2(idx2));
end

f1 = 1e3;
f2 = 1000e3;
hf = 1e3;
f = [f1:hf:f2];

subplot(2,1,1)
plot(f/1e3,m)
xlabel('f (kHz)')
ylabel('Amplitud')
grid
subplot(2,1,2)
plot(f/1e3,ph*180/pi)
xlabel('f (kHz)')
ylabel('Fase (grados)')
grid


