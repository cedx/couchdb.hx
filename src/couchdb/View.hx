package couchdb;

import tink.Url;
using haxe.io.Path;

/** Represents a CouchDB view. **/
class View implements Model {

	/** The associated design document. **/
	@:constant var design: DesignDocument;

	/** The view key. **/
	@:constant var key: String;

	/** The view URL. **/
	@:computed var url: Url = Url.parse(design.url.toString().addTrailingSlash()).resolve('_view/$key');
}

/** Defines the query parameters of a view. **/
typedef ViewOptions = Query & {

	/** Value indicating whether to return the documents in descending order. **/
	var ?descending: Bool;

	/** Stops returning records when the specified key is reached. **/
	var ?endkey: Any;

	/** Value indicating whether to group the results using the reduce function to a group or single row. **/
	var ?group: Bool;

	/** The group level to be used. **/
	var ?group_level: Int;

	/** Value indicating whether to include the associated document with each row. **/
	var ?include_docs: Bool;

	/** Value indicating whether the specified end key should be included in the result. **/
	var ?inclusive_end: Bool;

	/** Returns only documents that match the specified key. **/
	var ?key: Any;

	/** Returns only documents where the key matches one of the keys specified in the array. **/
	var ?keys: Array<Any>;

	/** The maximum number of documents to return. **/
	var ?limit: Int;

	/** Value indicating whether to use the reduction function. **/
	var ?reduce: Bool;

	/** The number of records to skip before starting to return the results. **/
	var ?skip: Int;

	/** Returns records starting with the specified key. **/
	var ?startkey: Any;
}
