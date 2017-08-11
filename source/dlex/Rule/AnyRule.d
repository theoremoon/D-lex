module dlex.Rule.AnyRule;

import dlex.Rule;
import std.conv;

class AnyRule : Rule {
    public:
	override MatchResult match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    if (pos.end(source)) {
		return null;
	    }
	    auto next = pos.next(source);
	    return new MatchResult(next.to!dstring, prevPos);
	}
}
