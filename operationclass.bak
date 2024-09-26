(* Copyright 2018 B. Zoltán Gorza
 * 
 * This file is part of Math is Fun!, released under the Modified BSD License.
 *)

{ This is the unit of the TOperation class and its supporting types. }
unit OperationClass;

{$mode objfpc}
{$H+}

interface

type
    { Pointer of an operation function }
    POperationFunction = function(const a: Integer; const b: Integer): Double;

    { 3 characters long short name }
    TShortName = String[3];
    { General name (variable long) }
    TName = String;

    { Set of operations --- used in some classes, but should not be used
                            explicitely! }
    TOp = (add, sub, mul, dvi, ind, mdu{, exo});

    { This class contains every needed information of an operation
      and the function that is used for this operation. }
    TOperation = class
    private
        _op: TOp;
        _sign: Char;
        _nam: TShortName;
        _name: TName;
        _func: POperationFunction;
    public
        { The sign of an operation (e.g. '+', '/'... }
        property sign: Char read _sign;
        { Short name of an operation (e.g. 'add', 'div'... }
        property nam: TShortName read _nam;
        { Name of an operation (e.g. 'addition, 'division'... }
        property name: TName read _name;
        { The function of an operation that is used for calculations. }
        property func: POperationFunction read _func;
        { The type of this operation. }
        property op: TOp read _op;
        { Constructor of an operation.
          @param(o Operation)
          @param(s Sign)
          @param(n3 Short name)
          @param(n Name)
          @param(f Function) }
        constructor create(const o: TOp;
                           const s: Char;
                           const n3: TShortName;
                           const n: TName;
                           const f: POperationFunction);
    end;

    { Fixed long array of operations
      @seealso(NUMBER_OF_OPERATIONS)}
    TOperationArray = Array[0..5{6}] of TOperation;

const
    { Number of operations }
    NUMBER_OF_OPERATIONS = 6; // 7 ;
    { Shorthand for Number Of Operations
      @seealso(NUMBER_OF_OPERATIONS)}
    NOO = NUMBER_OF_OPERATIONS;
    { Constant array of operations, contains a @link(TOperation) instance for
      every operation.

      Initially its values are @nil, but it gets new values during
      initialization that are used.
      @seealso(TOperation)
      @seealso(TOperationArray)}
    OPERATIONS: TOperationArray = (Nil, Nil, Nil, Nil, Nil, Nil); // , Nil);

//function modulo(const a: Integer; const b: Integer): Double; // just for tests

implementation // --------------------------------------------------------------

uses
    Math;

constructor TOperation.create(const o: TOp;
                              const s: Char;
                              const n3: TShortName;
                              const n: TName;
                              const f: POperationFunction);
begin
    _op := o;
    _sign := s;
    _nam := n3;
    _name := n;
    _func := f;
end;

function addition(const a: Integer; const b: Integer): Double;
begin
    addition := a + b;
end;

function subtraction(const a: Integer; const b: Integer): Double;
begin
    subtraction := a - b;
end;

function multiplication(const a: Integer; const b: Integer): Double;
begin
    multiplication := a * b;
end;

function division(const a: Integer; const b: Integer): Double;
begin
    division := a / b;
end;

function intdiv(const a: Integer; const b: Integer): Double;
begin
    intdiv := a div b;
end;

function modulo(const a: Integer; const b: Integer): Double;
begin
    modulo := a mod b;
end;

function exponentiation(const a: Integer; const b: Integer): Double;
begin
    exponentiation := power(a, b);
end;

initialization // --------------------------------------------------------------

    OPERATIONS[0] := TOperation.create(add,
                                       '+',
                                       'add',
                                       'addition',
                                       @addition);
    OPERATIONS[1] := TOperation.create(sub,
                                       '-',
                                       'sub',
                                       'subtraction',
                                       @subtraction);
    OPERATIONS[2] := TOperation.create(mul,
                                       '*',
                                       'mul',
                                       'multiplication',
                                       @multiplication);
    OPERATIONS[3] := TOperation.create(dvi,
                                       '/',
                                       'div',
                                       'division',
                                       @division);
    OPERATIONS[4] := TOperation.create(ind,
                                       '\',
                                       'ind',
                                       'integer division',
                                       @intdiv);
    OPERATIONS[5] := TOperation.create(mdu,
                                       '%',
                                       'mod',
                                       'modulo',
                                       @modulo);
    {OPERATIONS[6] := TOperation.create(exo,
                                       '^',
                                       'exp',
                                       'exponentiation',
                                       @exponentiation);}

end.
