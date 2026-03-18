-- ** Database generated with pgModeler (PostgreSQL Database Modeler).
-- ** pgModeler version: 1.2.3
-- ** PostgreSQL version: 18.0
-- ** Project Site: pgmodeler.io
-- ** Model Author: ---

-- ** Database creation must be performed outside a multi lined SQL file. 
-- ** These commands were put in this file only as a convenience.

-- object: new_database | type: DATABASE --
-- DROP DATABASE IF EXISTS new_database;
CREATE DATABASE new_database;
-- ddl-end --


-- object: instrumentation_health_monitoring | type: SCHEMA --
-- DROP SCHEMA IF EXISTS instrumentation_health_monitoring CASCADE;
CREATE SCHEMA instrumentation_health_monitoring;
-- ddl-end --
ALTER SCHEMA instrumentation_health_monitoring OWNER TO postgres;
-- ddl-end --

SET search_path TO pg_catalog,public,instrumentation_health_monitoring;
-- ddl-end --

-- object: public.instrument_types | type: TABLE --
-- DROP TABLE IF EXISTS public.instrument_types CASCADE;
CREATE TABLE public.instrument_types (
	type_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	type_code varchar NOT NULL,
	type_name varchar(100),
	sensing_principle text,
	typical_accuracy varchar(50),
	typical_range_min numeric,
	typical_range_max numeric,
	range_unit varchar(20),
	output_signal varchar(50),
	power_requirements varchar(50),
	environmental_qualification varchar(50),
	radiation_tolerance varchar(100),
	typical_lifespan_years numeric,
	maintenance_considerations text,
	is_active boolean NOT NULL DEFAULT TRUE,
	description text,
	parameter_id_measurement_parameters integer,
	CONSTRAINT uq_instrument_types_type_code UNIQUE (type_code),
	CONSTRAINT instrument_types_pk PRIMARY KEY (type_id),
	CONSTRAINT uq_instrument_types_type_name UNIQUE (type_name)
);
-- ddl-end --
COMMENT ON TABLE public.instrument_types IS E'Before we define the columns for the ''instruments'' table, we need to clarify an important distinction. The instruments table holds individual physical devices — the specific RTD with serial number TE-0412A installed on Hot Leg Loop 1. What makes it comprehensive isn''t the table structure itself, but the instrument types that populate it. The instrument types table is the catalog of all sensing technologies used in the plant, and every individual instrument references a type.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.type_id IS E'Primary key. An auto-incrementing integer. This is the internal database identifier that other tables reference. For data type, I choose integer because it is the standard choice for primary keys. It costs only 2 extra bytes per row and avoids any future limitations. For Default Value, I select the Identity radio button at the bottom (the third option). Make sure the dropdown next to it says ALWAYS. This is what makes it auto-incrementing.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.type_code IS E'A short, standardized code for the instrument type. For example, "RTD" for Resistance Temperature Detectors, "CT" for Current Transformers, "SPND" for Self-Powered Neutron Detectors. This is what engineers would use in conversation and on documentation. Should be unique and constrained to a consistent format. \n\nFor Data Type, we choose VarThen because Variable-length with a maximum. Stores only the characters you actually provide, up to the limit. "RTD" stores as just "RTD" using only 3 characters. The length limit acts as a data integrity guard — it prevents someone from accidentally inserting a 500-character string into a field that should hold a short code. That''s why it''s appropriate for type_code — you know codes should be short, so capping it at 20 characters enforces that expectation at the database level. Then in the L (length) field next to it, we enter 20. This gives us up to 20 characters, which is plenty for short codes like "RTD", "SPND", "LPMS_ACCEL" while preventing someone from accidentally storing a full sentence in a code field.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.type_name IS E'The full descriptive name. "Resistance Temperature Detector", "Capacitance Pressure Transmitter", "Self-Powered Neutron Detector". This is what displays on dashboards and reports.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.sensing_principle IS E'A text description of how the instrument physically makes its measurement. For an RTD: "Electrical resistance of platinum element changes predictably with temperature." For a capacitance pressure transmitter: "Diaphragm deflection under pressure changes capacitance between sensing element and fixed plate." This is valuable for training, troubleshooting, and understanding why certain failure modes occur.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.typical_accuracy IS E'The nominal accuracy specification for this type of instrument. For example, "±0.1-0.5°C" for RTDs, "±0.25% of span" for capacitance pressure transmitters. Stored as text rather than a numeric value because accuracy specifications have different formats and qualifying conditions across instrument types';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.typical_range_min IS E'Lower bound of the general operating range for this sensing technology. Represents the technology''s capability, not any individual instrument''s calibrated range.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.typical_range_max IS E'Upper bound of the general operating range for this sensing technology. Represents the technology''s capability, not any individual instrument''s calibrated range';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.range_unit IS E'The engineering unit for the typical range values. °C, MPa, neutrons/cm²·s, etc. This could alternatively be pulled from the measurement_parameters table if you want to enforce consistency at that level, but having it here allows for cases where different instrument types under the same parameter might use different practical units.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.output_signal IS E'What electrical signal the instrument produces. Common values: "4-20 mA", "0-10 VDC", "pulse/frequency", "thermocouple mV", "resistance (ohms)", "digital/fieldbus", "self-generating (no power required)", "contact closure". This is important because it determines what signal conditioning, wiring, and input cards are needed';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.power_requirements IS E'What the instrument needs to operate. "24 VDC loop powered", "120 VAC", "self-powered", "none (passive)". Important for understanding failure modes — a loss of power affects loop-powered transmitters differently than self-powered sensors.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.environmental_qualification IS E'Whether this instrument type is generally available in environmentally qualified (EQ) versions suitable for harsh environments (inside containment during design basis accidents). This could be a boolean (EQ available: yes/no) or a text field describing the qualifying conditions. EQ is a major regulatory requirement under 10CFR50.49, and knowing which instrument types can be qualified affects design decisions.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.radiation_tolerance IS E'General radiation tolerance of the sensing technology. Some instruments (like fiber optic sensors) are inherently radiation-tolerant, while others (like certain semiconductor devices) have limited total dose capability. Stored as text describing the general capability rather than a hard number, since tolerance depends on specific models and conditions';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.typical_lifespan_years IS E'The expected service life under normal conditions. RTDs might be 20-40 years, rhodium SPNDs might be 3-5 years due to emitter burnup. Helps with lifecycle planning and replacement forecasting.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.maintenance_considerations IS E'Text field describing general maintenance and calibration characteristics for this type. For example, RTDs: "Subject to RTDR (resistance vs. temperature) drift; calibration verified by cross-comparison or removal and bench calibration." For orifice plates: "No moving parts; primary degradation is plate erosion affecting discharge coefficient." This field supports maintenance planning and troubleshooting';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.is_active IS E'Boolean flag indicating whether this instrument type is currently in active use at the plant. Older technologies (like BF-3 proportional counters) may be retained in the database for historical records but flagged as inactive';
-- ddl-end --
COMMENT ON COLUMN public.instrument_types.description IS E'A longer text field for any additional information about the instrument type that doesn''t fit neatly into the structured fields. Technical notes, historical context, applicable IEEE or ISA standards, or references to vendor technical manuals.';
-- ddl-end --
COMMENT ON CONSTRAINT uq_instrument_types_type_code ON public.instrument_types IS E'We give this constraint a descriptive name like uq_instrument_types_type_code. The naming convention uq_tablename_columnname is a common professional practice that makes it immediately clear what the constraint does.';
-- ddl-end --
ALTER TABLE public.instrument_types OWNER TO postgres;
-- ddl-end --

-- object: public.measurement_parameters | type: TABLE --
-- DROP TABLE IF EXISTS public.measurement_parameters CASCADE;
CREATE TABLE public.measurement_parameters (
	parameter_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	parameter_code varchar(10) NOT NULL,
	parameter_name varchar(50) NOT NULL,
	si_unit varchar(30) NOT NULL,
	description text,
	CONSTRAINT measurement_parameters_pk PRIMARY KEY (parameter_id),
	CONSTRAINT uq_measurement_parameters_parameter_code UNIQUE (parameter_code),
	CONSTRAINT uq_measurement_parameters_parameter_name UNIQUE (parameter_name)
);
-- ddl-end --
COMMENT ON COLUMN public.measurement_parameters.parameter_id IS E'Primary key. Auto-incrementing integer identifier for each measurement parameter.';
-- ddl-end --
COMMENT ON COLUMN public.measurement_parameters.parameter_code IS E'Short standardized code for the measurement parameter (e.g., TEMP, PRES, FLOW, NFLUX). Used for filtering and quick reference';
-- ddl-end --
COMMENT ON COLUMN public.measurement_parameters.parameter_name IS E'Full descriptive name of the measurement parameter (e.g., Temperature, Pressure, Neutron Flux, Seismic Acceleration).';
-- ddl-end --
COMMENT ON COLUMN public.measurement_parameters.si_unit IS E'SI or standard engineering unit for this measurement parameter (e.g., °C, Pa, m³/s, neutrons/cm²·s).';
-- ddl-end --
COMMENT ON COLUMN public.measurement_parameters.description IS E'Detailed description of the measurement parameter including its significance in nuclear plant operations, typical applications, and regulatory relevance';
-- ddl-end --
ALTER TABLE public.measurement_parameters OWNER TO postgres;
-- ddl-end --

-- object: measurement_parameters_fk | type: CONSTRAINT --
-- ALTER TABLE public.instrument_types DROP CONSTRAINT IF EXISTS measurement_parameters_fk CASCADE;
ALTER TABLE public.instrument_types ADD CONSTRAINT measurement_parameters_fk FOREIGN KEY (parameter_id_measurement_parameters)
REFERENCES public.measurement_parameters (parameter_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.plant_systems | type: TABLE --
-- DROP TABLE IF EXISTS public.plant_systems CASCADE;
CREATE TABLE public.plant_systems (
	system_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	system_code varchar(10) NOT NULL,
	system_name varchar(100) NOT NULL,
	description text,
	is_safety_related boolean NOT NULL DEFAULT FALSE,
	CONSTRAINT plant_systems_pk PRIMARY KEY (system_id),
	CONSTRAINT uq_plant_systems_system_code UNIQUE (system_code),
	CONSTRAINT uq_plant_systems_system_name UNIQUE (system_name)
);
-- ddl-end --
COMMENT ON COLUMN public.plant_systems.system_id IS E'Primary key. Auto-incrementing integer identifier for each plant system.';
-- ddl-end --
COMMENT ON COLUMN public.plant_systems.system_code IS E'Standard system identifier code (e.g., RCS, CVCS, MSS, ECCS). Used in plant documentation, P&IDs, and work orders.';
-- ddl-end --
COMMENT ON COLUMN public.plant_systems.system_name IS E'Full descriptive name of the plant system (e.g., Reactor Coolant System, Chemical and Volume Control System)';
-- ddl-end --
COMMENT ON COLUMN public.plant_systems.description IS E'Description of the plant system including its function, major components, and role in plant operations and safety';
-- ddl-end --
COMMENT ON COLUMN public.plant_systems.is_safety_related IS E'Whether the system is classified as safety-related per 10CFR50. Determines quality assurance requirements and regulatory oversight applicable to the system and its instruments.';
-- ddl-end --
ALTER TABLE public.plant_systems OWNER TO postgres;
-- ddl-end --

-- object: public.locations | type: TABLE --
-- DROP TABLE IF EXISTS public.locations CASCADE;
CREATE TABLE public.locations (
	location_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	location_code varchar(20) NOT NULL,
	location_name varchar(100) NOT NULL,
	location_type varchar(20) NOT NULL,
	parent_location_id integer,
	description text,
	CONSTRAINT locations_pk PRIMARY KEY (location_id),
	CONSTRAINT uq_locations_location_code UNIQUE (location_code)
);
-- ddl-end --
COMMENT ON COLUMN public.locations.location_id IS E'Primary key. Auto-incrementing integer identifier for each location.';
-- ddl-end --
COMMENT ON COLUMN public.locations.location_code IS E'Short location identifier code (e.g., CTMT for containment, AUX-2 for auxiliary building second floor). Used in plant documentation and work orders.';
-- ddl-end --
COMMENT ON COLUMN public.locations.location_name IS E'Full descriptive name of the location (e.g., Containment Building, Auxiliary Building Second Floor)';
-- ddl-end --
COMMENT ON COLUMN public.locations.location_type IS E'Level in the location hierarchy (e.g., Building, Floor, Room, Area, Equipment). Supports hierarchical filtering and navigation.';
-- ddl-end --
COMMENT ON COLUMN public.locations.parent_location_id IS E'Self-referencing foreign key to the parent location. Creates a hierarchy (e.g., Room → Floor → Building). Null for top-level locations.';
-- ddl-end --
COMMENT ON COLUMN public.locations.description IS E'Additional details about the location including environmental conditions, access requirements, or radiological zone classification';
-- ddl-end --
ALTER TABLE public.locations OWNER TO postgres;
-- ddl-end --

-- object: public.safety_classifications | type: TABLE --
-- DROP TABLE IF EXISTS public.safety_classifications CASCADE;
CREATE TABLE public.safety_classifications (
	classification_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	classification_code varchar(10) NOT NULL,
	classification_name varchar(50) NOT NULL,
	regulatory_basis varchar(100),
	qa_requirements text,
	description text,
	CONSTRAINT safety_classifications_pk PRIMARY KEY (classification_id),
	CONSTRAINT uq_safety_classifications_classification_code UNIQUE (classification_code),
	CONSTRAINT uq_safety_classifications_classification_name UNIQUE (classification_name)
);
-- ddl-end --
COMMENT ON COLUMN public.safety_classifications.classification_id IS E'Primary key. Auto-incrementing integer identifier for each safety classification';
-- ddl-end --
COMMENT ON COLUMN public.safety_classifications.classification_code IS E'Short code for the safety classification (e.g., SR for Safety-Related, AQ for Augmented Quality, NSR for Non-Safety Related)';
-- ddl-end --
COMMENT ON COLUMN public.safety_classifications.classification_name IS E'Full name of the safety classification (e.g., Safety-Related, Augmented Quality, Non-Safety Related)';
-- ddl-end --
COMMENT ON COLUMN public.safety_classifications.regulatory_basis IS E'Regulatory requirement or standard that defines this classification (e.g., 10CFR50 Appendix B for Safety-Related).';
-- ddl-end --
COMMENT ON COLUMN public.safety_classifications.qa_requirements IS E'Description of quality assurance requirements applicable to instruments under this classification including documentation, testing, procurement, and maintenance standards.';
-- ddl-end --
COMMENT ON COLUMN public.safety_classifications.description IS E'General description of the safety classification including its significance for plant safety and the consequences of instrument failure within this classification';
-- ddl-end --
ALTER TABLE public.safety_classifications OWNER TO postgres;
-- ddl-end --

-- object: public.instrument_statuses | type: TABLE --
-- DROP TABLE IF EXISTS public.instrument_statuses CASCADE;
CREATE TABLE public.instrument_statuses (
	status_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	status_code varchar(10) NOT NULL,
	status_name varchar(30) NOT NULL,
	is_readings_valid boolean DEFAULT TRUE,
	description text,
	CONSTRAINT instrument_statuses_pk PRIMARY KEY (status_id),
	CONSTRAINT uq_instrument_statuses_status_code UNIQUE (status_code),
	CONSTRAINT uq_instrument_statuses_status_name UNIQUE (status_name)
);
-- ddl-end --
COMMENT ON COLUMN public.instrument_statuses.status_id IS E'Primary key. Auto-incrementing integer identifier for each instrument status';
-- ddl-end --
COMMENT ON COLUMN public.instrument_statuses.status_code IS E'Short code for the instrument status (e.g., ACT for Active, OOS for Out of Service, DEG for Degraded, FAIL for Failed)';
-- ddl-end --
COMMENT ON COLUMN public.instrument_statuses.status_name IS E'Full name of the instrument status (e.g., Active, Out of Service, Degraded, Failed, Decommissioned)';
-- ddl-end --
COMMENT ON COLUMN public.instrument_statuses.is_readings_valid IS E'Whether readings from instruments in this status should be considered valid for monitoring and trending purposes.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_statuses.description IS E'Description of what this status means operationally, including any required compensatory actions or documentation when an instrument enters this status';
-- ddl-end --
ALTER TABLE public.instrument_statuses OWNER TO postgres;
-- ddl-end --

-- object: public.instruments | type: TABLE --
-- DROP TABLE IF EXISTS public.instruments CASCADE;
CREATE TABLE public.instruments (
	instrument_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	tag_number varchar(20) NOT NULL,
	manufacturer varchar(100),
	model_number varchar(50),
	serial_number varchar(50),
	range_min numeric,
	range_max numeric,
	range_unit varchar(20),
	setpoint_high numeric,
	setpoint_low numeric,
	accuracy varchar(50),
	loop_number varchar(20),
	redundancy_group varchar(20),
	tech_spec_reference varchar(50),
	installation_date date,
	last_calibration_date date,
	calibration_interval_months integer,
	is_tech_spec boolean NOT NULL DEFAULT FALSE,
	is_eq_required boolean NOT NULL DEFAULT FALSE,
	description text,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	type_id_instrument_types integer,
	system_id_plant_systems integer,
	location_id_locations integer,
	classification_id_safety_classifications integer,
	status_id_instrument_statuses integer,
	CONSTRAINT instruments_pk PRIMARY KEY (instrument_id),
	CONSTRAINT uq_instruments_tag_number UNIQUE (tag_number)
);
-- ddl-end --
COMMENT ON COLUMN public.instruments.instrument_id IS E'Primary key. Auto-incrementing integer identifier for each individual instrument';
-- ddl-end --
COMMENT ON COLUMN public.instruments.tag_number IS E'Plant instrument tag number per ISA-5.1 conventions (e.g., TE-0412A). The unique plant-wide identifier used on P&IDs, work orders, and Technical Specifications.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.manufacturer IS E'Instrument manufacturer. Important for tracking vendor-specific issues, 10CFR21 defect notifications, and procurement.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.model_number IS E'Manufacturer model number. Determines exact technical specifications, spare parts compatibility, and applicable maintenance procedures.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.serial_number IS E'Unique manufacturer serial number for this specific device. Required for traceability — every calibration record, maintenance action, and quality record references the serial number.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.range_min IS E'Lower bound of this instrument''s calibrated range. This is the actual configured range, not the general capability of the instrument type.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.range_max IS E'Upper bound of this instrument''s calibrated range. This is the actual configured range, not the general capability of the instrument type';
-- ddl-end --
COMMENT ON COLUMN public.instruments.range_unit IS E'Engineering unit for this instrument''s calibrated range (e.g., °C, MPa, % power).';
-- ddl-end --
COMMENT ON COLUMN public.instruments.setpoint_high IS E'High alarm or trip setpoint value. Null if this instrument does not drive alarms or trips';
-- ddl-end --
COMMENT ON COLUMN public.instruments.setpoint_low IS E'Low alarm or trip setpoint value. Null if this instrument does not drive alarms or trips.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.accuracy IS E'Actual accuracy specification for this specific instrument as installed and calibrated. May differ from the instrument type''s typical accuracy due to range, environment, and age.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.loop_number IS E'Instrument loop this device belongs to. Multiple instruments often share a loop — a sensor, transmitter, indicator, and controller may all be part of the same loop';
-- ddl-end --
COMMENT ON COLUMN public.instruments.redundancy_group IS E'Redundancy division or train this instrument belongs to (e.g., Division I, Train A, Channel III). Critical for Technical Specification operability and allowed outage time tracking';
-- ddl-end --
COMMENT ON COLUMN public.instruments.tech_spec_reference IS E'Reference to the applicable Technical Specification section if any. Directly links the instrument to its regulatory surveillance and operability requirements';
-- ddl-end --
COMMENT ON COLUMN public.instruments.installation_date IS E'Date the instrument was first installed in the plant.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.last_calibration_date IS E'Date of the most recent calibration. Used with calibration_interval_months to calculate next due date and flag overdue instruments.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.calibration_interval_months IS E'Required calibration frequency in months. Typically 18 or 24 months for safety-related instruments, aligned with refueling outages.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.is_tech_spec IS E'Whether this instrument is referenced in the plant Technical Specifications. Tech Spec instruments have the most stringent surveillance requirements.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.is_eq_required IS E'Whether this instrument must be environmentally qualified per 10CFR50.49 to function under design basis accident conditions.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.description IS E'Additional notes specific to this instrument including special installation conditions, known issues, or compensatory measures when out of service.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.created_at IS E'Timestamp of when this record was created in the database.';
-- ddl-end --
COMMENT ON COLUMN public.instruments.updated_at IS E'Timestamp of the last update to this record. Should be updated automatically on any modification.';
-- ddl-end --
ALTER TABLE public.instruments OWNER TO postgres;
-- ddl-end --

-- object: instrument_types_fk | type: CONSTRAINT --
-- ALTER TABLE public.instruments DROP CONSTRAINT IF EXISTS instrument_types_fk CASCADE;
ALTER TABLE public.instruments ADD CONSTRAINT instrument_types_fk FOREIGN KEY (type_id_instrument_types)
REFERENCES public.instrument_types (type_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_systems_fk | type: CONSTRAINT --
-- ALTER TABLE public.instruments DROP CONSTRAINT IF EXISTS plant_systems_fk CASCADE;
ALTER TABLE public.instruments ADD CONSTRAINT plant_systems_fk FOREIGN KEY (system_id_plant_systems)
REFERENCES public.plant_systems (system_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: locations_fk | type: CONSTRAINT --
-- ALTER TABLE public.instruments DROP CONSTRAINT IF EXISTS locations_fk CASCADE;
ALTER TABLE public.instruments ADD CONSTRAINT locations_fk FOREIGN KEY (location_id_locations)
REFERENCES public.locations (location_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: safety_classifications_fk | type: CONSTRAINT --
-- ALTER TABLE public.instruments DROP CONSTRAINT IF EXISTS safety_classifications_fk CASCADE;
ALTER TABLE public.instruments ADD CONSTRAINT safety_classifications_fk FOREIGN KEY (classification_id_safety_classifications)
REFERENCES public.safety_classifications (classification_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: instrument_statuses_fk | type: CONSTRAINT --
-- ALTER TABLE public.instruments DROP CONSTRAINT IF EXISTS instrument_statuses_fk CASCADE;
ALTER TABLE public.instruments ADD CONSTRAINT instrument_statuses_fk FOREIGN KEY (status_id_instrument_statuses)
REFERENCES public.instrument_statuses (status_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.readings | type: TABLE --
-- DROP TABLE IF EXISTS public.readings CASCADE;
CREATE TABLE public.readings (
	reading_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	reading_value numeric NOT NULL,
	reading_unit varchar(20) NOT NULL,
	reading_timestamp timestamptz NOT NULL,
	quality_flag varchar(20) NOT NULL DEFAULT 'GOOD',
	is_anomaly boolean NOT NULL DEFAULT FALSE,
	anomaly_score numeric,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	instrument_id_instruments integer,
	CONSTRAINT readings_pk PRIMARY KEY (reading_id)
);
-- ddl-end --
COMMENT ON COLUMN public.readings.reading_id IS E'Primary key. Auto-incrementing bigint identifier due to the high volume of sensor readings over time';
-- ddl-end --
COMMENT ON COLUMN public.readings.reading_value IS E'The measured value from the instrument in its configured engineering units';
-- ddl-end --
COMMENT ON COLUMN public.readings.reading_unit IS E'Engineering unit of the reading value (e.g., °C, MPa, %). Must match the instrument''s configured range unit.';
-- ddl-end --
COMMENT ON COLUMN public.readings.reading_timestamp IS E'Exact time the reading was taken. Critical for time-series analysis, event correlation, and regulatory documentation.';
-- ddl-end --
COMMENT ON COLUMN public.readings.quality_flag IS E'Data quality indicator for this reading (e.g., GOOD, SUSPECT, BAD, MANUALLY_ENTERED, SUBSTITUTED). Supports filtering of valid data for trending and analysis.';
-- ddl-end --
COMMENT ON COLUMN public.readings.is_anomaly IS E'Whether this reading has been flagged as anomalous by automated detection algorithms such as SPRT or PCA-based methods.';
-- ddl-end --
COMMENT ON COLUMN public.readings.anomaly_score IS E'Numerical score from the anomaly detection algorithm indicating the degree of deviation from expected behavior. Null when no anomaly analysis has been performed.';
-- ddl-end --
COMMENT ON COLUMN public.readings.created_at IS E'Timestamp of when this reading record was inserted into the database.';
-- ddl-end --
ALTER TABLE public.readings OWNER TO postgres;
-- ddl-end --

-- object: instruments_fk | type: CONSTRAINT --
-- ALTER TABLE public.readings DROP CONSTRAINT IF EXISTS instruments_fk CASCADE;
ALTER TABLE public.readings ADD CONSTRAINT instruments_fk FOREIGN KEY (instrument_id_instruments)
REFERENCES public.instruments (instrument_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.alerts | type: TABLE --
-- DROP TABLE IF EXISTS public.alerts CASCADE;
CREATE TABLE public.alerts (
	alert_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	alert_type varchar(30) NOT NULL,
	alert_severity varchar(15) NOT NULL,
	alert_message text NOT NULL,
	trigger_value numeric,
	trigger_threshold numeric,
	triggered_at timestamptz NOT NULL,
	acknowledged_at timestamptz,
	acknowledged_by varchar(100),
	resolved_at timestamptz,
	resolution_notes text,
	is_active boolean NOT NULL DEFAULT TRUE,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	instrument_id_instruments integer,
	CONSTRAINT alerts_pk PRIMARY KEY (alert_id)
);
-- ddl-end --
COMMENT ON COLUMN public.alerts.alert_id IS E'Primary key. Auto-incrementing bigint identifier for each alert event.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.alert_type IS E'Classification of the alert.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.alert_severity IS E'Severity level of the alert (e.g., INFO, WARNING, ALARM, CRITICAL). Drives dashboard prioitization and notification routing.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.alert_message IS E'Human-readable description of the alert condition (e.g., ''RCS pressure exceeded high alarm setpoint of 15.9 MPa'').';
-- ddl-end --
COMMENT ON COLUMN public.alerts.trigger_value IS E'The instrument reading value that triggered the alert. Null for non-measurement-based alerts like calibration reminders.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.trigger_threshold IS E'The setpoint or threshold value that was exceeded to trigger the alert. Provides context for evaluating the severity of the exceedance.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.triggered_at IS E'Exact time the laert condition was detected.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.acknowledged_at IS E'Time the alert was acknowledged by an operator or engineer. Null if not yet acknowledged.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.acknowledged_by IS E'Name or user ID of the person who acknowledged the alert. Null if not yet acknowledged.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.resolved_at IS E'Time the alert condition was resolved or cleared. Null if still active.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.resolution_notes IS E'Description of the corrective actions taken to resolve the alert condition. Important for trend analysis and recurring issue identification.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.is_active IS E'Whether this alert is currently active. Set to false when resolved. Supports dashboard filtering for current alarm status.';
-- ddl-end --
COMMENT ON COLUMN public.alerts.created_at IS E'Timestamp of when this alert record was created in the database.';
-- ddl-end --
ALTER TABLE public.alerts OWNER TO postgres;
-- ddl-end --

-- object: instruments_fk | type: CONSTRAINT --
-- ALTER TABLE public.alerts DROP CONSTRAINT IF EXISTS instruments_fk CASCADE;
ALTER TABLE public.alerts ADD CONSTRAINT instruments_fk FOREIGN KEY (instrument_id_instruments)
REFERENCES public.instruments (instrument_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.maintenance_events | type: TABLE --
-- DROP TABLE IF EXISTS public.maintenance_events CASCADE;
CREATE TABLE public.maintenance_events (
	event_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	event_type varchar(30) NOT NULL,
	work_order_number varchar(30),
	description text NOT NULL,
	performed_by varchar(100),
	reviewed_by varchar(100),
	scheduled_date date,
	started_at timestamptz,
	completed_at timestamptz,
	findings text,
	corrective_actions text,
	status varchar(20) NOT NULL DEFAULT 'SCHEDULED',
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	instrument_id_instruments integer,
	technician_id_technicians integer,
	CONSTRAINT maintenance_events_pk PRIMARY KEY (event_id)
);
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.event_id IS E'Primary key. Auto-incrementing bigint identifier for each maintenance event.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.event_type IS E'Type of maintenance activity performed (e.g., CALIBRATION, REPAIR, REPLACEMENT, INSPECTION, PREVENTITIVE, CORRECTIVE, SURVEILLANCE).';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.work_order_number IS E'Plant work order number associated with this maintenance activity. Links to the plant''s work management system for full documentation.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.description IS E'Detailed description of the maintenance activity performed, including scope of work, findings, and any as-left conditions.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.performed_by IS E'Name or ID of the technician or engineer who performed the maintenance. Important for qualification tracking and accountability.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.reviewed_by IS E'Name or ID of the person who reviewed and approved the completed maintencance work. Required for safety-related instrument maintenance per 10CFR50 Appendix B.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.scheduled_date IS E'Planned date for the maintenance activity. Used for scheduling and workload planning.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.started_at IS E'Actual date and time the maintenance work began.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.completed_at IS E'Date and time the maintenance work was completed. Null if work is still in progress.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.findings IS E'Observations and findings during the maintenance activity including any unexpected conditions, degradation, or anomalies discovered.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.corrective_actions IS E'Actions taken to correct any issues found during maintenance. Includes parts replaced, adjustments made, and any follow-up actions required.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.status IS E'Current status of the maintenance event (e.g., SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED, DEFERRED).';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.created_at IS E'Timestamp of when this maintenance event record was created in the database.';
-- ddl-end --
COMMENT ON COLUMN public.maintenance_events.updated_at IS E'Timestamp of the last update to this record.';
-- ddl-end --
ALTER TABLE public.maintenance_events OWNER TO postgres;
-- ddl-end --

-- object: instruments_fk | type: CONSTRAINT --
-- ALTER TABLE public.maintenance_events DROP CONSTRAINT IF EXISTS instruments_fk CASCADE;
ALTER TABLE public.maintenance_events ADD CONSTRAINT instruments_fk FOREIGN KEY (instrument_id_instruments)
REFERENCES public.instruments (instrument_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.calibration_records | type: TABLE --
-- DROP TABLE IF EXISTS public.calibration_records CASCADE;
CREATE TABLE public.calibration_records (
	calibration_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	calibration_type varchar(30) NOT NULL,
	calibration_date date NOT NULL,
	calibration_due_date date,
	as_found_in_tolerance boolean NOT NULL,
	as_left_in_tolerance boolean NOT NULL,
	as_found_data text,
	as_left_data text,
	drift_value numeric,
	drift_unit varchar(20),
	tolerance_band numeric,
	reference_standard varchar(100),
	reference_standard_due_date date,
	performed_by varchar(100),
	reviewed_by varchar(100),
	work_order_number varchar(30),
	procedure_number varchar(30),
	notes text,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	instrument_id_instruments integer,
	technician_id_technicians integer,
	CONSTRAINT calibration_records_pk PRIMARY KEY (calibration_id)
);
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.calibration_id IS E'Primary key. Auto-incrementing bigint identifier for each calibration record.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.calibration_type IS E'Type of calibration performed (eg., FULL, PARTIAL, CHANNEL_CHECK, FUNCTIONAL, TEST, CROSS_CALIBRATION). Determine the scope and rigor of the calibration data.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.calibration_date IS E'Date the calibration was performed. Used to update the instrument''s last_calibration_date and calculate the next due date.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.calibration_due_date IS E'Date by which this calibration was required. Comparing with calibration_date shows whether calibration was performed on time, early, or late.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.as_found_in_tolerance IS E'Whether the instrument was found within its required tolerance before any adjustments. A critical metric for drift analysis and instrument reliability assessment.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.as_left_in_tolerance IS E'Whether the instrument was within required tolerance after calibration adjustments. Must be true for the instrument to be returned to service.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.as_found_data IS E'Detailed as-found calibration data including test point values, measured outputs, and deviations from expected values. May be stored as structured text or JSON.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.as_left_data IS E'Detailed as-left calibration data after adjustments. Same format as  as_found_data. Comparison between as-found and as-left quantifies the drift that occurred.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.drift_value IS E'Calculated drift since the previous calibration, typically expressed as the maximum deviation across all test points. The primary input for SPRT-based drift monitoring.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.drift_unit IS E'Engineering unit or format of the drift value (e.g., °C, % of span). Must be consistent across calibration records for the same instrument to enable trend analysis.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.tolerance_band IS E'The allowable tolerance band used to evaluate as-found and as-left conditions. Typically expressed in the same units as drift_value or as percent of span.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.reference_standard IS E'Identification of the reference standard or test equipment used for calibration. Must be traceable to NIST or equivalent national standards per 10CFR50 Appendix B.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.reference_standard_due_date IS E'Calibration due date of the reference standard at time of use. Verifies the standard was in calibration when used, a key QA requirement.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.performed_by IS E'Name or ID of the technician who performed the calibration. Required for qualification verification and accountability.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.reviewed_by IS E'Name or ID of the person who reviewed and approved the calibration results. Required for safety-related calibrations per 10CFR50 Appendix B.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.work_order_number IS E'Plant work order number associated with this calibration. Links to the plant''s work management system and the corresponding maintenance_events record.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.procedure_number IS E'Calibration procedure number used to perform the calibration. Required for repeatability and regulatory  compliance.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.notes IS E'Additional observations, anomalies, or conditions noted during calibration. Includes any limitations, compensatory measures, or receommended follow-up actions.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_records.created_at IS E'Timestamp of when this calibration record was created in the database.';
-- ddl-end --
ALTER TABLE public.calibration_records OWNER TO postgres;
-- ddl-end --

-- object: instruments_fk | type: CONSTRAINT --
-- ALTER TABLE public.calibration_records DROP CONSTRAINT IF EXISTS instruments_fk CASCADE;
ALTER TABLE public.calibration_records ADD CONSTRAINT instruments_fk FOREIGN KEY (instrument_id_instruments)
REFERENCES public.instruments (instrument_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.technicians | type: TABLE --
-- DROP TABLE IF EXISTS public.technicians CASCADE;
CREATE TABLE public.technicians (
	technician_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	employee_id varchar(20) NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	job_title varchar(50),
	department varchar(50),
	qualification_level varchar(30),
	certification_expiry_date date,
	is_active boolean NOT NULL DEFAULT TRUE,
	email varchar(100),
	phone varchar(20),
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT technicians_pk PRIMARY KEY (technician_id),
	CONSTRAINT uq_technicians_employee_id UNIQUE (employee_id)
);
-- ddl-end --
COMMENT ON COLUMN public.technicians.technician_id IS E'Primary key. Auto-incrementing integer identifier for each technician.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.employee_id IS E'Plant-assigned employee identifier. The unique business key used in work orders, qualification records, and access control systems.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.first_name IS E'Technician''s first name.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.last_name IS E'Technician''s last name.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.job_title IS E'Current job title or role (e.g., I&C Technician, Senior I&C Technician, I&C Engineer, Reactor Engineer).';
-- ddl-end --
COMMENT ON COLUMN public.technicians.department IS E'Department the technician belongs to (e.g., Instrumentation & Controls, Reactor Engineering, Maintenance).';
-- ddl-end --
COMMENT ON COLUMN public.technicians.qualification_level IS E'Overall qualification level (e.g., APPRENTICE, QUALIFIED, SENIOR, SUPERVISOR, SPECIALIST). Determines which maintenance and calibration tasks the technician may perform.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.certification_expiry_date IS E'Date when the technician''s current certification expires. Instruments calibrated by technicians with expired certifications may require recalibration per QA requirements.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.is_active IS E'Whether the technician is currently active. Inactive technicians are retained for historical traceability of past maintenance and calibration records.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.email IS E'Technician''s email address. Used for notification routing when alerts require response from qualified personnel.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.phone IS E'Technician''s contact phone number.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.created_at IS E'Timestamp of when this technician record was created in the database.';
-- ddl-end --
COMMENT ON COLUMN public.technicians.updated_at IS E'Timestamp of the last update to this record.';
-- ddl-end --
ALTER TABLE public.technicians OWNER TO postgres;
-- ddl-end --

-- object: technicians_fk | type: CONSTRAINT --
-- ALTER TABLE public.calibration_records DROP CONSTRAINT IF EXISTS technicians_fk CASCADE;
ALTER TABLE public.calibration_records ADD CONSTRAINT technicians_fk FOREIGN KEY (technician_id_technicians)
REFERENCES public.technicians (technician_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: technicians_fk | type: CONSTRAINT --
-- ALTER TABLE public.maintenance_events DROP CONSTRAINT IF EXISTS technicians_fk CASCADE;
ALTER TABLE public.maintenance_events ADD CONSTRAINT technicians_fk FOREIGN KEY (technician_id_technicians)
REFERENCES public.technicians (technician_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.drift_analyses | type: TABLE --
-- DROP TABLE IF EXISTS public.drift_analyses CASCADE;
CREATE TABLE public.drift_analyses (
	analysis_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	analysis_method varchar(30) NOT NULL,
	analysis_timestamp timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	calibration_intervals_included integer NOT NULL,
	first_calibration_id bigint,
	last_calibration_id bigint,
	test_statistic numeric NOT NULL,
	upper_threshold numeric,
	lower_threshold numeric,
	decision varchar(20) NOT NULL,
	confidence_level numeric,
	alpha_error numeric,
	beta_error numeric,
	mean_drift_rate numeric,
	drift_rate_unit varchar(30),
	recommended_action text,
	notes text,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	instrument_id_instruments integer,
	CONSTRAINT drift_analyses_pk PRIMARY KEY (analysis_id)
);
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.analysis_id IS E'Primary key. Auto-incrementing bigint identifier for each drift analysis run.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.analysis_method IS E'Statistical method used for the drift analysis (e.g., SPRT, CUSUM, EWMA, SIMPLE_TREND, REGRESSION). Determines how the test statistic and decision should be interpreted.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.analysis_timestamp IS E'Time the drift analysis was executed.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.calibration_intervals_included IS E'Number of calibration intervals included in this analysis. More intervals provide stronger statistical evidence. Minimum of 2 required for meaningful analysis.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.first_calibration_id IS E'Reference to the earliest calibration record included in this analysis. Defines the start of the analysis window.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.last_calibration_id IS E'Reference to the most recent calibration record included in this analysis. Defines the end of the analysis window.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.test_statistic IS E'The calculated test statistic from the analysis method. For SPRT, this is the log-likelihood ratio. For CUSUM, the cumulative sum. The value is compared against decision thresholds.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.upper_threshold IS E'Upper decision threshold. For SPRT, this is ln(B) where B = (1-beta)/alpha. Exceeding this threshold indicates the drift hypothesis should be accepted."';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.lower_threshold IS E'Lower decision threshold. For SPRT, this is ln(A) where A = beta/(1-alpha). Falling below this threshold indicates the no-drift hypothesis should be accepted.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.decision IS E'Outcome of the drift analysis (ACCEPTABLE, EXCESSIVE_DRIFT, INCONCLUSIVE). ACCEPTABLE means drift is within allowable limits. EXCESSIVE_DRIFT triggers corrective action. INCONCLUSIVE means more data is needed.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.confidence_level IS E'Statistical confidence level of the decision, expressed as a decimal (e.g., 0.95 for 95%). Derived from the alpha and beta error probabilities configured for the test.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.alpha_error IS E'Type I error probability (false positive rate) used in the analysis. Probability of concluding excessive drift when drift is actually acceptable."';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.beta_error IS E'Type II error probability (false negative rate) used in the analysis. Probability of concluding acceptable drift when drift is actually excessive.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.mean_drift_rate IS E'Estimated average drift rate per calibration interval. Positive values indicate upward drift, negative values indicate downward drift. Used for predicting future drift behavior.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.drift_rate_unit IS E'Unit of the mean drift rate (e.g., °C/interval, % of span/interval). Must be consistent across analyses for the same instrument."';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.recommended_action IS E'Recommended action based on the analysis results (e.g., continue monitoring, reduce calibration interval, schedule calibration, investigate root cause). May be auto-generated or manually entered."';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.notes IS E'Additional observations or context for the analysis including any data exclusions, anomalies in the calibration history, or engineering judgment applied to the results.';
-- ddl-end --
COMMENT ON COLUMN public.drift_analyses.created_at IS E'Timestamp of when this analysis record was created in the database.';
-- ddl-end --
ALTER TABLE public.drift_analyses OWNER TO postgres;
-- ddl-end --

-- object: instruments_fk | type: CONSTRAINT --
-- ALTER TABLE public.drift_analyses DROP CONSTRAINT IF EXISTS instruments_fk CASCADE;
ALTER TABLE public.drift_analyses ADD CONSTRAINT instruments_fk FOREIGN KEY (instrument_id_instruments)
REFERENCES public.instruments (instrument_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.pca_analyses | type: TABLE --
-- DROP TABLE IF EXISTS public.pca_analyses CASCADE;
CREATE TABLE public.pca_analyses (
	analysis_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	analysis_timestamp timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	sensor_group_name varchar(48) NOT NULL,
	sensor_group_description text,
	window_start timestamptz NOT NULL,
	window_end timestamptz NOT NULL,
	num_sensors integer NOT NULL,
	num_components_retained integer NOT NULL,
	variance_explained_ratio numeric,
	t_squared_threshold numeric,
	q_residual_threshold numeric,
	t_squared_value numeric,
	q_residual_value numeric,
	fault_detected boolean NOT NULL DEFAULT FALSE,
	fault_type varchar(30),
	faulted_sensor_tag varchar(20),
	contribution_data text,
	model_parameters text,
	decision varchar(20) NOT NULL,
	recommended_action text,
	notes text,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pca_analyses_pk PRIMARY KEY (analysis_id)
);
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.analysis_id IS E'Primary key. Auto-incrementing bigint identifier for each PCA analysis run.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.analysis_timestamp IS E'Time the PCA analysis was executed.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.sensor_group_name IS E'Name identifying the group of physically correlated sensors analyzed together (e.g., RCS_TEMPERATURE, SG_LEVEL). Sensors are grouped based on known physical relationships.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.sensor_group_description IS E'Description of the physical basis for this sensor grouping, including the expected correlations and the thermodynamic or process relationships that link the sensors.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.window_start IS E'Start of the time window of readings used in this analysis. Defines the data scope evaluated.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.window_end IS E'End of the time window of readings used in this analysis.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.num_sensors IS E'Number of sensors included in the analysis group. Determines the dimensionality of the PCA model.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.num_components_retained IS E'Number of principal components retained in the model. Selected to capture sufficient variance while separating signal from noise.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.variance_explained_ratio IS E'Cumulative proportion of total variance explained by the retained components, expressed as a decimal (e.g., 0.95 for 95%). Indicates how well the reduced model represents the original sensor relationships."';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.t_squared_threshold IS E'Hotelling''s T-squared control limit for the retained principal component space. Exceedances indicate abnormal variation in the modeled sensor relationships."';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.q_residual_threshold IS E'Q-statistic (squared prediction error) control limit for the residual space. Exceedances indicate a sensor has broken from its expected correlation with other sensors in the group.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.t_squared_value IS E'Calculated Hotelling''s T-squared value for the current analysis window. Compared against t_squared_threshold to detect abnormal variation.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.q_residual_value IS E'Calculated Q-statistic for the current analysis window. Compared against q_residual_threshold to detect sensor decorrelation.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.fault_detected IS E'Whether the analysis detected a fault condition — either a T-squared or Q-residual threshold exceedance indicating abnormal sensor behavior.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.fault_type IS E'Classification of the detected fault (e.g., SENSOR_DRIFT, SENSOR_FAILURE, PROCESS_CHANGE, COMMON_CAUSE). Null when no fault detected. Determined by contribution analysis of the principal components."';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.faulted_sensor_tag IS E'Tag number of the sensor identified as the source of the fault through contribution analysis. Null if no fault detected or if the fault cannot be isolated to a single sensor.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.contribution_data IS E'Detailed contribution analysis results showing each sensor''s contribution to the T-squared and Q-residual statistics. Used for fault isolation and diagnosis. Stored as structured text or JSON.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.model_parameters IS E'Serialized PCA model parameters including loading matrix, mean vector, and scaling factors. Enables model reconstruction and comparison across analysis runs.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.decision IS E'Overall outcome of the analysis (NORMAL, INVESTIGATE, SENSOR_FAULT, PROCESS_ANOMALY). Drives dashboard status indicators and alert generation.\\';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.recommended_action IS E'Recommended action based on the analysis results (e.g., continue monitoring, cross-check with independent measurement, schedule calibration verification, investigate process conditions)."';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.notes IS E'Additional observations or engineering context for the analysis including any known process transients, maintenance activities, or other factors that may affect interpretation.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analyses.created_at IS E'Timestamp of when this analysis record was created in the database.';
-- ddl-end --
ALTER TABLE public.pca_analyses OWNER TO postgres;
-- ddl-end --

-- object: public.calibration_test_points | type: TABLE --
-- DROP TABLE IF EXISTS public.calibration_test_points CASCADE;
CREATE TABLE public.calibration_test_points (
	test_point_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	test_point_number integer NOT NULL,
	nominal_input numeric NOT NULL,
	nominal_input_unit varchar(20) NOT NULL,
	expected_output numeric NOT NULL,
	expected_output_unit varchar(20) NOT NULL,
	as_found_output numeric NOT NULL,
	as_found_error numeric,
	as_found_error_pct_span numeric,
	as_left_output numeric,
	as_left_error numeric,
	as_left_error_pct_span numeric,
	tolerance_limit numeric,
	as_found_in_tolerance boolean NOT NULL,
	as_left_in_tolerance boolean,
	direction varchar(10),
	notes text,
	calibration_id_calibration_records bigint,
	CONSTRAINT calibration_test_points_pk PRIMARY KEY (test_point_id)
);
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.test_point_id IS E'Primary key. Auto-incrementing bigint identifier for each calibration test point.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.test_point_number IS E'Sequential number of this test point within the calibration (e.g., 1, 2, 3, 4, 5). Calibrations typically test 3-5 points across the instrument''s range.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.nominal_input IS E'The target input value applied to the instrument at this test point from the reference standard (e.g., 100°C, 10 MPa).';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.nominal_input_unit IS E'Engineering unit of the nominal input value (e.g., °C, MPa, mA).';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.expected_output IS E'The theoretical output the instrument should produce for the given nominal input, calculated from the instrument''s calibrated transfer function.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.expected_output_unit IS E'Engineering unit of the expected output value (e.g., mA, VDC, ohms).';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.as_found_output IS E'Actual output measured at this test point before any calibration adjustments. The difference between this and expected_output is the as-found error at this point.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.as_found_error IS E'Calculated difference between as_found_output and expected_output. Positive values indicate the instrument reads high, negative values indicate it reads low.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.as_found_error_pct_span IS E'As-found error expressed as a percentage of the instrument''s calibrated span. Normalizes errors across different test points and instruments for comparison and trending.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.as_left_output IS E'Actual output measured at this test point after calibration adjustments. Null if no adjustment was necessary because the as-found reading was within tolerance.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.as_left_error IS E'Calculated difference between as_left_output and expected_output after adjustments. Should be smaller than as_found_error if adjustments were effective.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.as_left_error_pct_span IS E'As-left error expressed as a percentage of the instrument''s calibrated span. Must be within the instrument''s tolerance band for the calibration to be acceptable.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.tolerance_limit IS E'Allowable error limit at this test point, typically expressed in the same units as the error values. The as-left error must fall within this limit for the test point to pass.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.as_found_in_tolerance IS E'Whether the as-found error at this test point was within the tolerance limit. Used to determine pass/fail at the individual test point level.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.as_left_in_tolerance IS E'Whether the as-left error at this test point was within the tolerance limit after adjustment. Must be true for the instrument to be returned to service.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.direction IS E'Whether this test point was measured during an upscale (UP) or downscale (DOWN) traverse. Some instruments exhibit hysteresis.';
-- ddl-end --
COMMENT ON COLUMN public.calibration_test_points.notes IS E'Additional observations at this test point including any anomalies, instability, or difficulty achieving a stable reading.';
-- ddl-end --
ALTER TABLE public.calibration_test_points OWNER TO postgres;
-- ddl-end --

-- object: calibration_records_fk | type: CONSTRAINT --
-- ALTER TABLE public.calibration_test_points DROP CONSTRAINT IF EXISTS calibration_records_fk CASCADE;
ALTER TABLE public.calibration_test_points ADD CONSTRAINT calibration_records_fk FOREIGN KEY (calibration_id_calibration_records)
REFERENCES public.calibration_records (calibration_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.audit_log | type: TABLE --
-- DROP TABLE IF EXISTS public.audit_log CASCADE;
CREATE TABLE public.audit_log (
	log_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	table_name varchar(50) NOT NULL,
	record_id bigint NOT NULL,
	action varchar(10) NOT NULL,
	changed_fields text,
	changed_by varchar(100) NOT NULL,
	changed_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	reason text,
	ip_address varchar(45),
	CONSTRAINT audit_log_pk PRIMARY KEY (log_id)
);
-- ddl-end --
COMMENT ON COLUMN public.audit_log.log_id IS E'Primary key. Auto-incrementing bigint identifier for each audit log entry.';
-- ddl-end --
COMMENT ON COLUMN public.audit_log.table_name IS E'Name of the database table where the change occurred (e.g., instruments, calibration_records, maintenance_events).';
-- ddl-end --
COMMENT ON COLUMN public.audit_log.record_id IS E'Primary key value of the record that was modified. Combined with table_name, uniquely identifies the affected record.';
-- ddl-end --
COMMENT ON COLUMN public.audit_log.action IS E'Type of modification performed (INSERT, UPDATE, DELETE). Required for 10CFR50 Appendix B traceability of changes to quality records.';
-- ddl-end --
COMMENT ON COLUMN public.audit_log.changed_fields IS E'JSON representation of the fields that were changed, including field names, old values, and new values. Provides complete change traceability.';
-- ddl-end --
COMMENT ON COLUMN public.audit_log.changed_by IS E'Username or identifier of the person or system process that made the change.';
-- ddl-end --
COMMENT ON COLUMN public.audit_log.changed_at IS E'Exact timestamp when the change was made. Provides chronological ordering of all modifications.';
-- ddl-end --
COMMENT ON COLUMN public.audit_log.reason IS E'Justification or reason for the change. Important for regulatory audits where modifications to safety-related instrument records must be justified.';
-- ddl-end --
COMMENT ON COLUMN public.audit_log.ip_address IS E'IP address from which the change was made. Supports security auditing and access tracking. Accommodates both IPv4 and IPv6 addresses.';
-- ddl-end --
ALTER TABLE public.audit_log OWNER TO postgres;
-- ddl-end --

-- object: public.documents | type: TABLE --
-- DROP TABLE IF EXISTS public.documents CASCADE;
CREATE TABLE public.documents (
	document_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	document_number varchar(50) NOT NULL,
	document_title varchar(200) NOT NULL,
	document_type varchar(30) NOT NULL,
	revision varchar(10) NOT NULL,
	revision_date date,
	file_path varchar(500),
	is_active boolean NOT NULL DEFAULT TRUE,
	description text,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT documents_pk PRIMARY KEY (document_id),
	CONSTRAINT uq_documents_document_number UNIQUE (document_number)
);
-- ddl-end --
COMMENT ON COLUMN public.documents.document_id IS E'Primary key. Auto-incrementing integer identifier for each document.';
-- ddl-end --
COMMENT ON COLUMN public.documents.document_number IS E'Plant document control number (e.g., ICP-4012 for a calibration procedure, VM-3201 for a vendor manual). The unique business identifier used in the document control system.';
-- ddl-end --
COMMENT ON COLUMN public.documents.document_title IS E'Full title of the document (e.g., ''Calibration Procedure for Rosemount 1153 Series D Pressure Transmitters'').';
-- ddl-end --
COMMENT ON COLUMN public.documents.document_type IS E'Classification of the document (e.g., CALIBRATION_PROCEDURE, VENDOR_MANUAL, ENGINEERING_CALCULATION, MODIFICATION_PACKAGE, REGULATORY_CORRESPONDENCE, DRAWING).';
-- ddl-end --
COMMENT ON COLUMN public.documents.revision IS E'Current revision number or letter of the document (e.g., ''Rev. 5'', ''R'', ''003''). Ensures the correct version is referenced for each instrument.';
-- ddl-end --
COMMENT ON COLUMN public.documents.revision_date IS E'Date of the current revision. Used to verify that the most current version is being used for maintenance and calibration activities.';
-- ddl-end --
COMMENT ON COLUMN public.documents.file_path IS E'Path or URL to the electronic copy of the document in the plant''s document management system or file storage.';
-- ddl-end --
COMMENT ON COLUMN public.documents.is_active IS E'Whether this document is currently active and in use. Superseded or cancelled documents are retained for historical reference but flagged as inactive.';
-- ddl-end --
COMMENT ON COLUMN public.documents.description IS E'Summary of the document''s content and scope. Helps users determine relevance without opening the full document.';
-- ddl-end --
COMMENT ON COLUMN public.documents.created_at IS E'Timestamp of when this document record was created in the database.';
-- ddl-end --
COMMENT ON COLUMN public.documents.updated_at IS E'Timestamp of the last update to this record.';
-- ddl-end --
ALTER TABLE public.documents OWNER TO postgres;
-- ddl-end --

-- object: public.instrument_documents | type: TABLE --
-- DROP TABLE IF EXISTS public.instrument_documents CASCADE;
CREATE TABLE public.instrument_documents (
	instrument_document_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	relationship_type varchar(30) NOT NULL,
	notes text,
	instrument_id_instruments integer,
	document_id_documents integer,
	CONSTRAINT instrument_documents_pk PRIMARY KEY (instrument_document_id)
);
-- ddl-end --
COMMENT ON COLUMN public.instrument_documents.instrument_document_id IS E'Primary key. Auto-incrementing integer identifier for each instrument-document association.';
-- ddl-end --
COMMENT ON COLUMN public.instrument_documents.relationship_type IS E'Nature of the relationship between the instrument and document (e.g., CALIBRATION_PROCEDURE, VENDOR_MANUAL, ENGINEERING_CALCULATION, INSTALLATION_DRAWING, SETPOINT_DOCUMENT).';
-- ddl-end --
COMMENT ON COLUMN public.instrument_documents.notes IS E'Additional context about why this document is associated with this instrument, such as specific sections or applicability conditions.';
-- ddl-end --
ALTER TABLE public.instrument_documents OWNER TO postgres;
-- ddl-end --

-- object: instruments_fk | type: CONSTRAINT --
-- ALTER TABLE public.instrument_documents DROP CONSTRAINT IF EXISTS instruments_fk CASCADE;
ALTER TABLE public.instrument_documents ADD CONSTRAINT instruments_fk FOREIGN KEY (instrument_id_instruments)
REFERENCES public.instruments (instrument_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: documents_fk | type: CONSTRAINT --
-- ALTER TABLE public.instrument_documents DROP CONSTRAINT IF EXISTS documents_fk CASCADE;
ALTER TABLE public.instrument_documents ADD CONSTRAINT documents_fk FOREIGN KEY (document_id_documents)
REFERENCES public.documents (document_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.notifications | type: TABLE --
-- DROP TABLE IF EXISTS public.notifications CASCADE;
CREATE TABLE public.notifications (
	notification_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	notification_channel varchar(20) NOT NULL,
	subject varchar(200) NOT NULL,
	message text NOT NULL,
	sent_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	read_at timestamptz,
	is_read boolean NOT NULL DEFAULT FALSE,
	delivery_status varchar(20) NOT NULL DEFAULT 'PENDING',
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	alert_id_alerts bigint,
	technician_id_technicians integer,
	CONSTRAINT notifications_pk PRIMARY KEY (notification_id)
);
-- ddl-end --
COMMENT ON COLUMN public.notifications.notification_id IS E'Primary key. Auto-incrementing bigint identifier for each notification.';
-- ddl-end --
COMMENT ON COLUMN public.notifications.notification_channel IS E'Delivery method for the notification (e.g., EMAIL, DASHBOARD, SMS, PAGER). Determines how the notification is routed to the recipient.';
-- ddl-end --
COMMENT ON COLUMN public.notifications.subject IS E'Subject line or title of the notification. Provides a concise summary for quick triage.';
-- ddl-end --
COMMENT ON COLUMN public.notifications.message IS E'Full notification message body including alert details, instrument identification, recommended actions, and any relevant context.';
-- ddl-end --
COMMENT ON COLUMN public.notifications.sent_at IS E'Timestamp when the notification was sent or queued for delivery.';
-- ddl-end --
COMMENT ON COLUMN public.notifications.read_at IS E'Timestamp when the recipient read or opened the notification. Null if not yet read. Supports response time tracking.';
-- ddl-end --
COMMENT ON COLUMN public.notifications.is_read IS E'Whether the notification has been read by the recipient. Supports dashboard filtering for unread notifications.';
-- ddl-end --
COMMENT ON COLUMN public.notifications.delivery_status IS E'Current delivery status of the notification (e.g., PENDING, SENT, DELIVERED, FAILED, BOUNCED). Supports retry logic and delivery confirmation.';
-- ddl-end --
COMMENT ON COLUMN public.notifications.created_at IS E'Timestamp of when this notification record was created in the database.';
-- ddl-end --
ALTER TABLE public.notifications OWNER TO postgres;
-- ddl-end --

-- object: alerts_fk | type: CONSTRAINT --
-- ALTER TABLE public.notifications DROP CONSTRAINT IF EXISTS alerts_fk CASCADE;
ALTER TABLE public.notifications ADD CONSTRAINT alerts_fk FOREIGN KEY (alert_id_alerts)
REFERENCES public.alerts (alert_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: technicians_fk | type: CONSTRAINT --
-- ALTER TABLE public.notifications DROP CONSTRAINT IF EXISTS technicians_fk CASCADE;
ALTER TABLE public.notifications ADD CONSTRAINT technicians_fk FOREIGN KEY (technician_id_technicians)
REFERENCES public.technicians (technician_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.pca_analysis_sensors | type: TABLE --
-- DROP TABLE IF EXISTS public.pca_analysis_sensors CASCADE;
CREATE TABLE public.pca_analysis_sensors (
	pca_sensor_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	sensor_index integer NOT NULL,
	contribution_to_t_squared numeric,
	contribution_to_q_residual numeric,
	is_faulted boolean NOT NULL DEFAULT FALSE,
	analysis_id_pca_analyses bigint,
	instrument_id_instruments integer,
	CONSTRAINT pca_analysis_sensors_pk PRIMARY KEY (pca_sensor_id)
);
-- ddl-end --
COMMENT ON COLUMN public.pca_analysis_sensors.pca_sensor_id IS E'Primary key. Auto-incrementing integer identifier for each PCA analysis-sensor association.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analysis_sensors.sensor_index IS E'Position of this sensor in the PCA model''s feature vector (0-indexed). Determines which column in the loading matrix corresponds to this sensor.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analysis_sensors.contribution_to_t_squared IS E'This sensor''s contribution to the T-squared statistic in this analysis. Higher values indicate greater influence on the detected variation. Used for fault isolation.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analysis_sensors.contribution_to_q_residual IS E'This sensor''s contribution to the Q-residual statistic in this analysis. A high Q contribution indicates this sensor has broken from its expected correlation with the group.';
-- ddl-end --
COMMENT ON COLUMN public.pca_analysis_sensors.is_faulted IS E'Whether this specific sensor was identified as the source of a fault in this analysis. Only one sensor per analysis is typically flagged unless a common-cause event is detected.';
-- ddl-end --
ALTER TABLE public.pca_analysis_sensors OWNER TO postgres;
-- ddl-end --

-- object: pca_analyses_fk | type: CONSTRAINT --
-- ALTER TABLE public.pca_analysis_sensors DROP CONSTRAINT IF EXISTS pca_analyses_fk CASCADE;
ALTER TABLE public.pca_analysis_sensors ADD CONSTRAINT pca_analyses_fk FOREIGN KEY (analysis_id_pca_analyses)
REFERENCES public.pca_analyses (analysis_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: instruments_fk | type: CONSTRAINT --
-- ALTER TABLE public.pca_analysis_sensors DROP CONSTRAINT IF EXISTS instruments_fk CASCADE;
ALTER TABLE public.pca_analysis_sensors ADD CONSTRAINT instruments_fk FOREIGN KEY (instrument_id_instruments)
REFERENCES public.instruments (instrument_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_locations_parent | type: CONSTRAINT --
-- ALTER TABLE public.locations DROP CONSTRAINT IF EXISTS fk_locations_parent CASCADE;
ALTER TABLE public.locations ADD CONSTRAINT fk_locations_parent FOREIGN KEY (parent_location_id)
REFERENCES public.locations (location_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE NO ACTION;
-- ddl-end --


