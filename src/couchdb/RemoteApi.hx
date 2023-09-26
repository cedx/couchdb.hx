package couchdb;

import couchdb.Database.DatabaseCreateOptions;
import couchdb.Server.ServerInfo;
import tink.Chunk;

/** Defines the interface of the remote API. **/
@:noDoc interface RemoteApi {

	/** The list of all databases. **/
	@:get("/_all_dbs")
	final databases: Array<String>;

	/** The binary content for the `favicon.ico` site icon. **/
	@:get
	final favicon: Chunk;

	/** Meta information about the server instance. **/
	@:get("/")
	final info: ServerInfo;

	/** Value indicating whether the server is up. **/
	@:get("/_up")
	final isUp: Noise;

	/** The database controller. **/
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
	function create(?query: {?n: Int, ?partitioned: Bool, ?q: Int}): Noise;

	/** Deletes a database. **/
	@:delete("/")
	function delete(): Noise;
}
