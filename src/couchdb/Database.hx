package couchdb;

using StringTools;
using haxe.io.Path;

/** Represents a CouchDB database. **/
class Database implements Model {

	/** Value indicating whether this database exists. **/
	public var exists(get, never): Promise<Bool>;
		function get_exists() return remote.use(name).exists()
			.next(_ -> true)
			.tryRecover(error -> error.code == NotFound ? Success(false) : Failure(error));

	/** The database name. **/
	@:constant var name: String;

	/** The associated server. **/
	@:constant var server: Server;

	/** The database URL. **/
	@:computed var url: Url = Url.parse(server.url.toString().addTrailingSlash()).resolve(name);

	/** The remote API client. **/
	@:computed private var remote: Remote<RemoteApi> = @:privateAccess server.remote;

	/** Creates this database. **/
	public function create(?options: DatabaseCreateOptions) return remote.use(name).create({
		n: options?.replicas,
		partitioned: options?.partitioned,
		q: options?.shards
	});

	/** Deletes this database. **/
	public function delete() return remote.use(name).delete();

	/** Returns an object for performing operations on a design document. **/
	public inline function design(key: String) return new DesignDocument({db: this, key: key});

	/** Returns an object for performing operations on a local document. **/
	public inline function local<T>(key: String) return new LocalDocument<T>({db: this, key: key});

	/** Returns an object for performing operations on a document. **/
	public inline function use<T>(document: String) return new Document<T>({db: this, id: document});

	/** Returns an object for performing operations on a view. **/
	public inline function view(designKey: String, viewKey: String) return design(designKey).use(viewKey);
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
