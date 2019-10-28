# PresideCMS Extension: Database Upgrade Script Generator

This is an extension for PresideCMS that allows you to create a database upgrade script in preparation for a deployment to another environment.

## Installation

```
box install preside-ext-dbupgradescriptgenerator
```

## Caution

While the system does its best to avoid problems, always proceed with caution when upgrading production databases. Large datasets and change conflicts can cause database upgrade issues that the software cannot resolve by itself.

For production databases, take a backup and restore it so that the script can be generated from and tested against the backup. Should you encounter upgrade issues, fix them with database scripts and add those scripts to your saved migration script.


## How it works

The extension provides two approaches to generating DB upgrade SQL scripts.

1. An admin UI where you enter DSN details for a seperate datasource
2. An environment variable to be set that forces the application to do nothing but output schema upgrade script for the current datasource

### Admin UI

You can navigate to the wizard in the admin via the **System** menu (top right), **System** -> **DB Script Generator**.


### Permissioning

By default, only the system user can access the script generator wizard. To allow other admin roles to be able to access the wizard, add the following line to your application's `Config.cfc` file:

```cfc
settings.adminRoles.sysadmin.append( "dbUpgradeScriptGenerator.*" );
```

In this example, we are allowing the "sysadmin" user role to access the generator functionality. See the [CMS Permissioning documentation](https://docs.presidecms.com/devguides/cmspermissioning.html) for more details.

### Switching the feature off entirely

You may only wish the feature to be enabled in local or development environments. To do so, edit your application's `Config.cfc` file by toggling the `settings.features.dbUpgradeScriptGenerator.enabled` flag. For example:


```cfc
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
```

## Environment variable flag

As of `v2.0.0` of this extension, you can set an env variable `GENERATE_DB_UPGRADE_SCRIPT_ONLY=true` to force the extension to always stop the application from loading and, instead, output the schema upgrade SQL for the running application.

This could be useful as a build tool helper to allow you to start the application with the datasource set to the target database and to then capture the output of an http request to the application to use as the SQL upgrade script.

For instance, you may do something like:

```bash
echo "\
GENERATE_DB_UPGRADE_SCRIPT_ONLY=true\
datasource.host=my.db.server
datasource.database_name=my_db
datasource.user=my_db_user
datasource.type=MySQL
datasource.password=123
" > .env
box install preside-ext-dbupgradescriptgenerator@2.0.0
box preside start name=sqlgen port=4444 trayEnable=false openbrowser=false
wget -O ./upgrade.sql http://localhost:4444
box preside stop sqlgen
```

You are then guaranteed an `upgrade.sql` file that you can use to run against your target DB (or send to DBA to evaluate and run, or whatever).

