package couchdb;

using AssertionTools;

/** Tests the features of the `Server` class. **/
@:asserts final class ServerTest {

	/** The server instance. **/
	final server = new Server({url: 'http://${Sys.getEnv("COUCHDB_USER")}:${Sys.getEnv("COUCHDB_PASSWORD")}@localhost:5984'});

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `databases` property. **/
	public function databases() {
		server.databases.next(databases -> {
			asserts.assert(databases.exists(db -> db.name == "_replicator"));
			asserts.assert(databases.exists(db -> db.name == "_users"));
		}).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `favicon` property. **/
	public function favicon() {
		asserts.doesNotReject(server.favicon).handle(asserts.handle);
		return asserts;
	}

	/** Tests the `isUp` property. **/
	public function isUp() {
		server.isUp.next(isUp -> asserts.assert(isUp)).handle(asserts.handle);
		return asserts;
	}

	/** Tests the `session()` property. **/
	public function session() {
		server.session.next(session -> {
			asserts.assert(session.handlers.exists(handler -> handler == "default"));
			asserts.assert(session.user.name == Sys.getEnv("COUCHDB_USER"));
		}).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `authenticate()` method. **/
	public function authenticate() {
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

	/** Tests the `fetch()` method. **/
	public function fetch() {
		server.fetch().next(info -> {
			asserts.assert(info.features.length > 0);
			asserts.assert(~/[a-z\d]{9}/.match(info.gitSha));
			asserts.assert(~/[a-z\d]{32}/.match(info.uuid));
			asserts.assert(info.vendor == "The Apache Software Foundation");
			asserts.assert(info.version.split(".").shift() == "3");
		}).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `use()` method. **/
	public function use() return assert(server.use("foo").name == "foo");

	/** Tests the `uuids()` method. **/
	public function uuids() {
		Promise.inParallel([server.uuids(), server.uuids(3)]).next(uuids -> {
			asserts.assert(uuids[0].length == 1);
			asserts.assert(uuids[1].length == 3);
			asserts.assert(~/[a-z\d]{32}/.match(uuids[0].first().sure()));
		}).handle(asserts.handle);

		return asserts;
	}
}
