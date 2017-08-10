module dlex.Position;

struct Position { // for copy constructor
    public:
	int p = 0;
	int col = 1;
	int row = 1;

	bool end(dstring src) {
	    return p >= src.length;
	}
	void count(dchar c) {
	    p++;
	    col++;
	    if (c == '\n') {
		col = 0;
		row++;
	    }
	}
	dchar next(dstring src) {
	    if (p >= src.length) {
		return cast(dchar)65535; // EOF ?
	    }
	    dchar nextChar = src[p];
	    count(nextChar);
	    return nextChar;
	}
}
