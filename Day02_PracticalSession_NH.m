%% Verify that the power spectrum of an impulse function is white.
% (a) Generate a hrf function (b) a vector of periodic binary events,
% (c) a vector with randomly binary events. Plot a, b, c in a row. Compute
% their Fourier transform and plot their power spectra below, so that you
% have 6 figures organized as a 2 by 3 matrix.

clear all
close all
addpath('C:\Users\herweg\Documents\workshops\advanced_numerical_methods');

srate = 1000;
npoints = srate*100;
[hrf]=spm_hrf(0.005);
events_per = zeros(1,npoints);
events_per(1,[1000,70000]) = 1;%[1:1000:10000]
events_rand = zeros(1,npoints);
randpos = round(rand(1,10)*npoints);
events_rand(1,randpos) = 1;


Nyquist = srate/2;
freq = linspace(0,Nyquist,(length(events_per)/2+1))';
hz = find (freq==0.4);

figure
subplot(2,3,1)
plot(hrf*500)
subplot(2,3,2)
plot(events_per,'r')

subplot(2,3,3)
plot(events_rand,'g')

pow_hrf = fft(hrf);
pow_events_per = fft(events_per);
pow_events_rand = fft(events_rand);

subplot(2,3,4)
plot(abs(pow_hrf))
subplot(2,3,5)
plot(freq(1:hz),abs(pow_events_per(1:hz)),'r')
subplot(2,3,6)
plot(abs(pow_events_rand),'g');


%% 2D Fourier transform
%In order to understand the k-space we need to get familiar with the 2D
%Fourier transform and get an intuitive feeling of the information that
%are represented by different Fourier components.
%Let's compute the 2D Fourier transform of the baboon picture with fft2()
%after transforming it to grayscale. You should
%observe some interesting points when you
%visualize its power spectra. %Apply fftshift() to the Fourier
%transform and also visualize in the log10 scale.

baboon =imread('baboon.jpg');
baboon =  mean(baboon,3);
figure
subplot(2,2,1)
imagesc(baboon);
colormap(gray);

baboon_pow = fft2(baboon);
subplot(2,2,2)
imagesc(fftshift(log10(abs(baboon_pow))));

% How this power spectra compares to the power spectra of a random image.
% Create a image consisting of random numbers the same size as baboon
% image, and visualize its power spectra.

rand_img = rand(size(baboon,1),size(baboon,2));
rand_img_pow = fft2(rand_img);

subplot(2,2,3)
imagesc(rand_img);

subplot(2,2,4)
imagesc(fftshift(log10(abs(rand_img_pow))));

%We would like to mask
%(make it equal to zero) different Fourier components and inverse transform
%back to the pixel space in order to see the contribution of different
%spatial frequencies. First of all let's zero the central part in the
%Fourier space. It would be very nice if you could create a function
%that returns you a mask with relevant parameters i.e. diameter.

mask = Circle (20);
inv_mask = ~mask;

themask = inv_mask;
themask = [ones(size(mask,1),(size(baboon,1)-size(mask,1))/2),themask,ones(size(mask,1),(size(baboon,1)-size(mask,1))/2)];
themask = [ones((size(baboon,1)-size(themask,1))/2,size(themask,2)); themask; ones((size(baboon,1)-size(themask,1))/2,size(themask,2))];

figure
subplot(2,2,2)
masked_baboon_pow = themask.*fftshift(baboon_pow);
imagesc(log10(abs(masked_baboon_pow)))
colormap(gray)

rec_mask_baboon1 = ifft2(fftshift(masked_baboon_pow));
subplot(2,2,1)
imagesc(real(rec_mask_baboon1))
colormap(gray)

mask = Circle (30);
themask = mask;
themask = [zeros(size(mask,1),(size(baboon,1)-size(mask,1))/2),themask,zeros(size(mask,1),(size(baboon,1)-size(mask,1))/2)];
themask = [zeros((size(baboon,1)-size(themask,1))/2,size(themask,2)); themask; zeros((size(baboon,1)-size(themask,1))/2,size(themask,2))];

subplot(2,2,4)
masked_baboon_pow = themask.*fftshift(baboon_pow);
imagesc(log10(abs(masked_baboon_pow)))
colormap(gray)

rec_mask_baboon2 = ifft2(fftshift(masked_baboon_pow));
subplot(2,2,3)
imagesc(real(rec_mask_baboon2))
colormap(gray)

% We were focusing a lot on the amplitudes so far, what about the phase
% information? What is the effect of destroying the phase information? So
% let's create random phases and mix them with the amplitude information of
% that we have in the Fourier space, and inverse it back to the pixel
% space. What do you see? 

mag =  abs(baboon_pow);
phase = angle(baboon_pow);
%phasenew = phase + 4*(rand(size(baboon_pow))-0.5);
phasenew = angle(rand_img_pow);
%% another way of implementing the random phase while respecting the symmetry structure
% create a random image in the pixel space, use its phase spectrum, which
% is necessarily also random.
phasenew = angle(fft2(rand(size(mag))));

% Calculate phasenew using some algorithm, phasenew is very similar to phase, so output should be same.

re = mag .* cos(phasenew);
im = mag .* sin(phasenew);
baboon_pow_randphase = complex(re,im);
baboon_randphase     = ifft2(baboon_pow_randphase);
%baboon_randphase should now have very very small imaginary parts, that can
%safely be discarded
baboon_randphase = real(baboon_randphase);
% rand_baboon_pow = baboon_pow+100000*rand(size(baboon_pow))*i;
% 
% rec_rand_baboon = ifft2(rand_baboon_pow);
figure

imagesc(baboon_randphase)
colormap(gray)
colorbar
