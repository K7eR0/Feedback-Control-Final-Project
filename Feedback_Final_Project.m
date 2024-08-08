%% Create closes loop no H(s)
clear all
G = tf([14273],[1,59.67,483.5])
H = 1;
T = feedback(G,H)
rlocus(G)
sgrid(.69,0)
figure(2); rlocus(T)
%%
clear all
% We found that the max value was 1.4 based on the simulink
Cmax = 1.4;
% Steady state value is 0.967 in simulink
Css = 0.967;
% We found K from num/omegan
K = 29.52
% Percent OS
%POS = round(100*(Cmax-Css)/Css, 2)
POS = 5
%Damping ratio
DR = round(-log(POS/100)/sqrt(pi^2 + (log(POS/100)^2)), 3)

% Nature freq
NatFa = 59.67/(2*DR)

%Settling time
Ts = 4/(DR*NatFa)

%Dominate Freq
OmegD = NatFa*sqrt(1-DR^2)

%Dominate Decay
SigD = DR*NatFa

%Kp
Kp = K/(9.67*50)

error = 1/(1+Kp)

t1 = 180 - mod(atand(OmegD/(SigD-9.67)),180)

t2 = mod(atand(OmegD/(50-SigD)),180)

t1 + t2

%%
clear all
syms s
% We found that the max value was 1.4 based on the simulink
Cmax = 1.4;
% Steady state value is 0.967 in simulink
Css = 0.967;
% We found K from K/omegan
K = 29.52

%POS = round(100*(Cmax-Css)/Css, 2)
POS = 5

%OL poles
p1 = -9.67
p2 = -50
%Damping ratio
DR = round(-log(POS/100)/sqrt(pi^2 + (log(POS/100)^2)), 3)

wn = 4/(.1*DR)

sd = -DR * wn

wd = wn*sqrt(1-DR^2)

t1 = mod(atand(wd/(sd-p1)),180)

t2 = mod(atand(wd/(sd-p2)),180)

t3 = t1 + t2 - 180

a = wd/mod((tand(t3)),180) - sd

s = tf('s')
G = 14273/((s+9.67)*(s+50))
Ga = G*(s+19.73817)/(s+11.33975)
G1 = Ga *(s+0.1)/s*1.15
%h = sd +j*wd;
%k = abs((h^3 + 59.67*h^2+483.5*h)/(h^2+141.6*h + 14.15))
rlocus(G1);
sgrid (.8,0);
figure(2);step(G1)
figure(3); step(feedback(G1,1))
%%
h = -20 +j*15;
k = abs(((h+9.67)*(h+50))/14273)
G = 14273/((h+9.67)*(h+50))
C = (h+19.74)/(h+11.34)
kc = 1/abs(k*G*C)

%%
clear all
syms s

POS = 5

%OL poles
p1 = -9.67
p2 = -50
%Damping ratio
DR = round(-log(POS/100)/sqrt(pi^2 + (log(POS/100)^2)), 3)

wn = 4/(.1*DR)

sd = -DR * wn

wd = wn*sqrt(1-DR^2)

t1 = mod(atand(wd/(sd-p1)),180)

t2 = mod(atand(wd/(sd-p2)),180)

a = wd/(mod(tand((t1+t2)-180),180))-sd
r = 7.85

s = tf('s')
G = 14273/((s+9.67)*(s+50))
Ga = G*(s+a)
G1 = Ga*(s+r)/s
h = sd + j*wd
g = 14273/((h+9.67)*(h+50))
k = abs(1/g)
c = (h+a)
kc = 1/abs(g*k*c)
G2 = G1*0.0015
g1 = 0.0015*(s+a)*(s+r)/s
rlocus(G2);
sgrid (.69,0);
%figure(2);step(G2)
figure(3); step(15*feedback(G2,1))