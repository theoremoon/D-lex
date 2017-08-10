module dlex.MatchResult;

import dlex.Position;

class MatchResult {
    public:
	dstring str;
	Position pos;

	this (dstring str, Position pos) {
	    this.str = str;
	    this.pos = pos;
	}
}
