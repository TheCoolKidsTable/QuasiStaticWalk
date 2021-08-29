function rCTt = plotZMP(p,rCPp)
%% Plot ZMP and CoM trajectory
figure('name','ZMP X-Axis');
plot(p.zmp_x,'LineWidth',5);
hold on;
plot(p.com_x,'LineWidth',5);
xlabel('Sample [Ts]')
ylabel('X [m]')
Hwp = trvec2tform([p.footstep(1,1)  0.055 -0.46])*roty(pi/2);
rCWW = zeros(4,p.N_samples);
for i = 1:p.N_samples
    rCWW(:,i) = Hwp*rCPp(:,i);
end
Hwp = trvec2tform([p.footstep(2,1)  -0.055 -0.46])*roty(pi/2);
for i = p.N_samples+1:2*p.N_samples
    rCWW(:,i) = Hwp*rCPp(:,i);
end
Hwp = trvec2tform([p.footstep(3,1)+p.footstep(2,1)  0.055 -0.46])*roty(pi/2);
for i = 2*p.N_samples+1:3*p.N_samples
    rCWW(:,i) = Hwp*rCPp(:,i);
end
plot(rCWW(1,1:3*p.N_samples),'--','LineWidth',3)
legend('ZMP_X [m]','CoM* X [m]','Actual CoM X [m]');
xlabel('Sample [Ts]')
ylabel('X [m]')


figure('name','ZMP Y-Axis');
plot(p.zmp_y,'LineWidth',5);
hold;
plot(p.com_y,'LineWidth',5);
plot(rCWW(2,1:3*p.N_samples),'--','LineWidth',3)
legend('ZMP_Y [m]','CoM Y [m]','Actual CoM Y [m]');
xlabel('Sample [Ts]')
ylabel('Y [m]')
figure('name','ZMP vs CoM');
plot(p.zmp_x, p.zmp_y,'LineWidth',5);
legend('ZMP_X [m]','ZMP_Y [m]');
xlabel('Sample [Ts]')
ylabel('X [m]')
hold on;
plot(p.com_x, p.com_y,'LineWidth',5);
plot(rCWW(1,1:3*p.N_samples), rCWW(2,1:3*p.N_samples),'--','LineWidth',3);
legend('ZMP [m]','CoM [m]','Actual CoM [m]');
xlabel('X [m]')
ylabel('Y [m]')
axis([0 0.2 -0.1 0.1])

end