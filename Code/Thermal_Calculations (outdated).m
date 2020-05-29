%% Thermal Calculations for Inconel Test Article and Heat Blocks

% Assumptions:
%   - Constant Density for water
%   - Constant Specific heats
%   - Constant Thermal Conductivities
%   - Constant Volume

clear; clc; close all;
kInc = 15; % [ W/(m*K) ] Thermal Conductivity of Inconel
kAir = .02587; %[ W/(m*K) ] Thermal Conductivity of Air
kNylon = 0.25; % [ W/(m*K) ] Thermal Conductivity of Nylon
cW = 4150; % [ J/(kg*K) ] Specific heat of water
rhoW = 1000; % [ kg/m^3 ]

AC = (20 * 40) * (1/1000)^2; % [m^2] Contact Surface Area
dI = (2) * 1/1000; % [m] Inconel surface thickness
TW = 363.15; % [K]
TI = 293.15; % [K]

h = 40 * (1/1000); % [m] height of thermal block
Vw = AC * h; % [m^3] Volume of water
mW =  Vw * rhoW; % [kg] Mass of water

Qdot = (kInc * AC * (TW - TI)) / dI; % [W or J/s]
dT = 5; % [C or K] allowable change in temperature
Q = mW * cW * dT; % [J] Energy required to complete temperature change
t = Q / Qdot;
fprintf('Thermal Calculations (maximum temperature difference):\n');
fprintf('Maximum rate of heat transfer into Inconel: %48.2f [W]\n', Qdot);
fprintf('Time for water to cool by %d degree(s) C: %49.2f [sec]\n', dT, t);


%% Thermal Block Structural Properties
FS = 1.2; % Safety factor of 1.1
Sy = 36; % [MPa] Tensile Yeild Stress
SyFS = Sy / FS; % [MPa] Allowable Stress
TMAX_1 = 0.5 * SyFS; % [MPa] Max Shear Stress (max shear stress theory)
TMAX_2 = 0.577 * SyFS; % [MPa] Max Shear Stress (max distortional energy theory)
sA = 43.45; % [mm^2] shearing area;
PA_1 = TMAX_1 * sA; % Allowable load (max shear stress theory)
PA_2 = TMAX_2 * sA; % Allowable load (max distortional energy theory)
fprintf('\n--------\n');
fprintf('Structural Calculations for Thermal Block Mount (FS %g):\n', FS);
fprintf('Maximum allowable tensile stress (FS %g) for Onyx Material: %30.2f [MPa]\n\n', FS, SyFS);
fprintf('*Maximum allowable shear stress at each bolt (max shear stress theory): %19.2f [MPa] (%.2f [psi])\n', TMAX_1, TMAX_1*10^6 * 1.45E-4);
fprintf('*Maximum allowable load at each bolt (max shear stress theory): %28.2f [N] (%.2f [lb])\n\n', PA_1, PA_1 * 0.224809);
fprintf('Maximum allowable shear stress at each bolt (max distortional energy theory): %13.2f [MPa] (%.2f [psi])\n', TMAX_2, TMAX_2*10^6 * 1.45E-4);
fprintf('Maximum allowable load at each bolt (max distortional energy theory): %22.2f [N] (%.2f [lb])\n', PA_2, PA_2 * 0.224809);

vessel_thickness = 3; % thickness of pressure vessel wall [mm]
vessel_radius = 20;
vessel_p_internal = (SyFS * vessel_thickness) / vessel_radius; % [MPa] internal pressure (BAD CYLINDRICAL ASSUMPTION)
fprintf('\n--------\n');
fprintf('Structural Calculations for Thermal Block Body (FS %g):\n', FS);
fprintf('Maximum allowable internal pressure (radial): %44.2f [MPa] (%.2f [psi]) (NOT ACCURATE YET)\n', vessel_p_internal, vessel_p_internal*10^6 * 1.45E-4);
fprintf('Maximum expected internal pressure from fluid: %43.2f [MPa] (%.2f [psi]) (NOT ACCURATE YET)\n', 0, 0);

%% GASKET PROPERTIES

bcA = 443.96; % [mm^2] contact area of the thermal block;
max_applied_pressure = PA_1 / bcA; % [MPa]
an_applied_stress = [0:100000:1000000]; % [Pa]
applied_force = an_applied_stress .* (bcA * (1/1000)^2);
prat = 0.47; % Poisson's ratio for silicone rubber
% ymod = exp((60)*0.0235-0.6403) * 10^6;
ymod = 0.001E9; % [Pa] youngs modulus for silicone rubber
longitudinal_strain = an_applied_stress ./ ymod; % [unitless]
radial_strain = longitudinal_strain .* prat; % [unitless]
longitudinal_compression = longitudinal_strain .* 1; % [mm]
radial_expansion = radial_strain .* 1.5; % [mm]


figure();
subplot(2,2,1);
hold on;
title("GASKET: Longitudinal Compression [mm] vs. Applied Force [lb]");
plot(applied_force * 0.224809, longitudinal_compression);
xlabel('Applied Force [lb]');
ylabel('Longitudinal Compression [mm]');
hold off;
subplot(2,2,2);
hold on;
title("GASKET: Radial Expansion [mm] vs. Applied Force [lb]");
plot(applied_force * 0.224809, radial_expansion);
xlabel('Applied Force [lb]');
ylabel('Radial Expansion [mm]');
hold off;
subplot(2,2,3);
hold on;
title("GASKET: Longitudinal Compression [mm] vs. Applied Stress [psi]");
plot(an_applied_stress* 1.45E-4, longitudinal_compression);
xlabel('Applied Stress [psi]');
ylabel('Longitudinal Compression [mm]');
hold off;
subplot(2,2,4);
hold on;
title("GASKET: Radial Expansion [mm] vs. Applied Stress [psi]");
plot(an_applied_stress * 1.45E-4, radial_expansion);
xlabel('Applied Stress [psi]');
ylabel('Radial Expansion [mm]');
hold off;

figure();
hold on;
title('GASKET: Applied Stress [psi] vs. Applied Force [lb]');
plot(applied_force * 0.224809, an_applied_stress * 1.45E-4);
xlabel('Applied Force [lb]');
ylabel('Applied Stress [psi]');
hold off;

fprintf('\n--------\n');
fprintf('Gasket:\n');
fprintf('Maximum Possible Applied Gasket Pressure: %48.2f [MPa] ( %.2f [psi] )\n', max_applied_pressure, max_applied_pressure*10^6 * 1.45E-4);
% fprintf('Axial compression: %71.2f [mm] with %.2f [N] applied force ( %.2f [lbs] )\n', longitudinal_compression, applied_force, applied_force * 0.224809);
% fprintf('Radial_expansion: %72.2f [mm] with %.2f [N] applied force ( %.2f [lbs] )\n', radial_expansion, applied_force, applied_force * 0.224809);

