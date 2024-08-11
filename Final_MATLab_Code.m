clear all
syms s

%Set a variable for OS%
OS = 5;

%OL poles from our tf
p1 = -9.67;
p2 = -50;

%Set the Settling Time
Ts = 0.1;

%Calculate damping ratio for OS%
DR = round(-log(OS/100)/sqrt(pi^2 + (log(OS/100)^2)), 3);

%Calculate the natural frequency from damping ratio and chosen settling time
wn = 4/(Ts*DR);

%Calculate the desired real part of the dominant pole
sd = -DR * wn;

%Calculate the desire imaginary part of the dominant pole
wd = wn*sqrt(1-DR^2);

%Find the angle between the dominant pole and the first OL pole from the real axis 
t1 = mod(atand(wd/(sd-p1)),180);

%Find the angle between the dominant pole and the second OL pole from the real axis 
t2 = mod(atand(wd/(sd-p2)),180);

%Calculate the position of the added zero from the derivative of the PID controller
a = wd/(mod(tand((t1+t2)-180),180))-sd;

%Choose the added zero from the intigral of the PID controller
r = 7.85;

%Set 's' to automatically for transfer functions
s = tf('s');

%Our original transfer function
G = 14273/((s+9.67)*(s+50));

%Combine the original transfer function with the derivative
Ga = G*(s+a);

%Add the intigral into the transfer function
G1 = Ga*(s+r)/s;

%Calculate the gain of the controller
L1 = sqrt((a+sd)^2 + wd^2);
L2 = sqrt((p2-sd)^2 + wd^2);
L3 = sqrt((p1-sd)^2 + wd^2);
k = (L2*L3)/L1;

%Calculate the total gain
k1 = k/14273;

%Add the gain to the system
G2 = G1*k1;

%Plot the rlocus and damping ratio
rlocus(G2);
sgrid (.69,0);

%Plot the step response
figure(3); step(15*feedback(G2,1))