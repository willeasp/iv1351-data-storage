\c template1;
DROP DATABASE IF EXISTS soundgood;

CREATE DATABASE soundgood;
\c soundgood;

/* create tables */
\i /host_files/src/scripts/LogPhysModel.sql


/* Populate data */
\i /host_files/src/scripts/PopulateData.sql;