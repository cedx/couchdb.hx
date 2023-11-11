package couchdb;

/** Represents an attachment. **/
typedef Attachment = {

	/** The media type. **/
	var content_type: String;

	/** The Base64-encoded content. **/
	var ?data: String;

	/** The content hash digest. **/
	var digest: String;

	/** The compressed file size, in bytes. **/
	var ?encoded_length: Int;

	/** The compression codec. **/
	var ?encoding: String;

	/** Value indicating whether the content is provided in the subsequent MIME bodies. **/
	var ?follows: Bool;

	/** The file size, in bytes. **/
	var ?length: Int;

	/** The revision where this attachment exists. **/
	var revpos: Int;

	/** Value indicating whether this attachment is a stub. **/
	var ?stub: Bool;
}
