{
  Delphi Yacc & Lex
  Copyright (c) 2003,2004 by Michiel Rook
  Based on Turbo Pascal Lex and Yacc Version 4.1

  Copyright (c) 1990-92  Albert Graef <ag@muwiinfa.geschichte.uni-mainz.de>
  Copyright (C) 1996     Berend de Boer <berend@pobox.com>
  Copyright (c) 1998     Michael Van Canneyt <Michael.VanCanneyt@fys.kuleuven.ac.be>
  
  ## $Id: lexpos.pas,v 1.4 2004/02/24 14:17:57 druid Exp $

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}

unit lexpos;


interface

uses 
	lexBase, 
	lextable;


procedure addExpr(r : RegExpr; var FIRST : IntSet);
  (* Add the positions in r to the position table, and return the set of
     first positions of r. *)

implementation

procedure eval(r : RegExpr;
               var FIRST, LAST : IntSet;
               var nullable : Boolean);
  (* Evaluates the expression r, adding the positions in r to the position
     table and assigning FIRST, LAST and FOLLOW sets accordingly (cf. Aho/
     Sethi/Ullman, Compilers : Principles, Techniques and Tools, Section 3.9).
     Returns:
     - FIRST: the set of first positions in r
     - LAST: the set of last positions in r
     - nullable: denotes whether the r is nullable (i.e. is matched by the
       empty string). *)
  var
    c : Char;
    str : StrPtr;
    cc : CClassPtr;
    rule, pos : Integer;
    r1, r2 : RegExpr;
    FIRST1, LAST1 : IntSet;
    nullable1 : Boolean;
    i : integer;
  begin
    if is_epsExpr(r) then
      begin
        empty(FIRST); empty(LAST);
        nullable := true
      end
    else if is_markExpr(r, rule, pos) then
      begin
        addMarkPos(rule, pos);
        singleton(FIRST, n_pos); singleton(LAST, n_pos);
        nullable := true
      end
    else if is_charExpr(r, c) then
      begin
        addCharPos(c);
        singleton(FIRST, n_pos); singleton(LAST, n_pos);
        nullable := false
      end
    else if is_strExpr(r, str) then
      if length(str^)=0 then
        (* empty string is treated as empty expression *)
        begin
          empty(FIRST); empty(LAST);
          nullable := true
        end
      else
        begin
          addCharPos(str^[1]);
          singleton(FIRST, n_pos);
          for i := 2 to length(str^) do
            begin
              addCharPos(str^[i]);
              singleton(pos_table^[pred(n_pos)].follow_pos^, n_pos);
            end;
          singleton(LAST, n_pos);
          nullable := false
        end
    else if is_CClassExpr(r, cc) then
      begin
        addCClassPos(cc);
        singleton(FIRST, n_pos); singleton(LAST, n_pos);
        nullable := false
      end
    else if is_starExpr(r, r1) then
      begin
        eval(r1, FIRST, LAST, nullable);
        for i := 1 to size(LAST) do
          setunion(pos_table^[LAST[i]].follow_pos^, FIRST);
        nullable := true
      end
    else if is_plusExpr(r, r1) then
      begin
        eval(r1, FIRST, LAST, nullable);
        for i := 1 to size(LAST) do
          setunion(pos_table^[LAST[i]].follow_pos^, FIRST);
      end
    else if is_optExpr(r, r1) then
      begin
        eval(r1, FIRST, LAST, nullable);
        nullable := true
      end
    else if is_catExpr(r, r1, r2) then
      begin
        eval(r1, FIRST, LAST1, nullable);
        eval(r2, FIRST1, LAST, nullable1);
        for i := 1 to size(LAST1) do
          setunion(pos_table^[LAST1[i]].follow_pos^, FIRST1);
        if nullable then setunion(FIRST, FIRST1);
        if nullable1 then setunion(LAST, LAST1);
        nullable := nullable and nullable1
      end
    else if is_altExpr(r, r1, r2) then
      begin
        eval(r1, FIRST, LAST, nullable);
        eval(r2, FIRST1, LAST1, nullable1);
        setunion(FIRST, FIRST1);
        setunion(LAST, LAST1);
        nullable := nullable or nullable1
      end
  end(*eval*);

procedure addExpr(r : RegExpr; var FIRST : IntSet);
  var LAST : IntSet;
      nullable : Boolean;
  begin
    eval(r, FIRST, LAST, nullable);
  end(*addExpr*);

end(*LexPos*).
