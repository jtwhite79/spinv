function out = model
%
% Rio_Grande_Forward_Model_to_Jeremy.m
%
% Model exported on Sep 2 2022, 12:24 by COMSOL 6.0.0.405.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('D:\Self-potential Surveying and Modeling\SP Inversion\Rio Grande Inverse Model\v5_to_Jeremy');

model.label('Rio_Grande_Forward_Model_to_Jeremy.mph');

model.param.set('Lm', '45000[m]', 'Model width to either side of the dam');
model.param.set('Ldam', '2[m]', 'Width of the dam');
model.param.set('Hdam', '10[m]', 'Height of the dam');
model.param.set('channel_depth', '1[m]', 'Channel depth');
model.param.set('RGA_thickness', '7[m]', 'Thickness of the Rio Grande Alluvium');
model.param.set('MBA_thickness', '700[m]', 'Thickness of the Mesilla Bolson Aquifer');
model.param.set('rho_sw', '1000[kg/m^3]', 'Density of the surface-water');
model.param.set('phi_sw', '1', 'porosity of the surface-water');
model.param.set('phi_RGA', '0.35', 'Porosity of the Rio Grande Alluvium');
model.param.set('phi_MBA', '0.25', 'Porosity of the Mesilla Boslon Aquifer');
model.param.set('phi_MDD', '0.001', 'Porosity of the Mesilla Diversion Dam');
model.param.set('K_sw', '1[ft/s]', 'Hydraulic conductivity of the surface water');
model.param.set('K_RGA', '200[ft/day]', 'Hydraulic conductiviy of the Rio Grande Alluvium');
model.param.set('K_MBA', '40[ft/day]', 'Hydraulic conductivity of the Mesilla Bolson Aquifer');
model.param.set('K_MDD', '1e-20[ft/day]', 'Hydraulic Conductivity of the Mesilla Diversion Dam');
model.param.set('m_sw', '1', 'Cementation Exponent Surface Water');
model.param.set('m_RGA', '2.15', 'Cementation exponent Rio Grande Alluvium');
model.param.set('m_MBA', '3.5', 'Cementation exponent Mesill Bolson Aquifer');
model.param.set('m_MDD', '1', 'Cementation Exponent Mesilla Diversion Dam');
model.param.set('F_sw', 'phi_sw^-m_sw', 'Formation factor surface water');
model.param.set('F_RGA', 'phi_RGA^-m_RGA', 'Formation factor Rio Grande Alluvium');
model.param.set('F_MBA', 'phi_MBA^-m_MBA', 'Formation factor Mesilla Bolson Aquifer');
model.param.set('F_MDD', 'phi_MDD^-m_MDD', 'Formation factor Mesilla Diversion Dam');
model.param.set('S_sw', '600[uS/cm]', 'Electric conductivity surface water');
model.param.set('S_RGA', 'S_sw/F_RGA', 'Electric conductivity Rio Grande Alluvium');
model.param.set('S_MBA', 'S_sw/F_MBA', 'Electric conductivity Mesilla Bolson Aquifer');
model.param.set('S_MDD', 'S_sw/F_MDD', 'Electric conductivity Mesilla Diversioin Dam');
model.param.set('k_sw', 'K_sw*mu/(rho_sw*g)', 'Permeability surface water');
model.param.set('k_RGA', 'K_RGA*mu/(rho_sw*g)', 'Permeability Rio Grande Alluvium');
model.param.set('k_MBA', 'K_MBA*mu/(rho_sw*g)', 'Permeability Mesilla Bolson Aquifer');
model.param.set('k_MDD', 'K_MDD*mu/(rho_sw*g)', 'Permeability Mesilla Diversion Dam');
model.param.set('mu', '1.012e-3[Pa*s]', 'Viscosity of surface water');
model.param.set('g', '9.81[m/s^2]', 'gravity');
model.param.set('Qv_sw', '10^(-9.23-0.82*log10(k_sw))[C/m^3]', 'Volumetric charge density surface water');
model.param.set('Qv_RGA', '10^(-9.23-0.82*log10(k_RGA))[C/m^3]', 'Volumetric charge density Rio Grande Alluvium');
model.param.set('Qv_MBA', '10^(-9.23-0.82*log10(k_MBA))[C/m^3]', 'Volumetric charge density Mesilla Bolson Aquifer');
model.param.set('Qv_MDD', '10^(-9.23-0.82*log10(k_MDD))[C/m^3]', 'Volumetric charge density Mesilla Diversion Dam');
model.param.set('Hup', '10[m]', 'Head on upstream boundary');
model.param.set('Hdown', '5[m]', 'Head on downstream boundary');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').curvedInterior(false);

model.result.table.create('evl2', 'Table');

model.func.create('int1', 'Interpolation');
model.func.create('int2', 'Interpolation');
model.func('int1').set('source', 'file');
model.func('int1').set('filename', 'D:\Self-potential Surveying and Modeling\SP Inversion\Rio Grande Inverse Model\v5_to_Jeremy\Input_K.txt');
model.func('int1').set('nargs', 2);
model.func('int1').set('fununit', {'m/s'});
model.func('int1').set('argunit', {'m' 'm'});
model.func('int2').set('source', 'file');
model.func('int2').set('importedname', 'Input_S.txt');
model.func('int2').set('importedstruct', 'Spreadsheet');
model.func('int2').set('importeddim', '2D');
model.func('int2').set('fununit', {'S/m'});
model.func('int2').set('argunit', {'m' 'm'});
model.func('int2').set('filename', 'C:\Users\sikard\AppData\Local\Temp\1\csjavabridge94875\Input_S.txt');
model.func('int2').importData;
model.func('int2').set('nargs', '2');
model.func('int2').set('struct', 'spreadsheet');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').label('Rio Grande Upstream');
model.component('comp1').geom('geom1').feature('r1').set('pos', {'-Lm' 'Hdam-channel_depth-2'});
model.component('comp1').geom('geom1').feature('r1').set('size', {'Lm' 'channel_depth'});
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').label('Rio Grande Downstream');
model.component('comp1').geom('geom1').feature('r2').set('pos', {'Ldam' '0'});
model.component('comp1').geom('geom1').feature('r2').set('size', {'Lm' 'channel_depth'});
model.component('comp1').geom('geom1').create('r3', 'Rectangle');
model.component('comp1').geom('geom1').feature('r3').label('Mesilla Dam');
model.component('comp1').geom('geom1').feature('r3').set('size', {'Ldam' 'Hdam'});
model.component('comp1').geom('geom1').create('r4', 'Rectangle');
model.component('comp1').geom('geom1').feature('r4').label('Rio Grande Alluvium Downstream');
model.component('comp1').geom('geom1').feature('r4').set('pos', {'0' '-RGA_thickness'});
model.component('comp1').geom('geom1').feature('r4').set('size', {'Lm+Ldam' 'RGA_thickness'});
model.component('comp1').geom('geom1').create('r5', 'Rectangle');
model.component('comp1').geom('geom1').feature('r5').label('Rio Grande Alluvium Upstream');
model.component('comp1').geom('geom1').feature('r5').set('pos', {'-Lm' '-RGA_thickness'});
model.component('comp1').geom('geom1').feature('r5').set('size', {'Lm' '(Hdam+RGA_thickness)-channel_depth-2'});
model.component('comp1').geom('geom1').create('r6', 'Rectangle');
model.component('comp1').geom('geom1').feature('r6').label('Mesilla Bolson Aquifer');
model.component('comp1').geom('geom1').feature('r6').set('pos', {'-Lm' '-RGA_thickness-MBA_thickness'});
model.component('comp1').geom('geom1').feature('r6').set('size', {'2*Lm+Ldam' 'MBA_thickness'});
model.component('comp1').geom('geom1').create('pt1', 'Point');
model.component('comp1').geom('geom1').feature('pt1').label('Well 1');
model.component('comp1').geom('geom1').feature('pt1').set('p', [-100 -35]);
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').physics.create('dl', 'DarcysLaw', 'geom1');
model.component('comp1').physics('dl').create('porous1', 'PorousMedium', 2);
model.component('comp1').physics('dl').create('dlm2', 'DarcysLawModel', 2);
model.component('comp1').physics('dl').feature('dlm2').selection.set([1 2 4]);
model.component('comp1').physics('dl').create('dlm3', 'DarcysLawModel', 2);
model.component('comp1').physics('dl').feature('dlm3').selection.set([1]);
model.component('comp1').physics('dl').create('dlm4', 'DarcysLawModel', 2);
model.component('comp1').physics('dl').feature('dlm4').selection.set([5]);
model.component('comp1').physics('dl').create('ag1', 'Atmosphere', 1);
model.component('comp1').physics('dl').feature('ag1').selection.set([7 18]);
model.component('comp1').physics('dl').create('ph1', 'PressureHead', 1);
model.component('comp1').physics('dl').feature('ph1').selection.set([1 3]);
model.component('comp1').physics('dl').create('ph2', 'PressureHead', 1);
model.component('comp1').physics('dl').feature('ph2').selection.set([19 20]);
model.component('comp1').physics('dl').create('hh1', 'HydraulicHead', 1);
model.component('comp1').physics('dl').feature('hh1').selection.set([5]);
model.component('comp1').physics('dl').create('hh2', 'HydraulicHead', 1);
model.component('comp1').physics('dl').feature('hh2').selection.set([21]);
model.component('comp1').physics.create('ec', 'ConductiveMedia', 'geom1');
model.component('comp1').physics('ec').create('cucn2', 'CurrentConservation', 2);
model.component('comp1').physics('ec').feature('cucn2').selection.set([1 3 5 6]);
model.component('comp1').physics('ec').create('cucn3', 'CurrentConservation', 2);
model.component('comp1').physics('ec').feature('cucn3').selection.set([1 5]);
model.component('comp1').physics('ec').create('cucn4', 'CurrentConservation', 2);
model.component('comp1').physics('ec').feature('cucn4').selection.set([5]);
model.component('comp1').physics('ec').create('ecd1', 'ExternalCurrentDensity', 2);
model.component('comp1').physics('ec').feature('ecd1').selection.set([3 6]);
model.component('comp1').physics('ec').create('ecd2', 'ExternalCurrentDensity', 2);
model.component('comp1').physics('ec').feature('ecd2').selection.set([2 4]);
model.component('comp1').physics('ec').create('ecd3', 'ExternalCurrentDensity', 2);
model.component('comp1').physics('ec').feature('ecd3').selection.set([1]);
model.component('comp1').physics('ec').create('ecd4', 'ExternalCurrentDensity', 2);
model.component('comp1').physics('ec').feature('ecd4').selection.set([5]);
model.component('comp1').physics('ec').create('gnd1', 'Ground', 1);
model.component('comp1').physics('ec').feature('gnd1').selection.set([1 2 3 5 19 20 21]);
model.component('comp1').physics('ec').create('ci1', 'ContactImpedance', 1);
model.component('comp1').physics('ec').feature('ci1').selection.set([6 10 11 16]);

model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');

model.result.table('evl2').label('Evaluation 2D');
model.result.table('evl2').comments('Interactive 2D values');

model.component('comp1').view('view1').axis.set('xmin', -358.86328125);
model.component('comp1').view('view1').axis.set('xmax', 489.421875);
model.component('comp1').view('view1').axis.set('ymin', -173.34320068359375);
model.component('comp1').view('view1').axis.set('ymax', 137.8796844482422);

model.component('comp1').physics('dl').feature('porous1').label('Porous Medium 2');
model.component('comp1').physics('dl').feature('dlm1').set('rho_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm1').set('rho', 'rho_sw');
model.component('comp1').physics('dl').feature('dlm1').set('mu_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm1').set('mu', 'mu');
model.component('comp1').physics('dl').feature('dlm1').set('ktype', 'conductivity');
model.component('comp1').physics('dl').feature('dlm1').set('K', {'int1(x,y)'; '0'; '0'; '0'; 'int1(x,y)'; '0'; '0'; '0'; 'int1(x,y)'});
model.component('comp1').physics('dl').feature('dlm1').set('epsilon_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm1').set('epsilon', 'phi_sw');
model.component('comp1').physics('dl').feature('dlm1').set('kappa', [0; 0; 0; 0; 0; 0; 0; 0; 0]);
model.component('comp1').physics('dl').feature('dlm1').set('minput_temperature_src', 'userdef');
model.component('comp1').physics('dl').feature('dlm1').label('Fluid and Matrix Properties Rio Grande');
model.component('comp1').physics('dl').feature('init1').set('InitType', 'Hp');
model.component('comp1').physics('dl').feature('dcont1').set('pairDisconnect', true);
model.component('comp1').physics('dl').feature('dcont1').label('Continuity');
model.component('comp1').physics('dl').feature('dlm2').set('rho_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm2').set('rho', 'rho_sw');
model.component('comp1').physics('dl').feature('dlm2').set('mu_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm2').set('mu', 'mu');
model.component('comp1').physics('dl').feature('dlm2').set('ktype', 'conductivity');
model.component('comp1').physics('dl').feature('dlm2').set('K', {'int1(x,y)'; '0'; '0'; '0'; 'int1(x,y)'; '0'; '0'; '0'; 'int1(x,y)'});
model.component('comp1').physics('dl').feature('dlm2').set('epsilon_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm2').set('epsilon', 'phi_RGA');
model.component('comp1').physics('dl').feature('dlm2').set('kappa_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm2').set('kappa', [0; 0; 0; 0; 0; 0; 0; 0; 0]);
model.component('comp1').physics('dl').feature('dlm2').set('minput_temperature_src', 'userdef');
model.component('comp1').physics('dl').feature('dlm2').label('Fluid and Matrix Properties Rio Grande Alluvium');
model.component('comp1').physics('dl').feature('dlm3').set('rho_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm3').set('rho', 'rho_sw');
model.component('comp1').physics('dl').feature('dlm3').set('mu_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm3').set('mu', 'mu');
model.component('comp1').physics('dl').feature('dlm3').set('ktype', 'conductivity');
model.component('comp1').physics('dl').feature('dlm3').set('K', {'int1(x,y)'; '0'; '0'; '0'; 'int1(x,y)'; '0'; '0'; '0'; 'int1(x,y)'});
model.component('comp1').physics('dl').feature('dlm3').set('epsilon_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm3').set('epsilon', 'phi_MBA');
model.component('comp1').physics('dl').feature('dlm3').set('kappa_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm3').set('kappa', [0; 0; 0; 0; 0; 0; 0; 0; 0]);
model.component('comp1').physics('dl').feature('dlm3').set('minput_temperature_src', 'userdef');
model.component('comp1').physics('dl').feature('dlm3').label('Fluid and Matrix Properties Mesilla Bolson Aquifer');
model.component('comp1').physics('dl').feature('dlm4').set('rho_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm4').set('rho', 1950);
model.component('comp1').physics('dl').feature('dlm4').set('mu_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm4').set('mu', 'mu');
model.component('comp1').physics('dl').feature('dlm4').set('ktype', 'conductivity');
model.component('comp1').physics('dl').feature('dlm4').set('K', {'int1(x,y)'; '0'; '0'; '0'; 'int1(x,y)'; '0'; '0'; '0'; 'int1(x,y)'});
model.component('comp1').physics('dl').feature('dlm4').set('epsilon_mat', 'userdef');
model.component('comp1').physics('dl').feature('dlm4').set('epsilon', 'phi_MDD');
model.component('comp1').physics('dl').feature('dlm4').set('kappa', [0; 0; 0; 0; 0; 0; 0; 0; 0]);
model.component('comp1').physics('dl').feature('dlm4').set('minput_temperature_src', 'userdef');
model.component('comp1').physics('dl').feature('dlm4').label('Fluid and Matrix Properties Mesilla Diversion Dam');
model.component('comp1').physics('dl').feature('ag1').active(false);
model.component('comp1').physics('dl').feature('ph1').set('Hp0', 'dl.H-y');
model.component('comp1').physics('dl').feature('ph1').label('Pressure Head Upstream');
model.component('comp1').physics('dl').feature('ph2').set('Hp0', 'dl.H+abs(y)');
model.component('comp1').physics('dl').feature('ph2').label('Pressure Head Downstream');
model.component('comp1').physics('dl').feature('hh1').set('H0', 'Hup');
model.component('comp1').physics('dl').feature('hh1').label('Hydraulic Head Upstream');
model.component('comp1').physics('dl').feature('hh2').set('H0', 'Hdown');
model.component('comp1').physics('dl').feature('hh2').label('Hydraulic Head Downstream');
model.component('comp1').physics('dl').feature('gr1').label('Gravity');
model.component('comp1').physics('ec').prop('PortSweepSettings').set('PortParamName', 'PortName');
model.component('comp1').physics('ec').feature('cucn1').set('sigma_mat', 'userdef');
model.component('comp1').physics('ec').feature('cucn1').set('sigma', {'int2(x,y)'; '0'; '0'; '0'; 'int2(x,y)'; '0'; '0'; '0'; 'int2(x,y)'});
model.component('comp1').physics('ec').feature('cucn1').set('materialType', 'solid');
model.component('comp1').physics('ec').feature('cucn1').set('minput_temperature_src', 'userdef');
model.component('comp1').physics('ec').feature('cucn1').set('minput_numberdensity', 0);
model.component('comp1').physics('ec').feature('cucn1').label('Current Conservation Rio Grande Alluvium');
model.component('comp1').physics('ec').feature('dcont1').set('pairDisconnect', true);
model.component('comp1').physics('ec').feature('dcont1').label('Continuity');
model.component('comp1').physics('ec').feature('cucn2').set('sigma_mat', 'userdef');
model.component('comp1').physics('ec').feature('cucn2').set('sigma', {'int2(x,y)'; '0'; '0'; '0'; 'int2(x,y)'; '0'; '0'; '0'; 'int2(x,y)'});
model.component('comp1').physics('ec').feature('cucn2').set('minput_temperature_src', 'userdef');
model.component('comp1').physics('ec').feature('cucn2').set('minput_numberdensity', 0);
model.component('comp1').physics('ec').feature('cucn2').label('Current Conservation Rio Grande');
model.component('comp1').physics('ec').feature('cucn3').set('sigma_mat', 'userdef');
model.component('comp1').physics('ec').feature('cucn3').set('sigma', {'int2(x,y)'; '0'; '0'; '0'; 'int2(x,y)'; '0'; '0'; '0'; 'int2(x,y)'});
model.component('comp1').physics('ec').feature('cucn3').set('materialType', 'solid');
model.component('comp1').physics('ec').feature('cucn3').set('minput_temperature_src', 'userdef');
model.component('comp1').physics('ec').feature('cucn3').set('minput_numberdensity', 0);
model.component('comp1').physics('ec').feature('cucn3').label('Current Conservation Mesilla Basin Aquifer');
model.component('comp1').physics('ec').feature('cucn4').set('sigma_mat', 'userdef');
model.component('comp1').physics('ec').feature('cucn4').set('sigma', {'int2(x,y)'; '0'; '0'; '0'; 'int2(x,y)'; '0'; '0'; '0'; 'int2(x,y)'});
model.component('comp1').physics('ec').feature('cucn4').set('materialType', 'solid');
model.component('comp1').physics('ec').feature('cucn4').set('minput_temperature_src', 'userdef');
model.component('comp1').physics('ec').feature('cucn4').set('minput_numberdensity', 0);
model.component('comp1').physics('ec').feature('cucn4').label('Current Conservation Mesilla Diversion Dam');
model.component('comp1').physics('ec').feature('ecd1').label('External Current Density - Rio Grande');
model.component('comp1').physics('ec').feature('ecd2').set('Je', {'dl.u*Qv_RGA'; 'dl.v*Qv_RGA'; '0'});
model.component('comp1').physics('ec').feature('ecd2').label('External Current Density - Rio Grande Alluvium');
model.component('comp1').physics('ec').feature('ecd3').set('Je', {'dl.u*Qv_MBA'; 'dl.v*Qv_MBA'; '0'});
model.component('comp1').physics('ec').feature('ecd3').label('External Current Density - Mesilla Basin Aquifer');
model.component('comp1').physics('ec').feature('ecd4').label('External Current Density - Mesilla Diversion Dam');
model.component('comp1').physics('ec').feature('gnd1').label('Electric Ground');
model.component('comp1').physics('ec').feature('ci1').set('sigmabnd_mat', 'userdef');
model.component('comp1').physics('ec').feature('ci1').set('sigmabnd', 'int2(x,y)');

model.component('comp1').mesh('mesh1').feature('size').set('hauto', 4);
model.component('comp1').mesh('mesh1').feature('ftri1').set('smoothmaxiter', 8);
model.component('comp1').mesh('mesh1').feature('ftri1').set('smoothmaxdepth', 8);
model.component('comp1').mesh('mesh1').run;

model.component('comp1').physics('dl').feature('dlm1').set('kappa_mat', 'from_mat');
model.component('comp1').physics('dl').feature('dlm4').set('kappa_mat', 'from_mat');

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').set('activate', {'dl' 'on' 'ec' 'off'});
model.study.create('std2');
model.study('std2').create('stat', 'Stationary');
model.study('std2').feature('stat').set('activate', {'dl' 'off' 'ec' 'on'});

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol.create('sol2');
model.sol('sol2').study('std2');
model.sol('sol2').attach('std2');
model.sol('sol2').create('st1', 'StudyStep');
model.sol('sol2').create('v1', 'Variables');
model.sol('sol2').create('s1', 'Stationary');
model.sol('sol2').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol2').feature('s1').feature.remove('fcDef');

model.result.create('pg1', 'PlotGroup2D');
model.result.create('pg2', 'PlotGroup2D');
model.result.create('pg3', 'PlotGroup1D');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').create('arws1', 'ArrowSurface');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('surf1').set('data', 'dset1');
model.result('pg1').feature('surf1').set('expr', 'dl.H');
model.result('pg1').feature('con1').set('expr', 'dl.H');
model.result('pg2').set('data', 'dset2');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').create('arws1', 'ArrowSurface');
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('surf1').set('expr', 'V');
model.result('pg2').feature('con1').set('expr', 'dl.H');
model.result('pg3').create('lngr1', 'LineGraph');
model.result('pg3').create('lngr2', 'LineGraph');
model.result('pg3').feature('lngr1').set('data', 'dset2');
model.result('pg3').feature('lngr1').set('xdata', 'expr');
model.result('pg3').feature('lngr1').selection.set([6 16]);
model.result('pg3').feature('lngr1').set('expr', 'V');
model.result('pg3').feature('lngr2').set('xdata', 'expr');
model.result('pg3').feature('lngr2').selection.set([7 18]);
model.result('pg3').feature('lngr2').set('expr', 'V');

model.study('std1').label('Darcys Law Solver');
model.study('std2').label('Electrostatic Solver');
model.study('std2').feature('stat').set('usesol', true);
model.study('std2').feature('stat').set('notsolmethod', 'sol');
model.study('std2').feature('stat').set('notstudy', 'std1');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label('Compile Equations: Stationary');
model.sol('sol1').feature('v1').label('Dependent Variables 1.1');
model.sol('sol1').feature('s1').label('Stationary Solver 1.1');
model.sol('sol1').feature('s1').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s1').feature('dDef').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('s1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol1').runAll;
model.sol('sol2').attach('std2');
model.sol('sol2').feature('st1').label('Compile Equations: Stationary');
model.sol('sol2').feature('v1').label('Dependent Variables 1.1');
model.sol('sol2').feature('v1').set('notsolmethod', 'sol');
model.sol('sol2').feature('v1').set('notsol', 'sol1');
model.sol('sol2').feature('v1').set('notsolnum', 'auto');
model.sol('sol2').feature('s1').label('Stationary Solver 1.1');
model.sol('sol2').feature('s1').feature('dDef').label('Direct 1');
model.sol('sol2').feature('s1').feature('aDef').label('Advanced 1');
model.sol('sol2').feature('s1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol2').runAll;

model.result.dataset('dset1').set('frametype', 'material');
model.result.dataset('dset2').set('frametype', 'material');
model.result('pg1').label('Hydraulic Model');
model.result('pg1').feature('surf1').label('Surface');
model.result('pg1').feature('surf1').set('rangecoloractive', true);
model.result('pg1').feature('surf1').set('rangecolormin', -450);
model.result('pg1').feature('surf1').set('rangecolormax', 200);
model.result('pg1').feature('surf1').set('colortable', 'RainbowClassic');
model.result('pg1').feature('surf1').set('smooth', 'internal');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('arws1').set('xnumber', 25);
model.result('pg1').feature('arws1').set('arrowlength', 'normalized');
model.result('pg1').feature('arws1').set('scale', 1.5);
model.result('pg1').feature('arws1').set('scaleactive', true);
model.result('pg1').feature('arws1').set('color', 'black');
model.result('pg1').feature('con1').set('number', 50);
model.result('pg1').feature('con1').set('levelrounding', false);
model.result('pg1').feature('con1').set('coloring', 'uniform');
model.result('pg1').feature('con1').set('color', 'white');
model.result('pg1').feature('con1').set('smooth', 'internal');
model.result('pg1').feature('con1').set('resolution', 'normal');
model.result('pg2').label('Electric Potential (ec)');
model.result('pg2').set('frametype', 'spatial');
model.result('pg2').feature('surf1').set('unit', 'mV');
model.result('pg2').feature('surf1').set('colortable', 'RainbowClassic');
model.result('pg2').feature('surf1').set('smooth', 'internal');
model.result('pg2').feature('surf1').set('resolution', 'normal');
model.result('pg2').feature('arws1').set('xnumber', 70);
model.result('pg2').feature('arws1').set('ynumber', 30);
model.result('pg2').feature('arws1').set('arrowlength', 'normalized');
model.result('pg2').feature('arws1').set('scale', 300000);
model.result('pg2').feature('arws1').set('scaleactive', true);
model.result('pg2').feature('arws1').set('color', 'black');
model.result('pg2').feature('con1').set('number', 50);
model.result('pg2').feature('con1').set('levelrounding', false);
model.result('pg2').feature('con1').set('coloring', 'uniform');
model.result('pg2').feature('con1').set('color', 'white');
model.result('pg2').feature('con1').set('smooth', 'internal');
model.result('pg2').feature('con1').set('resolution', 'normal');
model.result('pg3').set('xlabelactive', true);
model.result('pg3').set('ylabel', 'Electric potential (mV)');
model.result('pg3').set('ylabelactive', false);
model.result('pg3').feature('lngr1').set('unit', 'mV');
model.result('pg3').feature('lngr1').set('xdataexpr', 'x');
model.result('pg3').feature('lngr1').set('xdataunit', 'm');
model.result('pg3').feature('lngr1').set('xdatadescr', 'x-coordinate');
model.result('pg3').feature('lngr1').set('smooth', 'internal');
model.result('pg3').feature('lngr1').set('resolution', 'normal');
model.result('pg3').feature('lngr2').active(false);
model.result('pg3').feature('lngr2').set('unit', 'mV');
model.result('pg3').feature('lngr2').set('xdataexpr', 'x');
model.result('pg3').feature('lngr2').set('xdataunit', 'm');
model.result('pg3').feature('lngr2').set('xdatadescr', 'x-coordinate');
model.result('pg3').feature('lngr2').set('smooth', 'internal');
model.result('pg3').feature('lngr2').set('resolution', 'normal');



load('Output_V.txt');
coords=Output_V(:,1:2);
mo=mphinterp(model,{'d(ec.Jx,x) + d(ec.Jy,y) '},'Coord',coords',...
    'dataset','dset2','Outersolnum',1); %A/m3
dlmwrite('mref_v2.txt',mo','precision',15)






out = model;
