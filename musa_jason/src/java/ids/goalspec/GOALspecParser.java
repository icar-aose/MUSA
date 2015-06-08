// Generated from GOALspec.g4 by ANTLR 4.0
package ids.goalspec;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class GOALspecParser extends Parser {
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
	public static final String[] tokenNames = {
		"<INVALID>", "'''", "'+'", "'-'", "'*'", "'/'", "'\\'", "'^'", "'~'", 
		"':'", "'.'", "'?'", "'#'", "'$'", "'&'", "DIGIT", "'IS'", "'GOAL'", "'SOCIAL'", 
		"'WHERE'", "'SHALL ADDRESS'", "'AND'", "'OR'", "'NOT'", "'ON'", "'AFTER'", 
		"'WHEN'", "'SINCE'", "'THE SYSTEM'", "'THE'", "'ROLE'", "','", "'MESSAGE'", 
		"'RECEIVED FROM'", "'SENT TO'", "'('", "')'", "'['", "']'", "LOWERCASE_LETTER", 
		"UPPERCASE_LETTER", "'D'", "'M'", "'P'", "'Y'", "POSITIVEDIGIT", "WS"
	};
	public static final int
		RULE_specification = 0, RULE_goal_list = 1, RULE_goal_type = 2, RULE_social_goal = 3, 
		RULE_system_goal = 4, RULE_goal_name = 5, RULE_social_goal_content = 6, 
		RULE_system_goal_content = 7, RULE_trigger_condition = 8, RULE_final_state = 9, 
		RULE_where_clause = 10, RULE_item_descriptions = 11, RULE_item_description = 12, 
		RULE_data = 13, RULE_data_item = 14, RULE_event = 15, RULE_state = 16, 
		RULE_message_sent_state = 17, RULE_message_received_state = 18, RULE_msgActor = 19, 
		RULE_actors_list = 20, RULE_actor = 21, RULE_predicate = 22, RULE_term_list = 23, 
		RULE_term = 24, RULE_structure = 25, RULE_atom = 26, RULE_list = 27, RULE_numeral = 28, 
		RULE_variable = 29, RULE_string = 30, RULE_characters = 31, RULE_character = 32, 
		RULE_digits = 33, RULE_special = 34;
	public static final String[] ruleNames = {
		"specification", "goal_list", "goal_type", "social_goal", "system_goal", 
		"goal_name", "social_goal_content", "system_goal_content", "trigger_condition", 
		"final_state", "where_clause", "item_descriptions", "item_description", 
		"data", "data_item", "event", "state", "message_sent_state", "message_received_state", 
		"msgActor", "actors_list", "actor", "predicate", "term_list", "term", 
		"structure", "atom", "list", "numeral", "variable", "string", "characters", 
		"character", "digits", "special"
	};

	@Override
	public String getGrammarFileName() { return "GOALspec.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public GOALspecParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class SpecificationContext extends ParserRuleContext {
		public Goal_listContext goal_list() {
			return getRuleContext(Goal_listContext.class,0);
		}
		public SpecificationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_specification; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSpecification(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSpecification(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSpecification(this);
			else return visitor.visitChildren(this);
		}
	}

	public final SpecificationContext specification() throws RecognitionException {
		SpecificationContext _localctx = new SpecificationContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_specification);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(70); goal_list(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Goal_listContext extends ParserRuleContext {
		public int _p;
		public Goal_listContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Goal_listContext(ParserRuleContext parent, int invokingState, int _p) {
			super(parent, invokingState);
			this._p = _p;
		}
		@Override public int getRuleIndex() { return RULE_goal_list; }
	 
		public Goal_listContext() { }
		public void copyFrom(Goal_listContext ctx) {
			super.copyFrom(ctx);
			this._p = ctx._p;
		}
	}
	public static class Many_goal_listContext extends Goal_listContext {
		public Goal_typeContext goal_type() {
			return getRuleContext(Goal_typeContext.class,0);
		}
		public Goal_listContext goal_list() {
			return getRuleContext(Goal_listContext.class,0);
		}
		public Many_goal_listContext(Goal_listContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterMany_goal_list(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitMany_goal_list(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitMany_goal_list(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class Single_goal_listContext extends Goal_listContext {
		public Goal_typeContext goal_type() {
			return getRuleContext(Goal_typeContext.class,0);
		}
		public Single_goal_listContext(Goal_listContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSingle_goal_list(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSingle_goal_list(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSingle_goal_list(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Goal_listContext goal_list(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		Goal_listContext _localctx = new Goal_listContext(_ctx, _parentState, _p);
		Goal_listContext _prevctx = _localctx;
		int _startState = 2;
		enterRecursionRule(_localctx, RULE_goal_list);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			_localctx = new Single_goal_listContext(_localctx);
			_ctx = _localctx;
			_prevctx = _localctx;

			setState(73); goal_type();
			}
			_ctx.stop = _input.LT(-1);
			setState(79);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,0,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new Many_goal_listContext(new Goal_listContext(_parentctx, _parentState, _p));
					pushNewRecursionContext(_localctx, _startState, RULE_goal_list);
					setState(75);
					if (!(1 >= _localctx._p)) throw new FailedPredicateException(this, "1 >= $_p");
					setState(76); goal_type();
					}
					} 
				}
				setState(81);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,0,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class Goal_typeContext extends ParserRuleContext {
		public Social_goalContext social_goal() {
			return getRuleContext(Social_goalContext.class,0);
		}
		public System_goalContext system_goal() {
			return getRuleContext(System_goalContext.class,0);
		}
		public Goal_typeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_goal_type; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterGoal_type(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitGoal_type(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitGoal_type(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Goal_typeContext goal_type() throws RecognitionException {
		Goal_typeContext _localctx = new Goal_typeContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_goal_type);
		try {
			setState(84);
			switch (_input.LA(1)) {
			case SOCIAL:
				enterOuterAlt(_localctx, 1);
				{
				setState(82); social_goal();
				}
				break;
			case GOAL:
				enterOuterAlt(_localctx, 2);
				{
				setState(83); system_goal();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Social_goalContext extends ParserRuleContext {
		public TerminalNode COLON() { return getToken(GOALspecParser.COLON, 0); }
		public TerminalNode SOCIAL() { return getToken(GOALspecParser.SOCIAL, 0); }
		public Goal_nameContext goal_name() {
			return getRuleContext(Goal_nameContext.class,0);
		}
		public Social_goal_contentContext social_goal_content() {
			return getRuleContext(Social_goal_contentContext.class,0);
		}
		public TerminalNode GOAL() { return getToken(GOALspecParser.GOAL, 0); }
		public Social_goalContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_social_goal; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSocial_goal(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSocial_goal(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSocial_goal(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Social_goalContext social_goal() throws RecognitionException {
		Social_goalContext _localctx = new Social_goalContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_social_goal);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(86); match(SOCIAL);
			setState(87); match(GOAL);
			setState(88); goal_name();
			setState(89); match(COLON);
			setState(90); social_goal_content();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class System_goalContext extends ParserRuleContext {
		public TerminalNode COLON() { return getToken(GOALspecParser.COLON, 0); }
		public System_goal_contentContext system_goal_content() {
			return getRuleContext(System_goal_contentContext.class,0);
		}
		public Goal_nameContext goal_name() {
			return getRuleContext(Goal_nameContext.class,0);
		}
		public TerminalNode GOAL() { return getToken(GOALspecParser.GOAL, 0); }
		public System_goalContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_system_goal; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSystem_goal(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSystem_goal(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSystem_goal(this);
			else return visitor.visitChildren(this);
		}
	}

	public final System_goalContext system_goal() throws RecognitionException {
		System_goalContext _localctx = new System_goalContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_system_goal);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(92); match(GOAL);
			setState(93); goal_name();
			setState(94); match(COLON);
			setState(95); system_goal_content();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Goal_nameContext extends ParserRuleContext {
		public CharactersContext characters() {
			return getRuleContext(CharactersContext.class,0);
		}
		public Goal_nameContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_goal_name; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterGoal_name(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitGoal_name(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitGoal_name(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Goal_nameContext goal_name() throws RecognitionException {
		Goal_nameContext _localctx = new Goal_nameContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_goal_name);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(97); characters();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Social_goal_contentContext extends ParserRuleContext {
		public Final_stateContext final_state() {
			return getRuleContext(Final_stateContext.class,0);
		}
		public TerminalNode SHALL_ADDRESS() { return getToken(GOALspecParser.SHALL_ADDRESS, 0); }
		public Where_clauseContext where_clause() {
			return getRuleContext(Where_clauseContext.class,0);
		}
		public Actors_listContext actors_list() {
			return getRuleContext(Actors_listContext.class,0);
		}
		public Trigger_conditionContext trigger_condition() {
			return getRuleContext(Trigger_conditionContext.class,0);
		}
		public Social_goal_contentContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_social_goal_content; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSocial_goal_content(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSocial_goal_content(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSocial_goal_content(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Social_goal_contentContext social_goal_content() throws RecognitionException {
		Social_goal_contentContext _localctx = new Social_goal_contentContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_social_goal_content);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(99); trigger_condition(0);
			setState(100); actors_list();
			setState(101); match(SHALL_ADDRESS);
			setState(102); final_state(0);
			setState(104);
			switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
			case 1:
				{
				setState(103); where_clause();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class System_goal_contentContext extends ParserRuleContext {
		public Final_stateContext final_state() {
			return getRuleContext(Final_stateContext.class,0);
		}
		public TerminalNode SHALL_ADDRESS() { return getToken(GOALspecParser.SHALL_ADDRESS, 0); }
		public Trigger_conditionContext trigger_condition() {
			return getRuleContext(Trigger_conditionContext.class,0);
		}
		public ActorContext actor() {
			return getRuleContext(ActorContext.class,0);
		}
		public System_goal_contentContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_system_goal_content; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSystem_goal_content(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSystem_goal_content(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSystem_goal_content(this);
			else return visitor.visitChildren(this);
		}
	}

	public final System_goal_contentContext system_goal_content() throws RecognitionException {
		System_goal_contentContext _localctx = new System_goal_contentContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_system_goal_content);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(106); trigger_condition(0);
			setState(107); actor();
			setState(108); match(SHALL_ADDRESS);
			setState(109); final_state(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Trigger_conditionContext extends ParserRuleContext {
		public int _p;
		public Trigger_conditionContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Trigger_conditionContext(ParserRuleContext parent, int invokingState, int _p) {
			super(parent, invokingState);
			this._p = _p;
		}
		@Override public int getRuleIndex() { return RULE_trigger_condition; }
	 
		public Trigger_conditionContext() { }
		public void copyFrom(Trigger_conditionContext ctx) {
			super.copyFrom(ctx);
			this._p = ctx._p;
		}
	}
	public static class Neg_conditionContext extends Trigger_conditionContext {
		public TerminalNode NOT() { return getToken(GOALspecParser.NOT, 0); }
		public Trigger_conditionContext trigger_condition() {
			return getRuleContext(Trigger_conditionContext.class,0);
		}
		public Neg_conditionContext(Trigger_conditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterNeg_condition(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitNeg_condition(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitNeg_condition(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class And_conditionContext extends Trigger_conditionContext {
		public Trigger_conditionContext trigger_condition(int i) {
			return getRuleContext(Trigger_conditionContext.class,i);
		}
		public TerminalNode AND() { return getToken(GOALspecParser.AND, 0); }
		public List<Trigger_conditionContext> trigger_condition() {
			return getRuleContexts(Trigger_conditionContext.class);
		}
		public And_conditionContext(Trigger_conditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterAnd_condition(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitAnd_condition(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitAnd_condition(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class Sub_conditionContext extends Trigger_conditionContext {
		public TerminalNode ROUND_LEFT() { return getToken(GOALspecParser.ROUND_LEFT, 0); }
		public TerminalNode ROUND_RIGHT() { return getToken(GOALspecParser.ROUND_RIGHT, 0); }
		public Trigger_conditionContext trigger_condition() {
			return getRuleContext(Trigger_conditionContext.class,0);
		}
		public Sub_conditionContext(Trigger_conditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSub_condition(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSub_condition(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSub_condition(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class Or_conditionContext extends Trigger_conditionContext {
		public Trigger_conditionContext trigger_condition(int i) {
			return getRuleContext(Trigger_conditionContext.class,i);
		}
		public List<Trigger_conditionContext> trigger_condition() {
			return getRuleContexts(Trigger_conditionContext.class);
		}
		public TerminalNode OR() { return getToken(GOALspecParser.OR, 0); }
		public Or_conditionContext(Trigger_conditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterOr_condition(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitOr_condition(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitOr_condition(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class Event_definitionContext extends Trigger_conditionContext {
		public EventContext event() {
			return getRuleContext(EventContext.class,0);
		}
		public Event_definitionContext(Trigger_conditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterEvent_definition(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitEvent_definition(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitEvent_definition(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Trigger_conditionContext trigger_condition(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		Trigger_conditionContext _localctx = new Trigger_conditionContext(_ctx, _parentState, _p);
		Trigger_conditionContext _prevctx = _localctx;
		int _startState = 16;
		enterRecursionRule(_localctx, RULE_trigger_condition);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(119);
			switch (_input.LA(1)) {
			case NOT:
				{
				_localctx = new Neg_conditionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(112); match(NOT);
				setState(113); trigger_condition(3);
				}
				break;
			case ROUND_LEFT:
				{
				_localctx = new Sub_conditionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(114); match(ROUND_LEFT);
				setState(115); trigger_condition(0);
				setState(116); match(ROUND_RIGHT);
				}
				break;
			case AFTER:
			case WHEN:
				{
				_localctx = new Event_definitionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(118); event();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(129);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(127);
					switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
					case 1:
						{
						_localctx = new And_conditionContext(new Trigger_conditionContext(_parentctx, _parentState, _p));
						pushNewRecursionContext(_localctx, _startState, RULE_trigger_condition);
						setState(121);
						if (!(5 >= _localctx._p)) throw new FailedPredicateException(this, "5 >= $_p");
						setState(122); match(AND);
						setState(123); trigger_condition(6);
						}
						break;

					case 2:
						{
						_localctx = new Or_conditionContext(new Trigger_conditionContext(_parentctx, _parentState, _p));
						pushNewRecursionContext(_localctx, _startState, RULE_trigger_condition);
						setState(124);
						if (!(4 >= _localctx._p)) throw new FailedPredicateException(this, "4 >= $_p");
						setState(125); match(OR);
						setState(126); trigger_condition(5);
						}
						break;
					}
					} 
				}
				setState(131);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class Final_stateContext extends ParserRuleContext {
		public int _p;
		public Final_stateContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Final_stateContext(ParserRuleContext parent, int invokingState, int _p) {
			super(parent, invokingState);
			this._p = _p;
		}
		@Override public int getRuleIndex() { return RULE_final_state; }
	 
		public Final_stateContext() { }
		public void copyFrom(Final_stateContext ctx) {
			super.copyFrom(ctx);
			this._p = ctx._p;
		}
	}
	public static class Or_stateContext extends Final_stateContext {
		public List<Final_stateContext> final_state() {
			return getRuleContexts(Final_stateContext.class);
		}
		public Final_stateContext final_state(int i) {
			return getRuleContext(Final_stateContext.class,i);
		}
		public TerminalNode OR() { return getToken(GOALspecParser.OR, 0); }
		public Or_stateContext(Final_stateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterOr_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitOr_state(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitOr_state(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class Neg_stateContext extends Final_stateContext {
		public TerminalNode NOT() { return getToken(GOALspecParser.NOT, 0); }
		public StateContext state() {
			return getRuleContext(StateContext.class,0);
		}
		public Neg_stateContext(Final_stateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterNeg_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitNeg_state(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitNeg_state(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class State_definitionContext extends Final_stateContext {
		public StateContext state() {
			return getRuleContext(StateContext.class,0);
		}
		public State_definitionContext(Final_stateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterState_definition(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitState_definition(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitState_definition(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class And_stateContext extends Final_stateContext {
		public List<Final_stateContext> final_state() {
			return getRuleContexts(Final_stateContext.class);
		}
		public Final_stateContext final_state(int i) {
			return getRuleContext(Final_stateContext.class,i);
		}
		public TerminalNode AND() { return getToken(GOALspecParser.AND, 0); }
		public And_stateContext(Final_stateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterAnd_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitAnd_state(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitAnd_state(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class Sub_stateContext extends Final_stateContext {
		public Final_stateContext final_state() {
			return getRuleContext(Final_stateContext.class,0);
		}
		public TerminalNode ROUND_LEFT() { return getToken(GOALspecParser.ROUND_LEFT, 0); }
		public TerminalNode ROUND_RIGHT() { return getToken(GOALspecParser.ROUND_RIGHT, 0); }
		public Sub_stateContext(Final_stateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSub_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSub_state(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSub_state(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Final_stateContext final_state(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		Final_stateContext _localctx = new Final_stateContext(_ctx, _parentState, _p);
		Final_stateContext _prevctx = _localctx;
		int _startState = 18;
		enterRecursionRule(_localctx, RULE_final_state);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(140);
			switch (_input.LA(1)) {
			case ROUND_LEFT:
				{
				_localctx = new Sub_stateContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(133); match(ROUND_LEFT);
				setState(134); final_state(0);
				setState(135); match(ROUND_RIGHT);
				}
				break;
			case NOT:
				{
				_localctx = new Neg_stateContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(137); match(NOT);
				setState(138); state();
				}
				break;
			case MESSAGE:
			case LOWERCASE_LETTER:
				{
				_localctx = new State_definitionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(139); state();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(150);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,8,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(148);
					switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
					case 1:
						{
						_localctx = new And_stateContext(new Final_stateContext(_parentctx, _parentState, _p));
						pushNewRecursionContext(_localctx, _startState, RULE_final_state);
						setState(142);
						if (!(4 >= _localctx._p)) throw new FailedPredicateException(this, "4 >= $_p");
						setState(143); match(AND);
						setState(144); final_state(5);
						}
						break;

					case 2:
						{
						_localctx = new Or_stateContext(new Final_stateContext(_parentctx, _parentState, _p));
						pushNewRecursionContext(_localctx, _startState, RULE_final_state);
						setState(145);
						if (!(3 >= _localctx._p)) throw new FailedPredicateException(this, "3 >= $_p");
						setState(146); match(OR);
						setState(147); final_state(4);
						}
						break;
					}
					} 
				}
				setState(152);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,8,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class Where_clauseContext extends ParserRuleContext {
		public TerminalNode WHERE() { return getToken(GOALspecParser.WHERE, 0); }
		public Item_descriptionsContext item_descriptions() {
			return getRuleContext(Item_descriptionsContext.class,0);
		}
		public Where_clauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_where_clause; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterWhere_clause(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitWhere_clause(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitWhere_clause(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Where_clauseContext where_clause() throws RecognitionException {
		Where_clauseContext _localctx = new Where_clauseContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_where_clause);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(153); match(WHERE);
			setState(154); item_descriptions(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Item_descriptionsContext extends ParserRuleContext {
		public int _p;
		public TerminalNode ROUND_LEFT() { return getToken(GOALspecParser.ROUND_LEFT, 0); }
		public TerminalNode AND() { return getToken(GOALspecParser.AND, 0); }
		public TerminalNode ROUND_RIGHT() { return getToken(GOALspecParser.ROUND_RIGHT, 0); }
		public Item_descriptionsContext item_descriptions(int i) {
			return getRuleContext(Item_descriptionsContext.class,i);
		}
		public Item_descriptionContext item_description() {
			return getRuleContext(Item_descriptionContext.class,0);
		}
		public List<Item_descriptionsContext> item_descriptions() {
			return getRuleContexts(Item_descriptionsContext.class);
		}
		public Item_descriptionsContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Item_descriptionsContext(ParserRuleContext parent, int invokingState, int _p) {
			super(parent, invokingState);
			this._p = _p;
		}
		@Override public int getRuleIndex() { return RULE_item_descriptions; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterItem_descriptions(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitItem_descriptions(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitItem_descriptions(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Item_descriptionsContext item_descriptions(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		Item_descriptionsContext _localctx = new Item_descriptionsContext(_ctx, _parentState, _p);
		Item_descriptionsContext _prevctx = _localctx;
		int _startState = 22;
		enterRecursionRule(_localctx, RULE_item_descriptions);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(162);
			switch (_input.LA(1)) {
			case ROUND_LEFT:
				{
				setState(157); match(ROUND_LEFT);
				setState(158); item_descriptions(0);
				setState(159); match(ROUND_RIGHT);
				}
				break;
			case PLUS:
			case MINUS:
			case STAR:
			case SLASH:
			case BACKSLASH:
			case CARET:
			case TILDE:
			case COLON:
			case DOT:
			case QMARK:
			case HASH:
			case DOLLAR:
			case AMP:
			case DIGIT:
			case LOWERCASE_LETTER:
			case UPPERCASE_LETTER:
				{
				setState(161); item_description();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(169);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,10,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new Item_descriptionsContext(_parentctx, _parentState, _p);
					pushNewRecursionContext(_localctx, _startState, RULE_item_descriptions);
					setState(164);
					if (!(3 >= _localctx._p)) throw new FailedPredicateException(this, "3 >= $_p");
					setState(165); match(AND);
					setState(166); item_descriptions(4);
					}
					} 
				}
				setState(171);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,10,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class Item_descriptionContext extends ParserRuleContext {
		public Data_itemContext data_item() {
			return getRuleContext(Data_itemContext.class,0);
		}
		public DataContext data() {
			return getRuleContext(DataContext.class,0);
		}
		public TerminalNode Is() { return getToken(GOALspecParser.Is, 0); }
		public Item_descriptionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_item_description; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterItem_description(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitItem_description(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitItem_description(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Item_descriptionContext item_description() throws RecognitionException {
		Item_descriptionContext _localctx = new Item_descriptionContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_item_description);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(172); data();
			setState(173); match(Is);
			setState(174); data_item();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DataContext extends ParserRuleContext {
		public CharactersContext characters() {
			return getRuleContext(CharactersContext.class,0);
		}
		public DataContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_data; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterData(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitData(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitData(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DataContext data() throws RecognitionException {
		DataContext _localctx = new DataContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_data);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(176); characters();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Data_itemContext extends ParserRuleContext {
		public CharactersContext characters() {
			return getRuleContext(CharactersContext.class,0);
		}
		public Data_itemContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_data_item; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterData_item(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitData_item(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitData_item(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Data_itemContext data_item() throws RecognitionException {
		Data_itemContext _localctx = new Data_itemContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_data_item);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(178); characters();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EventContext extends ParserRuleContext {
		public EventContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_event; }
	 
		public EventContext() { }
		public void copyFrom(EventContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class StateEventContext extends EventContext {
		public StateContext state() {
			return getRuleContext(StateContext.class,0);
		}
		public TerminalNode WHEN() { return getToken(GOALspecParser.WHEN, 0); }
		public StateEventContext(EventContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterStateEvent(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitStateEvent(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitStateEvent(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AfterContext extends EventContext {
		public TerminalNode AFTER() { return getToken(GOALspecParser.AFTER, 0); }
		public TerminalNode SINCE() { return getToken(GOALspecParser.SINCE, 0); }
		public Trigger_conditionContext trigger_condition() {
			return getRuleContext(Trigger_conditionContext.class,0);
		}
		public VariableContext variable() {
			return getRuleContext(VariableContext.class,0);
		}
		public AfterContext(EventContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterAfter(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitAfter(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitAfter(this);
			else return visitor.visitChildren(this);
		}
	}

	public final EventContext event() throws RecognitionException {
		EventContext _localctx = new EventContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_event);
		try {
			setState(187);
			switch (_input.LA(1)) {
			case AFTER:
				_localctx = new AfterContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(180); match(AFTER);
				setState(181); variable();
				setState(182); match(SINCE);
				setState(183); trigger_condition(0);
				}
				break;
			case WHEN:
				_localctx = new StateEventContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(185); match(WHEN);
				setState(186); state();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StateContext extends ParserRuleContext {
		public StateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_state; }
	 
		public StateContext() { }
		public void copyFrom(StateContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class MessageInStateContext extends StateContext {
		public Message_received_stateContext message_received_state() {
			return getRuleContext(Message_received_stateContext.class,0);
		}
		public MessageInStateContext(StateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterMessageInState(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitMessageInState(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitMessageInState(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class PredicateStateContext extends StateContext {
		public PredicateContext predicate() {
			return getRuleContext(PredicateContext.class,0);
		}
		public PredicateStateContext(StateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterPredicateState(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitPredicateState(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitPredicateState(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class MessageOutStateContext extends StateContext {
		public Message_sent_stateContext message_sent_state() {
			return getRuleContext(Message_sent_stateContext.class,0);
		}
		public MessageOutStateContext(StateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterMessageOutState(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitMessageOutState(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitMessageOutState(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StateContext state() throws RecognitionException {
		StateContext _localctx = new StateContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_state);
		try {
			setState(192);
			switch ( getInterpreter().adaptivePredict(_input,12,_ctx) ) {
			case 1:
				_localctx = new PredicateStateContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(189); predicate();
				}
				break;

			case 2:
				_localctx = new MessageOutStateContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(190); message_sent_state();
				}
				break;

			case 3:
				_localctx = new MessageInStateContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(191); message_received_state();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Message_sent_stateContext extends ParserRuleContext {
		public TerminalNode MESSAGE() { return getToken(GOALspecParser.MESSAGE, 0); }
		public PredicateContext predicate() {
			return getRuleContext(PredicateContext.class,0);
		}
		public TerminalNode SENT_TO() { return getToken(GOALspecParser.SENT_TO, 0); }
		public ActorContext actor() {
			return getRuleContext(ActorContext.class,0);
		}
		public Message_sent_stateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_message_sent_state; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterMessage_sent_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitMessage_sent_state(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitMessage_sent_state(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Message_sent_stateContext message_sent_state() throws RecognitionException {
		Message_sent_stateContext _localctx = new Message_sent_stateContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_message_sent_state);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(194); match(MESSAGE);
			setState(195); predicate();
			setState(196); match(SENT_TO);
			setState(197); actor();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Message_received_stateContext extends ParserRuleContext {
		public TerminalNode MESSAGE() { return getToken(GOALspecParser.MESSAGE, 0); }
		public PredicateContext predicate() {
			return getRuleContext(PredicateContext.class,0);
		}
		public ActorContext actor() {
			return getRuleContext(ActorContext.class,0);
		}
		public TerminalNode RECEIVED_FROM() { return getToken(GOALspecParser.RECEIVED_FROM, 0); }
		public Message_received_stateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_message_received_state; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterMessage_received_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitMessage_received_state(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitMessage_received_state(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Message_received_stateContext message_received_state() throws RecognitionException {
		Message_received_stateContext _localctx = new Message_received_stateContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_message_received_state);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(199); match(MESSAGE);
			setState(200); predicate();
			setState(201); match(RECEIVED_FROM);
			setState(202); actor();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class MsgActorContext extends ParserRuleContext {
		public CharactersContext characters() {
			return getRuleContext(CharactersContext.class,0);
		}
		public MsgActorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_msgActor; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterMsgActor(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitMsgActor(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitMsgActor(this);
			else return visitor.visitChildren(this);
		}
	}

	public final MsgActorContext msgActor() throws RecognitionException {
		MsgActorContext _localctx = new MsgActorContext(_ctx, getState());
		enterRule(_localctx, 38, RULE_msgActor);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(204); characters();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Actors_listContext extends ParserRuleContext {
		public Actors_listContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_actors_list; }
	 
		public Actors_listContext() { }
		public void copyFrom(Actors_listContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class Actor_and_listContext extends Actors_listContext {
		public TerminalNode AND() { return getToken(GOALspecParser.AND, 0); }
		public Actors_listContext actors_list() {
			return getRuleContext(Actors_listContext.class,0);
		}
		public ActorContext actor() {
			return getRuleContext(ActorContext.class,0);
		}
		public Actor_and_listContext(Actors_listContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterActor_and_list(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitActor_and_list(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitActor_and_list(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class Single_actorContext extends Actors_listContext {
		public ActorContext actor() {
			return getRuleContext(ActorContext.class,0);
		}
		public Single_actorContext(Actors_listContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSingle_actor(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSingle_actor(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSingle_actor(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class Actor_comma_listContext extends Actors_listContext {
		public Actors_listContext actors_list() {
			return getRuleContext(Actors_listContext.class,0);
		}
		public TerminalNode COMMA() { return getToken(GOALspecParser.COMMA, 0); }
		public ActorContext actor() {
			return getRuleContext(ActorContext.class,0);
		}
		public Actor_comma_listContext(Actors_listContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterActor_comma_list(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitActor_comma_list(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitActor_comma_list(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Actors_listContext actors_list() throws RecognitionException {
		Actors_listContext _localctx = new Actors_listContext(_ctx, getState());
		enterRule(_localctx, 40, RULE_actors_list);
		try {
			setState(215);
			switch ( getInterpreter().adaptivePredict(_input,13,_ctx) ) {
			case 1:
				_localctx = new Actor_comma_listContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(206); actor();
				setState(207); match(COMMA);
				setState(208); actors_list();
				}
				break;

			case 2:
				_localctx = new Actor_and_listContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(210); actor();
				setState(211); match(AND);
				setState(212); actors_list();
				}
				break;

			case 3:
				_localctx = new Single_actorContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(214); actor();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ActorContext extends ParserRuleContext {
		public ActorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_actor; }
	 
		public ActorContext() { }
		public void copyFrom(ActorContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class System_actorContext extends ActorContext {
		public TerminalNode THE_SYSTEM() { return getToken(GOALspecParser.THE_SYSTEM, 0); }
		public System_actorContext(ActorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSystem_actor(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSystem_actor(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSystem_actor(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class Role_actorContext extends ActorContext {
		public TerminalNode ROLE() { return getToken(GOALspecParser.ROLE, 0); }
		public TerminalNode THE() { return getToken(GOALspecParser.THE, 0); }
		public CharactersContext characters() {
			return getRuleContext(CharactersContext.class,0);
		}
		public Role_actorContext(ActorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterRole_actor(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitRole_actor(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitRole_actor(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ActorContext actor() throws RecognitionException {
		ActorContext _localctx = new ActorContext(_ctx, getState());
		enterRule(_localctx, 42, RULE_actor);
		try {
			setState(222);
			switch (_input.LA(1)) {
			case THE_SYSTEM:
				_localctx = new System_actorContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(217); match(THE_SYSTEM);
				}
				break;
			case THE:
				_localctx = new Role_actorContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(218); match(THE);
				setState(219); characters();
				setState(220); match(ROLE);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PredicateContext extends ParserRuleContext {
		public AtomContext atom() {
			return getRuleContext(AtomContext.class,0);
		}
		public StructureContext structure() {
			return getRuleContext(StructureContext.class,0);
		}
		public PredicateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_predicate; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterPredicate(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitPredicate(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitPredicate(this);
			else return visitor.visitChildren(this);
		}
	}

	public final PredicateContext predicate() throws RecognitionException {
		PredicateContext _localctx = new PredicateContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_predicate);
		try {
			setState(226);
			switch ( getInterpreter().adaptivePredict(_input,15,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(224); structure();
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(225); atom();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Term_listContext extends ParserRuleContext {
		public int _p;
		public TermContext term() {
			return getRuleContext(TermContext.class,0);
		}
		public Term_listContext term_list() {
			return getRuleContext(Term_listContext.class,0);
		}
		public TerminalNode COMMA() { return getToken(GOALspecParser.COMMA, 0); }
		public Term_listContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Term_listContext(ParserRuleContext parent, int invokingState, int _p) {
			super(parent, invokingState);
			this._p = _p;
		}
		@Override public int getRuleIndex() { return RULE_term_list; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterTerm_list(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitTerm_list(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitTerm_list(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Term_listContext term_list(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		Term_listContext _localctx = new Term_listContext(_ctx, _parentState, _p);
		Term_listContext _prevctx = _localctx;
		int _startState = 46;
		enterRecursionRule(_localctx, RULE_term_list);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			setState(229); term();
			}
			_ctx.stop = _input.LT(-1);
			setState(236);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,16,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new Term_listContext(_parentctx, _parentState, _p);
					pushNewRecursionContext(_localctx, _startState, RULE_term_list);
					setState(231);
					if (!(2 >= _localctx._p)) throw new FailedPredicateException(this, "2 >= $_p");
					setState(232); match(COMMA);
					setState(233); term();
					}
					} 
				}
				setState(238);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,16,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class TermContext extends ParserRuleContext {
		public AtomContext atom() {
			return getRuleContext(AtomContext.class,0);
		}
		public StructureContext structure() {
			return getRuleContext(StructureContext.class,0);
		}
		public NumeralContext numeral() {
			return getRuleContext(NumeralContext.class,0);
		}
		public StringContext string() {
			return getRuleContext(StringContext.class,0);
		}
		public ListContext list() {
			return getRuleContext(ListContext.class,0);
		}
		public VariableContext variable() {
			return getRuleContext(VariableContext.class,0);
		}
		public TermContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_term; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterTerm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitTerm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitTerm(this);
			else return visitor.visitChildren(this);
		}
	}

	public final TermContext term() throws RecognitionException {
		TermContext _localctx = new TermContext(_ctx, getState());
		enterRule(_localctx, 48, RULE_term);
		try {
			setState(245);
			switch ( getInterpreter().adaptivePredict(_input,17,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(239); structure();
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(240); atom();
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(241); numeral();
				}
				break;

			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(242); variable();
				}
				break;

			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(243); string();
				}
				break;

			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(244); list();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StructureContext extends ParserRuleContext {
		public AtomContext atom() {
			return getRuleContext(AtomContext.class,0);
		}
		public Term_listContext term_list() {
			return getRuleContext(Term_listContext.class,0);
		}
		public TerminalNode ROUND_LEFT() { return getToken(GOALspecParser.ROUND_LEFT, 0); }
		public TerminalNode ROUND_RIGHT() { return getToken(GOALspecParser.ROUND_RIGHT, 0); }
		public StructureContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_structure; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterStructure(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitStructure(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitStructure(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StructureContext structure() throws RecognitionException {
		StructureContext _localctx = new StructureContext(_ctx, getState());
		enterRule(_localctx, 50, RULE_structure);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(247); atom();
			setState(248); match(ROUND_LEFT);
			setState(249); term_list(0);
			setState(250); match(ROUND_RIGHT);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AtomContext extends ParserRuleContext {
		public TerminalNode LOWERCASE_LETTER() { return getToken(GOALspecParser.LOWERCASE_LETTER, 0); }
		public CharactersContext characters() {
			return getRuleContext(CharactersContext.class,0);
		}
		public AtomContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_atom; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterAtom(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitAtom(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitAtom(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AtomContext atom() throws RecognitionException {
		AtomContext _localctx = new AtomContext(_ctx, getState());
		enterRule(_localctx, 52, RULE_atom);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(252); match(LOWERCASE_LETTER);
			setState(253); characters();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ListContext extends ParserRuleContext {
		public AtomContext atom() {
			return getRuleContext(AtomContext.class,0);
		}
		public TerminalNode SQUARE_RIGHT() { return getToken(GOALspecParser.SQUARE_RIGHT, 0); }
		public Term_listContext term_list() {
			return getRuleContext(Term_listContext.class,0);
		}
		public TerminalNode SQUARE_LEFT() { return getToken(GOALspecParser.SQUARE_LEFT, 0); }
		public ListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_list; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ListContext list() throws RecognitionException {
		ListContext _localctx = new ListContext(_ctx, getState());
		enterRule(_localctx, 54, RULE_list);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(255); atom();
			setState(256); match(SQUARE_LEFT);
			setState(257); term_list(0);
			setState(258); match(SQUARE_RIGHT);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class NumeralContext extends ParserRuleContext {
		public DigitsContext digits() {
			return getRuleContext(DigitsContext.class,0);
		}
		public NumeralContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_numeral; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterNumeral(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitNumeral(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitNumeral(this);
			else return visitor.visitChildren(this);
		}
	}

	public final NumeralContext numeral() throws RecognitionException {
		NumeralContext _localctx = new NumeralContext(_ctx, getState());
		enterRule(_localctx, 56, RULE_numeral);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(260); digits();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class VariableContext extends ParserRuleContext {
		public TerminalNode UPPERCASE_LETTER() { return getToken(GOALspecParser.UPPERCASE_LETTER, 0); }
		public CharactersContext characters() {
			return getRuleContext(CharactersContext.class,0);
		}
		public VariableContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_variable; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterVariable(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitVariable(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitVariable(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableContext variable() throws RecognitionException {
		VariableContext _localctx = new VariableContext(_ctx, getState());
		enterRule(_localctx, 58, RULE_variable);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(262); match(UPPERCASE_LETTER);
			setState(263); characters();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StringContext extends ParserRuleContext {
		public List<TerminalNode> APOSTROPHE() { return getTokens(GOALspecParser.APOSTROPHE); }
		public TerminalNode APOSTROPHE(int i) {
			return getToken(GOALspecParser.APOSTROPHE, i);
		}
		public CharactersContext characters() {
			return getRuleContext(CharactersContext.class,0);
		}
		public StringContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_string; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterString(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitString(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitString(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StringContext string() throws RecognitionException {
		StringContext _localctx = new StringContext(_ctx, getState());
		enterRule(_localctx, 60, RULE_string);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(265); match(APOSTROPHE);
			setState(266); characters();
			setState(267); match(APOSTROPHE);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CharactersContext extends ParserRuleContext {
		public CharacterContext character(int i) {
			return getRuleContext(CharacterContext.class,i);
		}
		public List<CharacterContext> character() {
			return getRuleContexts(CharacterContext.class);
		}
		public CharactersContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_characters; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterCharacters(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitCharacters(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitCharacters(this);
			else return visitor.visitChildren(this);
		}
	}

	public final CharactersContext characters() throws RecognitionException {
		CharactersContext _localctx = new CharactersContext(_ctx, getState());
		enterRule(_localctx, 62, RULE_characters);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(270); 
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(269); character();
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(272); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			} while ( _alt!=2 && _alt!=-1 );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CharacterContext extends ParserRuleContext {
		public TerminalNode LOWERCASE_LETTER() { return getToken(GOALspecParser.LOWERCASE_LETTER, 0); }
		public TerminalNode UPPERCASE_LETTER() { return getToken(GOALspecParser.UPPERCASE_LETTER, 0); }
		public TerminalNode DIGIT() { return getToken(GOALspecParser.DIGIT, 0); }
		public SpecialContext special() {
			return getRuleContext(SpecialContext.class,0);
		}
		public CharacterContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_character; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterCharacter(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitCharacter(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitCharacter(this);
			else return visitor.visitChildren(this);
		}
	}

	public final CharacterContext character() throws RecognitionException {
		CharacterContext _localctx = new CharacterContext(_ctx, getState());
		enterRule(_localctx, 64, RULE_character);
		int _la;
		try {
			setState(276);
			switch (_input.LA(1)) {
			case PLUS:
			case MINUS:
			case STAR:
			case SLASH:
			case BACKSLASH:
			case CARET:
			case TILDE:
			case COLON:
			case DOT:
			case QMARK:
			case HASH:
			case DOLLAR:
			case AMP:
				enterOuterAlt(_localctx, 1);
				{
				setState(274); special();
				}
				break;
			case DIGIT:
			case LOWERCASE_LETTER:
			case UPPERCASE_LETTER:
				enterOuterAlt(_localctx, 2);
				{
				setState(275);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << DIGIT) | (1L << LOWERCASE_LETTER) | (1L << UPPERCASE_LETTER))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				consume();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DigitsContext extends ParserRuleContext {
		public TerminalNode DIGIT(int i) {
			return getToken(GOALspecParser.DIGIT, i);
		}
		public List<TerminalNode> DIGIT() { return getTokens(GOALspecParser.DIGIT); }
		public DigitsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_digits; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterDigits(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitDigits(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitDigits(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DigitsContext digits() throws RecognitionException {
		DigitsContext _localctx = new DigitsContext(_ctx, getState());
		enterRule(_localctx, 66, RULE_digits);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(279); 
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,20,_ctx);
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(278); match(DIGIT);
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(281); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,20,_ctx);
			} while ( _alt!=2 && _alt!=-1 );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SpecialContext extends ParserRuleContext {
		public TerminalNode COLON() { return getToken(GOALspecParser.COLON, 0); }
		public TerminalNode DOLLAR() { return getToken(GOALspecParser.DOLLAR, 0); }
		public TerminalNode STAR() { return getToken(GOALspecParser.STAR, 0); }
		public TerminalNode SLASH() { return getToken(GOALspecParser.SLASH, 0); }
		public TerminalNode AMP() { return getToken(GOALspecParser.AMP, 0); }
		public TerminalNode CARET() { return getToken(GOALspecParser.CARET, 0); }
		public TerminalNode TILDE() { return getToken(GOALspecParser.TILDE, 0); }
		public TerminalNode HASH() { return getToken(GOALspecParser.HASH, 0); }
		public TerminalNode PLUS() { return getToken(GOALspecParser.PLUS, 0); }
		public TerminalNode MINUS() { return getToken(GOALspecParser.MINUS, 0); }
		public TerminalNode DOT() { return getToken(GOALspecParser.DOT, 0); }
		public TerminalNode QMARK() { return getToken(GOALspecParser.QMARK, 0); }
		public TerminalNode BACKSLASH() { return getToken(GOALspecParser.BACKSLASH, 0); }
		public SpecialContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_special; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).enterSpecial(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GOALspecListener ) ((GOALspecListener)listener).exitSpecial(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof GOALspecVisitor ) return ((GOALspecVisitor<? extends T>)visitor).visitSpecial(this);
			else return visitor.visitChildren(this);
		}
	}

	public final SpecialContext special() throws RecognitionException {
		SpecialContext _localctx = new SpecialContext(_ctx, getState());
		enterRule(_localctx, 68, RULE_special);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(283);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << PLUS) | (1L << MINUS) | (1L << STAR) | (1L << SLASH) | (1L << BACKSLASH) | (1L << CARET) | (1L << TILDE) | (1L << COLON) | (1L << DOT) | (1L << QMARK) | (1L << HASH) | (1L << DOLLAR) | (1L << AMP))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			consume();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 1: return goal_list_sempred((Goal_listContext)_localctx, predIndex);

		case 8: return trigger_condition_sempred((Trigger_conditionContext)_localctx, predIndex);

		case 9: return final_state_sempred((Final_stateContext)_localctx, predIndex);

		case 11: return item_descriptions_sempred((Item_descriptionsContext)_localctx, predIndex);

		case 23: return term_list_sempred((Term_listContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean final_state_sempred(Final_stateContext _localctx, int predIndex) {
		switch (predIndex) {
		case 3: return 4 >= _localctx._p;

		case 4: return 3 >= _localctx._p;
		}
		return true;
	}
	private boolean goal_list_sempred(Goal_listContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0: return 1 >= _localctx._p;
		}
		return true;
	}
	private boolean term_list_sempred(Term_listContext _localctx, int predIndex) {
		switch (predIndex) {
		case 6: return 2 >= _localctx._p;
		}
		return true;
	}
	private boolean trigger_condition_sempred(Trigger_conditionContext _localctx, int predIndex) {
		switch (predIndex) {
		case 1: return 5 >= _localctx._p;

		case 2: return 4 >= _localctx._p;
		}
		return true;
	}
	private boolean item_descriptions_sempred(Item_descriptionsContext _localctx, int predIndex) {
		switch (predIndex) {
		case 5: return 3 >= _localctx._p;
		}
		return true;
	}

	public static final String _serializedATN =
		"\2\3\60\u0120\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b"+
		"\4\t\t\t\4\n\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t"+
		"\20\4\21\t\21\4\22\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t"+
		"\27\4\30\t\30\4\31\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t"+
		"\36\4\37\t\37\4 \t \4!\t!\4\"\t\"\4#\t#\4$\t$\3\2\3\2\3\3\3\3\3\3\3\3"+
		"\3\3\7\3P\n\3\f\3\16\3S\13\3\3\4\3\4\5\4W\n\4\3\5\3\5\3\5\3\5\3\5\3\5"+
		"\3\6\3\6\3\6\3\6\3\6\3\7\3\7\3\b\3\b\3\b\3\b\3\b\5\bk\n\b\3\t\3\t\3\t"+
		"\3\t\3\t\3\n\3\n\3\n\3\n\3\n\3\n\3\n\3\n\5\nz\n\n\3\n\3\n\3\n\3\n\3\n"+
		"\3\n\7\n\u0082\n\n\f\n\16\n\u0085\13\n\3\13\3\13\3\13\3\13\3\13\3\13\3"+
		"\13\3\13\5\13\u008f\n\13\3\13\3\13\3\13\3\13\3\13\3\13\7\13\u0097\n\13"+
		"\f\13\16\13\u009a\13\13\3\f\3\f\3\f\3\r\3\r\3\r\3\r\3\r\3\r\5\r\u00a5"+
		"\n\r\3\r\3\r\3\r\7\r\u00aa\n\r\f\r\16\r\u00ad\13\r\3\16\3\16\3\16\3\16"+
		"\3\17\3\17\3\20\3\20\3\21\3\21\3\21\3\21\3\21\3\21\3\21\5\21\u00be\n\21"+
		"\3\22\3\22\3\22\5\22\u00c3\n\22\3\23\3\23\3\23\3\23\3\23\3\24\3\24\3\24"+
		"\3\24\3\24\3\25\3\25\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\5\26"+
		"\u00da\n\26\3\27\3\27\3\27\3\27\3\27\5\27\u00e1\n\27\3\30\3\30\5\30\u00e5"+
		"\n\30\3\31\3\31\3\31\3\31\3\31\3\31\7\31\u00ed\n\31\f\31\16\31\u00f0\13"+
		"\31\3\32\3\32\3\32\3\32\3\32\3\32\5\32\u00f8\n\32\3\33\3\33\3\33\3\33"+
		"\3\33\3\34\3\34\3\34\3\35\3\35\3\35\3\35\3\35\3\36\3\36\3\37\3\37\3\37"+
		"\3 \3 \3 \3 \3!\6!\u0111\n!\r!\16!\u0112\3\"\3\"\5\"\u0117\n\"\3#\6#\u011a"+
		"\n#\r#\16#\u011b\3$\3$\3$\2%\2\4\6\b\n\f\16\20\22\24\26\30\32\34\36 \""+
		"$&(*,.\60\62\64\668:<>@BDF\2\4\4\21\21)*\3\4\20\u0119\2H\3\2\2\2\4J\3"+
		"\2\2\2\6V\3\2\2\2\bX\3\2\2\2\n^\3\2\2\2\fc\3\2\2\2\16e\3\2\2\2\20l\3\2"+
		"\2\2\22y\3\2\2\2\24\u008e\3\2\2\2\26\u009b\3\2\2\2\30\u00a4\3\2\2\2\32"+
		"\u00ae\3\2\2\2\34\u00b2\3\2\2\2\36\u00b4\3\2\2\2 \u00bd\3\2\2\2\"\u00c2"+
		"\3\2\2\2$\u00c4\3\2\2\2&\u00c9\3\2\2\2(\u00ce\3\2\2\2*\u00d9\3\2\2\2,"+
		"\u00e0\3\2\2\2.\u00e4\3\2\2\2\60\u00e6\3\2\2\2\62\u00f7\3\2\2\2\64\u00f9"+
		"\3\2\2\2\66\u00fe\3\2\2\28\u0101\3\2\2\2:\u0106\3\2\2\2<\u0108\3\2\2\2"+
		">\u010b\3\2\2\2@\u0110\3\2\2\2B\u0116\3\2\2\2D\u0119\3\2\2\2F\u011d\3"+
		"\2\2\2HI\5\4\3\2I\3\3\2\2\2JK\b\3\1\2KL\5\6\4\2LQ\3\2\2\2MN\6\3\2\3NP"+
		"\5\6\4\2OM\3\2\2\2PS\3\2\2\2QO\3\2\2\2QR\3\2\2\2R\5\3\2\2\2SQ\3\2\2\2"+
		"TW\5\b\5\2UW\5\n\6\2VT\3\2\2\2VU\3\2\2\2W\7\3\2\2\2XY\7\24\2\2YZ\7\23"+
		"\2\2Z[\5\f\7\2[\\\7\13\2\2\\]\5\16\b\2]\t\3\2\2\2^_\7\23\2\2_`\5\f\7\2"+
		"`a\7\13\2\2ab\5\20\t\2b\13\3\2\2\2cd\5@!\2d\r\3\2\2\2ef\5\22\n\2fg\5*"+
		"\26\2gh\7\26\2\2hj\5\24\13\2ik\5\26\f\2ji\3\2\2\2jk\3\2\2\2k\17\3\2\2"+
		"\2lm\5\22\n\2mn\5,\27\2no\7\26\2\2op\5\24\13\2p\21\3\2\2\2qr\b\n\1\2r"+
		"s\7\31\2\2sz\5\22\n\2tu\7%\2\2uv\5\22\n\2vw\7&\2\2wz\3\2\2\2xz\5 \21\2"+
		"yq\3\2\2\2yt\3\2\2\2yx\3\2\2\2z\u0083\3\2\2\2{|\6\n\3\3|}\7\27\2\2}\u0082"+
		"\5\22\n\2~\177\6\n\4\3\177\u0080\7\30\2\2\u0080\u0082\5\22\n\2\u0081{"+
		"\3\2\2\2\u0081~\3\2\2\2\u0082\u0085\3\2\2\2\u0083\u0081\3\2\2\2\u0083"+
		"\u0084\3\2\2\2\u0084\23\3\2\2\2\u0085\u0083\3\2\2\2\u0086\u0087\b\13\1"+
		"\2\u0087\u0088\7%\2\2\u0088\u0089\5\24\13\2\u0089\u008a\7&\2\2\u008a\u008f"+
		"\3\2\2\2\u008b\u008c\7\31\2\2\u008c\u008f\5\"\22\2\u008d\u008f\5\"\22"+
		"\2\u008e\u0086\3\2\2\2\u008e\u008b\3\2\2\2\u008e\u008d\3\2\2\2\u008f\u0098"+
		"\3\2\2\2\u0090\u0091\6\13\5\3\u0091\u0092\7\27\2\2\u0092\u0097\5\24\13"+
		"\2\u0093\u0094\6\13\6\3\u0094\u0095\7\30\2\2\u0095\u0097\5\24\13\2\u0096"+
		"\u0090\3\2\2\2\u0096\u0093\3\2\2\2\u0097\u009a\3\2\2\2\u0098\u0096\3\2"+
		"\2\2\u0098\u0099\3\2\2\2\u0099\25\3\2\2\2\u009a\u0098\3\2\2\2\u009b\u009c"+
		"\7\25\2\2\u009c\u009d\5\30\r\2\u009d\27\3\2\2\2\u009e\u009f\b\r\1\2\u009f"+
		"\u00a0\7%\2\2\u00a0\u00a1\5\30\r\2\u00a1\u00a2\7&\2\2\u00a2\u00a5\3\2"+
		"\2\2\u00a3\u00a5\5\32\16\2\u00a4\u009e\3\2\2\2\u00a4\u00a3\3\2\2\2\u00a5"+
		"\u00ab\3\2\2\2\u00a6\u00a7\6\r\7\3\u00a7\u00a8\7\27\2\2\u00a8\u00aa\5"+
		"\30\r\2\u00a9\u00a6\3\2\2\2\u00aa\u00ad\3\2\2\2\u00ab\u00a9\3\2\2\2\u00ab"+
		"\u00ac\3\2\2\2\u00ac\31\3\2\2\2\u00ad\u00ab\3\2\2\2\u00ae\u00af\5\34\17"+
		"\2\u00af\u00b0\7\22\2\2\u00b0\u00b1\5\36\20\2\u00b1\33\3\2\2\2\u00b2\u00b3"+
		"\5@!\2\u00b3\35\3\2\2\2\u00b4\u00b5\5@!\2\u00b5\37\3\2\2\2\u00b6\u00b7"+
		"\7\33\2\2\u00b7\u00b8\5<\37\2\u00b8\u00b9\7\35\2\2\u00b9\u00ba\5\22\n"+
		"\2\u00ba\u00be\3\2\2\2\u00bb\u00bc\7\34\2\2\u00bc\u00be\5\"\22\2\u00bd"+
		"\u00b6\3\2\2\2\u00bd\u00bb\3\2\2\2\u00be!\3\2\2\2\u00bf\u00c3\5.\30\2"+
		"\u00c0\u00c3\5$\23\2\u00c1\u00c3\5&\24\2\u00c2\u00bf\3\2\2\2\u00c2\u00c0"+
		"\3\2\2\2\u00c2\u00c1\3\2\2\2\u00c3#\3\2\2\2\u00c4\u00c5\7\"\2\2\u00c5"+
		"\u00c6\5.\30\2\u00c6\u00c7\7$\2\2\u00c7\u00c8\5,\27\2\u00c8%\3\2\2\2\u00c9"+
		"\u00ca\7\"\2\2\u00ca\u00cb\5.\30\2\u00cb\u00cc\7#\2\2\u00cc\u00cd\5,\27"+
		"\2\u00cd\'\3\2\2\2\u00ce\u00cf\5@!\2\u00cf)\3\2\2\2\u00d0\u00d1\5,\27"+
		"\2\u00d1\u00d2\7!\2\2\u00d2\u00d3\5*\26\2\u00d3\u00da\3\2\2\2\u00d4\u00d5"+
		"\5,\27\2\u00d5\u00d6\7\27\2\2\u00d6\u00d7\5*\26\2\u00d7\u00da\3\2\2\2"+
		"\u00d8\u00da\5,\27\2\u00d9\u00d0\3\2\2\2\u00d9\u00d4\3\2\2\2\u00d9\u00d8"+
		"\3\2\2\2\u00da+\3\2\2\2\u00db\u00e1\7\36\2\2\u00dc\u00dd\7\37\2\2\u00dd"+
		"\u00de\5@!\2\u00de\u00df\7 \2\2\u00df\u00e1\3\2\2\2\u00e0\u00db\3\2\2"+
		"\2\u00e0\u00dc\3\2\2\2\u00e1-\3\2\2\2\u00e2\u00e5\5\64\33\2\u00e3\u00e5"+
		"\5\66\34\2\u00e4\u00e2\3\2\2\2\u00e4\u00e3\3\2\2\2\u00e5/\3\2\2\2\u00e6"+
		"\u00e7\b\31\1\2\u00e7\u00e8\5\62\32\2\u00e8\u00ee\3\2\2\2\u00e9\u00ea"+
		"\6\31\b\3\u00ea\u00eb\7!\2\2\u00eb\u00ed\5\62\32\2\u00ec\u00e9\3\2\2\2"+
		"\u00ed\u00f0\3\2\2\2\u00ee\u00ec\3\2\2\2\u00ee\u00ef\3\2\2\2\u00ef\61"+
		"\3\2\2\2\u00f0\u00ee\3\2\2\2\u00f1\u00f8\5\64\33\2\u00f2\u00f8\5\66\34"+
		"\2\u00f3\u00f8\5:\36\2\u00f4\u00f8\5<\37\2\u00f5\u00f8\5> \2\u00f6\u00f8"+
		"\58\35\2\u00f7\u00f1\3\2\2\2\u00f7\u00f2\3\2\2\2\u00f7\u00f3\3\2\2\2\u00f7"+
		"\u00f4\3\2\2\2\u00f7\u00f5\3\2\2\2\u00f7\u00f6\3\2\2\2\u00f8\63\3\2\2"+
		"\2\u00f9\u00fa\5\66\34\2\u00fa\u00fb\7%\2\2\u00fb\u00fc\5\60\31\2\u00fc"+
		"\u00fd\7&\2\2\u00fd\65\3\2\2\2\u00fe\u00ff\7)\2\2\u00ff\u0100\5@!\2\u0100"+
		"\67\3\2\2\2\u0101\u0102\5\66\34\2\u0102\u0103\7\'\2\2\u0103\u0104\5\60"+
		"\31\2\u0104\u0105\7(\2\2\u01059\3\2\2\2\u0106\u0107\5D#\2\u0107;\3\2\2"+
		"\2\u0108\u0109\7*\2\2\u0109\u010a\5@!\2\u010a=\3\2\2\2\u010b\u010c\7\3"+
		"\2\2\u010c\u010d\5@!\2\u010d\u010e\7\3\2\2\u010e?\3\2\2\2\u010f\u0111"+
		"\5B\"\2\u0110\u010f\3\2\2\2\u0111\u0112\3\2\2\2\u0112\u0110\3\2\2\2\u0112"+
		"\u0113\3\2\2\2\u0113A\3\2\2\2\u0114\u0117\5F$\2\u0115\u0117\t\2\2\2\u0116"+
		"\u0114\3\2\2\2\u0116\u0115\3\2\2\2\u0117C\3\2\2\2\u0118\u011a\7\21\2\2"+
		"\u0119\u0118\3\2\2\2\u011a\u011b\3\2\2\2\u011b\u0119\3\2\2\2\u011b\u011c"+
		"\3\2\2\2\u011cE\3\2\2\2\u011d\u011e\t\3\2\2\u011eG\3\2\2\2\27QVjy\u0081"+
		"\u0083\u008e\u0096\u0098\u00a4\u00ab\u00bd\u00c2\u00d9\u00e0\u00e4\u00ee"+
		"\u00f7\u0112\u0116\u011b";
	public static final ATN _ATN =
		ATNSimulator.deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
	}
}