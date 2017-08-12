module dlex.Rule.SeqRule;

import dlex.Rule;

class SeqRule : Rule {
    public:
	Rule prevRule;
	Rule postRule;

	this (Rule prevRule, Rule postRule) {
	    this.prevRule = prevRule;
	    this.postRule = postRule;
	}
	override MatchResult match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    auto prevMatch = prevRule.matched(source, pos);
	    if (! prevMatch) {
		return null;
	    }
	    auto postMatch = postRule.matched(source, pos);
	    if (! postMatch) {
		pos = prevPos;
		return null;
	    }
	    return new MatchResult(prevMatch.str ~ postMatch.str, prevPos);
	}
}
