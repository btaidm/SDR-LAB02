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

message = 'HELLO';
bMessage = (dec2bin(message,8) - '0')';
bMessage = bMessage(:)';

mMessage = bMessage;
mMessage(mMessage == 0) = -1;


Trails = [25 250 2500 25000];


in.time = [];
in.signals.values = bMessage';
in.signals.dimensions = size(bMessage');
R = (97.35 * 1000);
sampleTime = 1/R;
maxErrors = 1000;
maxBits = 1e6;

fltDelay = filterspan / (2*R);
fltDelaySamples = fltDelay*(R*outputSamples);

% delay = .5;

transInputs = [];
transOutputs = [];
recInputs = [];
recOutputs = [];
ndbers = [];
delaybers25 = [];
delaybers5 = [];
delaybers75 = [];
elbers001 = [];
elbers01 = [];
elbers1 = [];

index = 1:length(SNRdB);
for snr = SNRdB(index)
	fprintf('SNRdB: %d:  ', snr);
	fprintf('No Delay ');
	sim('bpskRC.mdl');
	ndbers = [ndbers ndber(end,1)];
	delay = .25;
	fprintf('%.2f Delay ', delay);
	sim('bpskRCdelay.mdl');
	delaybers25 = [delaybers25 ndber(end,1)];
	delay = .5;
	fprintf('%.2f Delay ', delay);
	sim('bpskRCdelay.mdl');
	delaybers5 = [delaybers5 ndber(end,1)];

	% loopGain = .001;
	% fprintf('%.4f loopGain ', loopGain);
	% sim('bpskRCdelayLG.mdl');
	% elbers001 = [elbers001 ndber(end,1)];
	% loopGain = .01;
	% fprintf('%.4f loopGain ', loopGain);
	% sim('bpskRCdelayLG.mdl');
	% elbers01 = [elbers01 ndber(end,1)];
	% loopGain = .1;
	% fprintf('%.4f loopGain ', loopGain);
	% sim('bpskRCdelayLG.mdl');
	% elbers1 = [elbers1 ndber(end,1)];

	delay = .75;
	fprintf('%.2f Delay\n', delay);
	sim('bpskRCdelay.mdl');
	delaybers75 = [delaybers75 ndber(end,1)];
end
figure(3)
semilogy(SNRdB(index),ndbers, '--*');
hold on
semilogy(SNRdB(index),delaybers25, '--o');
semilogy(SNRdB(index),delaybers5, '--x');
semilogy(SNRdB(index),delaybers75, '.--');
hold off

tx = 1000 * (0:(length(bMessage')-1)) / R;
cto = 1000 * (0:((length(bMessage')*outputSamples) - 1)) / (R * outputSamples);
yo = transOutput((fltDelay*(R*outputSamples) + 1):end);
figure(1)
stem(tx,input(1:length(tx)),'x'); hold on
stem(tx,real(transInput(1:length(tx))),'x');
plot(cto,real(yo(1:length(cto))),'b-'); hold off

figure(2)
ro = recOutput((fltDelay*(R*outputSamples) + 1):end);
ri = recInput((fltDelay*(R*outputSamples) + 1):end);
stem(tx,real(recOutput(1:length(tx))),'x'); hold on
plot(cto,real(ri(1:length(cto))),'b-'); hold off




% legend('Theoretical', 'berawgn', 'Simulated(Trails = 25)', 'Simulated(Trails = 250)', 'Simulated(Trails = 2500)', 'Simulated(Trails = 25000)', 'Simulink (bpsk)', 'Simulink(dbpsk)')

