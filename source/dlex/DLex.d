module dlex.DLex;

import std.conv;

import dlex.Position;
import dlex.MatchResult;
import dlex.Rule;


enum Type {
    Int
}

struct RuleT {
    Type type;
    Rule rule;
}
class DLex {
    public:

	RuleT rule;
	this (RuleT rule) {
	    this.rule = rule;
	}

	LexResult Lex(dstring source) {
	    Position pos;
	    MatchResult r = rule.rule.match(source, pos);
	    if (! r) {
		return null;
	    }

	    return new LexResult(rule.type, r.str, r.pos);
	}
}
class LexResult {
    public:
	Type type;
	dstring str;
	Position pos;

	this (Type type, dstring str, Position pos) {
	    this.type = type;
	    this.str = str;
	    this.pos = pos;
	}
}

unittest {
    import std.uni;

    auto dlex = new DLex(RuleT(Type.Int, new SelectRule([new StringRule("If"), new PredicateRule(&isAlpha)])));
    LexResult res = dlex.Lex("Int");

    assert (res !is null);
    assert (res.type == Type.Int);
    assert (res.str == "I");
    assert (res.pos.p == 0);
}

