clear all; close all;

rolloff = .5;
filterspan = 4;
outputSamples = 8;
inputSamples = 8;
decimationFactor = 8;
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
in.signals.dimensions = 1;
R = (97.35 * 1000);
sampleTime = 1/R;
maxErrors = 1000;
maxBits = 1e6;


transInputs = [];
transOutputs = [];
recInputs = [];
recOutputs = [];
ndbers = [];
index = 1;
for snr = SNRdB(index)
	sim('bpskRC.mdl');
	% transInputs(end+1,:) = transInput.Data(end,:);
	% transOutputs(end+1,:) = transOutput.Data(end,:);
	% recInputs(end+1,:) = recInput.Data(end,:);
	% recOutputs(end+1,:) = recOutput.Data(end,:);
	ndbers = [ndbers ndber(end,1)];
end
% figure(1)
% semilogy(SNRdB(index),ndbers, '--*');
% hold on
% % semilogy(SNRdB,dbers, '--o');
% hold off

tx = 1000 * (0:(length(bMessage')-1)) / R;
fltDelay = filterspan / (2*R);
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
