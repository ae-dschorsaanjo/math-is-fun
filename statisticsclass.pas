(* Copyright 2018 B. Zoltán Gorza
 * 
 * This file is part of Math is Fun!, released under the Modified BSD License.
 *)

{ Statistics class and its supporting types. }
unit StatisticsClass;

{$mode objfpc}
{$H+}

interface

uses
    OperationClass,
    ExpressionClass;

type
    { Defines an Array of TExpression. }
    TExpressionArray = Array of TExpression;

    { Operation Statistics Array, indexed by @link(TOp). }
    TOpStatArray = Array[TOp] of Integer;
    { Operation Category Statistics Array,
      indexed by @link(TOperationCategory). }
    TOpCatStatArray = Array[TOperationCategory] of Integer;
    { Operation Statistics By Operation Category Array.}
    TOpStatByCatArray = Array[TOperationCategory, TOp] of Integer;

    { Contains statistics of a series of @link(TExpression expressions) of a
      single game.

      It stores only an @link(TExpressionArray expression array), every
      other value is processed, but not saved. It does NOT format any output,
      that is up to the output functions!}
    TStatistics = class
    private
        _expr: TExpressionArray;
        function _lastExpression: TExpression;
        function _correct: TOpStatArray;
        function _wrong: TOpStatArray;
        function _correctByCat: TOpCatStatArray;
        function _wrongByCat: TOpCatStatArray;
        function _numberOfOpByCat: TOpStatByCatArray;
        function _number: TOpStatArray;
        function _numberByCat: TOpCatStatArray;
    public
        {  }
        property expressions: TExpressionArray read _expr;
        { The last expressions in the Expression array. }
        property lastExpression: TExpression read _lastExpression;
        { List of @link(correct) answers by @link(TOp operation). }
        property correct: TOpStatArray read _correct;
        { List of @link(incorrect wrong) answers by @link(TOp operation). }
        property wrong: TOpStatArray read _wrong;
        { List of @link(correct) answers by @link(TOperationCategory category).}
        property correctByCat: TOpCatStatArray read _correctByCat;
        { List of @link(incorrect) answers by
          @link(TOperationCategory category). }
        property wrongByCat: TOpCatStatArray read _wrongByCat;
        { Number of expressions by @link(TOperationCategory category) and
          @link(TOp operation). }
        property numberOfOpByCat: TOpStatByCatArray read _numberOfOpByCat;
        { Number of expressions by @link(TOp operation). }
        property numberOfOp: TOpStatArray read _number;
        { Number of expressions by @link(TOperationCategory category). }
        property numberByCat: TOpCatStatArray read _numberByCat;
        { Constructor. Simple, elegant, no parameters. }
        constructor create;
        { Returns the length of @link(TExpression expressions) stored 
          in this class. }
        function count: Integer;
        { Adds a new expression to the @link(TExpression expressions) stored in
          this class.
          @param(e Expression) }
        procedure addExpression(const e: TExpression);
    end;

implementation // --------------------------------------------------------------

constructor TStatistics.create;
begin
    setLength(_expr, 0);
end;

function TStatistics._lastExpression: TExpression;
begin
    _lastExpression := _expr[high(_expr)];
end;

function TStatistics._correct: TOpStatArray;
var
    e: TExpression;
    c: TOp;
begin
    for c in TOp do
        _correct[c] := 0;
        
    for e in _expr do
    begin
        if resultToBoolean(e.isCorrect) then
            _correct[e.o.op] += 1;
    end;
end;

function TStatistics._wrong: TOpStatArray;
var
    e: TExpression;
    c: TOp;
begin
    for c in TOp do
        _wrong[c] := 0;
        
    for e in _expr do
    begin
        if not resultToBoolean(e.isCorrect) then
            _wrong[e.o.op] += 1;
    end;
end;

function TStatistics._correctByCat: TOpCatStatArray;
var
    e: TExpression;
    c: TOperationCategory;
begin
    for c in TOperationCategory do
        _correctByCat[c] := 0;
        
    for e in _expr do
    begin
        if resultToBoolean(e.isCorrect) then
            _correctByCat[e.cat] += 1;
    end;
end;

function TStatistics._wrongByCat: TOpCatStatArray;
var
    e: TExpression;
    c: TOperationCategory;
begin
    for c in TOperationCategory do
        _wrongByCat[c] := 0;
        
    for e in _expr do
    begin
        if not resultToBoolean(e.isCorrect) then
            _wrongByCat[e.cat] += 1;
    end;
end;

function TStatistics._numberOfOpByCat: TOpStatByCatArray;
var
    e: TExpression;
    c: TOperationCategory;
    cc: TOp;
begin
    for c in TOperationCategory do
    begin
        for cc in TOp do
            _numberOfOpByCat[c, cc] := 0;
    end;

    for e in _expr do
        _numberOfOpByCat[e.cat, e.o.op] += 1;
end;

function TStatistics._number: TOpStatArray;
var
    e: TExpression;
    c: TOp;
begin
    for c in TOp do
        _number[c] := 0;
        
    for e in _expr do
        _number[e.o.op] += 1;
end;

function TStatistics._numberByCat: TOpCatStatArray;
var
    e: TExpression;
    c: TOperationCategory;
begin
    for c in TOperationCategory do
        _numberByCat[c] := 0;
        
    for e in _expr do
        _numberByCat[e.cat] += 1;
end;

function TStatistics.count: Integer;
begin
    count := length(_expr);
end;

procedure TStatistics.addExpression(const e: TExpression);
var
    oldLength: Integer;
begin
    oldLength := length(_expr);
    setLength(_expr, oldLength + 1);
    _expr[oldLength] := e;
end;

end.
