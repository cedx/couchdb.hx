package couchdb;

import tink.Url;
import tink.web.proxy.Remote;
using StringTools;

/** Represents a CouchDB design document. **/
class DesignDocument implements Model {

	/** The associated database. **/
	@:constant var database: Database;

	/** The document identifier. **/
	@:computed var id: String = '_design/$name';

	/** The document name. **/
	@:constant var name: String;

	/** The document URL. **/
	@:computed var url: Url = database.url.resolve('_design/${name.urlEncode()}');

	/** The remote API client. **/
	var remote(get, never): Remote<RemoteApi>;
		inline function get_remote() return @:privateAccess database.server.remote;

	/** Compacts the view indexes associated with this design document. **/
	public function compact() return database.compact(name);

	/** Returns an object for performing operations on a view. **/
	public function view(name: String) return new View({design: this, name: name});
}
