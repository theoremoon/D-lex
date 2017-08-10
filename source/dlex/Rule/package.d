module dlex.Rule;

public import dlex.MatchResult,
       dlex.Position;

abstract class Rule {
    public:
	MatchResult match(dstring source, ref Position pos);

	Rule opBinary(string op)(Rule rhs) {
	    static if (op == "+") {
		return new SeqRule(this, rhs);
	    }
	    else {
		static assert(0, "operator " ~ op ~ " not implemented");
	    }
	}

}

public import dlex.Rule.CharRule,
       dlex.Rule.StringRule,
       dlex.Rule.PredicateRule,
       dlex.Rule.SeqRule,
       dlex.Rule.SelectRule,
       dlex.Rule.RepeatRule;

