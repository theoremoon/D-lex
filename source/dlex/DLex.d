module dlex.DLex;

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
    auto dlex = new DLex(new StringRule(Type.Int, "Int"));
    Result res = dlex.Lex("Int");

    assert (res !is null);
    assert (res.type == Type.Int);
    assert (res.str == "Int");
    assert (res.pos.p == 0);
}

