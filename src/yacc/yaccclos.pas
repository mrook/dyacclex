{
  Delphi Yacc & Lex
  Copyright (c) 2003,2004 by Michiel Rook
  Based on Turbo Pascal Lex and Yacc Version 4.1

  Copyright (c) 1990-92  Albert Graef <ag@muwiinfa.geschichte.uni-mainz.de>
  Copyright (C) 1996     Berend de Boer <berend@pobox.com>
  Copyright (c) 1998     Michael Van Canneyt <Michael.VanCanneyt@fys.kuleuven.ac.be>
  
  ## $Id: yaccclos.pas,v 1.5 2004/08/17 20:07:24 druid Exp $

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

unit yaccclos;

interface


procedure closures;
(* compute the closure sets *)

procedure first_sets;
(* compute first sets and nullable flags *)

implementation

uses
  yaccbase,
  yacctabl;

procedure closures;

  (* The closure set of a nonterminal X is the set of all nonterminals Y
     s.t. Y appears as the first symbol in a rightmost derivation from the
     nonterminal X (i.e. X =>+ Y ... in a rightmost derivation). We can
     easily compute closure sets as follows:
     - Initialize the closure set for any nonterminal X to contain all
       nonterminals Y for which there is a rule X : Y ...
     - Now repeatedly pass over the already constructed sets, and for
       any nonterminal Y which has already been added to the closure set
       of some nonterminal X, also include the closure elements of Y in
       the closure set of X.
     The algorithm terminates as soon as no additional symbols have been
     added during the previous pass. *)

var
  sym, i, Count, prev_count: integer;
  act_syms: IntSet;

begin
  (* initialize closure sets: *)
  prev_count := 0;
  Count      := 0;
  for sym := 1 to n_nts do
  begin
    closure_table^[sym] := newEmptyIntSet;
    with rule_offs^[sym] do
      for i := rule_lo to rule_hi do
        with rule_table^[rule_no^[i]]^ do
          if (rhs_len > 0) and (rhs_sym[1] < 0) then
            include(closure_table^[sym]^, rhs_sym[1]);
    Inc(Count, size(closure_table^[sym]^));
  end;
    (* repeated passes until no more symbols have been added during the last
       pass: *)
  while prev_count < Count do
  begin
    prev_count := Count;
    Count      := 0;
    for sym := 1 to n_nts do
    begin
      act_syms := closure_table^[sym]^;
      for i := 1 to size(act_syms) do
        setunion(closure_table^[sym]^, closure_table^[ -act_syms[i]]^);
      Inc(Count, size(closure_table^[sym]^));
    end;
  end;
end(*closures*);

procedure first_sets;

  (* The first set of a nonterminal X is the set of all literal symbols
     y s.t. X =>+ y ... in some derivation of the nonterminal X. In
     addition, X is nullable if the empty string can be derived from X.
     Using the first set construction algorithm of Aho/Sethi/Ullman,
     Section 4.4, the first sets and nullable flags are computed as
     follows:

     For any production X -> y1 ... yn, where the yi are grammar symbols,
     add the symbols in the first set of y1 (y1 itself if it is a literal)
     to the first set of X; if y1 is a nullable nonterminal, then proceed
     with y2, etc., until either all yi have been considered or yi is non-
     nullable (or a literal symbol). If all of the yi are nullable (in
     particular, if n=0), then also set nullable[X] to true.

     This procedure is repeated until no more symbols have been added to any
     first set and none of the nullable flags have been changed during the
     previous pass. *)

var
  i, j, l, sym:  integer;
  n, null, done: boolean;

begin
  (* initialize tables: *)
  for sym := 1 to n_nts do
  begin
    nullable^[sym] := False;
    first_set_table^[sym] := newEmptyIntSet;
  end;
    (* repeated passes until no more symbols added and no nullable flags
       modified: *)
  repeat
    done := True;
    for i := 1 to n_rules do
      with rule_table^[i]^ do
      begin
        l    := size(first_set_table^[ -lhs_sym]^);
        n    := nullable^[ -lhs_sym];
        null := True;
        j    := 1;
        while (j <= rhs_len) and null do
        begin
          if rhs_sym[j] < 0 then
          begin
            setunion(first_set_table^[ -lhs_sym]^,
              first_set_table^[ -rhs_sym[j]]^);
            null := nullable^[ -rhs_sym[j]];
          end
          else  begin
            include(first_set_table^[ -lhs_sym]^,
              rhs_sym[j]);
            null := False;
          end;
          Inc(j);
        end;
        if null then
          nullable^[ -lhs_sym] := True;
        if (l < size(first_set_table^[ -lhs_sym]^)) or
          (n <> nullable^[ -lhs_sym]) then
          done := False;
      end;
  until done;
end(*first_sets*);

end(*YaccClosure*).
