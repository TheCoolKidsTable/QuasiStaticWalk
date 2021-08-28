clc;
clear;
close all;
addpath('./transforms');
%% Forward kinematics
robot = importrobot('NUgus.urdf');
% smimport('NUgus.urdf')
robot.DataFormat = 'column';
close all;
show(robot);
com = centerOfMass(robot,homeConfiguration(robot));
hold on;
plot3(com(1),com(2),com(3),'o');
%% Params
param = gaitParameters(robot);
%% Trajectory Plan Half Step
param.initial_conditions = initialConditions;
param.support_foot = 'left_foot';
param.swingFoot = 'right_foot';
% param.initial_conditions = opt_joint_angles_1(:,end);
is_half_step = true;
trajectory_1 = generateFootTrajectory(param,is_half_step);
%% Inverse Kinematics - Half Step - support foot -> left
[opt_joint_angles_1] = inverseKinematics(trajectory_1,param);
%% Trajectory Plan Full Step
param.support_foot = 'right_foot';
param.swingFoot = 'left_foot';
is_half_step = false;
param.initial_conditions = opt_joint_angles_1(:,end);
trajectory_2 = generateFootTrajectory(param,is_half_step);
%% Inverse Kinematics - Half Step - support foot -> left
[opt_joint_angles_2] = inverseKinematics(trajectory_2,param);
%% Trajectory Plan Full Step
param.support_foot = 'left_foot';
param.swingFoot = 'right_foot';
is_half_step = false;
param.initial_conditions = opt_joint_angles_2(:,end);
trajectory_3 = generateFootTrajectory(param,is_half_step);
%% Inverse Kinematics - Half Step - support foot -> left
[opt_joint_angles_3] = inverseKinematics(trajectory_3,param);
%% Plot Walking
% Plot first step
figure
param.support_foot = 'left_foot';
param.swingFoot = 'right_foot';
plotWalk(opt_joint_angles_1,robot,param);
% Plot 2nd step
param.support_foot = 'right_foot';
param.swingFoot = 'left_foot';
plotWalk(opt_joint_angles_2,robot,param);
% Plot 3rd step
param.support_foot = 'left_foot';
param.swingFoot = 'right_foot';
plotWalk(opt_joint_angles_3,robot,param);
%% Plot Data
% Plot first step
param.support_foot = 'left_foot';
param.swingFoot = 'right_foot';
plotData(opt_joint_angles_1,param,trajectory_1);
% Plot 2nd step
param.support_foot = 'right_foot';
param.swingFoot = 'left_foot';
plotData(opt_joint_angles_2,param,trajectory_2);
% Plot 3rd step
param.support_foot = 'left_foot';
param.swingFoot = 'right_foot';
plotData(opt_joint_angles_3,param,trajectory_3);
%% Plot CoM
% param.support_foot = 'left_foot';
% param.swingFoot = 'right_foot';
% plotCoM(opt_joint_angles_1,param);
% param.support_foot = 'right_foot';
% param.swingFoot = 'left_foot';
% plotCoM(opt_joint_angles_2,param);
% param.support_foot = 'left_foot';
% param.swingFoot = 'right_foot';
% plotCoM(opt_joint_angles_3,param);
%% Pack servo positions
servo_positions = [opt_joint_angles_1,opt_joint_angles_2,opt_joint_angles_3];
out=servo_positions(:)