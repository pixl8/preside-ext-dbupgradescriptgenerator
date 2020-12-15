component extends="coldbox.system.Interceptor" {

	property name="env"          inject="coldbox:setting:env";
	property name="dbSchemaSync" inject="delayedInjector:SqlSchemaSynchronizerForScriptGenerator";

	public void function configure() {}

	public void function postLoadPresideObjects( event, interceptData ){
		if ( IsBoolean( env.GENERATE_DB_UPGRADE_SCRIPT_ONLY ?: "" ) && env.GENERATE_DB_UPGRADE_SCRIPT_ONLY ) {
			var objects = interceptData.objects ?: {};
			var dsns    = {};
			var script  = "";

			for( var objName in objects ){
				dsns[ objects[ objName ].meta.dsn ] = 1
			}

			try {
				getController().getInterceptorService().processState( "preDbSyncObjects" );
				dbSchemaSync.synchronize( StructKeyArray( dsns ), objects );
				getController().getInterceptorService().processState( "postDbSyncObjects" );
			} catch( "presidecms.auto.schema.sync.disabled" e ) {
				script = e.detail ?: "";
			}

			script = _cleanScript( script );

			content reset=true type="text/plain";
			if ( Len( Trim( script ) ) ) {
				SystemOutput( "SQL Schema script generated." );
				echo( script );
			} else {
				SystemOutput( "NO SQL Schema script required." );
				echo( "/* NO SQL WAS GENERATED/REQUIRED */" )
			}

			StructClear( application );
			abort;
		}
	}

// private helpers
	private string function _cleanScript( required string script ) {
		if ( !Len( Trim( script ) ) ) {
			return "";
		}

		var cleaned         = arguments.script;
		var nl              = Chr( 13 ) & Chr( 10 );
		var disableFkChecks = IsBoolean( env.DISABLE_FK_CHECKS ?: "" ) && env.DISABLE_FK_CHECKS;
		var doNotDeprecate  = IsBoolean( env.DISABLE_FIELD_DEPRECATION_RENAME ?: "" ) && env.DISABLE_FIELD_DEPRECATION_RENAME;
		var removeDupes     = IsBoolean( env.REMOVE_DUPLICATE_SCHEMA_UPGRADE_LINES ?: "" ) && env.REMOVE_DUPLICATE_SCHEMA_UPGRADE_LINES;

		if ( disableFkChecks ) {
			cleaned = Replace( cleaned, "set foreign_key_checks=0;", "", "all" );
			cleaned = Replace( cleaned, "set foreign_key_checks=1;", "", "all" );
			cleaned = "set foreign_key_checks=0;" & nl & cleaned & nl & "set foreign_key_checks=1;"
		}

		if ( doNotDeprecate ) {
			cleaned = Replace( cleaned, "` `__deprecated__", "` `", "all" );
			cleaned = Replace( cleaned, "] [__deprecated__", "] [", "all" );
		}

		if ( removeDupes ) {
			var deduped = StructNew( "linked" );
			for( var line in ListToArray( cleaned, nl ) ) {
				deduped[ Trim( line ) ] = 1;
			}

			cleaned = ArrayToList( StructKeyArray( deduped ), nl );
		}

		return cleaned;
	}

}