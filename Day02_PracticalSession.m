%% Verify that the power spectrum of an impulse function is white.


% (a) Generate a hrf function (b) a vector of periodic binary events,
% (c) a vector with randomly binary events. Plot a, b, c in a row. Compute
% their Fourier transform and plot their power spectra below, so that you
% have 6 figures organized as a 2 by 3 matrix.


%% 2D Fourier transform
%In order to understand the k-space we need to get familiar with the 2D
%Fourier transform and get an intuitive feeling of the information that
%are represented by different Fourier components.
%Let's compute the 2D Fourier transform of the baboon picture with fft2()
%after transforming it to grayscale. You should 
%observe some interesting points when you
%visualize its power spectra. Apply fftshift() to the Fourier
%transform and also visualize in the log10 scale. 



% How this power spectra compares to the power spectra of a random image.
% Create a image consisting of random numbers the same size as baboon
% image, and visualize its power spectra. 



%We would like to mask
%(make it equal to zero) different Fourier components and inverse transform
%back to the pixel space in order to see the contribution of different
%spatial frequencies. First of all let's zero the central part in the
%Fourier space. It would be very nice if you could create a function
%that returns you a mask with relevant parameters i.e. diameter. 



% We were focusing a lot on the amplitudes so far, what about the phase
% information? What is the effect of destroying the phase information? So
% let's create random phases and mix them with the amplitude information of
% that we have in the Fourier space, and inverse it back to the pixel
% space. What do you see? 

