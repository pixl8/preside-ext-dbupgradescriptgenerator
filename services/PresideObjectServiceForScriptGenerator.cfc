/**
 * Extension of the preside object service to expose some internals
 *
 * @singleton
 */
component extends="preside.system.services.presideObjects.PresideObjectService" {

	public struct function getObjects() {
		return _getObjects();
	}

}