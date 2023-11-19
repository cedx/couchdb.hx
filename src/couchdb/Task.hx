package couchdb;

/** Represents a CouchDB task. **/
@:jsonParse(couchdb.Task.fromJson)
class Task implements Model {

	/** The number of processed changes. **/
	@:constant var changesDone: Int = @byDefault 0;

	/** The name of the source database. **/
	@:constant var database: String;

	/** The process identifier. **/
	@:constant var pid: String;

	/** The current percentage progress. **/
	@:constant var progress: Int = @byDefault 0;

	/** The date of of the task start time. **/
	@:constant var startedOn: Date;

	/** The total number of changes to process. **/
	@:constant var totalChanges: Int = @byDefault 0;

	/** The operation type. **/
	@:constant var type: TaskType;

	/** The date of the last operation update. **/
	@:constant var updatedOn: Date;

	/** Creates a new task from the specified JSON object. **/
	public static function fromJson(json: TaskInfo) return new Task({
		changesDone: json.changes_done,
		database: json.database,
		pid: json.pid,
		progress: json.progress,
		startedOn: Date.fromTime(json.started_on * 1_000),
		totalChanges: json.total_changes,
		type: json.type,
		updatedOn: Date.fromTime(json.updated_on * 1_000)
	});
}

/** Provides information about a task. **/
typedef TaskInfo = {

	/** The number of processed changes. **/
	var changes_done: Int;

	/** The name of the source database. **/
	var database: String;

	/** The process identifier. **/
	var pid: String;

	/** The current percentage progress. **/
	var progress: Int;

	/** The Unix timestamp of the task start time. **/
	var started_on: Int;

	/** The total number of changes to process. **/
	var total_changes: Int;

	/** The operation type. **/
	var type: String;

	/** The Unix timestamp of the last operation update. **/
	var updated_on: Int;
}

/** Defines the type of a task. **/
enum abstract TaskType(String) from String to String {

	/** A database compaction task. **/
	var DatabaseCompaction = "database_compaction";

	/** An indexation task. **/
	var Indexer = "indexer";

	/** A replication task. **/
	var Replication = "replication";

	/** A view compaction task. **/
	var ViewCompaction = "view_compaction";
}
