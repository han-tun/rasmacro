%put NOTE: You have called the macro _REPEAT, 2004-03-29.;
%put NOTE: Copyright (c) 2001-2004 Rodney Sparapani;
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

/* _REPEAT Documentation
    This is a variant of the DATASTEP function REPEAT.  It returns
    one less repeat than the DATASTEP function which is a more natural
    way of thinking about it.
            
    POSITIONAL Parameters  
            
    ARG1    string of characters to be repeated
       
    ARG2    number representing the repeats to create
*/

%macro _repeat(arg1, arg2);

%if &arg2>0 %then %sysfunc(repeat(&arg1, &arg2-1));

%mend _repeat;

/*
%put 2=%_repeat(0, 2);
%put 1=%_repeat(0, 1);
%put 0=%_repeat(0, 0);
%put -1=%_repeat(0, -1);
%put "%_repeat(%str( ), 5)";
*/
