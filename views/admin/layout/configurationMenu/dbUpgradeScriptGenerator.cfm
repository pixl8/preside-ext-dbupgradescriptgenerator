<cfif ( isFeatureEnabled( "dbUpgradeScriptGenerator" ) && hasCmsPermission( "dbUpgradeScriptGenerator.generate" ) )>
	<cfoutput>
		<li>
			<a href="#event.buildAdminLink( linkTo="dbUpgradeScriptGenerator" )#">
				<i class="fa fa-fw fa-database"></i>
				#translateResource( 'cms:dbUpgradeScriptGenerator.system.menu.title' )#
			</a>
		</li>
	</cfoutput>
</cfif>