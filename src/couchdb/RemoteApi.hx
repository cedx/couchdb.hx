package couchdb;

import couchdb.Server.ServerInfo;
import tink.Chunk;

/** Defines the interface of the remote API. **/
@:noDoc interface RemoteApi {

	/** Returns the binary content for the `favicon.ico` site icon. **/
	@:get
	final favicon: Chunk;

	/** Returns meta information about the server instance. **/
	@:get("/")
	final info: ServerInfo;
}
