# PresideCMS Extension: Database Upgrade Script Generator

This is an extension for PresideCMS that allows you to create a database upgrade script in preparation for a deployment to another environment.

## How it works

The extension provides an admin screen for entering the database connection details of the database that you wish to upgrade. When requested, the extension logic will produce an upgrade script for that databased based on the Preside data objects of the currently running application.

You can navigate to the wizard in the admin via the **System** menu (top right), **System** -> **DB Script Generator**.

## Caution

While the system does its best to avoid problems, always proceed with caution when upgrading production databases. Large datasets and change conflicts can cause database upgrade issues that the software cannot resolve by itself.

For production databases, take a backup and restore it so that the script can be generated from and tested against the backup. Should you encounter upgrade issues, fix them with database scripts and add those scripts to your saved migration script.

## Installation

Install the extension to your application via either of the methods detailed below (Git submodule / CommandBox) and then enable the extension by opening up the Preside developer console and entering:

    extension enable preside-ext-dbupgradescriptgenerator
    reload all

### Git Submodule method

From the root of your application, type the following command:

    git submodule add https://github.com/pixl8/preside-ext-dbupgradescriptgenerator.git application/extensions/preside-ext-dbupgradescriptgenerator

### CommandBox (box.json) method

From the root of your application, type the following command:

    box install pixl8/preside-ext-dbupgradescriptgenerator#v1.0.1

## Permissioning

By default, only the system user can access the script generator wizard. To allow other admin roles to be able to access the wizard, add the following line to your application's `Config.cfc` file:

    settings.adminRoles.sysadmin.append( "dbUpgradeScriptGenerator.*" );

In this example, we are allowing the "sysadmin" user role to access the generator functionality. See the [CMS Permissioning documentation](https://docs.presidecms.com/devguides/cmspermissioning.html) for more details.

### Switching the feature off entirely

You may only wish the feature to be enabled in local or development environments. To do so, edit your application's `Config.cfc` file by toggling the `settings.features.dbUpgradeScriptGenerator.enabled` flag. For example:

    component extends="preside.system.config.Config" {

        public void function configure() {
        	// ...

            // feature turned off by default
            settings.features.dbUpgradeScriptGenerator.enabled = false;

        	// ...
        }

        public void function local() {
        	// ...

            // setting turned on for 'local' environment
        	settings.features.dbUpgradeScriptGenerator.enabled = true;

        	// ...
        }
    }




