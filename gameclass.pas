(* Copyright 2018 B. Zoltán Gorza
 * 
 * This file is part of Math is Fun!, released under the Modified BSD License.
 *)

{ Game class, this class is responsible to hold everything together.
  It also provides a very minimalistic interface to keep things under control. }
unit GameClass;

{$mode objfpc}
{$H+}

interface

uses
    OperationClass,
    ExpressionClass,
    StatisticsClass;

type
    { Level of difficulty.
      @seealso(expressionGenerator) }
    TLevel = 1..5;

    { Container record for available settings. }
    TSettings = record
        { Number of games (0 for intinite -- default: 10)}
        nog: Integer;
        { Include non-arithmetic expressions (default: @false)}
        incNA: Boolean;
        { Level of difficulty (default: 2) }
        lvl: TLevel;
        { Include negative numbers (default: False) }
        incNeg: Boolean;
    end;

    { The holy game class. }
    TGame = class
    private
        _nog: Integer;
        _incNA: Boolean;
        _lvl: TLevel;
        _incNeg: Boolean;
        _stats: TStatistics;
        _cg: Integer;
        function _isFiniteGame: Boolean; inline;
        function _finiteGame: Boolean; inline;
        function _infiniteGame: Boolean; inline;
    public
        { The number of currently played games. }
        property numberOfGames: Integer read _cg;
        {  }
        property includeNonArithmetic: Boolean read _incNA;
        { Level of difficulty. }
        property level: TLevel read _lvl;
        {  }
        property includeNegative: Boolean read _incNeg;
        { }
        property stats: TStatistics read _stats;
        { Contructor
          @param(nog Number of games)
          @param(incNA Include non-arithmetic)
          @param(lvl Level of difficulty)
          @param(incNeg Include negative numbers) }
        constructor create(const nog: Integer;
                           const incNA: Boolean;
                           const lvl: TLevel;
                           const incNeg: Boolean); // options goes here
        { Increases the @(numberOfGames current turn) and generates a new
          expression. }
        function newTurn: TExpression;
        { Gives the user's input tot he expression instance and
          returns a boolean value depending on whether the game is finite
          or infinite.

          This is used in the main loop, that is implemented in the
          program itself (hence the backend is independent from the
          @link(numberio frontend). }
        function doContinue(const userInput: Double): Boolean; inline;
    end;

    TText = (normal, out);

const
    // as they are defined in TLevel
    { Minimum @link(TLevel level) }
    MIN_LEVEL = 1;
    { Maximum @link(TLevel level) }
    MAX_LEVEL = 5;

// function randomGenerator(const lvl: TLevel; const incNeg: Boolean): Integer;

{ @link(TExpression Expression) generator function. Takes the settings as
  parameters and the index.
  @param(incNA Include non-arithmetic)
  @param(lvl Level of difficulty)
  @param(incNeg Include negative numbers)
  @param(index Intex)
  @return(Our fancy new expression)}
function expressionGenerator(const incNA: Boolean;
                             const lvl: TLevel;
                             const incNeg: Boolean;
                             const index: Integer = 0): TExpression; overload;

{ @link(TExpression Expression) generator function. Takes the settings as
  parameters and the index.
  @param(incNA Include non-arithmetic)
  @param(lvl Level of difficulty)
  @param(incNeg Include negative numbers)
  @param(o Operation type)
  @return(Our fancy new expression)}
function expressionGenerator(const incNA: Boolean;
                             const lvl: TLevel;
                             const incNeg: Boolean;
                             const o: TOp): TExpression; overload;

implementation // --------------------------------------------------------------

uses
    Math;

const

    { Defines the number of easy operations, used during random generation. }
    EASYOP = 4; //< 0: add, 1: sub, 2: mul, 3: div
    { Non-arithmetic problems' texts. }
    TEXTS: Array[0..1, 0..3, TText] of String = (
        (('If Pete has %d apples and Jacky has %d, then how many apples do they'
        + ' have together?', 'They have %d apples.'),
         ('When Peter has %d apples but gives Jackie %d of them, how many'
        + ' apples do Peter have?', 'He has %d apples.'),
         ('If Pete had %d apples during the first year and he got the same '
        + 'amount of apple every year for %d years, how many apple does he '
        + ' have now?', 'He has %d apples.'),
         ('If Petey had %d apple and he has %d friends to whom he want to give'
        + ' the same amount of apple, how many apples will everyone have '
        + '(including Petey, who likes apples too)?', 'Everyone should have'
        + ' %d apples.')),

        (('', ''),
         ('', ''),
         ('', ''),
         ('', ''))
    );
    { Tricky non-arithmetic problems' texts. }
    FUN_TEXTS: Array[0..1, 0..3, TText] of String = (
        (('You have %d pines and %d apples. How many pineapples you have?',
          'You have %d (pines and apples don''t make any pineapples, duh!'),
         ('You''ve %d platypi and %d kiwis. How many of these are able to fly?',
          'Exactly! At least if you wrote %d.'),
         ('How many is %d times %d nothing?', '%d.'),
         ('There are %d birds (pigeons, crows, whatever) on a wire and you shoot'
        + ' %d of them. How many remains?',
          'They''re scared dude, there''s %d!')),

        (('If there are little houses on a hillside, and there are %d pink ones'
        + ', 1 green one, 1 blue one and %d yellow, then how many of them are'
        + ' unique designs?', '%d, because "Little boxes on the hillside \ '
        + 'Little boxes made of ticky-tacky \ Little boxes on the hillside \'
        + ' Little boxes all the same..."'),
         ('', ''),
         ('', ''),
         ('', ''))
    );

function randomGenerator(const lvl: TLevel; const incNeg: Boolean): Integer;
begin
    if not incNeg then
        randomGenerator := random(trunc(power(10, lvl)))
    else
        randomGenerator := random(
            trunc(power(10, lvl) * 1.5)) - trunc(power(10, lvl) * 0.5);
        //randomGenerator := random(power(10, lvl) * 2) - power(10, lvl);
end;

function expressionGenerator(const incNA: Boolean;
                             const lvl: TLevel;
                             const incNeg: Boolean;
                             const index: Integer = 0): TExpression; overload;
var
    mode: TOperationCategory;
    tmpI, tmpI2: Integer;
    txt: String;
    outTxt: String;
    o: TOperation;
begin
    // initialize
    txt := '';
    outTxt := '';

    // initialize mode
    if incNA then
    begin
        tmpI := randomGenerator(2, False);
        case tmpI of
            72, 99: mode := text;
            42: mode := tricky;
            else mode := arithmetic;
        end;
    end
    else
        mode := arithmetic;

    // initialize operation and texts (if needed)
    if mode <> arithmetic then
    begin
        tmpI2 := random(EASYOP);
        if mode = text then
            begin
            tmpI := random(length(TEXTS));
            txt := TEXTS[tmpI, tmpI2, normal];
            outTxt := TEXTS[tmpI, tmpI2, out];
            end
        else
            begin
            if mode = tricky then
                begin
                tmpI := random(length(FUN_TEXTS));
                txt := FUN_TEXTS[tmpI, tmpI2, normal];
                outTxt := FUN_TEXTS[tmpI, tmpI2, out];
                end;
            end;
    end
    else
        tmpI2 := random(NOO);

    o := OPERATIONS[tmpI2];

    expressionGenerator := TExpression.create(randomGenerator(lvl, incNeg),
                                              randomGenerator(lvl, incNeg),
                                              o,
                                              index,
                                              mode,
                                              txt,
                                              outTxt);
end;

function expressionGenerator(const incNA: Boolean;
                             const lvl: TLevel;
                             const incNeg: Boolean;
                             const o: TOp): TExpression; overload;
const
    index = 0;
var
    mode: TOperationCategory;
    tmpI, tmpI2: Integer;
    txt: String;
    outTxt: String;
begin
    // initialization
    txt := '';
    outTxt := '';

    // initialize mode
    if incNA then
    begin
        tmpI := randomGenerator(2, False);
        case tmpI of
            72, 99: mode := text;
            14: mode := tricky;
            else mode := arithmetic;
        end;
    end
    else
        mode := arithmetic;

    // initialize texts by the gotten operation (if needed)
    if mode <> arithmetic then
    begin
        tmpI2 := ord(o) mod EASYOP;
        if mode = text then
            begin
            tmpI := random(length(TEXTS));
            txt := TEXTS[tmpI, tmpI2, normal];
            outTxt := TEXTS[tmpI, tmpI2, out];
            end
        else
            begin
            if mode = tricky then
                begin
                tmpI := random(length(FUN_TEXTS));
                txt := FUN_TEXTS[tmpI, tmpI2, normal];
                outTxt := FUN_TEXTS[tmpI, tmpI2, out];
                end;
            end;
    end
    else
        tmpI2 := ord(o);

    expressionGenerator := TExpression.create(randomGenerator(lvl, incNeg),
                                              randomGenerator(lvl, incNeg),
                                              OPERATIONS[tmpI2],
                                              index,
                                              mode,
                                              txt,
                                              outTxt);
end;

constructor TGame.create(const nog: Integer;
                         const incNA: Boolean;
                         const lvl: TLevel;
                         const incNeg: Boolean);
begin
    _nog := nog;
    _incNA := incNA;
    _lvl := lvl;
    _incNeg := incNeg;
    _stats := TStatistics.create;
    _cg := 0;
end;

function TGame._isFiniteGame: Boolean; inline;
begin
    _isFiniteGame := _nog > 0;
end;

function TGame._finiteGame: Boolean; inline;
begin
    _finiteGame := _nog <= _cg;
end;

function TGame._infiniteGame: Boolean; inline;
begin
    _infiniteGame := _stats.lastExpression.isCorrect <> correct;
end;

function TGame.newTurn: TExpression;
var
    e: TExpression;
begin
    _cg += 1;
    e := expressionGenerator(_incNA, _lvl, _incNeg, _cg);
    _stats.addExpression(e);
    newTurn := e;
end;

function TGame.doContinue(const userInput: Double): Boolean; inline;
begin
    _stats.lastExpression.getUserInput(userInput);

    if _isFiniteGame then
        doContinue := _finiteGame
    else
        doContinue := _infiniteGame;
end;

initialization

randomize;

end.
