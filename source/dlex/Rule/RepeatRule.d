module dlex.Rule.RepeatRule;

import dlex.Rule;

class RepeatRule : Rule {
    public:
	Rule rule;

	this (Rule rule) {
	    this.rule = rule;
	}

	override MatchResult match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    dstring str = "";
	    while (true) {
		auto match = rule.match(source, pos);
		if (! match) {
		    break;
		}
		str ~= match.str;
	    }
	    if (str.length == 0) {
		return null;
	    }
	    return new MatchResult(str, prevPos);
	}
}
