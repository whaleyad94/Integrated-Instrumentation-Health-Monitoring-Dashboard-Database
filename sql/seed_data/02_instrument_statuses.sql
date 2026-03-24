INSERT INTO instrument_statuses (status_code, status_name, is_readings_valid, description)
VALUES ('ACT', 'Active', TRUE ,'Instrument is fully operational and performing within its design specifications. Readings are reliable for monitoring, trending, control, and safety functions.');

INSERT INTO instrument_statuses (status_code, status_name, is_readings_valid, description)
VALUES ('OOS','Out of Service', FALSE ,'Instrument has been deliberately removed from service for maintenance, calibration, or modification. Readings should not be used for any purpose. May require compensatory measures per Technical Specifications if the instrument supports a safety function.');

INSERT INTO instrument_statuses (status_code, status_name, is_readings_valid, description)
VALUES ('DEG','Degraded', TRUE , 'Instrument is operational but exhibiting signs of degradation such as increased drift, intermittent anomalies, or reduced accuracy. Readings may still be usable for trending but should be cross-checked against redundant instruments before being relied upon for safety or control decisions.');

INSERT INTO instrument_statuses (status_code, status_name, is_readings_valid, description)
VALUES ('FAIL','Failed', FALSE ,'Instrument has failed and is no longer producing reliable readings. Requires corrective maintenance before being returned to service. If safety-related, a Condition Report must be initiated and Technical Specification action statements may apply.');

INSERT INTO instrument_statuses (status_code, status_name, is_readings_valid, description)
VALUES ('DECOM','Decommissioned', FALSE ,'Instrument has been permanently removed from service and is no longer part of the plant monitoring program. Record retained for historical traceability of past readings, calibrations, and maintenance activities.');
