program exprtest;

uses
	SysUtils,
	expr;
	

var
	lexer : TLexer;
	parser : TParser;

	
begin  
  lexer := TLexer.Create();
  
  writeln('Do it, bitch!');
  
  parser := TParser.Create();
  parser.lexer := lexer;
  parser.parse();
end.