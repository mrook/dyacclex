#
# Delphi Yacc & Lex
# Copyright (c) 2003,2004 by Michiel Rook
# Based on Turbo Pascal Lex and Yacc Version 4.1
#
# Test Makefile - Use GNU make!
#
# $Id: Makefile,v 1.4 2004/02/24 14:17:57 druid Exp $
#


ifeq ($(OSTYPE),linux-gnu)
	LINUX=1
else
	WIN32=1
endif


ifdef WIN32
DCC=dcc32

EXPR=expr.exe
UNITDIRS='..\src'

MAKE=$(CURDIR)/../make

DYACC='..\src\yacc\dyacc'
DLEX='..\src\lex\dlex'

ifeq ($(OS), Windows_NT)
	RM=cmd /c del
else
	RM=del
endif
endif


ifdef LINUX
DCC=dcc

EXPR=expr
UNITDIRS=../src

DYACC=../src/yacc/dyacc
DLEX=../src/lex/dlex

RM=rm -f
endif

DCC_FLAGS=-Q -GD


all:	$(EXPR)

expr.dpr: expr.y
	$(DYACC) expr.y expr.dpr
	
exprlex.pas: exprlex.l
	$(DLEX) exprlex.l

$(EXPR): expr.dpr exprlex.pas
	$(DCC) expr.dpr $(DCC_FLAGS) -U$(UNITDIRS)
      
clean:
	$(RM) $(EXPR) 
	$(RM) exprlex.pas
	$(RM) expr.dpr
	$(RM) *.map
	$(RM) *.dcu
	$(RM) *.dpu
	$(RM) *.drc
	$(RM) *.dcp
