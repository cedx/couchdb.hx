package couchdb;

import couchdb.Database.DatabaseCreateOptions;
import couchdb.Database.DatabaseInfo;
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

	/** The list of active tasks. **/
	@:get("/_active_tasks")
	final tasks: Array<Task>;

	/** Returns an object for performing operations on a database. **/
	@:sub('/$database')
	function db(database: String): DatabaseController;

	/** Fetches information about the server. **/
	@:get("/")
	function fetch(): ServerInfo;

	/** Requests one or more Universally Unique Identifiers (UUIDs) from the server. **/
	@:get("/_uuids")
	function uuids(?query: {count: Int}): {uuids: Array<String>};
}

/** Manages the databases. **/
private interface DatabaseController {

	/** Checks whether the database exists. **/
	@:head("/")
	final exists: Noise;

	/** Compacts the database. **/
	@:post("/_compact")
	@:post('/_compact/$designDocument')
	function compact(?designDocument: String): Noise;

	/** Creates a new database. **/
	@:put("/")
	function create(?query: DatabaseCreateOptions): Noise;

	/** Deletes the database. **/
	@:delete("/")
	function delete(): Noise;

	/** Returns an object for performing operations on a design document. **/
	@:sub('/_design/$name')
	function design(name: String): DesignDocumentController;

	/** Returns an object for performing operations on a document. **/
	@:sub('/$document')
	function document(document: String): DocumentController;

	/** Fetches information about the database. **/
	@:get("/")
	function fetch(): DatabaseInfo;

	/** Returns an object for performing operations on a local document. **/
	@:sub('/_local/$name')
	function local(name: String): LocalDocumentController;
}

/** Manages the design documents. **/
private interface DesignDocumentController {

	/** Returns an object for performing operations on a view. **/
	@:sub('/_view/$view')
	function view(view: String): ViewController;
}

/** Manages the documents. **/
private interface DocumentController {}

/** Manages the local documents. **/
private interface LocalDocumentController {}

/** Manages the user sessions. **/
private interface SessionController {

	/** Deletes a session. **/
	@:delete("/")
	function delete(): Noise;

	/** Fetches information about the session. **/
	@:get("/")
	function fetch(): SessionInfo;
}

/** Manages the views. **/
private interface ViewController {

	/** Queries the view. **/
	//@:get("/")
	//function query<Key, Value, Record>(): DocumentListData<Key, Value, Record>;
}
