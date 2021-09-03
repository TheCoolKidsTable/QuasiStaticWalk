function rCPp = plotData(q,p,trajectory)
    %% Helper Functions
    FK = Kinematics();
    %% Convert centerOfMass into foot space
    rCTt = zeros(3,p.N);
    rCPp = zeros(4,p.N);
    rSPp = zeros(3,p.N);
    for i = 1:p.N
        rCTt(:,i) = FK.CoM(q(:,i),p);
        rSPp(:,i) = FK.xe(q(:,i),p);
        Htp = FK.Htp(q(:,i),p);
        rCPp(:,i) = Htp\[rCTt(:,i);1];
    end
    %% Plot CoM position
    figure
    n = p.N;
    subplot(2,1,1);
    hold on;
    plot(1:n,ones(1,n)*-0.115,'--');
    hold on;
    plot(1:n,ones(1,n)*0.115,'--');
    hold on;
    plot(1:n,rCPp(3,:),'LineWidth',5);
    legend('CoM upper limit [m]','CoM lower limit [m]','CoM position [m] (support foot space)');
    title('x CoM constraint')
    subplot(2,1,2);
    hold on;
    plot(1:n,ones(1,n)*0.13/2,'--','LineWidth',3);
    hold on;
    plot(1:n,ones(1,n)*-0.13/2,'--','LineWidth',3);
    hold on;
    plot(1:n,rCPp(2,:),'LineWidth',5);
    legend('CoM upper limit [m]','CoM lower limit [m]','CoM position [m] (support foot space)');
    title('y CoM constraint')
    %% Plot Trajectory vs End effector position
    figure
    subplot(3,1,1);
    plot(1:n,trajectory(1,:),'LineWidth',5);
    hold;
    plot(1:n,rSPp(1,:),'--','LineWidth',3);
    legend('Swing Foot x Position  [m] (support foot space)','Swing Foot x Trajectory [m] (support foot space)');
    subplot(3,1,2);
    plot(1:n,trajectory(2,:),'LineWidth',5);
    hold;
    plot(1:n,rSPp(2,:),'--','LineWidth',3);
    legend('Swing Foot y Position [m] (support foot space)','Swing Foot y Trajectory [m] (support foot space)');
    subplot(3,1,3);
    plot(1:n,trajectory(3,:),'LineWidth',5);
    hold;
    plot(1:n,rSPp(3,:),'--','LineWidth',3);
    legend('Swing Foot z Position [m] (support foot space)','Swing Foot z Trajectory [m] (support foot space)');
end
