%put NOTE: You have called the macro _LIST, 2013-09-04.;
%put NOTE: Copyright (c) 2001-2013 Rodney Sparapani;
%put;

/*
Author:  Rodney Sparapani <rsparapa@mcw.edu>
Created: 2001-00-00

This file is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

This file is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this file; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
*/

/* _LIST Documentation
    Expands lists of individual items from VAR1-VAR10 to
    VAR1 VAR2 ... VAR9 VAR10.  Non-numeric suffixes are also
    passed:  VAR1:-VAR3: -> VAR1: VAR2: VAR3:.  PDV lists like 
    VAR1--VAR10 are passed unchanged, i.e. VAR1--VAR10.  
            
    POSITIONAL Parameters  
            
    ARG1            lists to be expanded

    NAMED Parameters

    BY=1            expand list counting BY=
                    you can over-ride BY= with the @ notation
                    with BY=5, VAR10-VAR20 becomes VAR10 VAR15 VAR20
                    with BY=5, VAR10-VAR20@10 becomes VAR10 VAR20

    SPLIT=          split character that separates items,
                    defaults to blank
*/

%macro _list(arg1, by=1, split=%str( ));

    %local var var1 var2 i j k lo hi suffix max return at;

    %let max=%_count(&arg1);

    %do i=1 %to &max;
        %let var=%scan(&arg1, &i, %str( ));
        
        %*if %_count(&var, split=-)^=2 %then %let return=&return.&var.&split;
        %*else;
        %if %index(&var, -) & %index(&var, --)=0 %then %do;
            %let var1=%scan(&var, 1, -);
            %let var2=%scan(&var, 2, -);
            %let at=%scan(&var.@&by, 2, @);
            %let var2=%scan(&var2, 1, @);
            
            %let j=%length(&var1);
            %let lo=;
            %let suffix=;
            
/*
            single character suffixes commented out in favor of multiple character below
            %let lo=%bquote(%_substr(&var1, &j, 1));
            
            %if %index(0123456789, &lo)=0 %then %do;
                %let suffix=&lo;
                %let lo=;
            %end;
            %else %let suffix=;
            
            %let j=%eval(&j-1);
*/
            
            %do %while(%index(0123456789, %bquote(%_substr(&var1, &j, 1)))=0);
                %let suffix=%bquote(%_substr(&var1, &j, 1))&suffix;
                %let j=%eval(&j-1);
            %end;
            
            %do %while(%index(0123456789, %bquote(%_substr(&var1, &j, 1))));
                %let lo=%_substr(&var1, &j, 1)&lo;
                %let j=%eval(&j-1);
            %end;
            
            %let var1=%bquote(%_substr(&var1, 1, &j));
                
            %let hi=;
            %let j=%length(&var2);
            
            %*if %length(&suffix) %then %let j=%eval(&j-1);
            %let j=%eval(&j-%length(&suffix));
            
            %do %while(%index(0123456789, %bquote(%_substr(&var2, &j, 1))));
                %let hi=%_substr(&var2, &j, 1)&hi;
                %let j=%eval(&j-1);
            %end;
            
            %let var2=%bquote(%_substr(&var2, 1, &j));      
            
            %if %length(&lo) & %length(&hi) & "&var1"="&var2" %then %do;
		%let k=%length(&lo);
		
                %do j=&lo %to &hi %by &at;
                    %if &j=&hi & &i=&max %then 
                        %let return=&return.&var1%_repeat(0, &k-%length(&j))&j.&suffix;
                    %else 
                        %let return=&return.&var1%_repeat(0, &k-%length(&j))&j.&suffix.&split;
                %end;
            %end;
            %else %if &i=&max %then %let return=&return.&var;
            %else %let return=&return.&var.&split;
        %end;
        %else %if &i=&max %then %let return=&return.&var;
        %else %let return=&return.&var.&split;
    %end;

%unquote(&return)

%mend _list;

%*VALIDATION TEST STREAM;
/* un-comment to re-validate
 
%put %_list('10'-'20'-'30');
%put %_list('10'-'20'@5);
%put %_list('10'-'20');
%put %_list('10'-'90', by=10);
%put %_list('list1'-'list10');
%put %_list(list1:-list10:);
%put %_list(list1-list10);
%put %_list(list1);
%put %_list(one1:-one10: two1d-two10d);
%put %_list(two2-one1 two one);
%put %_list(two00-two10, split=%str(,));
%put %_list("/markov/disk0/medpar86"-"/markov/disk0/medpar99");
%put %_list(two1d-two10d);
%put %_list(two1dt-two10dt);
%put %_list(_4570_dt-_4572_dt);
%put %_list(_4591_dt-_4593_dt);
%put %_list(_4570_dt-_4572_dt _4591_dt-_4593_dt);

*/
