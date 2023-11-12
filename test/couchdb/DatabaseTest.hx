package couchdb;

import tink.http.Client;
using AssertionTools;

/** Tests the features of the `Database` class. **/
@:asserts final class DatabaseTest {

	/** The database instance. **/
	final database: Database;

	/** The server instance. **/
	final server = new Server({url: 'http://${Sys.getEnv("COUCHDB_USER")}:${Sys.getEnv("COUCHDB_PASSWORD")}@localhost:5984'});

	/** Creates a new test. **/
	public function new() database = server.db("test");

	/** Method invoked after each test. **/
	@:after public function after() return Client.fetch(database.url, {method: DELETE}).noise();

	/** Tests the `exists` property. **/
	@:variant("_users", true)
	@:variant("foo", false)
	public function exists(input: String, output: Bool) {
		new Database({name: input, server: server}).exists.next(exists -> asserts.assert(exists == output)).handle(asserts.handle);
		return asserts;
	}

	/** Tests the `url` property. **/
	@:variant("foo")
	@:variant("bar")
	public function url(input: String)
		return assert(new Database({name: input, server: server}).url == '${server.url}/$input');

	/** Tests the `create()` method. **/
	public function create() {
		database.exists
			.next(exists -> { asserts.assert(!exists); asserts.doesNotReject(database.create()); })
			.next(_ -> database.exists)
			.next(exists -> asserts.assert(exists))
			.handle(asserts.handle);

		return asserts;
	}

	/** Tests the `delete()` method. **/
	public function delete() {
		Client.fetch(database.url, {method: PUT})
			.next(_ -> database.exists)
			.next(exists -> { asserts.assert(exists); asserts.doesNotReject(database.delete()); })
			.next(_ -> database.exists)
			.next(exists -> asserts.assert(!exists))
			.handle(asserts.handle);

		return asserts;
	}

	/** Tests the `design()` method. **/
	public function design() return assert(database.design("foo").id == "_design/foo");

	/** Tests the `document()` method. **/
	public function document() return assert(database.document("foo").id == "foo");

	/** Tests the `local()` method. **/
	public function local() return assert(database.local("foo").id == "_local/foo");
}
