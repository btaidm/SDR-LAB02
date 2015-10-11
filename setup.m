clear all;
close all;

rolloff = .5;
filterspan = 4;
outputSamples = 8;
inputSamples = 8;
decimationFactor = 8;
decimationFactorREC = 1;
linearAmp = 1;

% R = 1000; % bits/sec

SNRdB = 0:10;
SNR = 10.^(SNRdB/10);

snr = SNRdB(1);

message = 'HELLO';
bMessage = (dec2bin(message,8) - '0')';
bMessage = bMessage(:)';

mMessage = bMessage;
mMessage(mMessage == 0) = -1;

in.time = [];
in.signals.values = bMessage';
in.signals.dimensions = size(bMessage');
R = (97.35 * 1000);
sampleTime = 1/R;
maxErrors = 1000;
maxBits = 1e6;

delay = .5;
loopGain = .001;
