package couchdb;

import tink.http.Client;
using AssertionTools;

/** Tests the features of the `Document` class. **/
@:asserts final class DocumentTest {

	/** The database instance. **/
	final database = new Server({url: 'http://${Sys.getEnv("COUCHDB_USER")}:${Sys.getEnv("COUCHDB_PASSWORD")}@localhost:5984/'}).database("test");

	/** Creates a new test. **/
	public function new() {}

	/** Method invoked after each test. **/
	@:after public function after() return Client.fetch(database.url, {method: DELETE}).noise();

	/** Method invoked before each test. **/
	@:before public function before() return Client.fetch(database.url, {method: PUT}).noise();

	/** Tests the `url` property. **/
	@:variant("foo")
	@:variant("bar")
	public function url(input: String)
		return assert(new Document({database: database, id: input}).url == '${database.url}/$input');
}
