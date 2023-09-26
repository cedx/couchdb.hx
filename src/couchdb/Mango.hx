package couchdb;

import haxe.DynamicAccess;
import haxe.extern.EitherType;

/** Represents a Mango selector. **/
typedef Selector = DynamicAccess<EitherType<String, {

}>>;
