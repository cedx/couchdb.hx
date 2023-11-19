package couchdb;

import tink.Chunk;
import tink.Url;
import tink.Web;
import tink.http.Response.IncomingResponse;
import tink.web.proxy.Remote;

/** Represents a CouchDB server. **/
class Server implements Model {

	/** The list of features supported by this server. **/
	@:constant var features: List<String> = @byDefault new List();

	/** The Git revision. **/
	@:constant var gitSha: String = @byDefault "";

	/** The server URL, including username and password if required. **/
	@:constant var url: Url;

	/** The server identifier. **/
	@:constant var uuid: String = @byDefault "";

	/** The vendor name. **/
	@:constant var vendor: String = @byDefault "";

	/** The version number. **/
	@:constant var version: String = @byDefault "";

	/** The list of all databases. **/
	public var databases(get, never): Promise<List<Database>>;
		function get_databases() return remote.databases()
			.next(names -> List.fromArray(names.map(name -> new Database({name: name, server: this}))));

	/** The binary content for the `favicon.ico` site icon. **/
	public var favicon(get, never): Promise<Chunk>;
		inline function get_favicon() return remote.favicon().next(IncomingResponse.readAll);

	/** Value indicating whether this server is up. **/
	public var isUp(get, never): Promise<Bool>;
		function get_isUp() return remote.isUp()
			.next(_ -> true)
			.tryRecover(error -> error.code == NotFound ? Success(false) : Failure(error));

	/** Returns information about the current session. **/
	public var session(get, never): Promise<Session>;
		function get_session() return new Session({server: this}).fetch();

	/** The list of active tasks. **/
	public var tasks(get, never): Promise<List<Task>>;
		function get_tasks() return remote.tasks().next(List.fromArray);

	/** The remote API client. **/
	@:editable private var remote: Remote<RemoteApi> = null;

	/** Creates a new server. **/
	public function new() remote = Web.connect((this.url: RemoteApi));

	/** Initiates a new session for the specified user credentials. **/
	public function authenticate(name: String, password: String) return new Session({server: this}).create(name, password);

	/** Returns an object for performing operations on a database. **/
	public function db(name: String) return new Database({name: name, server: this});

	/** Fetches information about this server. **/
	public function fetch() return remote.fetch().next(json -> new Server({
		features: json.features,
		gitSha: json.git_sha,
		url: url,
		uuid: json.uuid,
		vendor: json.vendor.name,
		version: json.version
	}));

	/** Requests one or more Universally Unique Identifiers (UUIDs) from this server. **/
	public function uuids(count = 1) return remote.uuids({count: count}).next(response -> List.fromArray(response.uuids));
}

/** Provides information about a server. **/
typedef ServerInfo = {

	/** A custom welcome message. **/
	var couchdb: String;

	/** The list of features supported by the server. **/
	var features: Array<String>;

	/** The Git revision. **/
	var git_sha: String;

	/** The server identifier. **/
	var uuid: String;

	/** Meta information about the vendor. **/
	var vendor: {name: String};

	/** The version number. **/
	var version: String;
}
