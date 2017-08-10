module dlex.Rule;

public import dlex.MatchResult,
       dlex.Position;

abstract class Rule {
    public:
	MatchResult match(dstring source, ref Position pos);
}

public import dlex.Rule.StringRule,
       dlex.Rule.PredicateRule,
       dlex.Rule.SeqRule,
       dlex.Rule.SelectRule,
       dlex.Rule.RepeatRule;

