// Generated from GOALspec.g4 by ANTLR 4.0
package musa.goalspec;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class GOALspecLexer extends Lexer {
	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		APOSTROPHE=1, PLUS=2, MINUS=3, STAR=4, SLASH=5, BACKSLASH=6, CARET=7, 
		TILDE=8, COLON=9, DOT=10, QMARK=11, HASH=12, DOLLAR=13, AMP=14, DIGIT=15, 
		Is=16, GOAL=17, SOCIAL=18, WHERE=19, SHALL_ADDRESS=20, AND=21, OR=22, 
		NOT=23, ON=24, AFTER=25, WHEN=26, SINCE=27, THE_SYSTEM=28, THE=29, ROLE=30, 
		COMMA=31, MESSAGE=32, RECEIVED_FROM=33, SENT_TO=34, ROUND_LEFT=35, ROUND_RIGHT=36, 
		SQUARE_LEFT=37, SQUARE_RIGHT=38, LOWERCASE_LETTER=39, UPPERCASE_LETTER=40, 
		D=41, M=42, P=43, Y=44, POSITIVEDIGIT=45, WS=46;
	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] tokenNames = {
		"<INVALID>",
		"'''", "'+'", "'-'", "'*'", "'/'", "'\\'", "'^'", "'~'", "':'", "'.'", 
		"'?'", "'#'", "'$'", "'&'", "DIGIT", "'IS'", "'GOAL'", "'SOCIAL'", "'WHERE'", 
		"'SHALL ADDRESS'", "'AND'", "'OR'", "'NOT'", "'ON'", "'AFTER'", "'WHEN'", 
		"'SINCE'", "'THE SYSTEM'", "'THE'", "'ROLE'", "','", "'MESSAGE'", "'RECEIVED FROM'", 
		"'SENT TO'", "'('", "')'", "'['", "']'", "LOWERCASE_LETTER", "UPPERCASE_LETTER", 
		"'D'", "'M'", "'P'", "'Y'", "POSITIVEDIGIT", "WS"
	};
	public static final String[] ruleNames = {
		"APOSTROPHE", "PLUS", "MINUS", "STAR", "SLASH", "BACKSLASH", "CARET", 
		"TILDE", "COLON", "DOT", "QMARK", "HASH", "DOLLAR", "AMP", "DIGIT", "Is", 
		"GOAL", "SOCIAL", "WHERE", "SHALL_ADDRESS", "AND", "OR", "NOT", "ON", 
		"AFTER", "WHEN", "SINCE", "THE_SYSTEM", "THE", "ROLE", "COMMA", "MESSAGE", 
		"RECEIVED_FROM", "SENT_TO", "ROUND_LEFT", "ROUND_RIGHT", "SQUARE_LEFT", 
		"SQUARE_RIGHT", "LOWERCASE_LETTER", "UPPERCASE_LETTER", "D", "M", "P", 
		"Y", "POSITIVEDIGIT", "WS"
	};


	public GOALspecLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "GOALspec.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	@Override
	public void action(RuleContext _localctx, int ruleIndex, int actionIndex) {
		switch (ruleIndex) {
		case 45: WS_action((RuleContext)_localctx, actionIndex); break;
		}
	}
	private void WS_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 0: skip();  break;
		}
	}

	public static final String _serializedATN =
		"\2\4\60\u011b\b\1\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b"+
		"\t\b\4\t\t\t\4\n\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20"+
		"\t\20\4\21\t\21\4\22\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27"+
		"\t\27\4\30\t\30\4\31\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36"+
		"\t\36\4\37\t\37\4 \t \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4"+
		"(\t(\4)\t)\4*\t*\4+\t+\4,\t,\4-\t-\4.\t.\4/\t/\3\2\3\2\3\3\3\3\3\4\3\4"+
		"\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\f\3\f\3\r"+
		"\3\r\3\16\3\16\3\17\3\17\3\20\3\20\5\20~\n\20\3\21\3\21\3\21\3\22\3\22"+
		"\3\22\3\22\3\22\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\24\3\24\3\24\3\24"+
		"\3\24\3\24\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\3\26\3\26\3\26\3\26\3\27\3\27\3\27\3\30\3\30\3\30\3\30\3\31"+
		"\3\31\3\31\3\32\3\32\3\32\3\32\3\32\3\32\3\33\3\33\3\33\3\33\3\33\3\34"+
		"\3\34\3\34\3\34\3\34\3\34\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35"+
		"\3\35\3\35\3\36\3\36\3\36\3\36\3\37\3\37\3\37\3\37\3\37\3 \3 \3!\3!\3"+
		"!\3!\3!\3!\3!\3!\3\"\3\"\3\"\3\"\3\"\3\"\3\"\3\"\3\"\3\"\3\"\3\"\3\"\3"+
		"\"\3#\3#\3#\3#\3#\3#\3#\3#\3$\3$\3%\3%\3&\3&\3\'\3\'\3(\3(\3)\3)\3)\3"+
		")\3)\3)\3)\3)\3)\5)\u0109\n)\3*\3*\3+\3+\3,\3,\3-\3-\3.\3.\3/\6/\u0116"+
		"\n/\r/\16/\u0117\3/\3/\2\60\3\3\1\5\4\1\7\5\1\t\6\1\13\7\1\r\b\1\17\t"+
		"\1\21\n\1\23\13\1\25\f\1\27\r\1\31\16\1\33\17\1\35\20\1\37\21\1!\22\1"+
		"#\23\1%\24\1\'\25\1)\26\1+\27\1-\30\1/\31\1\61\32\1\63\33\1\65\34\1\67"+
		"\35\19\36\1;\37\1= \1?!\1A\"\1C#\1E$\1G%\1I&\1K\'\1M(\1O)\1Q*\1S+\1U,"+
		"\1W-\1Y.\1[/\1]\60\2\3\2\4\4\\\\aa\5\13\f\17\17\"\"\u0124\2\3\3\2\2\2"+
		"\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2"+
		"\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2"+
		"\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2"+
		"\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2"+
		"\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2"+
		"\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2"+
		"\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2W"+
		"\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\3_\3\2\2\2\5a\3\2\2\2\7c\3\2"+
		"\2\2\te\3\2\2\2\13g\3\2\2\2\ri\3\2\2\2\17k\3\2\2\2\21m\3\2\2\2\23o\3\2"+
		"\2\2\25q\3\2\2\2\27s\3\2\2\2\31u\3\2\2\2\33w\3\2\2\2\35y\3\2\2\2\37}\3"+
		"\2\2\2!\177\3\2\2\2#\u0082\3\2\2\2%\u0087\3\2\2\2\'\u008e\3\2\2\2)\u0094"+
		"\3\2\2\2+\u00a2\3\2\2\2-\u00a6\3\2\2\2/\u00a9\3\2\2\2\61\u00ad\3\2\2\2"+
		"\63\u00b0\3\2\2\2\65\u00b6\3\2\2\2\67\u00bb\3\2\2\29\u00c1\3\2\2\2;\u00cc"+
		"\3\2\2\2=\u00d0\3\2\2\2?\u00d5\3\2\2\2A\u00d7\3\2\2\2C\u00df\3\2\2\2E"+
		"\u00ed\3\2\2\2G\u00f5\3\2\2\2I\u00f7\3\2\2\2K\u00f9\3\2\2\2M\u00fb\3\2"+
		"\2\2O\u00fd\3\2\2\2Q\u0108\3\2\2\2S\u010a\3\2\2\2U\u010c\3\2\2\2W\u010e"+
		"\3\2\2\2Y\u0110\3\2\2\2[\u0112\3\2\2\2]\u0115\3\2\2\2_`\7)\2\2`\4\3\2"+
		"\2\2ab\7-\2\2b\6\3\2\2\2cd\7/\2\2d\b\3\2\2\2ef\7,\2\2f\n\3\2\2\2gh\7\61"+
		"\2\2h\f\3\2\2\2ij\7^\2\2j\16\3\2\2\2kl\7`\2\2l\20\3\2\2\2mn\7\u0080\2"+
		"\2n\22\3\2\2\2op\7<\2\2p\24\3\2\2\2qr\7\60\2\2r\26\3\2\2\2st\7A\2\2t\30"+
		"\3\2\2\2uv\7%\2\2v\32\3\2\2\2wx\7&\2\2x\34\3\2\2\2yz\7(\2\2z\36\3\2\2"+
		"\2{~\7\62\2\2|~\5[.\2}{\3\2\2\2}|\3\2\2\2~ \3\2\2\2\177\u0080\7K\2\2\u0080"+
		"\u0081\7U\2\2\u0081\"\3\2\2\2\u0082\u0083\7I\2\2\u0083\u0084\7Q\2\2\u0084"+
		"\u0085\7C\2\2\u0085\u0086\7N\2\2\u0086$\3\2\2\2\u0087\u0088\7U\2\2\u0088"+
		"\u0089\7Q\2\2\u0089\u008a\7E\2\2\u008a\u008b\7K\2\2\u008b\u008c\7C\2\2"+
		"\u008c\u008d\7N\2\2\u008d&\3\2\2\2\u008e\u008f\7Y\2\2\u008f\u0090\7J\2"+
		"\2\u0090\u0091\7G\2\2\u0091\u0092\7T\2\2\u0092\u0093\7G\2\2\u0093(\3\2"+
		"\2\2\u0094\u0095\7U\2\2\u0095\u0096\7J\2\2\u0096\u0097\7C\2\2\u0097\u0098"+
		"\7N\2\2\u0098\u0099\7N\2\2\u0099\u009a\7\"\2\2\u009a\u009b\7C\2\2\u009b"+
		"\u009c\7F\2\2\u009c\u009d\7F\2\2\u009d\u009e\7T\2\2\u009e\u009f\7G\2\2"+
		"\u009f\u00a0\7U\2\2\u00a0\u00a1\7U\2\2\u00a1*\3\2\2\2\u00a2\u00a3\7C\2"+
		"\2\u00a3\u00a4\7P\2\2\u00a4\u00a5\7F\2\2\u00a5,\3\2\2\2\u00a6\u00a7\7"+
		"Q\2\2\u00a7\u00a8\7T\2\2\u00a8.\3\2\2\2\u00a9\u00aa\7P\2\2\u00aa\u00ab"+
		"\7Q\2\2\u00ab\u00ac\7V\2\2\u00ac\60\3\2\2\2\u00ad\u00ae\7Q\2\2\u00ae\u00af"+
		"\7P\2\2\u00af\62\3\2\2\2\u00b0\u00b1\7C\2\2\u00b1\u00b2\7H\2\2\u00b2\u00b3"+
		"\7V\2\2\u00b3\u00b4\7G\2\2\u00b4\u00b5\7T\2\2\u00b5\64\3\2\2\2\u00b6\u00b7"+
		"\7Y\2\2\u00b7\u00b8\7J\2\2\u00b8\u00b9\7G\2\2\u00b9\u00ba\7P\2\2\u00ba"+
		"\66\3\2\2\2\u00bb\u00bc\7U\2\2\u00bc\u00bd\7K\2\2\u00bd\u00be\7P\2\2\u00be"+
		"\u00bf\7E\2\2\u00bf\u00c0\7G\2\2\u00c08\3\2\2\2\u00c1\u00c2\7V\2\2\u00c2"+
		"\u00c3\7J\2\2\u00c3\u00c4\7G\2\2\u00c4\u00c5\7\"\2\2\u00c5\u00c6\7U\2"+
		"\2\u00c6\u00c7\7[\2\2\u00c7\u00c8\7U\2\2\u00c8\u00c9\7V\2\2\u00c9\u00ca"+
		"\7G\2\2\u00ca\u00cb\7O\2\2\u00cb:\3\2\2\2\u00cc\u00cd\7V\2\2\u00cd\u00ce"+
		"\7J\2\2\u00ce\u00cf\7G\2\2\u00cf<\3\2\2\2\u00d0\u00d1\7T\2\2\u00d1\u00d2"+
		"\7Q\2\2\u00d2\u00d3\7N\2\2\u00d3\u00d4\7G\2\2\u00d4>\3\2\2\2\u00d5\u00d6"+
		"\7.\2\2\u00d6@\3\2\2\2\u00d7\u00d8\7O\2\2\u00d8\u00d9\7G\2\2\u00d9\u00da"+
		"\7U\2\2\u00da\u00db\7U\2\2\u00db\u00dc\7C\2\2\u00dc\u00dd\7I\2\2\u00dd"+
		"\u00de\7G\2\2\u00deB\3\2\2\2\u00df\u00e0\7T\2\2\u00e0\u00e1\7G\2\2\u00e1"+
		"\u00e2\7E\2\2\u00e2\u00e3\7G\2\2\u00e3\u00e4\7K\2\2\u00e4\u00e5\7X\2\2"+
		"\u00e5\u00e6\7G\2\2\u00e6\u00e7\7F\2\2\u00e7\u00e8\7\"\2\2\u00e8\u00e9"+
		"\7H\2\2\u00e9\u00ea\7T\2\2\u00ea\u00eb\7Q\2\2\u00eb\u00ec\7O\2\2\u00ec"+
		"D\3\2\2\2\u00ed\u00ee\7U\2\2\u00ee\u00ef\7G\2\2\u00ef\u00f0\7P\2\2\u00f0"+
		"\u00f1\7V\2\2\u00f1\u00f2\7\"\2\2\u00f2\u00f3\7V\2\2\u00f3\u00f4\7Q\2"+
		"\2\u00f4F\3\2\2\2\u00f5\u00f6\7*\2\2\u00f6H\3\2\2\2\u00f7\u00f8\7+\2\2"+
		"\u00f8J\3\2\2\2\u00f9\u00fa\7]\2\2\u00faL\3\2\2\2\u00fb\u00fc\7_\2\2\u00fc"+
		"N\3\2\2\2\u00fd\u00fe\4c|\2\u00feP\3\2\2\2\u00ff\u0109\4CE\2\u0100\u0109"+
		"\5S*\2\u0101\u0109\4GN\2\u0102\u0109\5U+\2\u0103\u0109\4PQ\2\u0104\u0109"+
		"\5W,\2\u0105\u0109\4SZ\2\u0106\u0109\5Y-\2\u0107\u0109\t\2\2\2\u0108\u00ff"+
		"\3\2\2\2\u0108\u0100\3\2\2\2\u0108\u0101\3\2\2\2\u0108\u0102\3\2\2\2\u0108"+
		"\u0103\3\2\2\2\u0108\u0104\3\2\2\2\u0108\u0105\3\2\2\2\u0108\u0106\3\2"+
		"\2\2\u0108\u0107\3\2\2\2\u0109R\3\2\2\2\u010a\u010b\7F\2\2\u010bT\3\2"+
		"\2\2\u010c\u010d\7O\2\2\u010dV\3\2\2\2\u010e\u010f\7R\2\2\u010fX\3\2\2"+
		"\2\u0110\u0111\7[\2\2\u0111Z\3\2\2\2\u0112\u0113\4\63;\2\u0113\\\3\2\2"+
		"\2\u0114\u0116\t\3\2\2\u0115\u0114\3\2\2\2\u0116\u0117\3\2\2\2\u0117\u0115"+
		"\3\2\2\2\u0117\u0118\3\2\2\2\u0118\u0119\3\2\2\2\u0119\u011a\b/\2\2\u011a"+
		"^\3\2\2\2\6\2}\u0108\u0117";
	public static final ATN _ATN =
		ATNSimulator.deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
	}
}