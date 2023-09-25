package couchdb;

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
}
