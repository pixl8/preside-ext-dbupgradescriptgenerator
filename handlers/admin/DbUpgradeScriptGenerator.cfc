component extends="preside.system.base.AdminHandler" {

	public void function preHandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );

		if ( !hasCmsPermission( "dbUpgradeScriptGenerator.generate" ) ) {
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


}