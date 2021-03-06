//***************************************************************
// This source is written by John Kouraklis.
// � 2016, John Kouraklis
// Email : j_kour@hotmail.com
//
// The MIT License (MIT)
//
// Copyright (c) 2016 John Kouraklis
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
// KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// Unit Name: neTabTypes
//
//
//
//***************************************************************

unit neTabTypes;

interface

uses
  FMX.Types, Model.IntActions, Model.Interf,
  System.Types, FMX.Menus, System.Classes, System.Generics.Collections,
  FMX.TabControl;

//////////////////////////////////////////////////
/// For version info, please see the .inc file ///
//////////////////////////////////////////////////

{$I neTabControlVersionInfo.inc}


type

  TShowTabAnimation = (taNone, taFade);

  {$REGION 'Defines the elements of a tab item to be exported with the SaveTabs procedure'}
  /// <summary>
  ///   Defines the elements of a tab item to be exported with the SaveTabs
  ///   procedure
  /// </summary>
  /// <seealso cref="TExportElements">
  ///   <see cref="neTabTypes|TExportElements" />
  /// </seealso>
  {$ENDREGION}
  TExportElement = (
    {$REGION 'Export the Title of the tab item'}
    /// <summary>
    ///   Export the Title of the tab item
    /// </summary>
    {$ENDREGION}
    expTitle,
    {$REGION 'Exports the TagString property'}
    /// <summary>
    ///   Exports the TagString property
    /// </summary>
    {$ENDREGION}
    expTagString,
    {$REGION 'Exports the TagFloat property'}
    /// <summary>
    ///   Exports the TagFloat property
    /// </summary>
    {$ENDREGION}
    expTagFloat);
  {$REGION 'Defines the set of elements to be exported when SaveTabs is called'}
  /// <summary>
  ///   Defines the set of elements to be exported when SaveTabs is called
  /// </summary>
  /// <remarks>
  ///   If the set is empty the Title is exported. This is equivalent to using
  ///   the <see cref="neTabTypes|TExportElement">expTitle</see> identifier.
  /// </remarks>
  {$ENDREGION}
  TExportElements= set of TExportElement;
  TSetOfStrings = array of string;

  TneTimer = class(TTimer)
  public
    Action: TIntAction;
    Value: string;
  end;

  TneHintTimer = class(TneTimer)
  public
    MousePoint: TPointF;
  end;

  TneNotificationClass = class(TInterfacedObject, INotification)
  private
    fActions: TIntActions;
    fSender: TObject;
    fValue: string;
    fValueInt: integer;
    fPoint: TPointF;
    fPopupBefore,
    fPopupDefault,
    fPopupAfter: TPopupMenu;
  public
    property Action: TIntActions read fActions write fActions;
    property Value: string read fValue write fValue;
    property ValueInt: Integer read fValueInt write fValueInt;
    property Sender: TObject read fSender write fSender;
    property Point: TPointF read fPoint write fPoint;
    property PopupBefore: TPopupMenu read fPopupBefore write fPopupBefore;
    property PopupDefault: TPopupMenu read fPopupDefault write fPopupDefault;
    property PopupAfter: TPopupMenu read fPopupAfter write fPopupAfter;
  end;

  THistoryClass = class
  private
    fHistoryList: TList<string>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddHistory(const newStr: string);
    procedure DeleteHistory (const delStr: string);
    function GetLastEntry: string;
  end;

resourcestring
  SCloseTab = 'Close';
  SCloseAllTabs = 'Close All Tabs';
  SCloseOtherTabs = 'Close All Other Tabs';

implementation

uses
	System.SysUtils, FMX.Styles.Objects;

{ THistoryClass }

procedure THistoryClass.AddHistory(const newStr: string);
begin
  if trim(newStr)='' then
    Exit;
  fHistoryList.Add(trim(newStr));
end;

constructor THistoryClass.Create;
begin
  inherited;
  fHistoryList:=TList<string>.Create;
end;

procedure THistoryClass.DeleteHistory(const delStr: string);
var
  i: Integer;
begin
  i:=0;
  while i<=fHistoryList.Count-1 do
  begin
    if fHistoryList.Items[i]=trim(delStr) then
      fHistoryList.Remove(trim(delStr))
    else
      i:=i+1;
  end;
end;

destructor THistoryClass.Destroy;
begin
  inherited;
  fHistoryList.Free;
end;

function THistoryClass.GetLastEntry: string;
begin
  if fHistoryList.Count>0 then
    result:=fHistoryList.Items[fHistoryList.Count-1]
  else
    result:='';
end;

end.
