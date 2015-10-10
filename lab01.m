clear all; close all;

%% Perlab
SNRdB = 0:10;
SNR = 10.^(SNRdB/10);
figure(1)

berq = qfunc(sqrt(2*SNR));
semilogy(SNRdB, berq, '-o');

title('Figure 1: BPSK over AWGN');
xlabel('SNR (dB)');
ylabel('BER');

hold on 
berMat = berawgn(SNR,'psk', 2, 'nondiff');

semilogy(SNR, berMat, '-*');

hold off
legend('Theoretical', 'berawgn')

message = 'HELLO';
bMessage = (dec2bin(message,8) - '0')';
bMessage = bMessage(:)';

mMessage = bMessage;
mMessage(mMessage == 0) = -1;

figure(2)
plot(mMessage);
title('Figure 2: Modulated Baseband Signal');

Trails = [25 250 2500 25000];

figure(3)

semilogy(SNRdB, berq, '-');

title('Figure 3: BPSK over AWGN');
xlabel('SNR (dB)');
ylabel('BER');
hold on 

semilogy(SNR, berMat, '-');
hold off

for trails = Trails
	aveBer = [];
	for snrC = SNR
		sMessage = awgn(repmat(mMessage,trails,1),snrC);
		dmMessage = sMessage;
		dmMessage(dmMessage > 0) = 1;
		dmMessage(dmMessage <= 0) = 0;
		diffMessage = (dmMessage ~= repmat(bMessage,trails,1));
		totalError = sum(diffMessage,2);

		ber = totalError./size(bMessage,2);
		aveBer = [aveBer mean(ber)];
	end
	hold on
	semilogy(SNRdB,aveBer, '-.o');
	hold off
end
drawnow

in = bMessage;
sampleRate = 1/(97.35 * 1000);
maxErrors = 1000;
maxBits = 1e6;

ndbers = [];
dbers = [];
for snr = SNRdB
	sim('bpsk.mdl');
	sim('dbpsk.mdl');
	ndbers = [ndbers ndber.Data(end,1)];
	dbers = [dbers dber.Data(end,1)];
end
figure(3)
hold on
semilogy(SNRdB,ndbers, '--*');
semilogy(SNRdB,dbers, '--o');
hold off

legend('Theoretical', 'berawgn', 'Simulated(Trails = 25)', 'Simulated(Trails = 250)', 'Simulated(Trails = 2500)', 'Simulated(Trails = 25000)', 'Simulink (bpsk)', 'Simulink(dbpsk)')