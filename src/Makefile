#
# Delphi Yacc & Lex
# Copyright (c) 2003,2004 by Michiel Rook
# Based on Turbo Pascal Lex and Yacc Version 4.1
# Compiler generator toolset for Turbo/Borland/Free Pascal and Delphi
#
# Copyright (c) 1990-2000 by Albert Graef
#                       <ag@muwiinfa.geschichte.uni-mainz.de>
# Copyright (c) 1996 by Berend de Boer
#                       <berend@pobox.com>
# Copyright (c) 1998 by Michael Van Canneyt
#                       <Michael.VanCanneyt@fys.kuleuven.ac.be>
#
# Sources Makefile - Use GNU make!
#
# $Id: Makefile,v 1.2 2004/02/24 14:17:57 druid Exp $
#


ifeq ($(OSTYPE),linux-gnu)
	LINUX=1
else
	WIN32=1
endif


ifdef WIN32
MAKE=$(CURDIR)/../make
endif


all:
	$(MAKE) -C lex
	$(MAKE) -C yacc
      
clean:
	$(MAKE) -C lex clean
	$(MAKE) -C yacc clean
