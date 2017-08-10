# D-Lex

Lexical analyzer implemented by D-lang.

```
   ___--^^^^^^^
  /       o
 /
 vvvvvvvv
        </
      </      ___/
  ^^^^^   ___/
  \______/

```

this is 

＿人人人人＿

＞　T-rex　＜

￣Y^Y^Y^Y^￣

## Usage

See unittest in source/dlex/DLex.d.

```d
    enum Type {
	Ident,
	Number,
	Space
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
```

