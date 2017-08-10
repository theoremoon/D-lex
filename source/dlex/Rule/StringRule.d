module dlex.Rule.StringRule;

import dlex.Rule;

class StringRule : Rule {
    public:
	Rule rule;

	this (dstring pattern) {
	    if (pattern.length == 0) {
		throw new Exception("");
	    }
	    if (pattern.length == 1) {
		rule = new CharRule(pattern[0]);
	    }
	    else {
		rule = new CharRule(pattern[0]);
		foreach (c; pattern[1..$]) {
		    rule = new SeqRule(rule, new CharRule(c));
		}
	    }
	}
	override MatchResult match(dstring source, ref Position pos) {
	    return rule.match(source, pos);
	}
}
