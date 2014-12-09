%% Verify that the power spectrum of an impulse function is white.
clear
close all
clc

srate = 100;

% (a) Generate a hrf function 
hrf=spm_hrf(0.01);


% (b) a vector of periodic binary events,
events_periodic = zeros(50000,1);
eventpos = 1:1000:50000;
events_periodic(eventpos) = 1;

% (c) a vector with randomly binary events. 
events_rand = zeros(50000,1);
events_rand(1:50,1) = 1;
events_rand(:,2) =rand(50000,1);
events_rand = sortrows(events_rand,2);
events_rand(:,2) = [];

%Plot a, b, c in a row.
figure
subplot(331)
plot(hrf)
hold on
subplot(332)
plot(events_periodic)
subplot(333)
plot(events_rand)

datp = 2^nextpow2(50000);

% Compute their Fourier transform 
fft_hrf = fft(hrf,datp);
fft_per = fft(events_periodic,datp);
fft_rand = fft(events_rand,datp);

%and plot their power spectra below, so that you
% have 6 figures organized as a 2 by 3 matrix.

freq = linspace(0,50,(length(fft_hrf)/2+1))';
freqhrf = linspace(0,50,(length(fft_hrf)/2+1))';
hz =  min(find(freq>=0.2));
hzhrf = min(find(freqhrf>=0.2));

subplot(334)
plot(freqhrf(1:hzhrf),abs(fft_hrf(1:hzhrf)))
subplot(335)
plot(freq(1:hz),abs(fft_per(1:hz)))
subplot(336)
plot(freq(1:hz),abs(fft_rand(1:hz)))

fft_mult_per = fft_per.*fft_hrf;
fft_mult_rand = fft_rand.*fft_hrf;

subplot(337)
plot(freq(1:hz),abs(fft_mult_per(1:hz)),'r')
hold on
plot(freq(1:hz),abs(fft_mult_rand(1:hz)),'g')

ifft_mult_per= ifft(fft_mult_per);
ifft_mult_rand= ifft(fft_mult_rand);

subplot(338)
plot(ifft_mult_per(1:50000))

subplot(339)
plot(ifft_mult_rand(1:50000))
hold on
plot(conv(events_rand,hrf),'*r')

%% 2D Fourier transform
%In order to understand the k-space we need to get familiar with the 2D
%Fourier transform and get an intuitive feeling of the information that
%are represented by different Fourier components.
%Let's compute the 2D Fourier transform of the baboon picture with fft2()
%after transforming it to grayscale. 
%You should
%observe some interesting points when you
%visualize its power spectra. Apply fftshift() to the Fourier
%transform and also visualize in the log10 scale.


baboon = imread('baboon.jpg');
graybab = rgb2gray(baboon);
figure
imagesc(graybab)
colormap(gray)
fft_baboon = fft2(graybab);
figure
imagesc(fftshift(log10(abs(fft_baboon))));
colormap(gray)


% How this power spectra compares to the power spectra of a random image.
% Create a image consisting of random numbers the same size as baboon
% image, and visualize its power spectra.

rand_im = rand(size(graybab));
figure
subplot(121)
imagesc(rand_im)
colormap(gray)
fft_rand_im = fft2(rand_im);
subplot(122)
imagesc(fftshift(log10(abs(rand_im))));
colormap(gray)

%We would like to mask
%(make it equal to zero) different Fourier components and inverse transform
%back to the pixel space in order to see the contribution of different
%spatial frequencies. First of all let's zero the central part in the
%Fourier space. It would be very nice if you could create a function
%that returns you a mask with relevant parameters i.e. diameter.
rad = 30;
ci = [256,256,rad];
imageSize = size(graybab);
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
mask = (xx.^2 + yy.^2)<ci(3)^2;
mask = ~mask;
mask = +mask;
maskedbab = fftshift(log10(abs(fft_baboon))).*mask;
mbab = fftshift(fft_baboon) .*mask;
figure
subplot(142)
imagesc(maskedbab)
colormap(gray)

ifft_mbab = ifft2(fftshift(mbab));
subplot(143)
imagesc(real(ifft_mbab))
colormap(gray)

subplot(141)
imagesc(graybab)
% colorbar(gray)

mask = ~mask;
mask = +mask;
maskedbab = fftshift(log10(abs(fft_baboon))).*mask;
mbab = fftshift(fft_baboon) .*mask;
ifft_mbab = ifft2(fftshift(mbab));

subplot(144)
imagesc(real(ifft_mbab))
colormap(gray)

% We were focusing a lot on the amplitudes so far, what about the phase
% information? What is the effect of destroying the phase information? So
% let's create random phases and mix them with the amplitude information of
% that we have in the Fourier space, and inverse it back to the pixel
% space. What do you see? 


