package couchdb;

/** Represents a document list. **/
@:jsonParse(couchdb.DocumentList.fromJson)
class DocumentList<Key, Value, Record> implements Model {

	/** The list of row objects. **/
	@:constant var items: List<DocumentListItem<Key, Value, Record>> = @byDefault new List();

	/** The number of row objects. **/
	@:computed var length: Int = items.length;

	/** The offset where the document list started. **/
	@:constant var offset: Int = @byDefault 0;

	/** The total number of documents in the database or view. **/
	@:constant var totalCount: Int = @byDefault 0;

	/** Creates a new task from the specified JSON object. **/
	public static function fromJson<Key, Value, Record>(json: DocumentListData<Key, Value, Record>) return new DocumentList({
		items: json.rows.map(DocumentListItem.new),
		offset: json.offset,
		totalCount: json.total_rows
	});
}

/** Defines the data of a document list. **/
typedef DocumentListData<Key, Value, Record> = {

	/** The offset where the document list started. **/
	var ?offset: Int;

	/** The list of row objects. **/
	var rows: Array<DocumentListItemData<Key, Value, Record>>;

	/** The number of documents in the database or view. **/
	var ?total_rows: Int;
}

/** Represents a row of a document list. **/
@:jsonParse(json -> new couchdb.DocumentList.DocumentListItem(json))
class DocumentListItem<Key, Value, Record> implements Model {

	/** The document. **/
	@:constant var doc: Null<Record> = @byDefault null;

	/** The document identifier. **/
	@:constant var id: String;

	/** The row key. **/
	@:constant var key: Key;

	/** The row value. **/
	@:constant var value: Value;
}

/** Defines the data of a document list item. **/
typedef DocumentListItemData<Key, Value, Record> = {

	/** The document. **/
	var ?doc: Record;

	/** The document identifier. **/
	var id: String;

	/** The row key. **/
	var key: Key;

	/** The row value. **/
	var value: Value;
}
