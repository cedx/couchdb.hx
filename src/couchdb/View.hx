package couchdb;

import haxe.Json;
import tink.QueryString;
import tink.Url;
import tink.http.Client;
import tink.web.proxy.Remote;
using StringTools;

/** Represents a CouchDB view. **/
class View implements Model {

	/** The associated design document. **/
	@:constant var design: DesignDocument;

	/** The view name. **/
	@:constant var name: String;

	/** The view URL. **/
	@:computed var url: Url = '${design.url}/_view/${name.urlEncode()}';

	/** The remote API client. **/
	var remote(get, never): Remote<RemoteApi>;
		inline function get_remote() return @:privateAccess design.db.server.remote;

	/** Queries this view. **/
	public function query<Key, Value, Doc>(?options: ViewOptions): Promise<DocumentList<Key, Value, Doc>> {
		final query = QueryString.build(options);
		return Client.fetch('$url?$query').all().next(response -> DocumentList.fromJson(Json.parse(response.body)));
	}
}

/** Defines the query parameters of a view. **/
typedef ViewOptions = Query & {

	/** Value indicating whether to include conflicts information in response. **/
	var ?conflicts: Bool;

	/** Value indicating whether to return the documents in descending order. **/
	var ?descending: Bool;

	/** Stops returning records when the specified key is reached. **/
	var ?endkey: Any;

	/** Stops returning records when the specified document identifier is reached. **/
	var ?endkey_docid: String;

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

	/** Returns records starting with the specified document identifier. **/
	var ?startkey_docid: String;

	/** Value indicating whether the view should be updated prior to responding to the user. **/
	var ?update: ViewUpdate;
}

/** Defines how a view should be updated prior to responding to the user. **/
enum abstract ViewUpdate(String) from String to String {

	/** The view should not be updated. **/
	var False = "false";

	/** The view should be lazily updated. **/
	var Lazy = "lazy";

	/** The view should be updated. **/
	var True = "true";
}
