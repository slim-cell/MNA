% ELEC 4700
% PA 7
% Michael Nwokobia
% 101044216

G = zeros(6, 6); 

%Resistances:
r1 = 1;
r2 = 2;
r3 = 10;
r4 = 0.1; 
r0 = 1000; 

%Conductances:
G1 = 1/r1;
G2 = 1/r2;
G3 = 1/r3;
G4 = 1/r4;
G0 = 1/r0;

%Additional Parameters:
alp = 100;
cp = 0.25;
l = 0.2;
Vin = zeros(1, 20);
V0 = zeros(1, 20);
V3 = zeros(1, 20);

G(1, 1) = 1;                                    
G(2, 1) = -G1; 
G(2, 2) = G1 + G2; 
G(2, 3) = 1; 
G(3 ,2) = -1; 
G(3, 4) = 1;                      
G(4, 3) = -1; 
G(4, 4) = G3;  
G(5, 4) = alp*G3;
G(5, 5) = 1; 
G(6, 5) = -G4;
G(6, 6) = G4 + G0;   


C = zeros(6, 6);

C(2, 1) = -cp; C(2, 2) = cp;
C(3, 3) = l;

F = zeros(1, 6);
V = -10;

for i = 1:21
    Vin(i) = V;
    F(1) = Vin(i);
    
    Vm = G\F';
    
    V0(i) = Vm(6);
    V3(i) = Vm(4);
    V = V + 1;
end


figure(1)
plot(Vin, V0);
title('Vo (V) vs Vin (V)');
xlabel('Vin (V)')
ylabel('V0 (V)')

figure(2)
plot(Vin, V3)
title('V3 (V) vs Vin (V)')
xlabel('Vin (V)')
ylabel('V3 (V)')



F(1) = 1;
V02 = zeros(1, 1000); 
freq = linspace(0, 1000, 1000); % note: in radians
Av = zeros(1, 1000);
Avlog = zeros(1, 1000);

for i = 1:1000
    Vm2 = (G+1i*freq(i)*C)\F';
    V02(i) = Vm2(6);
    Av(i) = V02(i)/F(1);
    Avlog(i) = log10(Av(i));
end 
    
figure(3)
semilogx(freq, Avlog)
xlim([0 1000])
title('Av (dB) vs w (rad)')
xlabel('w (rad)')
ylabel('Av (dB)')
    
w = pi;
Av2 = zeros(15, 1);
Cper = zeros(15, 1);
vo3 = zeros(1, 15);

for i = 1:1000
    C(2, 1) = normrnd(-cp, 0.05); 
    C(2, 2) = normrnd(cp, 0.05);
    C(3, 3) = normrnd(l, 0.05);
    Vm3 = (G+1i*w*C)\F';
    vo3(i) = Vm3(6);
    Av2(i) = vo3(i)/F(1);
end

figure(4)
hist(real(Av2), 25)
title('Gain Distribution')
xlabel('Gain at w = pi')