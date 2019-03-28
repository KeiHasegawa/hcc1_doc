%token TYPEDEF EXTERN STATIC REGISTER AUTO
%token INLINE
%token VOID CHAR INT FLOAT DOUBLE COMPLEX
%token SHORT LONG
%token SIGNED UNSIGNED
%token CONST VOLATILE RESTRICT

%token STRUCT UNION ENUM

%token CONTINUE CASE SWITCH  FOR
%token WHILE BREAK GOTO DO
%token SIZEOF IF RETURN ELSE DEFAULT

%token ADD_ASSIGN OROR GREATEREQ SUB_ASSIGN ANDAND
%token LSH_ASSIGN NOTEQ RSH_ASSIGN
%token LESSEQ PLUSPLUS MUL_ASSIGN DOTS
%token RSH AND_ASSIGN DIV_ASSIGN XOR_ASSIGN
%token MOD_ASSIGN EQUAL MINUSMINUS OR_ASSIGN ARROW LSH

%token identifier constant string_literal typedef_name

%start translation_unit

%%

primary_expression
  : identifier
  | constant
  | string_literal
  | '(' expression ')'
  ;

postfix_expression
  : primary_expression
  | postfix_expression '[' expression ']'
  | postfix_expression '('                          ')'
  | postfix_expression '(' argument_expression_list ')'
  | postfix_expression '.' identifier
  | postfix_expression ARROW identifier
  | postfix_expression PLUSPLUS
  | postfix_expression MINUSMINUS
  | '(' type_name ')' '{' initializer_list '}'
  | '(' type_name ')' '{' initializer_list ',' '}'
  ;

argument_expression_list
  : assignment_expression
  | argument_expression_list ',' assignment_expression
  ;

unary_expression
  : postfix_expression
  | PLUSPLUS unary_expression
  | MINUSMINUS unary_expression
  | unary_operator cast_expression
  | SIZEOF unary_expression
  | SIZEOF '(' type_name ')'
  ;

unary_operator
  : '&'
  | '*'
  | '+'
  | '-'
  | '~'
  | '!'
  ;

cast_expression
  : unary_expression
  | '(' type_name ')' cast_expression
  ;

multiplicative_expression
  : cast_expression
  | multiplicative_expression '*' cast_expression
  | multiplicative_expression '/' cast_expression
  | multiplicative_expression '%' cast_expression
  ;

additive_expression
  : multiplicative_expression
  | additive_expression '+' multiplicative_expression
  | additive_expression '-' multiplicative_expression
  ;

shift_expression
  : additive_expression
  | shift_expression LSH additive_expression
  | shift_expression RSH additive_expression
  ;

relational_expression
  : shift_expression
  | relational_expression '<' shift_expression
  | relational_expression '>' shift_expression
  | relational_expression LESSEQ shift_expression
  | relational_expression GREATEREQ shift_expression
  ;

equality_expression
  : relational_expression
  | equality_expression EQUAL relational_expression
  | equality_expression NOTEQ relational_expression
  ;

AND_expression
  : equality_expression
  | AND_expression '&' equality_expression
  ;

exclusive_OR_expression
  : AND_expression
  | exclusive_OR_expression '^' AND_expression
  ;

inclusive_OR_expression
  : exclusive_OR_expression
  | inclusive_OR_expression '|' exclusive_OR_expression
  ;

logical_AND_expression
  : inclusive_OR_expression
  | logical_AND_expression ANDAND inclusive_OR_expression
  ;

logical_OR_expression
  : logical_AND_expression
  | logical_OR_expression OROR logical_AND_expression
  ;

conditional_expression
  : logical_OR_expression
  | logical_OR_expression '?' expression ':' conditional_expression
  ;

assignment_expression
  : conditional_expression
  | unary_expression assignment_operator assignment_expression
  ;

assignment_operator
  : '='
  | MUL_ASSIGN
  | DIV_ASSIGN
  | MOD_ASSIGN
  | ADD_ASSIGN
  | SUB_ASSIGN
  | LSH_ASSIGN
  | RSH_ASSIGN
  | AND_ASSIGN
  | XOR_ASSIGN
  | OR_ASSIGN
  ;

expression
  : assignment_expression
  | expression ',' assignment_expression
  ;

constant_expression
  : conditional_expression
  ;

declaration
  : declaration_specifiers                      ';'
  | declaration_specifiers init_declarator_list ';'
  ;

declaration_specifiers
  : storage_class_specifier
  | storage_class_specifier declaration_specifiers
  | type_specifier
  | type_specifier declaration_specifiers
  | type_qualifier
  | type_qualifier declaration_specifiers
  | function_specifier
  | function_specifier declaration_specifiers
  ;

init_declarator_list
  : init_declarator
  | init_declarator_list ',' init_declarator
  ;

init_declarator
  : declarator
  | declarator '=' initializer
  ;

storage_class_specifier
  : TYPEDEF
  | EXTERN
  | STATIC
  | AUTO
  | REGISTER
  ;

type_specifier
  : VOID
  | CHAR
  | SHORT
  | INT
  | LONG
  | FLOAT
  | DOUBLE
  | COMPLEX
  | SIGNED
  | UNSIGNED
  | struct_or_union_specifier
  | enum_specifier
  | typedef_name
  ;

struct_or_union_specifier
  : struct_or_union identifier '{' struct_declaration_list '}'
  | struct_or_union            '{' struct_declaration_list '}'
  | struct_or_union identifier
  ;

struct_or_union
  : STRUCT
  | UNION
  ;

struct_declaration_list
  : struct_declaration
  | struct_declaration_list struct_declaration
  ;

struct_declaration
  : specifier_qualifier_list struct_declarator_list ';'
  ;

specifier_qualifier_list
  : type_specifier
  | type_specifier specifier_qualifier_list
  | type_qualifier
  | type_qualifier specifier_qualifier_list
  ;

struct_declarator_list
  : struct_declarator
  | struct_declarator_list ',' struct_declarator
  ;

struct_declarator
  : declarator
  |            ':' constant_expression
  | declarator ':' constant_expression
  ;

enum_specifier
  : ENUM identifier '{' enumerator_list '}'
  | ENUM            '{' enumerator_list '}'
  | ENUM identifier '{' enumerator_list ',' '}'
  | ENUM            '{' enumerator_list ',' '}'
  | ENUM identifier
  ;

enumerator_list
  : enumerator
  | enumerator_list ',' enumerator
  ;

enumerator
  : identifier
  | identifier '=' constant_expression
  ;

type_qualifier
  : CONST
  | RESTRICT
  | VOLATILE
  ;

function_specifier
  : INLINE
  ;

declarator
  :         direct_declarator
  | pointer direct_declarator
  ;

direct_declarator
  : identifier
  | '(' declarator ')'
  | direct_declarator '['                       ']'
  | direct_declarator '[' assignment_expression ']'
  | direct_declarator '[' '*' ']'
  | direct_declarator '(' parameter_type_list ')'
  | direct_declarator '('                     ')'
  | direct_declarator '(' identifier_list ')'
  ;

pointer
  : '*'
  | '*' type_qualifier_list
  | '*'                     pointer
  | '*' type_qualifier_list pointer
  ;

type_qualifier_list
  : type_qualifier
  | type_qualifier_list type_qualifier
  ;

parameter_type_list
  : parameter_list
  | parameter_list ',' DOTS
  ;

parameter_list
  : parameter_declaration
  | parameter_list ',' parameter_declaration
  ;

parameter_declaration
  : declaration_specifiers declarator
  | declaration_specifiers
  | declaration_specifiers abstract_declarator
  ;

identifier_list
  : identifier
  | identifier_list ',' identifier
  ;

type_name
  : specifier_qualifier_list
  | specifier_qualifier_list abstract_declarator
  ;

abstract_declarator
  : pointer
  |         direct_abstract_declarator
  | pointer direct_abstract_declarator
  ;

direct_abstract_declarator
  : '(' abstract_declarator ')'
  |                            '['                       ']'
  |                            '[' assignment_expression ']'
  | direct_abstract_declarator '['                       ']'
  | direct_abstract_declarator '[' assignment_expression ']'
  | direct_abstract_declarator '[' '*' ']'
  |                            '('                     ')'
  |                            '(' parameter_type_list ')'
  | direct_abstract_declarator '('                     ')'
  | direct_abstract_declarator '(' parameter_type_list ')'
  ;

initializer
  : assignment_expression
  | '{' initializer_list '}'
  | '{' initializer_list ',' '}'
  ;

initializer_list
  :             initializer
  | designation initializer
  | initializer_list ','             initializer
  | initializer_list ',' designation initializer
  ;

designation
  : designator_list '='
  ;

designator_list
  : designator
  | designator_list designator
  ;

designator
  : '[' constant_expression ']'
  | '.' identifier
  ;

statement
  : labeled_statement
  | compound_statement
  | expression_statement
  | selection_statement
  | iteration_statement
  | jump_statement
  ;

labeled_statement
  : identifier ':' statement
  | CASE constant_expression ':' statement
  | DEFAULT ':' statement
  ;

compound_statement
  : '{'                 '}'
  | '{' block_item_list '}'
  ;

block_item_list
  : block_item
  | block_item_list block_item
  ;

block_item
  : declaration
  | statement
  ;

expression_statement
  :            ';'
  | expression ';'
  ;

selection_statement
  : IF '(' expression ')' statement
  | IF '(' expression ')' statement ELSE statement
  | SWITCH '(' expression ')' statement
  ;

iteration_statement
  : WHILE '(' expression ')'
  | DO statement WHILE '(' expression ')' ';'
  | FOR '('             ';'            ';'            ')' statement
  | FOR '('  expression ';'            ';'            ')' statement
  | FOR '(' declaration                ';'            ')' statement
  | FOR '('             ';' expression ';'            ')' statement
  | FOR '('  expression ';' expression ';'            ')' statement
  | FOR '(' declaration     expression ';'            ')' statement
  | FOR '('             ';'            ';' expression ')' statement
  | FOR '('  expression ';'            ';' expression ')' statement
  | FOR '(' declaration                ';' expression ')' statement
  | FOR '('             ';' expression ';' expression ')' statement
  | FOR '('  expression ';' expression ';' expression ')' statement
  | FOR '(' declaration     expression ';' expression ')' statement
  ;

jump_statement
  : GOTO identifier ';'
  | CONTINUE ';'
  | BREAK ';'
  | RETURN            ';'
  | RETURN expression ';'
  ;

translation_unit
  : external_declaration
  | translation_unit external_declaration
  ;

external_declaration
  : function_definition
  | declaration
  ;

function_definition
  : declaration_specifiers declarator                  compound_statement
  | declaration_specifiers declarator declaration_list compound_statement
  |                        declarator                  compound_statement
  |                        declarator declaration_list compound_statement
  ;

declaration_list
  :                      declaration
  | declaration_list ',' declaration
  ;

%%
