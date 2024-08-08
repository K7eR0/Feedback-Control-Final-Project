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