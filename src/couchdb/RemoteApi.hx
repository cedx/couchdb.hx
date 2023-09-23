package couchdb;

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
}
