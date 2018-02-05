% MFCC Feature extraction
%by Anirudh Itagi


Fs=input('input sampling frequency in Hertz: ')
recordingtime=input('input recording time in seconds: ')
t=recordingtime;
voice1=audiorecorder(Fs,16,1);  %recording the voice
recordblocking(voice1,t)
b=getaudiodata(voice1);
%voice1=audioread('she.wav');
voice1=b;
subplot(4,2,1)
plot(voice1);
voice1pre=filter([1 -0.95],1,voice1); %pre-emphasis

subplot(4,2,2)
plot(voice1pre);
M=100;
N=256;                                %Length of frame
Number_of_frames=round(recordingtime*Fs/N);                

%pkg load signal            %including the signal package (for octave users only)
                 
  y1{1}=buffer(voice1,256,35);             %FRAMING
  subplot(4,2,3);
  plot(y1{1})

n=[0:N-1];
h=0.54-0.46*cos((2*pi.*n/N));  %HAMMING WINDOW **** alternate code= hamming(256)
subplot(4,2,4)
plot(h);
y2=diag(h)*y1{1};              % applying the hamming window
dh=diag(h);
y22=dh*y1{1};                      %alternate way of applying the hamming window
  subplot(4,2,5)
  plot(y2)
f1=fft(y22,N);                       %applying the fft transform
f11=abs(f1(1:N)./(N/2));          % applying the Discreet Fourier Transform
subplot(4,2,6)
plot(f11);
m=melfilterbank(20,N,Fs);              % apply the Mel filter bank
subplot(4,2,7)
%m1=linspace(0,(Fs/2),129);
plot(linspace(0,(Fs/2),129),m);
n2=1+128;
%z=m*abs(y1{1}(1:n2,:)).^2;   
z=m*abs(f1(1:129,:)).^2;

cep=dct(log(z));                    % apply the Discreet Cosine Transform
subplot(4,2,8)
plot(cep);
disp('the Acoustic Vectors or Cepstral coefficients are: ')
diag(cep)

%REPORT

% In this code we have succesfully learnt and implemented speaker
% recognition using MFCC feature extraction method based on
% application of FFT. the implementation is as follows: 
%
% STEP1: 
% Intially we recorded voice inputs and stored it as
% a .wav file. The model reads these inputs and samples then at a given
% sampling frequency.
%
% STEP2: 
% In order to remove the noise present in the voice
% input we use a pre-emphasis filter. As we know that majority of noise
% lies in the low frequency range, hence pre-emphasis attenuates the lower
% frequencies and boostes the higher frequencies.
%
% STEP3: 
% The voice input is not stationary and hence we frame the signal into
% small intervals where the signal is almost stationary. 
% We do framing and overlap these frames to acquire
% all the features of the signal. 
% 
% STEP4: 
% We create a hamming window to remove the
% discontinuities in the framed signal and to dispose of the redundant features.
% The hamming window is multiplied with each frame of the signal in order to
% take the mean features(Frequency domain multiplication). 
% 
% STEP5: 
% Then we implement fast fourier transform on the
% obtained signal. FFT is used to analyse the signal in frequency domain.
% We get the absolute fourier transform coefficients. To obtain the
% features of the signal we use mel filter bank. 
% 
% STEP6:
% A mel filter bank consists of 20 triangular filter on the mel scale.
% We convert the signal to the mel scale and apply the filters.
% We do this because the response to an audio signal is always logarithmic.
% Each traingular filter of the mel filter bank extracts one feature each.
%
%STEP7:
% Discrete Cosine transform is applied to obtain the 20 point features. 
% These features are the MFCC (mel frequency ceptral coefficients) or 
% Acoustic Vectors of the voice input signal where each coefficient corresponds 
% to a signal attribute. These attribites vary from speaker to speaker 
% and are hence unique for each individual and hence these coefficients are used
% to recognise the speaker.
% The model correlates the mel frequency ceptral coefficients of
% different voices for speaker recognition.
