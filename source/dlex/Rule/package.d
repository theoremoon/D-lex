module dlex.Rule;

public import dlex.MatchResult,
       dlex.Position;

abstract class Rule {
    public:
	bool skip = false;
	MatchResult match(dstring source, ref Position pos);

	Rule opBinary(string op)(Rule rhs) {
	    static if (op == "+") {
		return new SeqRule(this, rhs);
	    }
	    else {
		static assert(0, "operator " ~ op ~ " not implemented");
	    }
	}

	Rule Repeat() {
	    return new RepeatRule(this);
	}

	Rule Skip() {
	    this.skip = true;
	    return this;
	}
}

auto Char(dchar c) {
    return new CharRule(c);
}
auto String(dstring str) {
    return new StringRule(str);
}
auto Pred(bool function(dchar) pred) {
    return new PredicateRule(pred); 
}
auto Select(Rule[] rules ...) {
    return new SelectRule(rules);
}

public import dlex.Rule.CharRule,
       dlex.Rule.StringRule,
       dlex.Rule.PredicateRule,
       dlex.Rule.SeqRule,
       dlex.Rule.SelectRule,
       dlex.Rule.RepeatRule;

