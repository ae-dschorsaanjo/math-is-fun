{ Copyright 2018-2024 B. Zoltán Gorza
  This file is part of Math is Fun!, released under the Modified BSD License. }

program MathIsFun;

{$mode objfpc}
{$H+}

uses
    Crt,
    Math,
    StrUtils,
    SysUtils,
    OperationClass,
    ExpressionClass,
    GameClass,
    NumberIO;

var
    { Gameplay settigns. }
    settings: TSettings = (nog: 10; incNA: False; lvl: 2; incNeg: False);
    { Display setting, does not alter gameplay. }
    useLongOperationMarks: Boolean = False;

{ Starts a new game based on current settings. }
procedure newGame;
var
    game: TGame;
    userInput: Double;
    b: Boolean;
    fn: String;
    i: Integer;
begin
    game := TGame.create(settings.nog,
                         settings.incNA,
                         settings.lvl,
                         settings.incNeg);

    // main loop
    repeat
        if settings.nog > 0 then
            i := round(log10(settings.nog)) + 1
        else
            i := 4;
        expressionWriter(game.newTurn, useLongOperationMarks,
                         settings.lvl + ord(settings.incNeg),
                         '%' + intToStr(i) + 'd: ');
        readNum(userInput);
    until game.doContinue(userInput);

    writeln;

    b := False;
    write('Would you like to write the statistics into a file? ');
    readBool(b, YES_NO_VALUES);
    writeln;

    if b then
    begin
        writeln('Please give a filename (with extension --');
        write(  '    leave empty for default filename): ');
        readln(fn);
        writeToFile(statisticsTextGenerator(game, settings.nog,
                                            useLongOperationMarks));
    end;
    writeln;

    b := True;
    write('Would you like to read the statistics now? ');
    readBool(b, YES_NO_VALUES);

    if b then
        writeLongText(statisticsTextGenerator(game, settings.nog,
                                              useLongOperationMarks));

    restoreGameArea;
end;

{ Handles the Settings menu item. }
procedure doSettings;
const
    TEXT_LENGTH = 41;
    TEXTS: Array[1..5] of String = ('Number of games',
                                    'Include text based problems',
                                    'Level',
                                    'Include negative numbers',
                                    'Operation format');
    DESCRIPTIONS: Array[1..5] of String = (
        'The total number of games. If 0, then "infinite mode"   will be '
      + 'activated.',
        'If True, then not only "a R b = x" kind of problem will be used '
      + '(there is about 3% chance for that).',
        'Level or difficulty. The generated numbers will be      '
      + 'maximum 10^level.',
        'If True, then negative numbers will be generated too.',
        'The Short format is the usual 1 character long mark     (such as ''+'''
      + '), while the long format is a 3 character   long text '
      + '(such as ''add'').');
var
    i, x, y: Byte;
    s: String;
procedure writeLvl(const lvl: TLevel);
    const
        C: Array[1..5] of Byte = (GREEN, LIGHTGREEN, WHITE, LIGHTRED, RED);
    begin
        textColor(C[lvl]);
        write(lvl);
        useDefaultColors;
    end;
procedure readLvl(var lvl: TLevel);
    var
        c: Char;
        x, y: Byte;
    begin
        x := wherex;
        y := wherey;
        writeLvl(lvl);

        repeat
            c := readkey;
            case c of
                #0: begin
                        c := readkey;
                        case c of
                            KEY_UP, KEY_LEFT: begin
                                              if lvl > 1 then
                                                  lvl -= 1;
                                              end;
                            KEY_DOWN, KEY_RIGHT: begin
                                                 if lvl < 5 then
                                                     lvl += 1;
                                                 end;
                        end;
                    end;
                '1': lvl := 1;
                '2': lvl := 2;
                '3': lvl := 3;
                '4': lvl := 4;
                '5': lvl := 5;
            end;
            gotoxy(x, y);
            writeLvl(lvl);
        until c in SELECT_KEYS;
        writeln;
    end;
begin // --- implementation of doSettings
    // initialization
    clrscr;
    window(10, 7, 65, 23);
    useDefaultColors;
    clrscr;

    for i := 1 to 5 do
    begin
        // Stringify item
        case i of
            1: s := intToStr(settings.nog);
            2: s := BOOLEAN_VALUES[ord(settings.incNA)];
            3: s := intToStr(settings.lvl);
            4: s := BOOLEAN_VALUES[ord(settings.incNeg)];
            //4: s := ifThen(settings.incNeg, 'True', 'False');
            5: s := OP_FORMAT_VALUES[ord(useLongOperationMarks)];
        end;

        // Write item
        write(format('%:' + intToStr(TEXT_LENGTH) + 's: ',
                     [format('%s (%s)', [TEXTS[i], trim(s)])]));

        // Write description
        x := wherex;
        y := wherey;
        gotoxy(1, 12);
        write(stringOfChar(' ', 100));
        gotoxy(1, 12);
        write(DESCRIPTIONS[i]);
        gotoxy(x, y);

        // Read setting
        case i of
            1: readNum(settings.nog, True);
            2: readBool(settings.incNA, BOOLEAN_VALUES);
            3: readLvl(settings.lvl);
            4: readBool(settings.incNeg, BOOLEAN_VALUES);
            5: readBool(useLongOperationMarks, OP_FORMAT_VALUES);
        end;

        // Ensure the good-looking and obviousity of the Number of Games
        if settings.nog < 0 then
            settings.nog := 0;

        // Reset
        useDefaultColors;
        writeln;
    end;

    // Clean up
    restoreGameArea;
    clrscr;
end;

function help: String;
var
    e: TExpression;
    o: TOp;
begin
    e := expressionGenerator(False, 1, False);
    help := 'Welcome to the ' + PROGRAM_NAME + ' ' + PROGRAM_VERSION + ' that '
          + 'is written by ' + PROGRAM_DEVELOPER + ' for your entertainment. '
          + 'This little text is only an introduction of the help that I am '
          + 'about to give you.|Please, enjoy!||'
          + 'What is this all about?|'
          + '-----------------------|'
          + 'This is a game where you have to calculate simple equasion, prefe'
          + 'rable without using a calculator (although the program cannot '
          + 'detect whether you use one or not).||'
          + 'How to play?|'
          + '------------|'
          + 'After you started a new game you should see expressions like this'
          + ' one:|~' + expressionToString(e, False)
          + '|or this one:|~'
          + expressionToString(e, True) + '|'
          + 'In both cases the expression is generated (i.e. if you exit and '
          + 'reenter this help, then you probably see different expressions.|'
          + 'Naturally the result of both is ' + e.result + '.'
          + 'If you want to exit a current game, then you sadly have to halt '
          + 'the program by the well known ^C (a.k.a. Ctrl+C) key, but be '
          + 'aware of the fact that you shall lose your current gameplay for '
          + 'good.||'
          + 'Operations|'
          + '----------|'
          + 'These are the operations that you might see in the game:|';

    for o in TOp do
    begin
        help += format('name: %:-17s    sign: %s    long format: %s|',
                       [OPERATIONS[ord(o)].name,
                        OPERATIONS[ord(o)].sign,
                        OPERATIONS[ord(o)].nam]);
    end;

    help += '|Here are some example how you might see them in the game (the '
          + 'used sign within expressions are depends on the settings, '
          + 'the current setting is "'
          + lowercase(OP_FORMAT_VALUES[ord(useLongOperationMarks)]) + '"): |';

    for o in TOp do
    begin
        e := expressionGenerator(False, 1, False, o);
        help += format('~%s%s%s|', [expressionToString(e),
                                    expressionToString(e, True),
                                    e.result]);
    end;

    help += '|Of course the game is not this simple usually, only if your '
          + 'settings dictates so, which reminds me...||'
          + 'Settings|'
          + '--------|'
          + 'There are 5 possible settings in the game that are described '
          + 'enough within the settings, so I will not describe them again '
          + 'here.|I will thell you though that which settings you should use'
          + ' to get such easy equasions as above:|'
          + 'Include non arithmetic...: False|Level: 1|Include negative: False'
          + '.||'
          + 'Conclusion|'
          + '----------|'
          + 'Thank you for playing this little game, I hope you will/do/did '
          + 'enjoy it, at least as much as I did writing it :)||You''re welcome'
          + ',|' + PROGRAM_DEVELOPER + ' ' + PROGRAM_DEV_CONTACT;
end;

{ This procedure shall provide the help from the menu. }
procedure giveSomeHelp;
begin
    cursoroff;
    writeLongText(help);
    cursoron;
end;

{ Main loop.

  Contains an infinite loop, since the menu's Exit options halts the program. }
procedure mainMenu;
const
    items: Array[1..4] of TMenuItem = ((txt: 'New Game'; pro: @newGame),
                                       (txt: 'Settings'; pro: @doSettings),
                                       (txt: 'Help'; pro: @giveSomeHelp),
                                       (txt: 'Exit'; pro: @thatsItIQuit));
begin
    repeat
        writeMenu(items, 30, 8, 50, 16);
    until False; // there is an Exit option in the menu that handles Exit.
end;

// ---------------------------------- main ---------------------------------- //

begin
    theBeginning;
    mainMenu;
end.

