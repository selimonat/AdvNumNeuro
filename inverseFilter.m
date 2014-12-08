function p = inverseFilter(s,r)
%
% p = inverseFilter(y,h,gamma,d);
%
% S = R*P, we are trying to recover P, which is convolved with R to obtain
% S, the observed Signal.
%
% Generalized inverse filtering using threshold gamma:
%
%  inv_g(R) = gamma*abs(fft(r))/fft(r), if abs(fft(r)) <= 1/gamma
%  inv_g(R) = inv(R),			otherwise
%
% Reference: J.S.Lim,"Two dimensional signal and image processing", 
%            Prentice Hall, 1990- pg.552 Eq.(9.50)
%
%d is a vector of the form d(m)= exp(-i*w*m) that takes care of the delay
%that the linear phase inverse filter causes in th etime domain
gamma = 1000000;

N= length(s);
S = fft(s,max(length(s),length(r)));% result of convolution
R = fft(r,max(length(s),length(r)));% impulse response

% Replace zeros with 1/gamma. This is basically a thesholding
fprintf('Detected %d zero values in the amplitude spectrum (out of %d).\n',sum((abs(R)==0)),length(S));
R1 = R.*(abs(R)>0) + 1/gamma.*(abs(R)==0);
iR = 1./R1;
%  
% invert Hf using threshold gamma
G = iR.*(abs(R)*gamma>1) + gamma*abs(R1).*iR.*(abs(R1)*gamma<=1);
% G = iR;
% figure(2);
% plot(fftshift((abs(G))));

% G = 1./R;
% p = real(ifft(S.*G.*d));
p = real(ifft(S.*G));
