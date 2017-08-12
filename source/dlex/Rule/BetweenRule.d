module dlex.Rule.BetweenRule;

import dlex.Rule;

class BetweenRule : Rule {
    public:
	Rule beginRule;
	Rule endRule;
	Rule innerRule;
	this (Rule beginRule, Rule endRule, Rule innerRule) {
	    this.beginRule = beginRule;
	    this.endRule = endRule;
	    this.innerRule = innerRule;
	}

	override MatchResult match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    
	    // begin がマッチ
	    auto beginR = beginRule.matched(source, pos);
	    if (!beginR) {
		pos = prevPos;
		return null;
	    }
	    auto str = beginR.str;

	    while (true) {
		auto save = pos;
		// end がマッチしたら返る
		auto endR = endRule.matched(source, pos);
		if (endR) {
		    str ~= endR.str;
		    break;
		}
		pos = save;

		// innerがマッチしなかったらそもそもダメ
		auto innerR = innerRule.matched(source, pos);
		if (! innerR) {
		    pos = prevPos;
		    return null;
		}
		str ~= innerR.str;
	    }
	    return new MatchResult(str, prevPos);
	}
}
