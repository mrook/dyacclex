#
# Delphi Yacc & Lex - Parser generator toolset for Delphi and Kylix
# Copyright (c) 2003,2004 by Michiel Rook
# Based on Turbo Pascal Lex and Yacc Version 4.1
#
#
# Copyright (c) 1990-2000 by Albert Graef
#                       <ag@muwiinfa.geschichte.uni-mainz.de>
# Copyright (c) 1996 by Berend de Boer
#                       <berend@pobox.com>
# Copyright (c) 1998 by Michael Van Canneyt
#                       <Michael.VanCanneyt@fys.kuleuven.ac.be>
#
# Main Makefile - Use GNU make!
#
# $Id: Makefile,v 1.4 2004/02/24 14:17:57 druid Exp $
#


all:	
	$(MAKE) -C src

test: all
	$(MAKE) -C test

clean:
	$(MAKE) -C src clean
	$(MAKE) -C test clean
