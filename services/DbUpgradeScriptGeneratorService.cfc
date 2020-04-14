/**
 * @singleton
 */
component {

// CONSTRUCTOR
	/**
	 * @presideObjectService.inject  presideObjectServiceForScriptGenerator
	 * @sqlSchemaSynchronizer.inject sqlSchemaSynchronizerForScriptGenerator
	 * @env.inject                   coldbox:setting:env
	 */
	public any function init(
		  required any    presideObjectService
		, required any    sqlSchemaSynchronizer
		, required struct env
	) {
		_setPresideObjectService(  arguments.presideObjectService  );
		_setSqlSchemaSynchronizer( arguments.sqlSchemaSynchronizer );
		_setEnv( arguments.env );
	}

// PUBLIC API
	public string function createScript(
		  required string  host
		, required numeric port
		, required string  dbname
		, required string  username
		, required string  password
	) {
		var dsn            = "dbScriptGeneratorDatasource";
		var e              = "";
		var noSqlGenerated = "/* NO SQL WAS GENERATED/REQUIRED */";
		var objects        = _getPresideObjectService().getobjects();

		_setupDsn( argumentCollection=arguments, dsn=dsn );
		for( var objName in objects ) {
			objects[ objName ].meta.dsn = dsn;
		}

		setting requesttimeout=12000;

		try {
			_getSqlSchemaSynchronizer().synchronize(
				  dsns    = [ dsn ]
				, objects = objects
			);
			_teardownDsn( dsn=dsn );
		} catch( "presidecms.auto.schema.sync.disabled" e ) {
			return e.detail ?: noSqlGenerated;
		}

		return noSqlGenerated;
	}

	public string function cleanScript( required string script ) {
		var cleaned         = arguments.script;
		var env             = _getEnv();
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
			cleaned = Replace( cleaned, "__deprecated__", "", "all" );
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

// PRIVATE HELPERS
	private void function _setupDsn(
		  required string  host
		, required numeric port
		, required string  dbname
		, required string  username
		, required string  password
		, required string  dsn
	) {
    	admin action     = "updateDatasource"
 		      type       = "web"
 		      classname  = "org.gjt.mm.mysql.Driver"
 		      dsn        = "jdbc:mysql://#arguments.host#:#arguments.port#/#arguments.dbname#?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true"
 		      name       = arguments.dsn
 		      newName    = arguments.dsn
 		      host       = arguments.host
 		      database   = arguments.dbname
 		      port       = arguments.port
 		      dbusername = arguments.username
 		      dbpassword = arguments.password;
	}

	private void function _teardownDsn() {
		admin action = "removeDatasource"
 		      type   = "web"
 		      name   = arguments.dsn;
	}

// GETTERS AND SETTERS
	private any function _getPresideObjectService() {
		return _presideObjectService;
	}
	private void function _setPresideObjectService( required any presideObjectService ) {
		_presideObjectService = arguments.presideObjectService;
	}

	private any function _getSqlSchemaSynchronizer() {
		return _sqlSchemaSynchronizer;
	}
	private void function _setSqlSchemaSynchronizer( required any sqlSchemaSynchronizer ) {
		_sqlSchemaSynchronizer = arguments.sqlSchemaSynchronizer;
	}

	private struct function _getEnv() {
	    return _env;
	}
	private void function _setEnv( required struct env ) {
	    _env = arguments.env;
	}
}