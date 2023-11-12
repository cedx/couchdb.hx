package couchdb;

import tink.Url;
import tink.web.proxy.Remote;
using StringTools;
using haxe.io.Path;

/** Represents a CouchDB database. **/
class Database implements Model {

	/** The database name. **/
	@:constant var name: String;

	/** The associated server. **/
	@:constant var server: Server;

	/** The opening date of this database. **/
	@:constant var startTime: Null<Date> = @byDefault null;

	/** The database URL. **/
	@:computed var url: Url = Url.parse(server.url.toString().addTrailingSlash()).resolve(name);

	/** Value indicating whether this database exists. **/
	public var exists(get, never): Promise<Bool>;
		function get_exists() return remote.use(name).exists()
			.next(_ -> true)
			.tryRecover(error -> error.code == NotFound ? Success(false) : Failure(error));

	/** The remote API client. **/
	var remote(get, never): Remote<RemoteApi>;
		inline function get_remote() return @:privateAccess server.remote;

	/** Compacts this database. **/
	public function compact(?designDocument: String) return remote.use(name).compact(designDocument);

	/** Creates this database. **/
	public function create(?options: DatabaseCreateOptions) return remote.use(name).create({
		n: options?.replicas,
		partitioned: options?.partitioned,
		q: options?.shards
	});

	/** Deletes this database. **/
	public function delete() return remote.use(name).delete();

	/** Returns an object for performing operations on a design document. **/
	public function design(key: String) return new DesignDocument({db: this, key: key});

	/** Fetches information about this database. **/
	public function fetch() return remote.use(name).fetch().next(json -> new Database({
		name: name,
		server: server,
		startTime: json.instance_start_time != "0" ? Date.fromTime(Std.parseFloat(json.instance_start_time)) : null
	}));

	/** Returns an object for performing operations on a local document. **/
	public function local<T>(key: String) return new LocalDocument<T>({db: this, key: key});

	/** Returns an object for performing operations on a document. **/
	public function use<T>(document: String) return new Document<T>({db: this, id: document});

	/** Returns an object for performing operations on a view. **/
	public function view(designKey: String, viewKey: String) return design(designKey).use(viewKey);
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

/** Provides information about a database. **/
typedef DatabaseInfo = {

	/** The cluster information. **/
	var cluster: {n: Int, q: Int, r: Int, w: Int};

	/** Value indicating whether the compaction routine is operating on this database. **/
	var compact_running: Bool;

	/** The database name. **/
	var db_name: String;

	/** The version of the physical format used for the data when it is stored on disk. **/
	var disk_format_version: Int;

	/** The number of documents. **/
	var doc_count: Int;

	/** The number of deleted documents. **/
	var doc_del_count: Int;

	/** The timestamp in microseconds of when the database was opened. **/
	var instance_start_time: String;

	/** The database properties. **/
	var props: {?partitioned: Bool};

	/** An opaque string that describes the purge state of the database. **/
	var purge_seq: String;

	/** The database sizes, in bytes. **/
	var sizes: {active: Int, external: Int, file: Int};

	/** An opaque string that describes the state of the database. **/
	var update_seq: String;
}
