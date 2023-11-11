package couchdb;

import couchdb.Server.ServerInfo;
import couchdb.Session.SessionInfo;
import couchdb.User.UserInfo;
import tink.Chunk;

/** Defines the interface of the remote API. **/
@:noDoc interface RemoteApi {

	/** The list of all databases. **/
	@:get("/_all_dbs")
	final databases: Array<String>;

	/** The binary content for the `favicon.ico` site icon. **/
	@:get
	final favicon: Chunk;

	/** Value indicating whether the server is up. **/
	@:get("/_up")
	final isUp: Noise;

	/** The session controller. **/
	@:sub("/_session")
	final session: SessionController;

	/** Fetches information about the server. **/
	@:get("/")
	function fetch(): ServerInfo;

	/** Returns an object for performing operations on a database. **/
	@:sub('/$database')
	function use(database: String): DatabaseController;

	/** Requests one or more Universally Unique Identifiers (UUIDs) from the server. **/
	@:get("/_uuids")
	function uuids(?query: {count: Int}): {uuids: Array<String>};
}

/** Manages the databases. **/
private interface DatabaseController {

	/** Checks whether a database exists. **/
	@:head("/")
	final exists: Noise;

	/** Creates a new database. **/
	@:put("/")
	function create(?query: DatabaseCreateOptions): Noise;

	/** Deletes a database. **/
	@:delete("/")
	function delete(): Noise;

	/** Returns an object for performing operations on a design document. **/
	@:sub('/_design/$key')
	function design(key: String): DesignDocumentController;

	/** Returns an object for performing operations on a local document. **/
	@:sub('/_local/$key')
	function local(key: String): LocalDocumentController;

	/** Returns an object for performing operations on a document. **/
	@:sub('/$document')
	function use(document: String): DocumentController;
}

/** Defines the options for creating a database. **/
private typedef DatabaseCreateOptions = {

	/** The number of replicas (i.e. the copies of the database in the cluster). **/
	var ?n: Int;

	/** Value indicating whether to create a partitioned database. **/
	var ?partitioned: Bool;

	/** The number of shards (i.e. the range partitions). **/
	var ?q: Int;
}

/** Manages the design documents. **/
private interface DesignDocumentController {}

/** Manages the documents. **/
private interface DocumentController {}

/** Manages the local documents. **/
private interface LocalDocumentController {}

/** Manages the user sessions. **/
private interface SessionController {

	/** Initiates a new session for the specified user credentials. **/
	@:post("/")
	function create(?query: {redirect: String}): UserInfo;

	/** Deletes a session. **/
	@:delete("/")
	function delete(): Noise;

	/** Fetches information about the session. **/
	@:get("/")
	function fetch(): SessionInfo;
}
