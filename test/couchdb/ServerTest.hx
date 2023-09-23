package couchdb;

/** Tests the features of the `Server` class. **/
@:asserts final class ServerTest {

	/** The server instance. **/
	final server = new Server("http://localhost:5984");

	/** Creates a new test. **/
	public function new() {}

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
}
