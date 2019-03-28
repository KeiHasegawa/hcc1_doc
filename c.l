hex-quad  {hexadecimal-digit}{4}
universal-character-name  \\u{hex-quad}|\\U{hex-quad}{hex-quad}

identifier  {nondigit}({nondigit}|{digit})*
nondigit  {universal-character-name}|[_a-zA-Z]
digit  [0-9]

floating-constant  {decimal-floating-constant}|{hexadecimal-floating-constant}
decimal-floating-constant  {fractional-constant}{exponent-part}?{floating-suffix}?|{digit-sequence}{exponent-part}{floating-suffix}?
hexadecimal-floating-constant  0[xX]({hexadecimal-fractional-constant}|{hexadecimal-digit-sequence}){binary-exponent-part}{floating-suffix}?
fractional-constant  {digit-sequence}?\.{digit-sequence}|{digit-sequence}\.
exponent-part  [eE]{sign}?{digit-sequence}
sign  [+-]
digit-sequence  {digit}+
hexadecimal-fractional-constant  {hexadecimal-digit-sequence}?\.hexadecimal-digit-sequence|hexadecimal-digit-sequence\.
binary-exponent-part  [pP]{sign}?{digit-sequence}
hexadecimal-digit-sequence  {hexadecimal-digit}+
hexadecimal-digit  [0-9a-fA-F]
floating-suffix  [flFL]

integer-constant  {decimal-constant}{integer-suffix}?|{octal-constant}{integer-suffix}?|{hexadecimal-constant}{integer-suffix}?
decimal-constant  {nonzero-digit}{digit}*
octal-constant  0{octal-digit}*
hexadecimal-constant  0[xX]{hexadecimal-digit}+
nonzero-digit  [1-9]
octal-digit  [0-7]
integer-suffix  {unsigned-suffix}{long-suffix}?|{long-suffix}{unsigned-suffix}?|{unsigned-suffix}{long-long-suffix}?|{long-long-suffix}{unsigned-suffix}?
unsigned-suffix  u|U
long-suffix  l|L
long-long-suffix  ll|LL

character-constant  L?'{c-char-sequence}'
c-char-sequence  {c-char}+
c-char  [^'\\\n\r]|{escape-sequence}|{universal-character-name}
escape-sequence  {simple-escape-sequence}|{octal-escape-sequence}|{hexadecimal-escape-sequence}
simple-escape-sequence  \\'|\\\"|\\\?|\\\\|\\a|\\b|\\f|\\n|\\r|\\t|\\v
octal-escape-sequence  \\{octal-digit}{1,3}
hexadecimal-escape-sequence  \\x{hexadecimal-digit}+

string-literal  L?\"{s-char-sequence}?\"
s-char-sequence  {s-char}+
s-char  [^\"\\\n\r]|{escape-sequence}|{universal-character-name}

%%

auto
break
case
char
complex
const
continue
default
do
double
else
enum
extern
float
for
goto
if
imaginary
inline
int
long
register
restrict
return
short
signed
sizeof
static
struct
switch
typedef
union
unsigned
void
volatile
while

"!="
"%="
"&&"
"&="
"*="
"++"
"+="
"--"
"-="
"->"
"..."
"/="
"<<"
"<<="
"<="
"=="
">="
">>"
">>="
"^="
"|="
"||"

{identifier}
{floating-constant}
{integer-constant}
{character-constant}
{string-literal}
[ \t]
\n|\r\n
.

%%
