package couchdb;

import tink.http.Fetch;
using AssertionTools;

/** Tests the features of the `Database` class. **/
@:asserts final class DatabaseTest {

	/** The server instance. **/
	final server = new Server('http://${Sys.getEnv("COUCHDB_USER")}:${Sys.getEnv("COUCHDB_PASSWORD")}@localhost:5984');

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `exists` property. **/
	public function exists() {
		Promise.inParallel([server.use("_users").exists, server.use("foo").exists]).next(exists -> {
			asserts.assert(exists[0]);
			asserts.assert(!exists[1]);
		}).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `create()` method. **/
	public function create() {
		final database = server.use("test");
		database.exists
			.next(exists -> { asserts.assert(!exists); asserts.doesNotReject(database.create()); })
			.next(_ -> database.exists)
			.next(exists -> { asserts.assert(exists); database.delete(); })
			.handle(asserts.handle);

		return asserts;
	}

	/** Tests the `delete()` method. **/
	public function delete() {
		final database = server.use("test");
		database.create()
			.next(_ -> database.exists)
			.next(exists -> { asserts.assert(exists); asserts.doesNotReject(database.delete()); })
			.next(_ -> database.exists)
			.next(exists -> asserts.assert(!exists))
			.handle(asserts.handle);

		return asserts;
	}
}
