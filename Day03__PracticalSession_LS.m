%Advanced Numerical Analysis in Neurosciences Class
%8.12.14-11.12.14  Day03 by JF/SO
%Day03 Practical Session

% % ex1 MR Image Rekonstruction
% rawdata=read_dat('flash_1mm_384mm');
% data=rawdata;
% fdata=fft2(data);
% imagesc(abs(fftshift(fdata)));
% colormap(gray);

% %ex2 Spike Artefact
% data=rawdata;
% x=10;
% y=0;
% data(round(size(data,1)/2)+y,round(size(data,2)/2)-62+x)=100;
% fdata=fft2(data);
% imagesc(abs(fftshift(fdata)));

% %ex3 Resolution
% rawdata1=read_dat('flash_1mm_384mm');
% rawdata3=read_dat('flash_3mm_384mm');
% rawdata6=read_dat('flash_6mm_384mm');
% data1=rawdata1;
% data3=rawdata3;
% data6=rawdata6;
% subplot(3,2,1);
% imagesc(abs((data1)));
% subplot(3,2,3);
% imagesc(abs((data3)));
% subplot(3,2,5);
% imagesc(abs((data6)));
% fdata1=fft2(data1);
% fdata3=fft2(data3);
% fdata6=fft2(data6);
% subplot(3,2,2);
% imagesc(abs(fftshift(fdata1)));
% subplot(3,2,4);
% imagesc(abs(fftshift(fdata3)));
% subplot(3,2,6);
% imagesc(abs(fftshift(fdata6)));

% %ex4 Field of View
% rawdata384=read_dat('flash_1mm_384mm');
% rawdata192=read_dat('flash_1mm_192mm');
% rawdata96=read_dat('flash_1mm_96mm');
% data384=rawdata384;
% data192=rawdata192;
% data96=rawdata96;
% subplot(3,2,1);
% imagesc(abs((data384)));
% subplot(3,2,3);
% imagesc(abs((data192)));
% subplot(3,2,5);
% imagesc(abs((data96)));
% fdata384=fft2(data384);
% fdata192=fft2(data192);
% fdata96=fft2(data96);
% subplot(3,2,2);
% imagesc(abs(fftshift(fdata384)));
% subplot(3,2,4);
% imagesc(abs(fftshift(fdata192)));
% subplot(3,2,6);
% imagesc(abs(fftshift(fdata96)));

% %ex5 EPI
% rawflash=read_dat('flash_1mm_192mm');
% rawepi=read_dat('epi-se_2mm');
% flash=rawflash;
% epi=rawepi;
% subplot(2,3,1);
% imagesc(log10(abs((flash))));
% subplot(2,3,2);
% imagesc(log10(abs((epi))));
% fflash=fft2(flash);
% fepi=fft2(epi);
% subplot(2,3,4);
% imagesc(abs(fftshift(fflash)));
% subplot(2,3,5);
% imagesc(abs(fftshift(fepi)));
%
% %removing first few lines
% epi2=epi(4:end,:);
% subplot(2,3,3);
% imagesc(log10(abs((epi2))));
% fepi2=fft2(epi2);
% subplot(2,3,6);
% imagesc(abs(fftshift(fepi2)));

% %ex6 N/2 ghosting
% flash=rawflash;
% gflash=flash;
% gflash(1:2:end,:)=flash(1:2:end,:)*3;
% subplot(1,3,1);
% imagesc(log10(abs((flash))));
% subplot(1,3,2);
% imagesc(log10(abs((gflash))));
% fgflash=fft2(gflash);
% subplot(1,3,3);
% imagesc(abs(fftshift(fgflash)));

% %ex7 Image Blurring / Resoultion
% flash=rawflash;
% dec=ones(size(flash,1),size(flash,2));
% for x = 1:size(flash,1); 
% dec(x,:)=dec(x,:).*exp(x*0.03);
% end
% subplot(2,2,1);
% imagesc(abs((dec)));
% dflash=flash.*dec;
% fdflash=fft2(dflash);
% fflash=fft2(flash);
% subplot(2,2,2);
% imagesc(log10(abs((dflash))));
% subplot(2,2,3);
% imagesc(abs(fftshift(fdflash)));
% subplot(2,2,4);
% imagesc(abs(fftshift(fflash)));

