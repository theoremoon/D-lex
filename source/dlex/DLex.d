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
			MatchResult r = rule.rule.match(source, savePos);
			if (r) {
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

unittest {
    enum Type {
	Ident,
	Number,
	Space,
	Symbol,
    }

    import std.uni;

    auto dlex = new DLex!(Type);
    dlex.Rules([
            dlex.RuleT(Type.Ident, Pred(&isAlpha) + Pred(&isAlphaNum).Repeat),
            dlex.RuleT(Type.Number, Pred(&isNumber).Repeat),
            dlex.RuleT(Type.Space, Pred(&isSpace).Skip),
    ]);
    auto rs = dlex.Lex("Int 123");

    assert(rs.length == 2);
    assert(rs[0].str == "Int");
    assert(rs[0].pos.col == 1);
    assert(rs[1].str == "123");
    assert(rs[1].pos.col == 5);

    dlex.Rules([
	    dlex.RuleT(Type.Symbol, Char('>')),
	    dlex.RuleT(Type.Symbol, Char('<')),
	    dlex.RuleT(Type.Symbol, String(">>")),
	    dlex.RuleT(Type.Symbol, String("<<")),
	    dlex.RuleT(Type.Space, Pred(&isSpace).Skip),
    ]);
    rs = dlex.Lex("> > >><>><>");
    assert(rs.length == 7);
    assert(rs[0].str == ">");
    assert(rs[1].str == ">");
    assert(rs[2].str == ">>");
    assert(rs[3].str == "<");
    assert(rs[4].str == ">>");
    assert(rs[5].str == "<");
    assert(rs[6].str == ">");
}


unittest {
    import std.uni, std.string;
    enum Type {
	Space,
	Newline,
	Number,
	Identifier,
	String,
	Symbol,
    }
    auto dlex = new DLex!(Type);
    dlex.Rules([
	    dlex.RuleT(Type.Space, Select(Char(' '), Char('\t')).Skip),
	    dlex.RuleT(Type.Newline, Select(Char('\n'), Char(';')).Repeat),
	    dlex.RuleT(Type.Number, Pred(&isNumber).Repeat),
	    dlex.RuleT(Type.Identifier, Pred((c) => (c == '_' || c.isAlpha))+Pred((c) => (c == '_' || c.isAlphaNum)).Repeat),
	    dlex.RuleT(Type.String, Char('"')+Pred((c) => c != '"').Repeat+Char('"')),
	    dlex.RuleT(Type.Symbol, Char('=')),
	    dlex.RuleT(Type.Symbol, Char('+')),
	    dlex.RuleT(Type.Symbol, Char('<')),
	    dlex.RuleT(Type.Symbol, String("+=")),
	    dlex.RuleT(Type.Symbol, Char('{')),
	    dlex.RuleT(Type.Symbol, Char('}')),
	    dlex.RuleT(Type.Symbol, Char('(')),
	    dlex.RuleT(Type.Symbol, Char(')')),
    ]);
    auto rs = dlex.Lex(`
	    int main() {
		int num = 1;
		print("Start");
		while (num < 10) {
		    print(num);
		    num += 1;
		}
	    }
    `d.strip);

    assert(rs[0].type == Type.Identifier);
    assert(rs[0].str == "int");
    assert(rs[2].type == Type.Symbol);
    assert(rs[2].str == "(");
    assert(rs[4].type == Type.Symbol);
    assert(rs[4].str == "{");
    assert(rs[5].type == Type.Newline);
    assert(rs[5].str == "\n");
    assert(rs[8].type == Type.Symbol);
    assert(rs[8].str == "=");
    assert(rs[9].type == Type.Number);
    assert(rs[9].str == "1");
    assert(rs[10].type == Type.Newline);
    assert(rs[10].str == ";\n");
    assert(rs[13].type == Type.String);
    assert(rs[13].str == "\"Start\"");
    assert(rs[30].type == Type.Symbol);
    assert(rs[30].str == "+=");
}
