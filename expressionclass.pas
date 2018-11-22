(* Copyright 2018 B. Zoltán Gorza
 * 
 * This file is part of Math is Fun!, released under the Modified BSD License.
 *)

{ Expression class, and its supporting types and functions. }
unit ExpressionClass;

{$mode objfpc}
{$H+}

interface

uses
    OperationClass;

type
    { Operation category that is not marked or used in the TOperation class. }
    TOperationCategory = (arithmetic, text, tricky);
    
    { Set of statuses of possible results. }
    TResult = (correct, incorrect, unknown);
    
    { The mighty class that contains every needed data about an expression. }
    TExpression = class
    private
        _a, _b: Integer;
        _o: TOperation;
        _r: Double;
        _uR: Double;
        _iC: TResult;
        _oC: TOperationCategory;
        _idx: Integer;
        _text: String;
        _outText: String;
        procedure validateExpression;
        function niceResult: String;
        function niceUserResult: String;
    public
        { First constant }
        property a: Integer read _a;
        { Second constant }
        property b: Integer read _b;
        { Operation }
        property o: TOperation read _o;
        { Operation category }
        property cat: TOperationCategory read _oC;
        { Index (used for outputs about statistics) }
        property idx: Integer read _idx;
        { Text for non-arithmetic expressions, this is the text that is shown
          instead of a regulas "a R b = x" formula.
          @seealso(TOperationCategory)}
        property text: String read _text;
        { This is the result of non-arithmetic expressions.
          @seealso(TOperationCategory) }
        property outText: String read _outText;
        { Formatted result }
        property result: String read niceResult;
        { Formatted user's result  }
        property userResult: String read niceUserResult;
        { The result status. }
        property isCorrect: TResult read _iC;
        { Constructor of the class.
          @param(ao First constant)
          @param(bo Second constant)
          @param(oo Operation)
          @param(io Index)
          @param(oc Operation category)
          @param(t Text)
          @param(ot Out text or Result text) }
        constructor create(const ao: Integer;
                           const bo: Integer;
                           const oo: TOperation;
                           const io: Integer;
                           const oc: TOperationCategory;
                           const t: String = '';
                           const oT: String = '');
        { User input processer procedure. }
        procedure getUserInput(uI: Double);
    end;
    
{ Returns a string representation of a @link(TResult result).
  @param(r The result to be a string.}
function resultToString(const r: TResult): String;

{ Returns the according Boolean value of a @link(TResult result).
  @param(r The result to be a boolean.)
  @return(@true if correct, @false otherwise.) }
function resultToBoolean(const r: TResult): Boolean;

{ Return a string representation of an @link(TOperationCategory operation
  category).
  @param(c The category) }
function categoryToString(const c: TOperationCategory): String;

implementation // --------------------------------------------------------------

uses
    Math,
    SysUtils;

procedure prepareForDiv(var a: Integer; var b: Integer);
var
    tmp: Integer;
begin
    if a < b then
    begin
        tmp := a;
        a := b;
        b := tmp;
    end;
    
    b := b div 2;
    
    if b = 0 then
        b := 1;
end;

procedure TExpression.validateExpression;
begin
    case _o.op of
        dvi, ind, mdu: prepareForDiv(_a, _b);
        mul: _b := _b div 7;
        //exo: _b := _b mod 5;
    end;
end;

constructor TExpression.create(const ao: Integer;
                               const bo: Integer;
                               const oo: TOperation;
                               const io: Integer;
                               const oc: TOperationCategory;
                               const t: String = '';
                               const oT: String = '');
begin
    _a := ao;
    _b := bo;
    _o := oo;
    _oC := oc;
    _idx := io;
    validateExpression;
    if _oC <> tricky then
        _r := _o.func(_a, _b)
    else
        _r := 0.0;
    _iC := unknown;
    _text := t;
    _outText := oT;
end;

function TExpression.niceResult: String;
begin
    niceResult := formatFloat('0.##', _r);
end;

function TExpression.niceUserResult: String;
begin
    niceUserResult := formatFloat('0.##', _uR);
end;

procedure TExpression.getUserInput(uI: Double);
begin
    if _iC = unknown then
    begin
        _uR := uI;
        if niceResult = niceUserResult then
            _iC := correct
        else
            _iC := incorrect;
    end;
end;

function resultToString(const r: TResult): String;
begin
    case r of
        correct: resultToString := ':D'; //'Correct :D';
        incorrect: resultToString := ':('; //'Incorrect:''(';
        unknown: resultToString := ':/'; //'Unknown :/';
   end;
end;

function resultToBoolean(const r: TResult): Boolean;
begin
    if r = correct then
        resultToBoolean := True
    else
        resultToBoolean := False;
end;

function categoryToString(const c: TOperationCategory): String;
begin
    case c of
        arithmetic: categoryToString := 'arithmetic';
        text: categoryToString := 'text';
        tricky: categoryToString := 'tricky';
    end;
end;

end.
