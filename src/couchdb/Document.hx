package couchdb;

using haxe.io.Path;

/** Represents a CouchDB document. **/
class Document implements Model {

	/** The associated database. **/
	@:constant var database: Database;

	/** The document key. **/
	@:constant var key: String;

	/** The database URL. **/
	@:computed var url: Url = Url.parse(database.url.toString().addTrailingSlash()).resolve(key);
}
