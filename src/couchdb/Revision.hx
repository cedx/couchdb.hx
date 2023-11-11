package couchdb;

/** Defines the status of a revision. **/
enum abstract RevisionStatus(String) from String to String {

	/** The revision is available. **/
	var Available = "available";

	/** The revision was deleted. **/
	var Deleted = "deleted";

	/** The revision is missing. **/
	var Missing = "missing";
}
