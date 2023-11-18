package couchdb;

import tink.Url;
import tink.web.proxy.Remote;
using StringTools;

/** Represents a CouchDB local document. **/
class LocalDocument<T> implements Model {

	/** The document data. **/
	@:constant var data: Null<T> = @byDefault null;

	/** The associated database. **/
	@:constant var db: Database;

	/** The document identifier. **/
	@:computed var id: String = '_local/$name';

	/** The document name. **/
	@:constant var name: String;

	/** The document URL. **/
	@:computed var url: Url = '${db.url}/_local/${name.urlEncode()}';

	/** The remote API client. **/
	var remote(get, never): Remote<RemoteApi>;
		inline function get_remote() return @:privateAccess db.server.remote;
}
