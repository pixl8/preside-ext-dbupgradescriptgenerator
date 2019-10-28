component {

	public void function configure( required struct config ) {
		var settings     = arguments.config.settings     ?: {};
		var interceptors = arguments.config.interceptors ?: [];

		settings.features = settings.features ?: {};
		settings.features.dbUpgradeScriptGenerator = { enabled=true, siteTemplates=[ "*" ] };

		settings.adminPermissions = settings.adminPermissions ?: {};
		settings.adminPermissions.dbUpgradeScriptGenerator = [ "generate" ];

		settings.adminConfigurationMenuItems = settings.adminConfigurationMenuItems ?: [];
		settings.adminConfigurationMenuItems.append( "dbUpgradeScriptGenerator" );

		interceptors.append( { class="app.extensions.preside-ext-dbupgradescriptgenerator.interceptors.DbUpgradeScriptGeneratorInterceptors", properties={} } );



	}
}