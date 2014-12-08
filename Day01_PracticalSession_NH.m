%% This is the Practical Session of AdvNumNeuro Lecture 12.2014.
% Your task is to fill in empty spaces in this .m file with your own code based
% what we have learnt in the theoretical part. In case you prefer Octave or
% Python that is also fine. To proceed please download the Github
% repository from AdvNumNeuro (located in ...), this repository contains
% few .mat files that will be necessary for the rest of this session.
%% ============CONVOLUTION==================================================================================
% In this section, using convolution we will generate some time-series data that will
% ressemble to the activity of a single voxel recorded during an
% event-related design. These will consist of simulated
% BOLD responses evoked by individual stimuli presented at speeds much faster than BOLD responses.
% Following this step we will analyze this data using deconvolution and
% generic GLM models. Have a look at the Convolution.png file to get an
% idea.
% Say we recorded 600 seconds of BOLD responses at a sampling rate of 100Hz
% (this is highly unrealistic, but why not). We had 2 conditions and 50
% repetitions each. In order to generate BOLD responses, you will need to
% create a binary event matrix of size [#samples #conditions]. Following
% this you will have to convolve this matrix with the hemodynamic response
% kernel, the BOLD impulse response. Use spm_hrf for getting this response
% kernel. The convolution will produce a response profile specific for each conditions. And let's assume
% that condition 2 generates 2 times stronger responses than condition 1.
% So the weight vector [2 4] could be used to mix the design matrix into simulated responses. Once you have
% these variables please plot the design matrix and responses as shown in Convolution.png.
% CODE HERE:
clear all
close all
addpath('C:\Users\herweg\Documents\workshops\advanced_numerical_methods');

srate = 100;
time = 1:1000/srate:600001;
ncond = 2;
nevents = ncond*50;
nsamples = size(time,2);
designmat (1:nevents/ncond,1) = 1;
designmat (nevents/ncond+1:nevents,2) = 1;
designmat (1:nsamples,3) = rand(1,nsamples)';
designmat = sortrows(designmat,3);
designmat(:,3) = [];
weights = [2 4];
sim_resp = designmat * weights';
[hrf]=spm_hrf(0.01);

conv_res = conv(sim_resp,hrf);
plot(time/1000,sim_resp);
hold on
ext_time = 1:1000/srate:632001;
plot(ext_time/1000,conv_res(1:size(ext_time,2),1)*100,'r');




% Imagine that the data you created above represents BOLD time-series
% recorded during an experiment and you would like to know the underlying
% neuronal activity. This is most useful when
% neuronal events occur in temporal proximity, thus generating overlapping
% recorded responses. Using the deconvolution technique implemented in
% inverseFilter.m try to recover the original mixing weights. Do the same
% also using a simple glm. In matlab you can do that with DM\R = weights,
% where DM is your design matrix and R observed responses.
% CODE HERE:
% Above, we cheated totally because we created the impulse
% responses ourselves, we thus knew the kernel perfectly. How could we proceed if we didn't
% know the kernel? Make an estimation of the kernel based on the data and
% repeat the same exercice as above.
% CODE HERE:
% We were still cheating a lot :), because we didn't have any noise in our
% responses, which is not possible in a real physiological experiment. So
% let's add some random noise with amplitude, A, simulating the recording
% noise. Do what you did above for different values of A. Compare
% deconvolution and GLM techniques. Which one is more sensitive?
% CODE HERE:
% If you are still alive now, let's compare the above situation (additive
% external random noise) to the case where the noise is added when
% neuronal responses are generated (additive internal noise). How can you
% explain that in this scenario the deconvolution method is not as
% sensitive as above to noise amplitude.
% CODE HERE: