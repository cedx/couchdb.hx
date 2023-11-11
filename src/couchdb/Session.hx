package couchdb;

import couchdb.User.UserInfo;
import tink.Web;

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
	@:constant var user: User;

	/** The remote API client. **/
	var remote(get, never): Remote<RemoteApi>;
		inline function get_remote() return @:privateAccess server.remote;

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
		user: new User({name: json.userCtx.name, roles: json.userCtx.roles})
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
