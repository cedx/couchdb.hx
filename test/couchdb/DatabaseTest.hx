package couchdb;

import tink.http.Client;
using AssertionTools;

/** Tests the features of the `Database` class. **/
@:asserts final class DatabaseTest {

	/** The server instance. **/
	final server = new Server({url: 'http://${Sys.getEnv("COUCHDB_USER")}:${Sys.getEnv("COUCHDB_PASSWORD")}@localhost:5984'});

	/** Creates a new test. **/
	public function new() {}

	/** This method is invoked after each test. **/
	@:after public function after() return Client.fetch(server.url.resolve("test"), {method: DELETE}).noise();

	/** Tests the `exists` property. **/
	public function exists() {
		Promise.inParallel([server.use("_users").exists, server.use("foo").exists]).next(exists -> {
			asserts.assert(exists[0]);
			asserts.assert(!exists[1]);
		}).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `url` property. **/
	@:variant("foo")
	@:variant("bar")
	public function url(input: String)
		return assert(new Database({name: input, server: server}).url == '${server.url}/$input');

	/** Tests the `create()` method. **/
	public function create() {
		final database = server.use("test");
		database.exists
			.next(exists -> { asserts.assert(!exists); asserts.doesNotReject(database.create()); })
			.next(_ -> database.exists)
			.next(exists -> asserts.assert(exists))
			.handle(asserts.handle);

		return asserts;
	}

	/** Tests the `delete()` method. **/
	public function delete() {
		final database = server.use("test");
		Client.fetch(server.url.resolve("test"), {method: PUT})
			.next(_ -> database.exists)
			.next(exists -> { asserts.assert(exists); asserts.doesNotReject(database.delete()); })
			.next(_ -> database.exists)
			.next(exists -> asserts.assert(!exists))
			.handle(asserts.handle);

		return asserts;
	}
}
