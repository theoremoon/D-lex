module dlex.DLex;

import std.conv;
import std.array;
import std.typecons;
import std.algorithm;

import dlex.Position;
import dlex.MatchResult;
import dlex.Rule;

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

		struct Matched {
		    MatchResult result;
		    Position pos;
		    Type type;
		    bool skip;
		}
		while (!pos.end(source)) {
		    Matched[] rs = [];
		    foreach (rule; rules) {
			auto savePos = pos;
			MatchResult r = rule.rule.matched(source, savePos);
			if (r && r.str.length > 0) { // 0文字でマッチし得る
			    rs ~= Matched(r, savePos, rule.type, rule.rule.skip); 
			}
		    }
		    if (rs.length == 0) {
			break;
		    }


		    // 最長一致なので最長のMatchResultを採用する
		    // 同じ長さならより早く見つけた（先に登録した）方を優先する
		    auto result = rs.reduce!((a,b) => (
				(a.result.str.length >= b.result.str.length) ? a : b
				));

		    if (!result.skip) {
			results ~= new LexResult(result.type, result.result.str, pos);
		    }
		    pos = result.pos;
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

