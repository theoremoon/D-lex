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
		auto r = rule.matched(source, pos);
		if (! r) {
		    break;
		}
		str ~= r.str;
	    }
	    // 0こにもマッチ
	    if (str.length == 0) {
		return new MatchResult("", prevPos);
	    }
	    return new MatchResult(str, prevPos);
	}
}
