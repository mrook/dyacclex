#
# Delphi Yacc & Lex
# Copyright (c) 2003 by Michiel Rook
# Based on Turbo Pascal Lex and Yacc Version 4.1
#
# Test Makefile - Use GNU make!
#
# $Id: Makefile,v 1.1 2003/12/18 19:37:46 druid Exp $
#


ifeq ($(OSTYPE),linux-gnu)
	LINUX=1
else
	WIN32=1
endif


ifdef WIN32
DCC=dcc32

EXPRTEST=exprtest.exe
UNITDIRS=..\src

MAKE=$(CURDIR)/../make

DYACC=..\src\yacc\dyacc
DLEX=..\src\lex\dlex

ifeq ($(OS), Windows_NT)
	RM=cmd /c del
else
	RM=del
endif
endif


ifdef LINUX
DCC=dcc

EXPRTEST=exprtest
UNITDIRS=../src

DYACC=../src/yacc/dyacc
DLEX=../src/lex/dlex

RM=rm -f
endif

DCC_FLAGS=-Q -GD


all:	$(EXPRTEST)

expr.pas: expr.y
	$(DYACC) expr.y
	
exprlex.pas: exprlex.l
	$(DLEX) exprlex.l

$(EXPRTEST): exprtest.dpr expr.pas exprlex.pas
	$(DCC) exprtest.dpr $(DCC_FLAGS) -U$(UNITDIRS)
      
clean:
	$(RM) $(EXPRTEST) 
	$(RM) *.map
	$(RM) *.dcu
	$(RM) *.dpu
	$(RM) *.drc
	$(RM) *.dcp
