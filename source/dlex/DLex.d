module dlex.DLex;

import std.conv;


enum Type {
    Int
}

struct Position { // for copy constructor
    public:
	int p = 0;
	int col = 0;
	int row = 0;
}

class DLex {
    public:
	struct RuleT {
	    Type type;
	    Rule rule;
	}

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
abstract class Rule {
    public:
	MatchResult match(dstring source, ref Position pos);
}
class StringRule : Rule {
    public:
	dstring pattern;

	this (dstring pattern) {
	    this.pattern = pattern;
	}
	override MatchResult match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    if (source[pos.p..$] == this.pattern) {
		pos.p += this.pattern.length;
		return new MatchResult(this.pattern, prevPos);
	    }
	    return null;
	}
}
class PredicateRule : Rule {
    public:
	alias PredT = bool function(dchar);
	PredT pred;
	this (PredT pred) {
	    this.pred = pred;
	}
	override MatchResult match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    if (pred(source[pos.p])) {
		pos.p += 1;
		return new MatchResult(source[prevPos.p].to!dstring, prevPos);
	    }
	    return null;
	}
}
class MatchResult {
    public:
	dstring str;
	Position pos;

	this (dstring str, Position pos) {
	    this.str = str;
	    this.pos = pos;
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

    auto dlex = new DLex(DLex.RuleT(Type.Int, new PredicateRule(&isAlpha)));
    LexResult res = dlex.Lex("Int");

    assert (res !is null);
    assert (res.type == Type.Int);
    assert (res.str == "I");
    assert (res.pos.p == 0);
}

