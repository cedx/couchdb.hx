package couchdb;

using haxe.io.Path;

/** Represents a CouchDB document. **/
class Document<T> implements Model {

	/** The document data. **/
	@:constant var data: Null<T> = @byDefault null;

	/** The associated database. **/
	@:constant var db: Database;

	/** The document identifier. **/
	@:constant var id: String;

	/** The document URL. **/
	@:computed var url: Url = Url.parse(db.url.toString().addTrailingSlash()).resolve(id);

	/** The remote API client. **/
	@:computed private var remote: Remote<RemoteApi> = @:privateAccess db.remote;
}
