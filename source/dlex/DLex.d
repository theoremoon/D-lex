module dlex.DLex;

import std.conv;
import std.typecons;
import std.algorithm;

import dlex.Position;
import dlex.MatchResult;
import dlex.Rule;

enum Type {
    Int
}


template DLex(Type) {
    class DLex {
	public:
	    struct RuleT {
		Type type;
		Rule rule;
	    }

	    RuleT[] rules;
	    
	    void Rules(RuleT[] rules) {
		this.rules = rules;
	    }

	    auto Lex(dstring source) {
		Position pos;
		LexResult[] results = [];

		while (!pos.end(source)) {
		    Tuple!(MatchResult, Position, Type)[] rs = [];
		    foreach (rule; rules) {
			auto savePos = pos;
			MatchResult r = rule.rule.match(source, savePos);
			if (r) {
			    rs ~= tuple(r, savePos, rule.type); 
			}
		    }
		    if (rs.length == 0) {
			break;
		    }

		    // 最長一致なので最長のMatchResultを採用する
		    // 同じ長さならより早く見つけた（先に登録した）方を優先する
		    auto result = rs.reduce!((a,b) => (
				(a[0].str.length >= b[0].str.length) ? a : b
				));

		    results ~= new LexResult(result[2], result[0].str, pos);
		    pos = result[1];
		}

		return results;
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
}

unittest {
    import std.uni;

    auto dlex = new DLex!(Type);
    dlex.Rules([
	    dlex.RuleT(Type.Int, Char('I') + Pred(&isAlpha).Repeat)
    ]);
    auto res = dlex.Lex("Int");

    assert (res.length == 1);
    assert (res[0].type == Type.Int);
    assert (res[0].str == "Int");
    assert (res[0].pos.p == 0);
}

