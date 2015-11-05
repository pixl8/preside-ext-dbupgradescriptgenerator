/**
 * @singleton
 */
component extends="preside.system.services.presideObjects.SqlSchemaSynchronizer" {
	public void function synchronize() {
		_setAutoRunScripts( false );
		return super.synchronize( argumentCollection=arguments );
	}
}