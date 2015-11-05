component extends="preside.system.base.AdminHandler" {

	property name="dbUpgradeScriptGeneratorService" inject="dbUpgradeScriptGeneratorService";

	public void function preHandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );

		if ( !isFeatureEnabled( "dbUpgradeScriptGenerator" ) || !hasCmsPermission( "dbUpgradeScriptGenerator.generate" ) ) {
			event.adminAccessDenied();
		}

		prc.pageIcon = "database";
		event.addAdminBreadCrumb(
			  title = translateResource( "cms:dbUpgradeScriptGenerator.breadcrumb.title" )
			, link  = event.buildAdminLink( linkTo="dbUpgradeScriptGenerator" )
		);
	}

	public void function index( event, rc, prc ) {
		prc.pageTitle    = translateResource( "cms:dbUpgradeScriptGenerator.page.title" );
		prc.pageSubTitle = translateResource( "cms:dbUpgradeScriptGenerator.page.subtitle" );
	}

	public void function finished( event, rc, prc ) {
		prc.pageTitle    = translateResource( "cms:dbUpgradeScriptGenerator.page.title" );
		prc.pageSubTitle = translateResource( "cms:dbUpgradeScriptGenerator.page.subtitle" );
	}

	public void function generateScriptAction( event, rc, prc ) {
		var formName         = "dbupgradescriptgenerator.datasource";
		var formData         = event.getCollectionForForm( formName );
		var validationResult = validateForm( formName, formData );
		var persistStruct    = {};

		if ( !validationResult.validated() ) {
			persistStruct.append( formData );
			persistStruct.validationResult = validationResult;
			setNextEvent( url=event.buildAdminLink( "dbupgradescriptgenerator" ), persistStruct=persistStruct );
		}

		persistStruct.script = dbUpgradeScriptGeneratorService.createScript( argumentCollection=formData );
		setNextEvent( url=event.buildAdminLink( "dbupgradescriptgenerator.finished" ), persistStruct=persistStruct );
	}
}