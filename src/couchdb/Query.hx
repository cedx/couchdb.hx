package couchdb;

/** Defines the base parameters of a query. **/
typedef Query = {

	/** Value indicating whether to retrieve the content of all attached files. **/
	var ?attachments: Bool;

	/** Value indicating whether to retrieve information on the size of compressed attachments and the codec used. **/
	var ?att_encoding_info: Bool;
}
