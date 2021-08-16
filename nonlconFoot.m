function [c,ceq] = nonlconFoot(joint_angles,param,joints0)
    %% Constraints
    FK = kinematics3D(joint_angles,param);
    rTPt = FK.xs;
    %% Convert centerOfMass into foot space
    rCTt = [FK.com;1];
    rCPp = FK.Htf\rCTt; %CoM to planted foot space
    polygon_threshold = 0.35;
    c =[
        % Ensure rCTp is always within support foot support polygon
        rCPp(3)-polygon_threshold*0.115;  
        -rCPp(3)-polygon_threshold*0.115 
        rCPp(2)-polygon_threshold*0.065;
        -rCPp(2)-polygon_threshold*0.065;
        %Ensure knees are always bent backwards
        joint_angles(15) - pi/2;
        -joint_angles(15);
        joint_angles(4) - pi/2;
        -joint_angles(4);
        % Ensure support doesnt shift backwards to far
         -rTPt(1) - 0.05;
         rTPt(3) + 0.42; % rTPt(3) <= -0.4
       ];
    ceq = [];
end