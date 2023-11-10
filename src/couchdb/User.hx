package couchdb;

/** Represents a CouchDB user. **/
@:jsonParse(json -> new couchdb.User(json))
class User implements Model {

	/** The user name. **/
	@:constant var name: String;

	/** The user roles. **/
	@:constant var roles: List<String> = @byDefault new List();
}

/** Provides information about a user. **/
typedef UserInfo = {

	/** The user name. **/
	var name: String;

	/** The user roles. **/
	var roles: Array<String>;
}
