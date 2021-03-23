# Changelog

## v2.1.2

* Support latest MySQL driver used by Lucee

## v2.1.1

* Ensure pre/post interceptors are fired before generating sql script

## v2.1.0

* Add feature to cleanup script that allows: remove duplicate script lines, never rename fields to __deprecated__ and disable foreign key checks during entire script (mysql/mariadb only)

## v2.0.0

* Add a feature for forcing the application to ONLY EVER generate a SQL upgrade script if an environment flag is set. Allowing devs to use in build scripts to start an application with the view to always just generating the SQL upgrade script

## v1.0.1

* Remove package directory option and create package directory
* Add directory to box.json
* Change instructiosn for box install to use versioned releases
* Checking feature is enabled before any admin request

## v1.0.0 

* Original commit creating admin functionality to generate script through UI
