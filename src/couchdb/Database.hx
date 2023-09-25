package couchdb;

import tink.Url;
using StringTools;

/** Provides access to a CouchDB database. **/
class Database {

	/** Value indicating whether this database exists. **/
	public var exists(get, never): Promise<Bool>;
		function get_exists() return server.remote.use(name).exists()
			.next(_ -> true)
			.tryRecover(error -> error.code == NotFound ? Success(false) : Failure(error));

	/** The database name. **/
	public final name: String;

	/** The database URL. **/
	public var url(get, never): Url;
		inline function get_url() return server.url.resolve(name);

	/** The associated server instance. **/
	final server: Server;

	/** Creates a new database. **/
	public function new(name: String, server: Server) {
		this.name = name;
		this.server = server;
	}

	/** Creates this database. **/
	public function create(?options: DatabaseCreateOptions) return server.remote.use(name).create(options);

	/** Deletes this database. **/
	public function delete() return server.remote.use(name).delete();
}

/** Defines the options for creating a database. **/
typedef DatabaseCreateOptions = {

	/** The number of replicas (i.e. the copies of the database in the cluster). **/
	var ?n: Int;

	/** Value indicating whether to create a partitioned database. **/
	var ?partitioned: Bool;

	/** The number of shards (i.e. the range partitions). **/
	var ?q: Int;
}
