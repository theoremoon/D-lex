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
	Rule rule;
	this (Rule rule) {
	    this.rule = rule;
	}

	Result Lex(dstring source) {
	    Position pos;
	    Result r = rule.match(source, pos);
	    if (! r) {
		return null;
	    }

	    return r;
	}
}
abstract class Rule {
    public:
	Type type;
	this (Type type) {
	    this.type = type;
	}

	Result match(dstring source, ref Position pos);
}
class StringRule : Rule {
    public:
	dstring pattern;

	this (Type type, dstring pattern) {
	    super(type);
	    this.pattern = pattern;
	}
	override Result match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    if (source[pos.p..$] == this.pattern) {
		pos.p += this.pattern.length;
		return new Result(type, this.pattern, prevPos);
	    }
	    return null;
	}
}
class PredicateRule : Rule {
    public:
	alias PredT = bool function(dchar);
	PredT pred;
	this (Type type, PredT pred) {
	    super(type);
	    this.pred = pred;
	}
	override Result match(dstring source, ref Position pos) {
	    auto prevPos = pos;
	    if (pred(source[pos.p])) {
		pos.p += 1;
		return new Result(type, source[prevPos.p].to!dstring, prevPos);
	    }
	    return null;
	}
}
class Result {
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

    auto dlex = new DLex(new PredicateRule(Type.Int, &isAlpha));
    Result res = dlex.Lex("Int");

    assert (res !is null);
    assert (res.type == Type.Int);
    assert (res.str == "I");
    assert (res.pos.p == 0);
}

