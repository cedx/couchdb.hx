package couchdb;

using AssertionTools;

/** Tests the features of the `Session` class. **/
@:asserts final class SessionTest {

	/** The server instance. **/
	final server = new Server({url: 'http://${Sys.getEnv("COUCHDB_USER")}:${Sys.getEnv("COUCHDB_PASSWORD")}@localhost:5984/'});

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `create()` method. **/
	public function create() {
		final session = new Session({server: server});
		final userName = Sys.getEnv("COUCHDB_USER");

		asserts.rejects(Unauthorized, session.create("foo", "bar"))
			.next(_ -> session.create(userName, Sys.getEnv("COUCHDB_PASSWORD")))
			.next(newSession -> {
				asserts.assert(newSession.token.length > 60);
				asserts.assert(newSession.user.name == userName);
				asserts.assert(newSession.user.roles.exists(role -> role == "_admin"));
			})
			.handle(asserts.handle);

		return asserts;
	}

	/** Tests the `delete()` method. **/
	public function delete() {
		asserts.doesNotReject(() -> new Session({server: server}).delete()).handle(asserts.handle);
		return asserts;
	}

	/** Tests the `fetch()` method. **/
	public function fetch() {
		new Session({server: server}).fetch().next(session -> {
			asserts.assert(session.handlers.exists(handler -> handler == "default"));
			asserts.assert(session.user.name == Sys.getEnv("COUCHDB_USER"));
		}).handle(asserts.handle);

		return asserts;
	}
}
