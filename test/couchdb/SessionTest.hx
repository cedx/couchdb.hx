package couchdb;

using AssertionTools;

/** Tests the features of the `Session` class. **/
@:asserts final class SessionTest {

	/** The server instance. **/
	final server = new Server({url: 'http://${Sys.getEnv("COUCHDB_USER")}:${Sys.getEnv("COUCHDB_PASSWORD")}@localhost:5984'});

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `create()` method. **/
	public function create() {
		final userName = Sys.getEnv("COUCHDB_USER");
		asserts.rejects(Unauthorized, server.authenticate("foo", "bar"))
			.next(_ -> server.authenticate(userName, Sys.getEnv("COUCHDB_PASSWORD")))
			.next(session -> {
				asserts.assert(session.token.length > 60);
				asserts.assert(session.user.name == userName);
				asserts.assert(session.user.roles.exists(role -> role == "_admin"));
			})
			.handle(asserts.handle);

		return asserts;
	}
}
