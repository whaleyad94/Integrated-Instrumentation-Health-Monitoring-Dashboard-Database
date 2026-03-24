INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('TEMP', 'Temperature', '°C', 'The most widely measured parameter in nuclear plants. Covers RCS hot/cold leg, core exit, steam generator, containment atmosphere, and component cooling water.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('PRES', 'Pressure', 'Pa', 'Absolute and gauge pressure measurements throughout the plant. Includes RCS pressure via pressurizer transmitters, steam generator secondary side pressure, containment pressure for accident monitoring, and accumulator pressure. One of the most safety-critical measurements in a PWR as it indicates whether the reactor coolant system is maintaining its pressure boundary.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('DP', 'Differential Pressure', 'Pa', 'Pressure difference measured between two points. The foundation for inferring flow rate across orifice plates and venturis, level from hydrostatic head, and filter/strainer condition. The most widely installed instrument type in nuclear plants, with a single plant potentially having several hundred differential pressure transmitters.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('FLOW', 'Flow', 'm³/s', 'Direct measurement of fluid flow rate using technologies like magnetic flow meters, ultrasonic meters, or turbine meters. Also inferred from differential pressure across orifice plates, venturis, and elbow taps. Critical for reactor power calculation via secondary heat balance, safety injection verification, and RCS leak detection.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('LEVEL', 'Level', 'm', 'Height of liquid in a vessel or tank. Critical measurements include pressurizer level for RCS inventory control, steam generator level for heat transfer and feedwater control, reactor vessel level for inadequate core cooling monitoring, and RWST level for available safety injection water.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('NFLUX', 'Neutron Flux', 'neutrons/cm²·s', 'The fundamental measurement of the nuclear fission chain reaction. Spans approximately 10 decades from shutdown to full power, requiring three separate detector ranges. Unique to nuclear facilities. Provides the primary inputs for reactor protection system trips and automatic control rod positioning.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('RAD', 'Radiation', 'Sv/h', 'Measurement of ionizing radiation for health physics, environmental protection, and process monitoring. Covers area dose rate monitoring, airborne activity, process fluid activity, effluent releases, and post-accident high-range containment monitoring. Required for compliance with 10CFR20 dose limits and ODCM effluent requirements.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('VIB', 'Vibration', 'm/s²', 'Dynamic mechanical motion of rotating machinery components. Monitors bearing health, shaft condition, and mechanical integrity of reactor coolant pumps, main turbine-generator, feedwater pumps, and other critical equipment. The primary parameter for predictive maintenance of rotating machinery.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('ACOUS', 'Acoustic Emission', 'dB', 'High-frequency stress waves from material deformation, crack propagation, or mechanical impacts. Covers loose parts monitoring systems on the reactor vessel and steam generators, structural integrity monitoring via acoustic emission sensors, and acoustic leak detection.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('POS', 'Position', '%', 'Location or state of mechanical components including valves, control rods, dampers, and breakers. Critical for verifying plant configuration, safety system alignment, and control rod insertion for reactor shutdown capability.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('SPEED', 'Speed', 'RPM', 'Rotational velocity of pumps, turbines, generators, and motors. Monitored for equipment protection, performance verification, and as input to control systems for diesel generator frequency control and turbine overspeed protection.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('TORQ', 'Torque', 'N·m', 'Rotational force applied by motors and drives. Primary application is motor-operated valve testing to verify valve thrust capability per NRC Generic Letters 89-10 and 96-05. Also monitored on pump drives for load assessment.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('STRAIN', 'Strain', 'με', 'Deformation of structural materials under load, thermal cycling, and pressure. Measured on piping, reactor vessel nozzles, containment structures, and structural steel for structural integrity monitoring and fatigue life tracking.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('DISP', 'Displacement', 'mm', 'Physical movement or change in distance between structural points. Covers thermal expansion of piping systems, relative movement between building structures, crack width monitoring in concrete, and structural settlement over the plant''s operating lifetime.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('FORCE', 'Force/Load', 'N', 'Direct force measurement for structural loads, crane operations, fuel handling, and containment tendon surveillance. Ensures mechanical components are operating within design load limits and safety margins.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('ELEC', 'Electrical', 'V/A/W', 'Voltage, current, power, frequency, resistance, and impedance measurements across the plant''s electrical distribution system. Covers generator output, bus loads, motor health via current signature analysis, battery monitoring, and insulation resistance.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('CHEM', 'Chemistry', 'varies', 'Water quality parameters including pH, conductivity, dissolved oxygen, dissolved hydrogen, boron concentration, and trace contaminant levels. Protects against corrosion-induced degradation of steam generator tubes, piping, and structural materials.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('GAS', 'Gas Concentration', '% vol', 'Percentage by volume or ppm concentration of specific gases in enclosed spaces. Primary application is containment hydrogen monitoring to detect flammable concentrations following fuel damage. Also covers oxygen monitoring and combustible gas detection in waste processing systems.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('HUMID', 'Humidity', '%RH', 'Moisture content of air in containment, equipment rooms, and control room. An early indicator of RCS leakage inside containment and important for preventing moisture-related degradation of electrical equipment and insulation.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('SEIS', 'Seismic Acceleration', 'g', 'Ground and structural acceleration during earthquake events. Measured by triaxial accelerometers at multiple plant locations per Regulatory Guide 1.12. Used to determine whether seismic design basis has been exceeded and whether continued operation is safe.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('MET', 'Meteorological', 'varies', 'Weather conditions measured at the plant''s meteorological tower. Wind speed and direction at multiple elevations, atmospheric stability from delta-temperature, precipitation, and barometric pressure. Required for radiological dose projections during emergency events per 10CFR50.47 and Regulatory Guide 1.23.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('LEAK', 'Leak Rate', 'L/min', 'Quantification of fluid leakage from containment or primary system boundaries. Includes containment integrated leak rate testing per 10CFR50 Appendix J, local leak rate testing of individual penetrations and valves, and continuous RCS leak detection and quantification.');

INSERT INTO measurement_parameters (parameter_code, parameter_name, si_unit, description)
VALUES ('DENS', 'Density', 'kg/m³', 'Mass per unit volume of process fluids. Used for compensating level measurements that are affected by temperature-dependent density changes, verifying boric acid concentration, and monitoring for two-phase conditions in the RCS.');
