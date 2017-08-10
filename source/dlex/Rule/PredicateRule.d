module dlex.Rule.PredicateRule;

import dlex.Rule;

import std.conv;

class PredicateRule : Rule {
    public:
	alias PredT = bool function(dchar);
	PredT pred;
	this (PredT pred) {
	    this.pred = pred;
	}
	override MatchResult match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    if (source.length <= pos.p) {
		return null;
	    }
	    if (pred(source[pos.p])) {
		pos.p += 1;
		return new MatchResult(source[prevPos.p].to!dstring, prevPos);
	    }
	    return null;
	}
}
