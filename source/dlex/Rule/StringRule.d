module dlex.Rule.StringRule;

import dlex.Rule;
class StringRule : Rule {
    public:
	dstring pattern;

	this (dstring pattern) {
	    this.pattern = pattern;
	}
	override MatchResult match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    if (source.length <= pos.p) {
		return null;
	    }
	    if (source[pos.p..$] == this.pattern) {
		pos.p += this.pattern.length;
		return new MatchResult(this.pattern, prevPos);
	    }
	    return null;
	}
}
