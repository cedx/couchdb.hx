package couchdb;

using haxe.io.Path;

/** Represents a CouchDB design document. **/
class DesignDocument implements Model {

	/** The associated database. **/
	@:constant var db: Database;

	/** The document identifier. **/
	@:computed var id: String = '_design/$key';

	/** The document key. **/
	@:constant var key: String;

	/** The document URL. **/
	@:computed var url: Url = Url.parse(db.url.toString().addTrailingSlash()).resolve(id);

	/** The remote API client. **/
	var remote(get, never): Remote<RemoteApi>;
		inline function get_remote() return @:privateAccess db.server.remote;

	/** Returns an object for performing operations on a view. **/
	public inline function use(view: String) return new View({design: this, key: view});
}
