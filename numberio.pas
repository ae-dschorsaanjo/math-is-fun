(* Copyright 2018 B. Zoltán Gorza
 * 
 * This file is part of Math is Fun!, released under the Modified BSD License.
 *)

{ Basic IO functions specifically for terminal/command line use, using Crt. }
unit NumberIO;

{$mode objfpc}
{$H+}

interface

uses
    ExpressionClass,
    StatisticsClass,
    GameClass;

type
    { Simple supporting class for menu-generating and handling. }
    TMenuItem = record
        { Text }
        txt: String;
        { Procedure }
        pro: procedure;
    end;

    { A 2 long array used for displaying meaningful representations of the
      value. }
    TBooleanStrings = Array[0..1] of String[5];

    { General dynamic string array. }
    TStringArray = Array of String;

const
    { Set of numberic characters }
    KEYS_NUMBERS = [#48, #49, #50, #51, #52, #53, #54, #55, #56, #57];
    { Set of lower case letter characters }
    KEYS_LOWCHAR = [#97, #98, #99, #100, #101, #102, #103, #104, #105, #106,
                    #107, #108, #109, #110, #111, #112, #113, #114, #115, #116,
                    #117, #118, #119, #120, #121, #122];
    { Set of upper case letter characters }
    KEYS_UPCHAR = [#65, #66, #67, #68, #69, #70, #71, #72, #73, #74, #75, #76,
                   #77, #78, #79, #80, #81, #82, #83, #84, #85, #86, #87, #88,
                   #89, #90];
    { Character code of <Return> }
    KEY_RETURN = #13;
    { Character code of <Space> }
    KEY_SPACE = #32;
    { Character code of <Backspace> }
    KEY_BACKSPACE = #8;
    { Character code of '~' }
    KEY_TILDE = #126;
    { Character code of '-' }
    KEY_DASH = #45;
    { Character code of '_' }
    KEY_UNDERSCORE = #95;
    { Character code of '.' }
    KEY_POINT = #46;
    { Set of characters that are accepted as a "Select" command in menus.
      (<Return>, <Space>) }
    SELECT_KEYS = [KEY_RETURN, KEY_SPACE];
    { Character code of <Up> }
    KEY_UP = #72;
    { Character code of <Down> }
    KEY_DOWN = #80;
    { Character code of <Left> }
    KEY_LEFT = #75;
    { Character code of <Right> }
    KEY_RIGHT = #77;
    { Character code of <PAGE_UP> }
    KEY_PAGE_UP = #73;
    { Character code of <PAGE_DOWN> }
    KEY_PAGE_DOWN = #81;
    { The quit character. }
    KEY_QUIT = 'q';
    { The halt character. }
    KEY_HALT = #3;
    { Name of the program }
    PROGRAM_NAME = 'Math is Fun!';
    { Version number of the program }
    PROGRAM_VERSION = 'v0.1';
    { Developer (or developers) of the program }
    PROGRAM_DEVELOPER = 'B. Zolta''n Gorza';
    { Contact info of the developer(s) }
    PROGRAM_DEV_CONTACT = '(b.zoltan.gorza@gmail.com)';
    { The year in which the program was worked on }
    PROGRAM_DATE = '2018';
    { Header's first line }
    TEXT_HEADER: String = '';
    //TEXT_HEADER = 'Math Is Fun v0.1 by B. Zolta''n Gorza (2018)';
    { Header's second line }
    //TEXT_HEADER2 = 'Now published under Modified BSD!';
    TEXT_HEADER2: String = '';
    { Header's first line's vertical position }
    Y_HEADER = 1;
    { Header's second line's vertical position }
    Y_HEADER2 = 2;
    { Minimum horizontal coordinate of the second header line }
    X_MIN_HEAD = 55;
    { Minimum horizontal coordinate of the game area }
    X_MIN = 1;
    { Minimum vertical coordinate of the game area }
    Y_MIN = 4;
    { Maximum horizontal coordinate of the game area }
    X_MAX = 80;
    { Maximum Vertical coordinate of the game area }
    Y_MAX = 23;
    { The veri last line's vertical coordinate }
    Y_LAST_LINE = 24;
    { Default Foreground Color (light gray) }
    DEF_FCOLOR = 7;
    { Default Background Color (black) }
    DEF_BCOLOR = 0;
    { Used in default filenames. }
    FILENAME_PREFIX = 'MiF_';
    { Default string for boolean values. }
    BOOLEAN_VALUES: TBooleanStrings = ('False', ' True');
    { Operation format values. }
    OP_FORMAT_VALUES: TBooleanStrings = ('Short', ' Long');
    { Yes/No values }
    YES_NO_VALUES: TBooleanStrings = (' <No>', '<Yes>');

{ It's the Beginning, where everything begins. }
procedure theBeginning;

{ Exit procedure...

  I don't wanna write it anymore. That's it.

  I quit. }
procedure thatsItIQuit;

{ Number reader function for doubles. If isThereDefault is set to True, then the
  gotten value will be written and used.
  @param(d Output variable)
  @param(isThereDefault (default: False) }
procedure readNum(var d: Double;
                  const isThereDefault: Boolean = False); overload;

{ Number reader function for integers. If isThereDefault is set to True, then
  the gotten value will be written and used.

  The value can be increased or decreased by 1 with the cursor/arrow keys.
  @param(i Output variable)
  @param(isThereDefault (default: False) }
procedure readNum(var i: Integer;
                  const isThereDefault: Boolean = False); overload;

{ Number reader function. }
procedure readBool(var b: Boolean;
                   const values: TBooleanStrings);

{ @link(TExpression Expression) formatter procedure.
  @seealso(expressionWriter)
  @param(e Expression to be written)
  @param(longOp Use long format of the operator (i.e. the 3 character
         long name instead of the sign -- default: False).
  @return(A string representation of an expression.) }
function expressionToString(const e: TExpression;
                            const longOp: Boolean = False;
                            const width: Byte = 0;
                            const idxFmt: String = '%d: '): String; inline;

{ @link(TExpression Expression) writer procedure.
  @seealso(expressionToString)
  @param(e Expression to be written)
  @param(longOp Use long format of the operator (i.e. the 3 character
         long name instead of the sign -- default: False).
  @param(checkFirstTime If True, then it will write the current expression's
         name along with the expression, giving a little bit of help. )}
procedure expressionWriter(const e: TExpression;
                           const longOp: Boolean = False;
                           const width: Byte = 0;
                           const idxFmt: String = '%d: ';
                           const checkFirstTime: Boolean = True); inline;

{ Set ups the default colors.
  @seealso(DEF_FCOLOR)
  @seealso(DEF_BCOLOR)
  @param(invert Invert the default colors (default: @false)) }
procedure useDefaultColors(const invert: Boolean = False); inline;

{ Restores the game area and clears it. }
procedure restoreGameArea; inline;

{ Menu generator and writer procedure.
  @param(item The used/wanted menu items.)
  @param(menuXMin The minimum horizontal coordinate (default: @link(X_MIN).)
  @param(menuYMin The minimum vertical coordinate (default: @link(Y_MIN).)
  @param(menuXMax The maximum horizontal coordinate (default: @link(X_MAX).)
  @param(menuYMax The maximum vertical coordinate (default: @link(Y_MAX).)
  @param(step Number of line-breaks between items (default: 2). )
  @param(indexFormat The format string for the index. )
  @param(indexSeparator The separator character between the index and the text.)
}
procedure writeMenu(const items: Array of TMenuItem;
                    const menuXMin: Byte = X_MIN; // X_MIN should be 1
                    const menuYMin: Byte = Y_MIN; // Y_MIN should be 1
                    const menuXMax: Byte = X_MAX;
                    const menuYMax: Byte = Y_MAX;
                    const step: Byte = 2;
                    const indexFormat: String = '[%d]';
                    const indexSeparator: String = ' ');

{ Long text writer, and reader for long texts. The key bindings were inspired
  by the "man" program of Linux.

  It uses the @link(restoreGameArea) procedure for cleaning and defining area.
  @param(txt The text to be read.)}
procedure writeLongText(const txt: String);

{ Generates a formatted string of the statistics. For special markers it uses
  the @link(NEWLINECHAR) and @(TABCHAR) characters.
  @param(g The current game)
  @param(s The statistics to be stringified)
  @param(sett Settings)
  @param(longOp Setting of long operation)}
function statisticsTextGenerator(const g: TGame; nog: Integer;
                                 const longOp: Boolean): String;

{ Writes a string into a file.
  @param(s The stirng to be written.)
  @param(fn The filename of the output. If it is empty, then a special filename
         will be used, containing the @link(FILENAME_PREFIX), and the date
         and time of creation.)}
procedure writeToFile(s: String; fn: String = '');

implementation // --------------------------------------------------------------

uses
    Crt,
    Math,
    StrUtils,
    SysUtils,
    OperationClass;

var
    isFirstTime: Array[TOp] of Boolean = (True, True, True, True, True, True);

procedure theBeginning;
begin
    clrscr;
    window(X_MIN, Y_HEADER, X_MAX, Y_HEADER);
    textBackground(MAGENTA);
    textColor(WHITE);
    clrscr;
    write(TEXT_HEADER);
    window(X_MIN_HEAD, Y_HEADER2, X_MAX, Y_HEADER2 + 1);
    textBackground(BLACK);
    textColor(MAGENTA);
    clrscr;
    write(TEXT_HEADER2);
    restoreGameArea;
end;

procedure thatsItIQuit;
const
    QUIT_MSG = 'Are you sure that you want to quit? ';
    QUIT_BUTTON = '<Yes>';
var
    ch: Char;
begin
    restoreGameArea;
    cursoroff;
    // Write aligned to mid
    gotoxy(40 - length(QUIT_MSG + QUIT_BUTTON) div 2, 10);
    write(QUIT_MSG);
    useDefaultColors(True);
    write(QUIT_BUTTON);
    //gotoxy(wherex - length(QUIT_BUTTON) div 2 - 1, wherey);
    useDefaultColors;
    cursoron;
    // Wait to the needed characters
    repeat
        ch := readkey;
    until ch in SELECT_KEYS + ['y', 'Y', KEY_QUIT, KEY_HALT];
    window(X_MIN, Y_HEADER, X_MAX, Y_MAX);
    clrscr;
    // Halt the program
    halt(0);
end;

procedure readNum(var d: Double;
                  const isThereDefault: Boolean = False); overload;
var
    s: String; // temporarily store the current input
    x, ox: Byte; // the last position
    c: Char; // current input char
procedure addChar(const ch: Char); inline;
    begin
    if length(s) < 15 then
        begin
        s += ch;
        write(ch);
        end;
    end;
begin
    ox := wherex;

    if isThereDefault then
    begin
        s := floatToStr(d);
        write(s);
    end
    else
        s := '';

    repeat
        x := wherex;

        c := readkey;

        if c = KEY_HALT then
            halt;

        if c = KEY_BACKSPACE then
        begin
            if length(s) > 1 then
               s := leftStr(s, length(s)-1)
            else
                s := '';

            if x - ox > 0 then
            begin
                gotoxy(wherex - 1, wherey);
                write(' ');
                gotoxy(wherex - 1, wherey);
            end;
            continue;
        end;

        if c = KEY_DASH then
        begin
            if s = '' then
                addChar(KEY_DASH);
        end;

        if c = KEY_POINT then
        begin
            if pos(KEY_POINT, s) = 0 then
            begin
                if (s <> '') and (s <> KEY_DASH) then
                    addChar(KEY_POINT)
                else
                begin
                    addChar('0');
                    addChar(KEY_POINT);
                end;
            end;
        end;

        if c in KEYS_NUMBERS then
            addChar(c);

    until (c = KEY_RETURN) and (s <> '');

    if (pos(KEY_POINT, s) <> 0) and
       (KEY_POINT <> defaultFormatSettings.decimalSeparator) then
        s := replaceStr(s, KEY_POINT, defaultFormatSettings.decimalSeparator);

    if s = KEY_DASH then
        d := 0
    else
        d := strToFloat(s);

    writeln;
end;

procedure readNum(var i: Integer;
                  const isThereDefault: Boolean = False); overload;
var
    s: String; // temporarily store the current input
    x, ox: Byte; // the last position
    c: Char; // current input char
procedure addChar(const ch: Char); inline;
    begin
    if length(s) < 10 then // avoiding overflow
        begin
        s += ch;
        write(ch);
        end;
    end;
begin
    ox := wherex;

    if isThereDefault then
    begin
        s := intToStr(i);
        write(s);
    end
    else
        s := '';

    repeat
        x := wherex;

        c := readkey;

        if c = #0 then
        begin
            if tryStrToInt(s, i) then
            begin
                c := readkey;
                case c of
                    KEY_UP, KEY_LEFT: i -= 1;
                    KEY_DOWN, KEY_RIGHT: i += 1;
                end;
                gotoxy(ox, wherey);
                write(stringOfChar(' ', length(s)));
                gotoxy(ox, wherey);
                s := intToStr(i);
                write(s);
                continue;
            end;
        end;

        if c = KEY_HALT then
            halt;

        if c = KEY_BACKSPACE then
        begin
            if length(s) > 1 then
               s := leftStr(s, length(s)-1)
            else
                s := '';

            if x - ox > 0 then
            begin
                gotoxy(wherex - 1, wherey);
                write(' ');
                gotoxy(wherex - 1, wherey);
            end;
            continue;
        end;

        if c = KEY_DASH then
        begin
            if s = '' then
                addChar(KEY_DASH);
        end;

        if c in KEYS_NUMBERS then
            addChar(c);

    until (c = KEY_RETURN) and (s <> '');

    if (pos(KEY_POINT, s) <> 0) and
       (KEY_POINT <> defaultFormatSettings.decimalSeparator) then
        s := replaceStr(s, KEY_POINT, defaultFormatSettings.decimalSeparator);

    if s = KEY_DASH then
        i := 0
    else
        i := strToInt(s);

    writeln;
end;

procedure readBool(var b: Boolean;
                   const values: TBooleanStrings);
var
    idx: 0..1;
    c: Char;
    x, y: Byte;
begin

    if b then
        idx := 1
    else
        idx := 0;

    x := wherex;
    y := wherey;

    write(values[idx]);

    repeat
        c := readkey;
        case c of
            #0: begin
                    c := readkey;
                    case c of
                        KEY_UP, KEY_LEFT: idx := (idx + 1) mod 2;
                        KEY_DOWN, KEY_RIGHT: idx := abs(idx - 1) mod 2;
                    end;
                    gotoxy(x, y);
                    write(values[idx]);
                end;
            '0', 'f', 'h', 'n': begin
                                    idx := 0;
                                    gotoxy(x, y);
                                    write(values[idx]);
                                    c := KEY_RETURN;
                                end;
            '1', 't', 'i', 'y': begin
                                    idx := 1;
                                    gotoxy(x, y);
                                    write(values[idx]);
                                    c := KEY_RETURN;
                                end;
            KEY_HALT: halt; // aborted by user
        end;
    until c in SELECT_KEYS;
    writeln;

    b := idx = 1;
end;

function strSplit(str: String; len: Byte): TStringArray;
const
    NEWLINECHAR = '|';
    TABCHAR = '~';
    TABSEQUENCE = '        ';
var
    tmpS, s: String;
    tmpI: Integer;
    tmpSA: TStringArray = NIL;
procedure addText;
    begin
        tmpI := length(tmpSA);
        setLength(tmpSA, tmpI + 1);
        tmpSA[tmpI] := tmpS;
        tmpS := '';
    end;
procedure addLine(const empty: Boolean = False);
    begin
        tmpI += 1;
        setLength(strSplit, tmpI + 1);
        strSplit[tmpI] := ifThen(not empty, s, '');
    end;
begin
    // initializing
    str := trim(str);
    tmpS := '';

    // split the string by spaces, or max `len` long pieces
    for s in str do
    begin
        if (s <> ' ') and (length(tmpS + s) <= len)  then
        begin
            if s = NEWLINECHAR then
                begin
                    addText;
                    tmpS += s;
                    addText;
                end
            else
                begin
                    if s <> TABCHAR then
                        tmpS += s
                    else
                        tmpS += TABSEQUENCE;
                end;
        end
        else
            addText;
    end;
    addText;

    tmpI := 0;
    setLength(strSplit, tmpI + 1);
    strSplit[tmpI] := '';

    // put it back together
    for s in tmpSA do
    begin
        if (length(strSplit[tmpI]) + length(s) + 1) <= len then
        begin
            if length(strSplit[tmpI]) <> 0 then
                begin
                    if s <> NEWLINECHAR then
                        strSplit[tmpI] += ' ' + s
                    else
                        addLine(True);
                end
            else
                begin
                    if s <> NEWLINECHAR then
                        strSplit[tmpI] += s
                    else
                        addLine(True);
                end;
        end
        else
            addLine;
    end;
end;

function expressionToString(const e: TExpression;
                            const longOp: Boolean = False;
                            const width: Byte = 0;
                            const idxFmt: String = '%d: '): String; inline;
var
    s: TStringArray;
    c: Integer;
begin
    if e.cat = arithmetic then
        expressionToString := format(idxFmt + '%' + intToStr(width) + 'd %s %'
                                   + intToStr(width) + 'd = ',
                                     [e.idx,
                                      e.a,
                                      ifThen(longOp, e.o.nam, e.o.sign),
                                      e.b])
    else
    begin
        s := strSplit(format(e.text + ' ', [e.a, e.b]), X_MAX);
        for c := 0 to high(s) - 1 do
            expressionToString += s[c] + stringOfChar(' ',
                                                      X_MAX - length(s[c]));
        c += 1;
        if length(s[c]) <> X_MAX then
            expressionToString += s[c] + ' '
        else
            expressionToString += s[c];
    end;
end;

procedure expressionWriter(const e: TExpression;
                           const longOp: Boolean = False;
                           const width: Byte = 0;
                           const idxFmt: String = '%d: ';
                           const checkFirstTime: Boolean = True); inline;
var
    x, y: Byte;
begin
    write(expressionToString(e, longOp, width, idxFmt));

    if checkFirstTime and (isFirstTime[e.o.op]) then
    begin
        x := wherex;
        y := wherey;
        isFirstTime[e.o.op] := False;
        gotoxy(40, y);
        write(e.o.name);
        gotoxy(x, y);
    end;
end;

procedure useDefaultColors(const invert: Boolean = False); inline;
begin
    if invert then
        begin
            textColor(DEF_BCOLOR);
            textBackground(DEF_FCOLOR);
        end
    else
        begin
            textColor(DEF_FCOLOR);
            textBackground(DEF_BCOLOR);
        end;
end;

procedure restoreGameArea; inline;
begin
    window(X_MIN, Y_MIN, X_MAX, Y_MAX);
    useDefaultColors;
    clrscr;
end;

procedure writeMenu(const items: Array of TMenuItem;
                    const menuXMin: Byte = X_MIN; // X_MIN should be 1
                    const menuYMin: Byte = Y_MIN; // Y_MIN should be 1
                    const menuXMax: Byte = X_MAX;
                    const menuYMax: Byte = Y_MAX;
                    const step: Byte = 2;
                    const indexFormat: String = '[%d]';
                    const indexSeparator: String = ' ');
var
    i: Byte; // short for 'item'
    lI: Byte; // short for 'last item' -- it's also a test for fonts
    ch: Char;
    validKeys: Set of Char = SELECT_KEYS; // SELECT_KEYS should be [#13, #32]
    itemsLength: Byte;
procedure writeItem(const item: Byte; const highlight: Boolean;
                    const text: String = '');
    begin
    gotoxy(X_MIN, 1 + (item - 1) * step);
    useDefaultColors(highlight);
    write(format(indexFormat, [item]));
    if text <> '' then
        begin
        useDefaultColors;
        write(' ', text);
        end // end of if
    else
        gotoxy(wherex - 2, wherey);
    end; // end of procedure
begin
    cursoroff;
    itemsLength := length(items);

    window(menuXMin, menuYMin, menuXMax, menuYMax);

    for i := itemsLength downTo 1 do
    begin
        writeItem(i, False, items[i - 1].txt);
        include(validKeys, chr(48 + i));
    end;

    writeItem(i, True);

    repeat
        lI := i;
        ch := readkey;
        case ch of
            #0: begin
                    ch := readkey;
                    case ch of
                        KEY_UP, KEY_LEFT: i -= 1; // up, left
                        KEY_DOWN, KEY_RIGHT: i += 1; // down, right
                    end; // end of case of
                    if i < 1 then
                        i := itemsLength
                    else
                    begin
                        if i > itemsLength then
                            i := 1;
                    end; // end of else
                    writeItem(lI, False);
                    writeItem(i, True);
                end; // end of case
        end; // end of case of
    until ch in validKeys;

    if not (ch in SELECT_KEYS) then
        i := ord(ch) - 48;

    restoreGameArea;
    cursoron;

    items[i - 1].pro; // call the item's procedure
end;

procedure writeLongText(const txt: String);
const
    USER_HELP = 'Press <q> to exit, <Left> or <Right> to navigate.';
    HEIGHT = Y_MAX - Y_MIN;
var
    split: TStringArray;
    current_line: Integer;
    ch: Char;
procedure writeLastLine; inline;
    begin
        window(X_MIN, Y_LAST_LINE, X_MAX, Y_LAST_LINE);
        useDefaultColors(True);
        clrscr;
        write(USER_HELP);
    end;
procedure clearLastLine; inline;
    begin
        window(X_MIN, Y_LAST_LINE, X_MAX, Y_LAST_LINE);
        useDefaultColors;
        clrscr;
    end;
procedure writePage; inline;
    var
        c: Integer;
    begin
        clrscr;
        for c := current_line to current_line + HEIGHT - 1 do
        begin
            if c < length(split) then
                writeln(split[c]);
        end;
        if c + 1 < length(split) then
            write(split[c + 1]);
    end;
begin // --- writeLongText
    writeLastLine;
    restoreGameArea;
    split := strSplit(txt, X_MAX);
    current_line := 0;

    repeat

        writePage;

        ch := readkey;

        case ch of
            #0: begin
                    ch := readkey;
                    case ch of
                        KEY_UP: current_line -= 5;
                        KEY_DOWN: current_line += 5;
                        KEY_LEFT, KEY_PAGE_UP: current_line -= HEIGHT + 1;
                        KEY_RIGHT, KEY_PAGE_DOWN: current_line += HEIGHT - 1;
                    end;
                end;
            KEY_RETURN: current_line += 1;
            KEY_SPACE: current_line += HEIGHT;
            KEY_HALT: halt;
        end;

        if current_line < 0 then
            current_line := 0
        else
        begin
            if current_line > high(split) then
                current_line := high(split);
        end;
    until ch = KEY_QUIT;

    clearLastLine;
    restoreGameArea;
end;

function statisticsTextGenerator(const g: TGame; nog: Integer;
                                 const longOp: Boolean): String;
const
    GAME_TYPE: Array[0..1] of String = ('finite', 'infinite');
var
    e: TExpression;
    o: TOp;
    oc: TOperationCategory;
    tmpOA: TOpStatArray;
    tmpOCA: TOpCatStatArray;
    stg: String; // short for staisticsTextGenerator
    tmpS: String;
    tableHead: String;
    tableRow: String;
    tableAdditional: String;
    w: String;
begin
    w := intToStr(MAX_LEVEL); //intToStr(ifThen(nog > 0, nog, g.numberOfGames));
    tableHead := '%:3s: %' + w + 's   %' + w + 's   %' + w + 's|';
    tableRow := '~%s: %' + w + 'd   %' + w + 'd   %' + w + 'd';
    tableAdditional := '   (%d%%)';

    stg := 'This game was ' + GAME_TYPE[ord(nog <= 0)]
         + ' during which ' + intToStr(g.stats.count) + ' turn(s) has been '
         + 'played.||Used settings:|'
         + format('~%s: %d|~%s: %s|~%s: %d|~%s: %s|~%s: %s||',
                  ['Number of games', nog,
                   'Include non-arithmetic',
                   trim(BOOLEAN_VALUES[ord(g.includeNonArithmetic)]),
                   'Level of difficulty', g.level,
                   'Include negative numbers',
                   trim(BOOLEAN_VALUES[ord(g.includeNegative)]),
                   'Operator format', trim(OP_FORMAT_VALUES[ord(longOp)])]);

    {     + 'Number of expressions (by operation):|';
    tmpOA := g.stats.numberOfOp;
    for o in TOp do
        stg += format('~%s: %d|', [OPERATIONS[ord(o)].nam, tmpOA[o]]);
    stg += '|Correct answers by operation:|';
    tmpOA := g.stats.correct;
    for o in TOp do
        stg += format('~%s: %d|', [OPERATIONS[ord(o)].nam, tmpOA[o]]);
    stg += '|Wrong answers by operation:|';
    tmpOA := g.stats.wrong;
    for o in TOp do
        stg += format('~%s: %d|', [OPERATIONS[ord(o)].nam, tmpOA[o]]);}

    stg += '||Statistics by operation:|~';
    tmpS := format(tableHead,
                   ['op', '#',
                    resultToString(correct), resultToString(incorrect)]);
    stg += tmpS;
    stg += '~' + stringOfChar('-', length(tmpS)) + '|';
    tmpOA := g.stats.numberOfOp;
    for o in TOp do
    begin
        stg += format(tableRow,
                      [OPERATIONS[ord(o)].nam, tmpOA[o],
                       g.stats.correct[o], g.stats.wrong[o]]);
        if tmpOA[o] <> 0 then
            stg += format(tableAdditional,
                          [round(g.stats.correct[o]/tmpOA[o]*100)]);
        stg += '|'
    end;

    if g.includeNonArithmetic then
    begin
        stg += '||Statistics by Category:|~';
        tmpS := format(tableHead,
                       ['op', '#',
                        resultToString(correct), resultToString(incorrect)]);
        stg += tmpS;
        stg += '~' + stringOfChar('-', length(tmpS)) + '|';
        tmpOCA := g.stats.numberByCat;
        for oc in TOperationCategory do
        begin
            stg += format(tableRow,
                          [OPERATIONS[ord(oc)].nam, tmpOCA[oc],
                           g.stats.correctByCat[oc], g.stats.wrongByCat[oc]]);
            if tmpOCA[oc] <> 0 then
                stg += format(tableAdditional,
                              [round(g.stats.correctByCat[oc]/tmpOCA[oc]*100)]);
            stg += '|'
        end;
    end;

    tableHead := '%-' + intToStr(g.level + ord(g.includeNegative)) + 'd';
    tmpS := ': %' + w + 'd %s %' + w + 'd = %-5s   user: %-15s   %-15s   %s|';
    stg += '||List of expressions (in order):|';
    for e in g.stats.expressions do
        stg += format(tableHead + tmpS,
                      [e.idx, e.a,
                       ifThen(longOp, e.o.nam, e.o.sign), e.b, e.result,
                       e.userResult, resultToString(e.isCorrect),
                       categoryToString(e.cat)]);

    stg += '||Thanks for playing ' + PROGRAM_NAME + ' (' + PROGRAM_VERSION
         + ')! We wish the best for you, and if you have not been the best '
         + 'player of all, then never forget: everything is gonna be better '
         + '(at least that is what they told me).||'
         + 'Generated at ' + formatDateTime('YYYY. MM. DD. hh:mm.', NOW);

    statisticsTextGenerator := stg;
end;

function validateString(const s: String): String;
const
    VALID = KEYS_LOWCHAR + [KEY_POINT] + KEYS_UPCHAR + KEYS_NUMBERS
          + [KEY_UNDERSCORE, KEY_DASH, KEY_TILDE];
var
    c: Char;
begin
    if s = '' then
        exit('');

    validateString := '';
    for c in s do
    begin
        if c in VALID then
           validateString += c;
    end;
end;

procedure writeToFile(s: String; fn: String = '');
var
    split: TStringArray;
    f: TextFile;
begin
    split := strSplit(s, X_MAX - X_MIN);

    fn := validateString(fn);

    if fn = '' then
        fn := FILENAME_PREFIX
            + formatDateTime('YYYY_MM_DD_hh_mm_ss', NOW) + '.txt';

    assignFile(f, fn);

    try
        rewrite(f);
        for s in split do
            writeln(f, s);
        closeFile(f);
        writeln(fn, ' has been written.');
    except on e: EInOutError do
        writeln('The file was not written due to unforeseen circumstances. ',
                'Details: ', e.className, '/', e.message);
    end;
end;

function randomTextHeader(): String;
const
    texts: Array[1..10] of String = (
        '         Placeholder texts',
        '   TODO: put texts *here*.',
        'Math is Fun! or is it not?',
        'Art thou a master of Math?',
        '    Pascal wasn''t my idea',
        'Uses Modified BSD License!',
        '   Hello? Is anyone there?',
        '     Leibniz was cool too.',
        '                  HELP ME!',
        '    a.k.a. Ae. Dschorsaanjo'
    );
var
    r: Integer;
begin
    r := random(length(texts)) + low(texts);
    randomTextHeader := texts[r];
end;

initialization // --------------------------------------------------------------

TEXT_HEADER := format('%s %s (%s) by %s', [PROGRAM_NAME, PROGRAM_VERSION,
                                           PROGRAM_DATE, PROGRAM_DEVELOPER]);
TEXT_HEADER2 := randomTextHeader();
end.
