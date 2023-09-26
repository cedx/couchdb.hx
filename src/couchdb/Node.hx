package couchdb;

/** Represents an Erlang node. **/
class Node {

	/** The node name. **/
	public final name: String;

	/** The associated server instance. **/
	public final server: Server;

	/** Creates a new database. **/
	public function new(name: String, server: Server) {
		this.name = name;
		this.server = server;
	}
}
