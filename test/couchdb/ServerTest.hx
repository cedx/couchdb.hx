package couchdb;

using AssertionTools;
using Lambda;

/** Tests the features of the `Server` class. **/
@:asserts final class ServerTest {

	/** The server instance. **/
	final server = new Server('http://${Sys.getEnv("COUCHDB_USER")}:${Sys.getEnv("COUCHDB_PASSWORD")}@localhost:5984');

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
		final isCI = Sys.getEnv("GITHUB_ACTIONS") == "true";
		final promise = isCI ? asserts.rejects(NotFound, server.favicon) : asserts.doesNotReject(server.favicon);
		promise.handle(asserts.handle);
		return asserts;
	}

	/** Tests the `info` property. **/
	public function info() {
		server.info.next(info -> {
			asserts.assert(info.features.length > 0);
			asserts.assert(~/[a-z\d]{9}/.match(info.gitSha));
			asserts.assert(~/[a-z\d]{32}/.match(info.uuid));
			asserts.assert(info.vendor == "The Apache Software Foundation");
			asserts.assert(info.version.split(".").shift() == "3");
		}).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `isUp` property. **/
	public function isUp() {
		server.isUp.next(isUp -> asserts.assert(isUp)).handle(asserts.handle);
		return asserts;
	}

	/** Tests the `use()` method. **/
	public function use()
		return assert(server.use("foo").name == "foo");
}
