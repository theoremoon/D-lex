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
	    if (pos.end(source)) {
		return null;
	    }
	    auto next = pos.next(source);
	    if (pred(next)) {
		return new MatchResult(next.to!dstring, prevPos);
	    }
	    pos = prevPos;
	    return null;
	}
}
