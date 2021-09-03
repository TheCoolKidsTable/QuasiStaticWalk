function [com_x, com_y, zmp_x, zmp_y] = generateCoMTraj(p)
    % Load params
    t_calc = length(p.footstep) * p.step_time - p.t_preview - p.Ts;
    % Generating ZMP trajectory
    [zmp_x, zmp_y] = createZmpTrajectory(p.footstep, p.Ts, p.step_time);
    % Simulating for t_calc seconds
    [com_x, com_y] = previewControl(zmp_x, zmp_y, p.Ts, p.t_preview, t_calc, p.A_d, p.B_d, p.C_d, p.Gi, p.Gx, p.Gd);
end