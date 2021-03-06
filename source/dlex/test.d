module dlex.test;

import dlex;

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
            dlex.RuleT(Type.Symbol, Any),
    ]);
    auto rs = dlex.Lex("Int 123 *");

    assert(rs.length == 3);
    assert(rs[0].str == "Int");
    assert(rs[0].pos.col == 1);
    assert(rs[1].str == "123");
    assert(rs[1].pos.col == 5);
    assert(rs[2].str == "*");
    assert(rs[2].pos.col == 9);

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
	    dlex.RuleT(Type.Space, (Char(' ') | Char('\t')).Skip),
	    dlex.RuleT(Type.Newline, (Char('\n') | Char(';')).Repeat),
	    dlex.RuleT(Type.Number, Pred(&isNumber).Repeat),
	    dlex.RuleT(Type.Identifier, Pred((c) => (c == '_' || c.isAlpha))+Pred((c) => (c == '_' || c.isAlphaNum)).Repeat),
	    dlex.RuleT(Type.String, Between(Char('"'), Char('"'), String(`\"`).As((dstring s) => `"`d)|Any).As((dstring s) => s[1..$-1])),
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
    int i = 1;
    print("Start\"");
    while (i < 10) {
	print(i);
	i += 1;
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
    assert(rs[13].str == "Start\"");
    assert(rs[13].pos.line == 3);
    assert(rs[13].pos.col == 10);
    assert(rs[30].type == Type.Symbol);
    assert(rs[30].str == "+=");
}

unittest {
    enum Type {
	Ident,
	Number,
	Space,
	Symbol,
    }

    import std.uni;
    import std.exception;

    auto dlex = new DLex!(Type);
    dlex.Rules([
            dlex.RuleT(Type.Ident, Pred(&isAlpha) + Pred(&isAlphaNum).Repeat),
            dlex.RuleT(Type.Number, Pred(&isNumber).Repeat),
            dlex.RuleT(Type.Space, Pred(&isSpace).Skip),
    ]);
    assertThrown(dlex.Lex("Int 123 *"));

}
