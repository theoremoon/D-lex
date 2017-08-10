module dlex.DLex;

enum Type {
    Int
}

class DLex {
    public:
	Rule rule;
	this (Rule rule) {
	    this.rule = rule;
	}

	Result Lex(string source) {
	    Result r = rule.match(source);
	    if (! r) {
		return null;
	    }

	    return r;
	}
}
class Rule {
    public:
	Type type;
	string pattern;

	this (Type type, string pattern) {
	    this.type = type;
	    this.pattern = pattern;
	}

	Result match(string source) {
	    if (source == pattern) {
		return new Result(type, source);
	    }
	    return null;
	}
}
class Result {
    public:
	Type type;
	string str;

	this (Type type, string str) {
	    this.type = type;
	    this.str = str;
	}
}

unittest {
    auto dlex = new DLex(new Rule(Type.Int, "Int"));
    Result res = dlex.Lex("Int");

    assert (res !is null);
    assert (res.type == Type.Int);
    assert (res.str == "Int");
}

