nnCron LITE. A system task scheduler.

Copyright (C) 2000,2001 Nicholas Nemtsev. e-mail:nemtsev@nncron.ru
                    http://nemtsev.eserv.ru/

SP-Forth 3.75 Copyright (C) 1992-2000  A.Cherezov  http://www.forth.org.ru/

What is 'nnCron LITE'?
~~~~~~~~~~~~~~~~~~~~~~

The nnCron LITE is freeware version of nnCron without scripting.
The nnCron LITE understands only classic unix crontab foprmat.

System requirements
-------------------
 * IBM PC or compatible
 * Intel 80486/66 processor or higher
 * Windows NT/95/98/2000

Install/Uninstall
-----------------
    (You must have administrative privileges to install/uninstall the nnCron)

    To install run: install.bat

    To uninstall run: uninstall.bat

Status
~~~~~~
    FreeWare.

Distribution status
~~~~~~~~~~~~~~~~~~~
    Freely distributable

The technical features of nnCron
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ini file
--------
    Ini file is 'cron.ini' and placed at nncron's directory.
    See nncron.ini file for more details
    The nnCron loads 'cron.ini' file once during start of the nnCron service.

Crontab file.
-------------
    
    Crontab is a file which contains tasks definitions.
    Name of crontab file is 'cron.tab' and it placed at nnCron
    directory. If you have changed crontab, nnCron will
    reload it at the latest one minute.

    An  active line in a crontab will be either an environment
    setting or a system command.  An environment setting  is  of
    the form,
           SET name = value
    where  the  spaces around the equal-sign (=) are optional,
    and any subsequent non-leading spaces  in  value  will  be
    part  of the value assigned to name.  The value string may
    be placed in double quotes.

    Blank lines and leading spaces are ignored. Lines whose first non-space
    character is a pound-sign (#) are comments, and are ignored. Note that
    comments are not allowed on the same line as cron commands, since they
    will be taken to be part of the command.
    Each line has six time and date fields, followed by a command:
     <minute>  <hour>  <day of month>  <month>  <day of week>  <year>  <command>

    Each of first six fields can be '*'. It means 'any minute', 'any hour' etc.
    Example:
        0,15,30,45 * * 2,4,6,8-12 1-5  c:\xxx\chime.exe
        |          | | |          |    |
        |          | | |          |    - Command
        |          | | |          |   
        |          | | |          +-------------- Week days (mon..fri)
        |          | | +------------------------- Months (feb,apr,jun,aug..dec)
        |          | +--------------------------- Days of month (any)
        |          +----------------------------- Hours (any)
        +---------------------------------------- Minutes

    Names can also be used for the <month> and <day of week> fields. 
    Use the first three letters of the particular day or month 
    (case doesn't matter).

Macro variables
---------------

%hh%        - hours of current local time (00-23)
%mm%        - minutes   (00-59)
%ss%        - seconds   (00-59)
%MM%        - number of month of current local date (01-12)
%MMM%       - name of month (Jun-Dec)
%DD%        - day of month (01-31)
%WW%        - day of week (Mo-Su)
%WD%        - day of week (1-7, 1-monday, 7-sunday)
%YYYY%      - year (4 digit)
%YY%        - year (last 2 digit)
%QUOTE%     - quote character (")
%PERCENT%   - percent character (%)

Command line switches
---------------------
nncron.exe
    -install          installs service (Win NT) or adds registry key (95/98)
    -remove           removes service or registry key.
    -ns               runs as no service
    -v                displays version and number of build
    -stop             stop the cron (useful in Win 9x)
    -reload           reloads crontab files

Feel free to address with any problems, wishes, remarks
to the e-mail nemtsev@nncron.ru
