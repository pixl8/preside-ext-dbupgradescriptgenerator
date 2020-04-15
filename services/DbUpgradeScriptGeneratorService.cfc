/**
 * @singleton
 */
component {

// CONSTRUCTOR
	/**
	 * @presideObjectService.inject  presideObjectServiceForScriptGenerator
	 * @sqlSchemaSynchronizer.inject sqlSchemaSynchronizerForScriptGenerator
	 */
	public any function init(
		  required any    presideObjectService
		, required any    sqlSchemaSynchronizer
	) {
		_setPresideObjectService(  arguments.presideObjectService  );
		_setSqlSchemaSynchronizer( arguments.sqlSchemaSynchronizer );
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
}