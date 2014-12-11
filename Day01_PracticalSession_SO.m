%% some necessary variables..
tevents       = 20;
sampling_rate = 100;%Hz
duration      = 600;%seconds
conditions    = 2;
tsample       = duration*sampling_rate;
pad_amount    = 30;%in seconds
beta          = [1 2 4 6 8];
beta          = beta(1:conditions);
%%
error_noise   = 0;%std(responses)/50;
error_drive   = 0.5;
%% create an event matrix
onsets        = zeros(tevents,conditions);
event_matrix  = zeros(tsample,conditions);
for nc = 1:conditions
    onsets(:,nc)       = round(rand(tevents,1)*duration);%onsets in seconds
    event_matrix(onsets(:,nc)*sampling_rate,nc) = ones(1,tevents)+randn(1,tevents)*error_drive;
end
event_matrix  = padarray(event_matrix,[pad_amount*sampling_rate 0],'post');%only pad the end.
%% impulse response and convolution
ir            = spm_hrf(1/sampling_rate)';
design_matrix_noisy = conv2(event_matrix,ir(:));
design_matrix = conv2(double(logical(event_matrix)),ir(:));
time_axis     = (0:length(design_matrix)-1)/sampling_rate;
%% get responses
responses = design_matrix_noisy*beta' + randn(length(design_matrix),1)*error_noise;
%% plot dm and onsets
figure(1);
subplot(2,1,1)
plot(time_axis,responses);
hold on;
plot([onsets(:) onsets(:)],ylim,'ro-')
hold off
xlabel('time (seconds)')
ylabel('a.u.');
title('Convolution == Responses (blue) and Onsets (red)')
%% Make a deconvolution
drive       = inverseFilter(responses, ir(:));
%% plot the result
figure(1);
subplot(2,1,2)
plot(time_axis,drive,'bo-');
axis tight;
hold on;
plot([onsets(:) onsets(:)],ylim,'ro-')
hold off
title('Deconvolution == Sources (blue) and Onsets (red)')
%% recorver the beta values
beta_estimated = drive(1:length(event_matrix),:)'*event_matrix
beta_estimated(1)./beta_estimated(2)
%% normal GLM estimation
[design_matrix ones(length(design_matrix),1)]\responses

