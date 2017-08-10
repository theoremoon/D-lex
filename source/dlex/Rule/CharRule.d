module dlex.Rule.CharRule;

import dlex.Rule;
import std.conv;

class CharRule : Rule {
    public:
	dchar c;
	this (dchar c) {
	    this.c = c;
	}

	override MatchResult match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    if (pos.end(source)) {
		return null;
	    }
	    auto next = pos.next(source);
	    if (next == c) {
		return new MatchResult(next.to!dstring, prevPos);
	    }
	    return null;
	}
}
