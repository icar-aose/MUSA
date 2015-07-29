grammar GOALspec;

options {
  language = Java;
}

specification
    : goal_list 
    ;

goal_list
    : goal_type             # single_goal_list
    | goal_list goal_type   # many_goal_list
    ;

goal_type
    : social_goal 
    | system_goal 
    ;

social_goal
    : SOCIAL GOAL goal_name COLON social_goal_content
    ;

system_goal
    : GOAL goal_name COLON system_goal_content
    ;

goal_name
    : characters 
    ;

social_goal_content
    : trigger_condition actors_list SHALL_ADDRESS final_state where_clause?
    ;

system_goal_content
    : trigger_condition actor SHALL_ADDRESS final_state
    ;

trigger_condition
    : trigger_condition AND trigger_condition   # and_condition
    | trigger_condition OR trigger_condition    # or_condition
    | NOT trigger_condition                     # neg_condition
    | ROUND_LEFT trigger_condition ROUND_RIGHT  # sub_condition
    | event                                     # event_definition
    ;

final_state 
    : ROUND_LEFT final_state ROUND_RIGHT        # sub_state
    | final_state AND final_state               # and_state
    | final_state OR final_state                # or_state
    | NOT state                                 # neg_state
    | state                                     # state_definition
    ;
    
where_clause
    : WHERE item_descriptions
    ;

item_descriptions
    : item_descriptions AND item_descriptions
    | ROUND_LEFT item_descriptions ROUND_RIGHT
    | item_description
    ;

item_description
    : data Is data_item
    ;

data 
    : characters
    ;

data_item
    : characters
    ;

event 
    : AFTER variable SINCE trigger_condition    # After
    | WHEN state                                # StateEvent
    ;

state
    : predicate                     # PredicateState
    | message_sent_state            # MessageOutState
    | message_received_state        # MessageInState
    ;

message_sent_state
    : MESSAGE predicate SENT_TO actor
    ;

message_received_state
    : MESSAGE predicate RECEIVED_FROM actor
    ;

msgActor
    : characters
    ;

actors_list 
    : actor COMMA actors_list		# actor_comma_list
    | actor AND actors_list             # actor_and_list
    | actor				# single_actor
    ;

actor
    : THE_SYSTEM            # system_actor
    | THE characters ROLE   # role_actor
    ;

predicate
    : structure     
    | atom          
    ;

term_list 
    : term_list COMMA term 
    | term 
    ;

term 
    : structure
    | atom 
    | numeral 
    | variable 
    | string
    | list
    ;

structure
    : atom ROUND_LEFT term_list ROUND_RIGHT 
    ;

atom 
    : LOWERCASE_LETTER characters 
    ;

list
    : atom SQUARE_LEFT term_list SQUARE_RIGHT 
    ;

numeral 
    : digits 
    ;

variable
    : UPPERCASE_LETTER characters
    ;

string
    : APOSTROPHE characters APOSTROPHE
    ;

characters 
    : character+
    ;

character
    : special 
    | (
        LOWERCASE_LETTER  
      | UPPERCASE_LETTER 
      | DIGIT  
      )
    ;

digits
    : DIGIT+
    ;

special : PLUS | MINUS | STAR | SLASH | BACKSLASH | CARET | TILDE | COLON | DOT | QMARK | HASH | DOLLAR | AMP ;
APOSTROPHE: '\'';

PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
BACKSLASH: '\\';
CARET: '^';
TILDE: '~';
COLON: ':';
DOT: '.';
QMARK: '?';
HASH: '#';
DOLLAR: '$';
AMP: '&';

DIGIT: '0' | POSITIVEDIGIT; 

Is: 'IS';
GOAL: 'GOAL';
//GOAL: [gG][oO][aA][lL];
SOCIAL: 'SOCIAL';
WHERE: 'WHERE';
SHALL_ADDRESS: 'SHALL ADDRESS'; 
AND: 'AND';
OR: 'OR';
NOT: 'NOT';
ON: 'ON';
AFTER: 'AFTER';
WHEN: 'WHEN';
SINCE: 'SINCE';
THE_SYSTEM: 'THE SYSTEM';
THE: 'THE';
ROLE: 'ROLE';
COMMA: ',';
MESSAGE: 'MESSAGE';
RECEIVED_FROM: 'RECEIVED FROM';
SENT_TO: 'SENT TO';
ROUND_LEFT: '(';
ROUND_RIGHT: ')';
SQUARE_LEFT: '[';
SQUARE_RIGHT: ']';

LOWERCASE_LETTER : 'a'..'z';
//UPPERCASE_LETTER : 'A'..'Z' | '_' ;
UPPERCASE_LETTER : 'A'..'C' | D | 'E'..'L' | M | 'N' | 'O' | P | 'Q'..'X' | Y | 'Z' | '_' ;
D: 'D';
M: 'M';
P: 'P';
Y: 'Y';
POSITIVEDIGIT : '1'..'9';

WS : [ \r\t\n]+ -> skip ;  // Define whitespace rule, toss it out

//timeDuration : P_LETTER year MINUS month MINUS monthDay T_LETTER ZEROTHRU24 COLON minute COLON second;
/*
timeDuration : 'P'
               (
               DIGITS
               (
               'Y'
               )
               );
*/               
//timeDuration : 'P' durationContent;
/*
durationContent : DIGITS 'Y' afterYears | afterYears;
afterYears : DIGITS 'M' afterMonths | afterMonths;
afterMonths : DIGITS 'D' times | times;
times : 'T' timeContent;
timeContent: DIGITS 'H' afterHours | afterHours;
afterHours: dMinutes dSeconds | dSeconds;
dMinutes: DIGITS 'M';
dSeconds: DIGITS 'S';

DIGITS: DIGIT+;

dateTimeString : level0Expression; 

level0Expression : date 
    | dateAndTime 
    | l0Interval;

date : year | yearMonth | yearMonthDay;

dateAndTime : date T time;
time : baseTime zoneOffset?;
baseTime : hour COLON minute COLON second | HOUR_24; 
  
zoneOffset : Z 
      | (PLUS | MINUS) (zoneOffsetHour (COLON minute)? | FOURTEEN | ZEROZERO COLON ONETHRU59 ); 

zoneOffsetHour : ONETHRU13;

l0Interval : date SLASH date;


year : positiveYear 
  | negativeYear 
  | ZEROYEAR;

positiveYear :
       POSITIVEDIGIT DIGIT DIGIT DIGIT 
     | DIGIT POSITIVEDIGIT DIGIT DIGIT
     | DIGIT DIGIT POSITIVEDIGIT DIGIT
     | DIGIT DIGIT DIGIT POSITIVEDIGIT;

negativeYear : MINUS positiveYear;
*/
//year : digit digit digit digit;
/*
month : ONETHRU12;
monthDay : MONTHDAY31 MINUS ONETHRU31
    | MONTHDAY30 MINUS ONETHRU30
    | MONTHDAY29 MINUS ONETHRU29;

MONTHDAY31: '01' |'03' |'05' |'07' |'08' |'10' |'12';
MONTHDAY30: '04' |'06' |'09' |'11';
MONTHDAY29: '02';

yearMonth : year MINUS month;
yearMonthDay : year MINUS monthDay;

day: ONETHRU31; 
hour: ZEROTHRU23;
minute: ZEROTHRU59;
second:  ZEROTHRU59;

ONETHRU12: '01' | '02' | '03' | '04' | '05' | '06' | '07' | '08' | '09' | '10' | '11' | '12';
ONETHRU13: ONETHRU12 | '13';
ONETHRU23: ONETHRU13 | '14' | '15' | '16' | '17' | '18' | '19' | '20' | '21' | '22' | '23';
ZEROTHRU23: '00' | ONETHRU23;
ZEROTHRU24: ZEROTHRU23 | '24';
ONETHRU29: ONETHRU23 | '24' | '25' | '26' | '27' | '28' | '29';
ONETHRU30: ONETHRU29 | '30';
ONETHRU31: ONETHRU30 | '31';
ONETHRU59: ONETHRU31 | '32' | '33'| '34'| '35'| '36'| '37'| '38'| '39'| '40'| '41'| '42' | '43'
           | '44'| '45'| '46' | '47'| '48'| '49' |'50'|'51'|'52'|'53'|'54'|'55'|'56'|'57'|'58'|'59';
ZEROTHRU59: '00' | ONETHRU59; 

ZEROYEAR: '0000';
ZEROZERO: '00';
FOURTEEN: '14:00';
SPACE: ' ';
PLUS: '+';
MINUS: '-';
EQUAL: '=';
SLASH: '/';

DAY : 'Mon' | 'Tue' | 'Wed' | 'Thu' | 'Fri' | 'Sat' | 'Sun';
MONTH : 'Jan' | 'Feb' | 'Mar' | 'Apr' | 'May' | 'Jun' | 'Jul' | 'Aug' | 'Sep' | 'Oct' | 'Nov' | 'Dec';
*/
