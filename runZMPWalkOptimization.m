clc;
clear;
close all;
addpath('./transforms');
addpath('./ZMP');
%% Forward kinematics
robot = importrobot('NUgus.urdf');
robot.DataFormat = 'column';
%% Params
p = gaitParameters(robot);
%% Broad search optimization
all_results = [];
iteration = 0;
for step_length_x=0.4:0.1:0.5
    for step_time = 0.4:0.1:0.5
    %update gait parameters
    p.step_length_x = step_length_x;
    p.step_time = step_time;
    p.footsteps = [];
    p.footsteps = generateFootsteps(p);
    p.iteration = iteration;
    iteration = iteration + 1;
    %% ZMP Trajectory
    p.support_foot = 'left_foot';
    p.swingFoot = 'right_foot';
    [com_x, com_y, zmp_x, zmp_y] = generateCoMTraj(p);
    p.com_x = com_x;
    p.com_y = com_y;
    p.zmp_x = zmp_x;
    p.zmp_y = zmp_y;
    %initial conditions
    opt_joint_angles = [];
    foot_traj = [];
    p.initial_conditions = initialConditions;
    opt_joint_angles_temp = p.initial_conditions;
    for i=1:(length(p.footsteps)- 2)
        p.step_count = i;   
        %get swing foot trajectory
        p.initial_conditions = opt_joint_angles_temp(:,end);

        foot_traj_temp = generateFootTrajectory(p);
        foot_traj = [foot_traj foot_traj_temp];
        %get com traj for step
        rCdWw = [com_x((i-1)*p.N+1:p.N*i);com_y((i-1)*p.N+1:p.N*i);zeros(1,p.N)];
        %perform inverse kinematics
        opt_joint_angles_temp = inverseKinematicsZMP(p,foot_traj_temp,rCdWw);
        opt_joint_angles = [opt_joint_angles opt_joint_angles_temp];
        %switch feet
        if(p.support_foot == "left_foot")
            p.support_foot = 'right_foot';
            p.swingFoot = 'left_foot';
        else
            p.support_foot = 'left_foot';
            p.swingFoot = 'right_foot';
        end
    end
    %% Run simulation
    save('controllers/walk_controller/data.mat','p','opt_joint_angles');
    path_to_webots = "X:\Webots\Webots\msys64\mingw64\bin\webots.exe";
    path_to_world = "X:\Walk\worlds\kid.wbt";
    open_webots = path_to_webots + " " + path_to_world;
    system(open_webots)
    result = load('controllers/walk_controller/result.mat');
    %update results param
    result.distance_travelled = result.position(end,1);
    result.step_length_x = step_length_x;
    result.step_time = step_time;
    result.iteration = p.iteration;
    %store results
    all_results = [all_results;result];
    end
end

%% Plot the results
close all;
plot_results = zeros(3,size(all_results,1));
for i=1:size(all_results,1)
    plot_results(1,i) = all_results(i).step_length_x;
    plot_results(2,i) = all_results(i).step_time;
    plot_results(3,i) = all_results(i).distance_travelled;
end
surf(plot_results)
title('Optimization Results');
xlabel('Step Length X [m]');
ylabel('Step Time [s]');
zlabel('Distance Travelled in '+string(p.walk_time)+' [s]');
grid on;

figure;
title('Step length vs distance travelled');
plot(plot_results(1,:),plot_results(3,:));
xlabel('Step Length X [m]');
ylabel('Distance Travelled [m]');

figure;
plot(plot_results(3,:),'LineWidth',3);
title('Distance travelled vs Iteration');
legend('Distance Travelled');
xlabel('Step Length X [m]');
ylabel('Distance Travelled [m]');

    