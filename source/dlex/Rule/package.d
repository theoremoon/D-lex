module dlex.Rule;

public import dlex.MatchResult,
       dlex.Position;

abstract class Rule {
    public:
	bool skip = false;
	alias MatchFuncT = MatchResult delegate(MatchResult, dstring, ref Position);
	MatchFuncT matchfunc; 
	this() {
	    matchfunc = null;
	}

	MatchResult match(dstring source, ref Position pos);
	MatchResult match2(dstring source, ref Position pos) {
	    auto r = match(source, pos);
	    if (matchfunc) {
		auto save = pos;
		auto r2 = matchfunc(r, source, pos);
		if (r2) {
		    return r2;
		}
		pos = save;
	    }
	    return r;
	}

	Rule opBinary(string op)(Rule rhs) {
	    static if (op == "+") {
		return new SeqRule(this, rhs);
	    }
	    else static if (op == "|") {
		return new SelectRule([this, rhs]);
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

	Rule Then(MatchFuncT f) {
	    matchfunc = f;
	    return this;
	}
}

auto Any() {
    return new AnyRule;
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

public import dlex.Rule.AnyRule,
       dlex.Rule.CharRule,
       dlex.Rule.StringRule,
       dlex.Rule.PredicateRule,
       dlex.Rule.SeqRule,
       dlex.Rule.SelectRule,
       dlex.Rule.RepeatRule;

