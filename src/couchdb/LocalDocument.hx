package couchdb;

using haxe.io.Path;

/** Represents a CouchDB local document. **/
class LocalDocument<T> implements Model {

	/** The document data. **/
	@:constant var data: Null<T> = @byDefault null;

	/** The associated database. **/
	@:constant var db: Database;

	/** The document identifier. **/
	@:computed var id: String = '_local/$key';

	/** The document key. **/
	@:constant var key: String;

	/** The document URL. **/
	@:computed var url: Url = Url.parse(db.url.toString().addTrailingSlash()).resolve('_local/$key');

	/** The remote API client. **/
	@:computed private var remote: Remote<RemoteApi> = @:privateAccess db.remote;
}
