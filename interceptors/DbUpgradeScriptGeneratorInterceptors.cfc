component extends="coldbox.system.Interceptor" {

	property name="env" inject="coldbox:setting:env";
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
				dbSchemaSync.synchronize( StructKeyArray( dsns ), objects );
			} catch( "presidecms.auto.schema.sync.disabled" e ) {
				script = e.detail ?: "";
			}



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

}