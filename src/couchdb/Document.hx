package couchdb;

import tink.Url;
import tink.web.proxy.Remote;
using StringTools;

/** Represents a CouchDB document. **/
class Document<T> implements Model {

	/** The document data. **/
	@:constant var data: Null<T> = @byDefault null;

	/** The associated database. **/
	@:constant var database: Database;

	/** The document identifier. **/
	@:constant var id: String;

	/** The document URL. **/
	@:computed var url: Url = database.url.resolve(id.urlEncode());

	/** The remote API client. **/
	var remote(get, never): Remote<RemoteApi>;
		inline function get_remote() return @:privateAccess database.server.remote;
}
