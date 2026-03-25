INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('RCS', 'Reactor Coolant System', 'Primary loop that circulates pressurized water through the reactor core and steam generators to transfer heat from nuclear fission to the secondary system. Includes the reactor vessel, steam generators, reactor coolant pumps, pressurizer, and connecting piping. Operates at approximately 15.5 MPa and 315°C.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('ECCS', 'Emergency Core Cooling System', 'Provides emergency cooling water to the reactor core following a loss of coolant accident. Includes high-pressure safety injection, low-pressure safety injection (residual heat removal), and accumulators. Designed to keep the fuel covered and prevent core damage under all postulated break sizes.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('RHR', 'Residual Heat Removal System', 'Removes decay heat from the reactor core during shutdown and cooldown operations. Also serves as the low-pressure safety injection component of the ECCS during accident conditions. Operates when RCS pressure and temperature are reduced below normal operating conditions.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('CVCS', 'Chemical and Volume Control System', 'Controls RCS water chemistry, boron concentration, and coolant inventory. Provides charging flow to maintain pressurizer level, letdown flow for purification, and boric acid addition and dilution for reactivity control. Contains ion exchangers and filters for coolant purification.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('SIS', 'Safety Injection System', 'Delivers borated water from the refueling water storage tank and accumulators to the reactor vessel during a loss of coolant accident. Includes safety injection pumps, accumulator tanks pressurized with nitrogen, and associated piping and valves.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('CSS', 'Containment Spray System', 'Reduces containment pressure and temperature following a loss of coolant accident or main steam line break inside containment by spraying cool borated water into the containment atmosphere. Also removes airborne radioactive iodine through chemical addition to the spray solution.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('CCW', 'Component Cooling Water System', 'Closed-loop intermediate cooling system that removes heat from safety-related and non-safety-related components. Acts as a barrier between potentially radioactive systems and the ultimate heat sink. Cools RCP thermal barriers, letdown heat exchangers, spent fuel pool heat exchangers, and RHR heat exchangers.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('SWS', 'Service Water System', 'Provides cooling water from the ultimate heat sink to the component cooling water heat exchangers, diesel generator coolers, and other heat loads. The interface between the plant cooling systems and the environment. Must function during all design basis events including loss of offsite power.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('EDS', 'Emergency Diesel Generator System', 'Provides onsite emergency AC power to safety-related buses when offsite power is lost. Typically two or more diesel generators, each capable of powering a complete train of safety equipment. Must start and load within approximately 10 seconds of a loss of offsite power signal.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('AFW', 'Auxiliary Feedwater System', 'Provides feedwater to the steam generators when the main feedwater system is unavailable. Critical for removing decay heat from the RCS following a reactor trip. Includes motor-driven and turbine-driven pumps drawing from the condensate storage tank.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('CRDS', 'Control Rod Drive System', 'Provides the mechanism for inserting and withdrawing control rod assemblies in the reactor core. Includes the control rod drive mechanisms mounted on the reactor vessel head, the power supply cabinets, and the rod position indication system. Must provide rapid insertion (scram) capability for reactor shutdown.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('RPS', 'Reactor Protection System', 'Monitors critical plant parameters and automatically initiates reactor trip and engineered safety feature actuation when setpoints are exceeded. Uses redundant sensor channels with coincidence logic to prevent both spurious trips and failure to trip. The most safety-critical instrumentation and control system in the plant.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('ESFAS', 'Engineered Safety Features Actuation System', 'Automatically actuates engineered safety features such as safety injection, containment spray, containment isolation, and auxiliary feedwater based on plant parameter signals. Works in conjunction with the reactor protection system to mitigate design basis accidents.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('CTMT', 'Containment System', 'The reinforced concrete and steel structure that encloses the reactor, steam generators, and RCS piping. Designed to contain radioactive material released during a design basis accident. Includes the containment building, penetrations, isolation valves, personnel airlocks, and equipment hatches.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('CVS', 'Containment Ventilation System', 'Controls the atmosphere inside containment including temperature, humidity, and airborne radioactivity during normal operations. Includes containment air coolers, hydrogen monitoring and control, containment purge and vent systems, and post-accident filtration.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('EDPS', 'Essential DC Power System', 'Provides vital DC power from station batteries and battery chargers for reactor protection system logic, emergency instrumentation, control room indication, emergency lighting, and DC-powered valve operations. Must function for the duration of a station blackout event.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('MSS', 'Main Steam System', 'Delivers steam from the steam generators to the main turbine-generator for electricity production. Includes main steam piping, main steam isolation valves, atmospheric relief valves, and safety valves. The main steam isolation valves are safety-related components within this otherwise non-safety system.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('FWS', 'Main Feedwater System', 'Supplies heated feedwater to the steam generators during normal power operation. Includes the main feedwater pumps, feedwater heaters, feedwater regulating valves, and associated piping. Works with the condensate system to form the secondary cycle.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('CDS', 'Condensate System', 'Collects condensed steam from the main condenser and pumps it through low-pressure feedwater heaters toward the main feedwater system. Includes condensate pumps, condensate polishers for water purification, and the condensate storage tank that serves as backup supply for auxiliary feedwater.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('TGS', 'Turbine-Generator System', 'Converts thermal energy in the main steam to electrical energy. Includes the high-pressure and low-pressure turbine stages, moisture separator reheaters, the main generator, hydrogen cooling system, and excitation system. The single largest piece of equipment in the plant.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('CWS', 'Circulating Water System', 'Provides cooling water to the main condenser to condense exhaust steam from the low-pressure turbines. Includes circulating water pumps, the cooling tower or intake/discharge structures, and the condenser water boxes and tubes.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('IAS', 'Instrument Air System', 'Provides clean, dry compressed air for pneumatically operated instruments and control valves throughout the plant. Includes air compressors, aftercoolers, dryers, filters, and the distribution header. Loss of instrument air can cause multiple control valves to fail to their safe position.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('WPS', 'Radioactive Waste Processing System', 'Collects, processes, stores, and disposes of radioactive waste generated during plant operations. Includes liquid waste processing, gaseous waste processing, and solid waste handling. Processes include filtration, demineralization, evaporation, and decay storage before controlled release or disposal.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('SFPS', 'Spent Fuel Pool System', 'Provides cooling and purification for the spent fuel pool where used fuel assemblies are stored after removal from the reactor. Maintains fuel pool water temperature below limits and water clarity sufficient for fuel handling operations. Includes spent fuel pool heat exchangers, pumps, and demineralizers.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('HVAC', 'Heating Ventilation and Air Conditioning', 'Maintains environmental conditions throughout the plant including the control room, equipment rooms, auxiliary building, and turbine building. Controls temperature, humidity, and airborne contamination. The control room HVAC includes emergency filtration for post-accident habitability.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('FPS', 'Fire Protection System', 'Provides fire detection and suppression throughout the plant. Includes fire detection systems, sprinkler systems, fire hydrants, hose stations, and CO2 suppression systems. Nuclear plant fire protection is governed by 10CFR50.48 and NFPA 805.', FALSE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('RWST', 'Refueling Water Storage Tank System', 'Stores a large inventory of borated water that supplies the ECCS and containment spray pumps during accident conditions. Also used during refueling operations to flood the refueling cavity. RWST level is a critical monitored parameter that triggers the switchover to containment sump recirculation.', TRUE);

INSERT INTO plant_systems (system_code, system_name, description, is_safety_related)
VALUES ('BDS', 'Boron Dilution System', 'Provides controlled dilution of primary coolant boron concentration using demineralized water. Used to increase reactivity as fuel depletes over the operating cycle. Boron dilution must be carefully controlled to prevent inadvertent criticality.', FALSE);
