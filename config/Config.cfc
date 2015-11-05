component {

	public void function configure( required struct config ) {
		var settings            = arguments.config.settings            ?: {};

		settings.features = settings.features ?: {};
		settings.features.dbUpgradeScriptGenerator = { enabled=true, siteTemplates=[ "*" ] };

		settings.adminPermissions = settings.adminPermissions ?: {};
		settings.adminPermissions.dbUpgradeScriptGenerator = [ "generate" ];

		settings.adminConfigurationMenuItems = settings.adminConfigurationMenuItems ?: [];
		settings.adminConfigurationMenuItems.append( "dbUpgradeScriptGenerator" );
	}
}