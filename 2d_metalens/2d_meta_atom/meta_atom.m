%% Meta-atom design for metasurfaces
% Example of Meta-atom design for metasurfaces using mesti2s()
% 
% Use mesti2s() to 
% 
% 1. Computing the transmission coefficient of meta-atom with different ridge 
% widths and find meta-atoms satisfying 8 discrete ideal relative phases over 
% [0, 2pi).
% 2. Scanning over ridge width and incident angle to get phase and amplitude 
% map of transmission coefficient.

%% System parameters
% Set up the parameters for the meta-atom system.

clear

n_air    = 1;    % Refractive index of air
n_silica = 1.46; % Refractive index of silica
n_TiO2   = 2.43; % Refractive index of TiO2
lambda   = 532;  % Free-space wavelength [nm]
dx = lambda/40;  % Discretization grid size [nm]
w  = 18*dx;      % Width of meta-atom cell [nm]
l  = 600;        % Thickness of meta-atom cell [nm]
ridge_height = l; % Ridge height is the thickness of meta-atom cell.

%% General setup for mesti2s()
% Set up input arguments for mesti2s(). 

syst.epsilon_L = n_silica^2; % Relative permittivity on the left hand side
syst.epsilon_R = n_air^2;    % Relative permittivity on the right hand side
syst.wavelength = lambda;    % Free-space wavelength [nm]
syst.dx = dx;                % Grid size of system [nm]
syst.length_unit = 'nm';     % Length unit
in = {'left'};               % Specify input channel on the left.
out = {'right'};             % Specify output channel on the right.
opts.verbal = false;         % Suppress output information.

%% Structure of meta-atom
% Plot refractive index profile of a meta-atom with ridge with = 79.8 nm as 
% an illustration.

ridge_width = 79.8; % Ridge width of meta-atom [nm]

% Build permittivity for the meta-atom. 
% Please refer to the function build_epsilon_meta_atom.    
epsilon_meta_atom = build_epsilon_meta_atom(dx, n_air, n_TiO2, ridge_width, ridge_height, w);
[ny, nx]= size(epsilon_meta_atom);

n_extra_for_plot = 10; % Extra pixels on side for plotting

% For plotting the space position
x = (-n_extra_for_plot+0.5:nx+n_extra_for_plot)*dx;
y = (0.5:ny)*dx;

figure
imagesc(x, y, [syst.epsilon_L*ones(ny,n_extra_for_plot), epsilon_meta_atom, 1*syst.epsilon_R*ones(ny,n_extra_for_plot)])
colormap(flipud(pink));
xlabel('{\itx} (nm)');
ylabel('{\ity} (nm)');
set(gca, 'fontsize', 15, 'FontName','Arial')
caxis([1 12])
text(670,140,'air','FontSize', 15,'Rotation',90)
text(240,120,'TiO_2','FontSize', 15)
text(-80,165,'silica','FontSize', 15,'Rotation',90)
axis image
title('Meta-atom','FontSize',20)

%% Transmission coefficient of meta-atom at normal incidence
% In standard procedure of designing metasurface, people calculate the phase 
% of transmission coefficient of meta-atom with different parameters (for example, 
% ridge width). Then, use this information to design metasurface. Here following 
% the similar procedure, we calculate transmission coefficient of meta-atom looping 
% over different ridge widths.

syst.yBC = 'periodic'; % Periodic boundary in y direction
% In periodic boundary, since 2*w/(lambda/n_silica) ~ 1, only one
% propagating channel is on the left. Our ky(a) = a*2*pi/W in periodic boundary 
% and ky = 0 is the only propagating channel whose incident angle is normal. 


ridge_width_list = 40:0.1:200; % List of ridge width: from 40 nm to 200 nm with 0.1 nm increment

t_list = zeros(1,size(ridge_width_list,2)); % Transmission coefficient list

% Loop over different ridge widths
for ii =1:length(ridge_width_list)
    syst.epsilon = build_epsilon_meta_atom(dx, n_air, n_TiO2, ridge_width_list(ii), ridge_height, w);
    % Compute the transmission matrix, which only contains one coefficient (no diffraction) at normal incidence.
    t_list(1,ii) = mesti2s(syst, in, out, opts);
end

rel_phi_over_pi_list = mod(angle(t_list)-angle(t_list(1)), 2*pi)/pi; % Relative phase over different ridge widths

% Plot the relative phase of meta-atom with different ridge widths
figure
plot(ridge_width_list, rel_phi_over_pi_list, '-','linewidth', 2)
xlabel('Ridge width (nm)')
ylabel('Phase (\pi)')
xlim([40 200])
title('$\Phi - \Phi^0$', 'Interpreter','latex')
set(gca, 'fontsize', 20, 'FontName','Arial')

%% Finding meta-atoms satisfying 8 discrete ideal relative phases over [0, 2pi)
% In the design point of view, practically people would only use meta-atom with 
% discrete parameters to construct the metasurface. Typically, 8 different meta-atoms 
% covering the relative phases equally spacing over [0, 2pi) are used.

n_phases = 8;
ideal_rel_phase_over_pi_list = (2/n_phases)*(0:(n_phases-1)); % 8 equally spaced relative phases from 0 to 2pi.

% Find meta-atoms which are closest to the ideal relative phase through nearest neighbor interpolation.
ind = interp1(rel_phi_over_pi_list,1:length(rel_phi_over_pi_list),ideal_rel_phase_over_pi_list,'nearest');
phi_over_pi_design_list = rel_phi_over_pi_list(ind); 
ridge_width_design_list = ridge_width_list(ind); 

% Print the relative phases and ridge widths.
fprintf(['Relative phase.(pi) %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f\n' ...
         'Ridge width....(nm) %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f\n'],...
         phi_over_pi_design_list,ridge_width_design_list);
% Save the phase list and the ridge width list.
save('meta_atom.mat','ridge_width_design_list','phi_over_pi_design_list')

%% Phase and amplitude map of transmission coefficient of meta-atom with different ridge widths and incident angles
% In addition to normal incidence, the response of oblique incidence is also 
% important. With Bloch periodic boundary condition, the transmission coefficient 
% with different ridge widths and incident angles is calculated.

syst.yBC = 'Bloch'; % Bloch periodic boundary along transverse direction

ridge_width_list = 40:4:200; % List of ridge width: from 40 nm to 200 nm with 4 nm increment
theta_in_list = -89:1:89;    % List of incident angle in air [degree]
n_angles = numel(theta_in_list);

ky_list = (2*pi/lambda)*sind(theta_in_list);  % wave number in y direction

t_list = zeros(n_angles, numel(ridge_width_list));  % Transmission coefficient list 

% Loop over different ridge widths
for ii = 1:length(ridge_width_list)
    syst.epsilon = build_epsilon_meta_atom(dx, n_air, n_TiO2, ridge_width_list(ii), ridge_height, w);

    % Loop over different incident angles
    for jj = 1:n_angles
        syst.ky_B = ky_list(jj); % Bloch wave number in y direction
        [tmatrix, channels] = mesti2s(syst, in, out, opts); % compute the transmission matrix.

        % At large incident angles, there can be more than one channel on the left (i.e., diffraction).
        % We want the incident channel whose ky equals the Bloch wave number we specify (i.e., zeroth-order).
        [~, ind] = min(abs(channels.L.kydx_prop - syst.ky_B*dx));
        t_list(jj,ii) = tmatrix(1, ind);
    end
end

% Plot the phase of the transmission coefficient relative to the first width
figure
imagesc(ridge_width_list, theta_in_list, mod(angle(t_list)-angle(t_list(:,1)), 2*pi))
caxis([0, 2*pi]);
xlabel('Pillar width (nm)')
ylabel('\theta_{in} (degree)')
title('Phase')
cyclic_color = [flipud(pink); bone]; 
colormap(cyclic_color)
colorbar
hcb=colorbar; hcb.Ticks = [0 pi 2*pi]; hcb.TickLabels = {'0','\pi','2\pi'};

% Plot the amplitude of transmission coefficient.
figure
imagesc(ridge_width_list, theta_in_list, abs(t_list))
caxis([0, 1]);
xlabel('Pillar width (nm)')
ylabel('\theta_{in} (degree)')
title('Amplitude')
colormap('hot')
colorbar
