package couchdb;

import couchdb.User.UserInfo;
import haxe.io.Mime;
import tink.Chunk;
import tink.Json;
import tink.Url;
import tink.Web;
import tink.http.Client;
import tink.http.Fetch.FetchOptions;
import tink.http.Header.HeaderField;
import tink.web.proxy.Remote;
using haxe.io.Path;

/** Represents a CouchDB session. **/
class Session implements Model {

	/** The enabled authentication handlers. **/
	@:constant var handlers: List<SessionHandler> = @byDefault new List();

	/** The handler used to initiate this session. **/
	@:constant var method: Null<SessionHandler> = @byDefault null;

	/** The associated server. **/
	@:constant var server: Server;

	/** The authorization token. **/
	@:constant var token: String = @byDefault "";

	/** The session user. **/
	@:constant var user: Null<User> = @byDefault null;

	/** The remote API client. **/
	var remote(get, never): Remote<RemoteApi>;
		inline function get_remote() return @:privateAccess server.remote;

	/** Initiates a new session for the specified user credentials. **/
	public function create(name: String, password: String) {
		final body: Chunk = Json.stringify({name: name, password: password});
		final options: FetchOptions = {
			method: POST,
			headers: [new HeaderField(CONTENT_LENGTH, body.length), new HeaderField(CONTENT_TYPE, Mime.ApplicationJson)],
			body: body
		};

		final url = Url.parse(server.url.toString().addTrailingSlash()).resolve("_session");
		return Client.fetch(url, options).all().next(response -> switch response.header.byName(SET_COOKIE) {
			case Failure(error): Failure(error);
			case Success(header):
				final cookie = (header: String).split(";").shift();
				@:privateAccess server.remote = Web.connect((server.url: RemoteApi), {headers: [new HeaderField(COOKIE, cookie)]});
				new Session({server: server, token: cookie.split("=").pop(), user: (Json.parse(response.body): User)});
		});
	}

	/** Deletes this session. **/
	public function delete() return remote.session().delete().next(_ -> {
		@:privateAccess server.remote = Web.connect((server.url: RemoteApi));
		Noise;
	});

	/** Fetches information about this session. **/
	public function fetch() return remote.session().fetch().next(json -> new Session({
		handlers: json.info.authentication_handlers,
		method: json.info.authenticated,
		server: server,
		token: token,
		user: json.userCtx.name == null ? null : new User({name: json.userCtx.name, roles: json.userCtx.roles})
	}));
}

/** Provides the list of supported authentication handlers. **/
enum abstract SessionHandler(String) from String to String {

	/** Basic authentication. **/
	var Basic = "default";

	/** Cookie authentication. **/
	var Cookie = "cookie";
}

/** Provides information about a user session. **/
typedef SessionInfo = {

	/** The server authentication configuration. **/
	var info: {?authenticated: String, authentication_handlers: Array<String>};

	/** The user context for the current user. **/
	var userCtx: UserInfo;
}
