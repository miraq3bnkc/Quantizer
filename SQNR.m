function sqnr = SQNR(x,xq)

%Parameters
%x: signal
%xq: quantized signal of x

Sound=mean(x.^2);
noise= abs(x-xq);
Noise=mean(noise.^2);

sqnr=10*log10(Sound/Noise);
%in decibels

fprintf('The SQNR is equal to : %.4fdB\n',sqnr);

end