package couchdb;

using StringTools;
using haxe.io.Path;

/** Represents a CouchDB database. **/
class Database implements Model {

	/** Value indicating whether this database exists. **/
	public var exists(get, never): Promise<Bool>;
		function get_exists() return @:privateAccess server.remote.use(name).exists()
			.next(_ -> true)
			.tryRecover(error -> error.code == NotFound ? Success(false) : Failure(error));

	/** The database name. **/
	@:constant var name: String;

	/** The associated server. **/
	@:constant var server: Server;

	/** The database URL. **/
	@:computed var url: Url = Url.parse(server.url.toString().addTrailingSlash()).resolve(name);

	/** Creates this database. **/
	public function create(?options: DatabaseCreateOptions) return @:privateAccess server.remote.use(name).create({
		n: options?.replicas,
		partitioned: options?.partitioned,
		q: options?.shards
	});

	/** Deletes this database. **/
	public function delete() return @:privateAccess server.remote.use(name).delete();

	/** Returns a document object that allows you to perform operations against that document. **/
	public inline function use(document: String) return new Document({database: this, key: document});
}

/** Defines the options for creating a database. **/
typedef DatabaseCreateOptions = {

	/** Value indicating whether to create a partitioned database. **/
	var ?partitioned: Bool;

	/** The number of replicas (i.e. the copies of the database in the cluster). **/
	var ?replicas: Int;

	/** The number of shards (i.e. the range partitions). **/
	var ?shards: Int;
}
