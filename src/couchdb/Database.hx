package couchdb;

import tink.Url;
using StringTools;

/** Provides access to a CouchDB database. **/
class Database {

	/** The server URL. **/
	public final url: Url;

	/** Creates a new database. **/
	public function new(name: String, server: Server) url = server.url.resolve(name);
}
