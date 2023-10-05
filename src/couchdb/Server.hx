package couchdb;

import tink.Chunk;
import tink.Url;
import tink.Web;
import tink.web.proxy.Remote;
using haxe.io.Path;

/** Provides access to a CouchDB server. **/
class Server {

	/** The list of all databases. **/
	public var databases(get, never): Promise<Array<Database>>;
		function get_databases() return remote.databases()
			.next(names -> names.map(name -> new Database(name, this)));

	/** The binary content for the `favicon.ico` site icon. **/
	public var favicon(get, never): Promise<Chunk>;
		inline function get_favicon() return remote.favicon();

	/** Meta information about the server instance. **/
	public var info(get, never): Promise<ServerInfo>;
		inline function get_info() return remote.info();

	/** Value indicating whether this server is up. **/
	public var isUp(get, never): Promise<Bool>;
		function get_isUp() return remote.isUp()
			.next(_ -> true)
			.tryRecover(error -> error.code == NotFound ? Success(false) : Failure(error));

	/** The server URL. **/
	public final url: Url;

	/** The remote API client. **/
	@:allow(couchdb) final remote: Remote<RemoteApi>;

	/** Creates a new server. **/
	public function new(url: Url) {
		this.url = url.toString().addTrailingSlash();
		remote = Web.connect((this.url: RemoteApi));
	}

	/** Returns a database object that allows you to perform operations against that database. **/
	public inline function use(database: String) return new Database(database, this);

	/** Requests one or more Universally Unique Identifiers (UUIDs) from this server. **/
	public function uuids(count = 1) return remote.uuids({count: count}).next(response -> response.uuids);
}

/** Provides meta information about a server instance. **/
@:jsonParse(json -> couchdb.Server.ServerInfo.fromJson(json))
class ServerInfo implements Model {

	/** The list of features supported by the server. **/
	@:constant var features: List<String>;

	/** The Git revision. **/
	@:constant var gitSha: String;

	/** The server identifier. **/
	@:constant var uuid: String;

	/** The vendor name. **/
	@:constant var vendor: String;

	/** The version number. **/
	@:constant var version: String;

	/** Creates a new server from the specified JSON object. **/
	public static function fromJson(json: ServerInfoResponse) return new ServerInfo({
		features: json.features,
		gitSha: json.git_sha,
		uuid: json.uuid,
		vendor: json.vendor.name,
		version: json.version
	});
}

/** Provides meta information about a server instance. **/
private typedef ServerInfoResponse = {

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
