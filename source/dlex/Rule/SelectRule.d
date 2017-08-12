module dlex.Rule.SelectRule;

import dlex.Rule;

class SelectRule : Rule {
    public:
	Rule[] rules;

	this (Rule[] rules) {
	    this.rules = rules;
	}

	override MatchResult match(dstring source, ref Position pos) {
	    foreach (rule; rules) {
		auto prevPos = pos;
		auto result = rule.matched(source, pos);
		if (result) {
		    return result;
		}
		pos = prevPos;
	    }
	    return null;
	}
}
