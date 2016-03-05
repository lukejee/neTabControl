{***************************************************************}
{ This source is written by John Kouraklis.			}
{ � 2016, John Kouraklis           				}
{ Email : j_kour@hotmail.com                           		}
{                                                      		}
{The MIT License (MIT)                                          }
{                                                               }
{ Copyright (c) 2016 John Kouraklis                             }
{                                                               }
{ Permission is hereby granted, free of charge, to any person   }
{ obtaining a copy of this software and associated documentation}
{ files (the "Software"), to deal in the Software without       }
{ restriction, including without limitation the rights to use,  }
{ copy, modify, merge, publish, distribute, sublicense, and/or  }
{ sell copies of the Software, and to permit persons to whom the}
{ Software is furnished to do so, subject to the following      }
{ conditions:                                                   }
{                                                               }
{ The above copyright notice and this permission notice shall be}
{ included in all copies or substantial portions of the Software}
{                                                               }
{ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY     }
{ KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE    }
{ WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR       }
{ PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR }
{ COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER   }
{ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR          }
{ OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     }
{ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.        }
{								}
{ Unit Name: neTabControl					}
{                                                               }
{                                                               }
{                                                               }
{***************************************************************}
unit neTabControl;

interface

uses

  System.SysUtils, System.Generics.Collections,
  FMX.Controls, FMX.TabControl, FMX.Types,
  FMX.Graphics, FMX.Forms, FMX.Menus,
  FMX.Styles.Objects,
  System.Classes,
  System.UITypes, FMX.Objects, FMX.StdCtrls;


const
  MajorVersion = '0';
  MinorVersion = '2';
  BugVersion = '0';

{***************************************************************}
{ Version History:                                              }
{                                                               }
{ 0.2.0 - 05/03/2016                                            }
{                                                               }
{** Changes                                                     }
{    * Change license to MIT                                    }
{    * ShowHint disabled                                        }
{    * Check for duplicate Tag name added                       }
{    * Adjust Width improvement                                 }
{                                                               }
{** Bug                                                         }
{    * Access Violation on MouseOverTabItem when the control is }
{      host in other control (eg. a Frame)                      }
{    * AdjustWidth returns 0 when the control is within two     }
{      frames                                                   }
{                                                               }
{** New Feature                                                 }
{    * Option to disable right-click menu added                 }
{    * MinWidth property added                                  }
{    * Normal TTabItem can be added                             }
{    * Add "Close all the rest" option in popup menu            }
{                                                               }
{                                                               }
{ 0.1.0 - Initial Version (20/02/2016)                          }
{***************************************************************}

type
  THintStyle = (ShowTitle, ShowPreview, None);

  TneTabItem = class(TTabItem)
  private
    fCanClose: Boolean;
    fTabControlParent: TTabControl;
    fCloseImageNormal,
    fCloseImageHover,
    fCloseImagePressed: TBitmap;
    fIcon: TBitmap;
    fShowIcon: boolean;

    fIsMouseOver: boolean;
    fDeleted: Boolean;
    fIsMousePressed: Boolean;

    fVersion: string;
    procedure SetCloseImageNormal(const newImage: TBitmap);
    procedure SetCloseImageHover(const newImage: TBitmap);
    procedure SetCloseImagePressed (const newImage: TBitMap);

    procedure SetCanClose(const can: Boolean);
    procedure SetIconImage(const newImage: TBitmap);
    procedure SetShowIcon(const can: Boolean);
    procedure AdjustTabWidth(const minW: single; const maxW: Single);

    function GetVersion: string;

    //Events
    procedure NewOnMouseEnter(ASender: TObject);
    procedure NewOnMouseLeave(ASender: TObject);
    procedure NewOnMouseMove(Sender: TObject; Shift: TShiftState; X,
                                                              Y: Single);
    procedure OnCloseImageClick(ASender: TObject);
    procedure OnCloseImageHoverClick(ASender: TObject);
    procedure OnCloseImageLeave(ASender: TObject);
    procedure OnCloseImageMouseDown(ASender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure OnCloseImageMouseUp(ASender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  protected
    procedure MouseClick(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure ApplyStyle; override;
    property Deleted: boolean read fDeleted write fDeleted;
  published
    {$REGION 'Defines whether the tab can close.'}
    /// <summary>
    ///   Defines whether the tab can close.
    /// </summary>
    {$ENDREGION}
    property CanClose: boolean read fCanClose write SetCanClose;
    {$REGION 'Sets the image for the close button (normal).'}
    /// <summary>
    ///   Sets the image for the close button (normal).
    /// </summary>
    {$ENDREGION}
    property CloseImageNormal: TBitmap read fCloseImageNormal write SetCloseImageNormal;
    {$REGION 'Sets the image for the close button (hover).'}
    /// <summary>
    ///   Sets the image for the close button (normal).
    /// </summary>
    {$ENDREGION}
    property CloseImageHover: TBitmap read fCloseImageHover write SetCloseImageHover;
    {$REGION 'Sets the image for the close button (pressed).'}
    /// <summary>
    ///   Sets the image for the close button (normal).
    /// </summary>
    {$ENDREGION}
    property CloseImagePressed: TBitmap read fCloseImagePressed write SetCloseImagePressed;
    {$REGION 'Sets the image for the icon which appears at the left side of the tab.'}
    /// <summary>
    ///   Sets the image for the icon which appears at the left side of the
    ///   tab.
    /// </summary>
    {$ENDREGION}
    property Icon:TBitmap read fIcon write SetIconImage;
    {$REGION 'Controls whether the icon at the left is visible.'}
    /// <summary>
    ///   Controls whether the icon at the left is visible.
    /// </summary>
    {$ENDREGION}
    property ShowIcon: boolean read fShowIcon write SetShowIcon default true;

    property Version: string read GetVersion;

    constructor Create(AOwner: TComponent); override;
  end;

  {$REGION 'This event is called before the deletion of a tab. If it is false, the deletion is aborted. By default it returns true.'}
  /// <summary>
  ///   This event is called before the deletion of a tab. If it is false, the
  ///   deletion is aborted. By default it returns true.
  /// </summary>
  {$ENDREGION}
  TOnBeforeDelete = function (const AItem: TneTabItem): boolean of object;
  {$REGION 'This event is raised after the deletion of a tab.'}
  /// <summary>
  ///   This event is raised after the deletion of a tab.
  /// </summary>
  /// <remarks>
  ///   ADeletedItem MUST BE freed in the event handler.
  /// </remarks>
  {$ENDREGION}
  TOnAfterDelete = procedure (ADeletedItem: TneTabItem; ADeletedFrame: TFrame) of object;

  TneTabControl = class(TTabControl)
  private
    fDictionaryTabs: TDictionary<string, TneTabItem>;
    fDictionaryFrames: TDictionary<string, TFrame>;
    fHintStyle: THintStyle;
    fHintContainer: TPanel;
    fCloseImageNormal,
    fCloseImageHover,
    fCloseImagePressed: TBitmap;
    fVersion: string;

    //Events
    fOnBeforeDelete: TOnBeforeDelete;
    fOnAfterDelete: TOnAfterDelete;

    //Published properties
    fPopupBeforeDefaultMenu: TPopupMenu;
    fPopupAfterDefaultMenu: TPopupMenu;
    fCloseTabLabel: string;
    fMaxTabWidth: single;
    fMinTabWidth: single;
    fDisablePopupMenu: boolean;
    fCloseAllOtherTabsLabel: string;

    //Holds the history of the clicked tags
    fHistoryTags: TList<string>;
    function GetLastVisitedTag: string;

    //Events
    procedure OnTabChangeInternal(Sender: TObject);

    //Popup Events
    procedure OnPopUpMenuClose(ASender: TObject);
    procedure OnPopUpChangeTab(ASender: TObject);
    procedure OnPopUpMenuCloseAllOtherTabs (ASender: TObject);

    //Procedures
    procedure ShowPopUpMenu(const ASender:TNETabItem; const X, Y: Single);
    procedure SetHintSTyle(const showH: THintStyle);
    procedure SetMaxTabWidth (const newW: Single);
    procedure SetMinTabWidth (const newW: Single);
    {$REGION 'This method shows the hint on the tabitem.'}
    /// <summary>
    ///   This method shows the hint on the tabitem.
    /// </summary>
    {$ENDREGION}
    procedure MouseOverTabItem(const tag: string; const X, Y: Single);
    procedure MouseExitTabItem;

    function GetVersion: string;
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddTab(const tag: string; var newFrame: TFrame); overload;
    procedure AddTab(const tag: string; var newItem: TneTabItem;
      var newFrame: TFrame); overload;
    procedure AddTab(const tag: string; var newItem: TTabItem;
      var newFrame: TFrame); overload;

    {$REGION 'Deletes a tab using the tag.'}
    /// <summary>
    ///   Deletes a tab using the tag.
    /// </summary>
    /// <param name="forceDelete">
    ///   By default it is False. The CanClose property defines whether a tag
    ///   can be deleted. If true value is passed, the tab is deleted
    ///   regardless the CanClose value
    /// </param>
    {$ENDREGION}
    procedure DeleteTab(const tag: string; const forceDelete: Boolean = false);

    procedure InsertTab(const tag: string; const index: Integer;
                                              var newFrame: TFrame);overload;
    procedure InsertTab(const tag: string; const index: Integer;
                      var newItem: TneTabItem; var newFrame:TFrame); overload;

    procedure SetActiveTab(const tag: string);

    function GetTab(const tag: string): TneTabItem;
    function GetFrame(const tag: string): TFrame;
    function GetTabsTags: TStringList;
    function GetTabsText: TStringList;
    function FindTabOrderFromTag(const Tag: string): Integer;
  published
    //Events
    property OnBeforeDelete: TOnBeforeDelete read fOnBeforeDelete write fOnBeforeDelete;
    property OnAfterDelete: TOnAfterDelete read fOnAfterDelete write fOnAfterDelete;
    {$REGION 'This method is called before the construction of the default menu items. Use this method to add menu items in the beginning of the popup menu.'}
    /// <summary>
    ///   This method is called before the construction of the default menu
    ///   items. Use this method to add menu items in the beginning of the
    ///   popup menu.
    /// </summary>
    {$ENDREGION}
    property PopupBeforeDefault:TPopupMenu read fPopupBeforeDefaultMenu
      write fPopupBeforeDefaultMenu;
    {$REGION 'This method is called after the construction of the default menu items. Use this method to add menu items at the end of the popup menu.'}
    /// <summary>
    ///   This method is called after the construction of the default menu
    ///   items. Use this method to add menu items at the end of the popup
    ///   menu.
    /// </summary>
    {$ENDREGION}
    property PopupAfterDefault: TPopupMenu read fPopupAfterDefaultMenu
      write fPopupAfterDefaultMenu;

    //Properties
    {$REGION 'If true shows the text of the tab as hint.'}
    /// <summary>
    ///   If true shows the text of the tab as hint.
    /// </summary>
    {$ENDREGION}
    property HintStyle: THintStyle read fHintStyle write SetHintSTyle;
    {$REGION 'Defines the label for the Close menu in the popup menu.'}
    /// <summary>
    ///   Defines the label for the Close menu in the popup menu.
    /// </summary>
    {$ENDREGION}
    property CloseTabLabel: string read fCloseTabLabel write fCloseTabLabel;
    {$REGION 'Defines the minimum tab width.'}
    /// <summary>
    ///   Defines the minimum tab width.
    /// </summary>
    {$ENDREGION}
    property MixTabWidth: Single read fMinTabWidth write SetMinTabWidth;
    {$REGION 'Defines the maximum tab width.'}
    /// <summary>
    ///   Defines the maximum tab width.
    /// </summary>
    /// <remarks>
    ///   Default value: 120px
    /// </remarks>
    {$ENDREGION}
    property MaxTabWidth: single read fMaxTabWidth write SetMaxTabWidth;
    {$REGION 'The image for the close pic (normal state).'}
    /// <summary>
    ///   The image for the close pic (normal state).
    /// </summary>
    {$ENDREGION}
    property CloseImageNormal: TBitmap read fCloseImageNormal write fCloseImageNormal;
    property CloseImageHover: TBitmap read fCloseImageHover write fCloseImageHover;
    property CloseImagePressed: TBitmap read fCloseImagePressed write fCloseImagePressed;
    {$REGION 'Disables the popup menu when the user right-clicks on a tab.'}
    /// <summary>
    ///   Disables the popup menu when the user right-clicks on a tab.
    /// </summary>
    {$ENDREGION}
    property DisablePopupMenu: boolean read fDisablePopupMenu write fDisablePopupMenu;
    {$REGION 'The label for the "Close All Other Tabs" option in the popup menu.'}
    /// <summary>
    ///   The label for the "Close All Other Tabs" option in the popup menu.
    /// </summary>
    {$ENDREGION}
    property CloseAllOtherTabsLabel: string read fCloseAllOtherTabsLabel
             write fCloseAllOtherTabsLabel;
    property Version: string read GetVersion;
  end;

procedure Register;

implementation

uses
  System.Math, FMX.Dialogs, System.Types;


{General Utils}

function ResizeBitmap(B: TBitmap; width, height: Integer): TBitmap;
begin
  result:=TBitmap.Create(width, height);
  Result.Clear(0);
  if result.Canvas.BeginScene then
  try
    Result.Canvas.DrawBitmap(B, RectF(0,0,b.Width, b.Height), RectF(0,0,width, height),1);
  finally
    Result.Canvas.EndScene;
  end;
end;

function FindParentForm(const checkComponent: TFmxObject):TForm;
begin
  if not Assigned(checkComponent.Parent) then
    result:=checkComponent as TForm
  else
    if checkComponent.Parent Is TForm then
      result:=checkComponent.Parent as TForm
    else
      result:=FindParentForm(checkComponent.Parent.Parent);
end;

{ Register}

procedure Register;
begin
  RegisterComponents('NusEnvision', [TneTabControl]);
end;

{ TneTabControl }

procedure TneTabControl.AddTab(const tag: string; var newFrame: TFrame);
var
  tmpItem: TNeTabItem;
  str: string;
begin
  if trim(tag)='' then
    Exit;
  tmpItem:=TneTabItem.create(self);
  str:='Tab '+self.TabCount.ToString;
  tmpItem.Text:=str;
  AddTab(tag, tmpItem, newFrame);
end;

procedure TneTabControl.AddTab(const tag: string; var newItem: TneTabItem;
  var newFrame: TFrame);
begin
  if trim(tag)='' then Exit;
  if not Assigned(newitem) then Exit;

  try
    if fDictionaryTabs.ContainsKey(tag) then Exit;
    if fDictionaryFrames.ContainsKey(tag) then Exit;

    fdictionaryTabs.Add(trim(tag), newItem);
    fDictionaryFrames.Add(trim(tag), newFrame);

    newItem.Parent:=self;
    newItem.TagString:=trim(tag);
    newItem.Deleted:=False;

    newItem.CloseImageNormal:=fCloseImageNormal;
    newItem.CloseImageHover:=fCloseImageHover;
    newItem.CloseImagePressed:=fCloseImagePressed;

    if Assigned(newFrame) then
    begin
      newFrame.Parent:=newItem;
      newFrame.TagString:=trim(tag);
      newItem.AddObject(newFrame);
    end;

    if fDictionaryTabs.Count=1 then
      fHistoryTags.Add(newItem.TagString);

    self.AddObject(newItem);

    newItem.AdjustTabWidth(fMinTabWidth, fMaxTabWidth);

    //this is to fix the empty entry in the very beggining (no tabs)
    if trim(fHistoryTags.Items[0])='' then
      fHistoryTags.Delete(0);
  except
    raise ;
  end;

end;

procedure TneTabControl.AddTab(const tag: string; var newItem: TTabItem;
  var newFrame: TFrame);
var
  tmpneItem: TneTabItem;

begin

  if trim(tag)='' then Exit;
  if not Assigned(newitem) then Exit;
  if not Assigned(fDictionaryTabs) then Exit;
  if not Assigned(fDictionaryFrames) then Exit;

  if fDictionaryTabs.ContainsKey(tag) then Exit;
  if fDictionaryFrames.ContainsKey(tag) then Exit;

  tmpneItem:=TneTabItem.Create(newItem.Owner);
  tmpneItem.Text:=newItem.Text;
  tmpneItem.TagString:=trim(tag);
  tmpneItem.Parent:=self;
  tmpneItem.Deleted:=false;
  tmpneItem.CanClose:=False;
  tmpneItem.ShowIcon:=False;
  tmpneItem.AutoSize:=True;

  if Assigned(newFrame) then
  begin
    newFrame.Parent:=tmpneItem;
    newFrame.TagString:=trim(tag);
    tmpneItem.AddObject(newFrame);
  end;

  fdictionaryTabs.Add(trim(tag), tmpneItem);
  fDictionaryFrames.Add(trim(tag), newFrame);

  if fDictionaryTabs.Count=1 then
    fHistoryTags.Add(newItem.TagString);

  self.AddObject(tmpneItem);

  //this is to fix the empty entry in the very beggining (no tabs)
  if (fHistoryTags.Count>0) and (fHistoryTags.Items[0]='') then
    fHistoryTags.Delete(0);

end;

constructor TneTabControl.Create(AOwner: TComponent);
begin
  inherited;
  fDictionaryTabs:=TDictionary<string, TneTabItem>.Create;
  fDictionaryFrames:=TDictionary<string, TFrame>.Create;

  fHistoryTags:=TList<string>.Create;

  self.OnChange:=OnTabChangeInternal;

  fCloseTabLabel:='Close Tab';

  fDisablePopupMenu:=False;

  fPopupBeforeDefaultMenu:=nil;
  fPopupAfterDefaultMenu:=nil;

  fMaxTabWidth:=120;
  fMinTabWidth:=80;

  fCloseAllOtherTabsLabel:='Close All Other Tabs';

  self.StyleLookup:='netabcontrolstyle';

end;

procedure TneTabControl.DeleteTab(const tag: string; const forceDelete: Boolean = false);
var
  tag2,
  lastvisitedTag: string;
  currentIndex,
  deleteindex: Integer;
  deletedItem,
  tmpItem: TneTabItem;
  deletedFrame: TFrame;
begin
  tag2:=Trim(tag);

  if not Assigned(fDictionaryTabs) then Exit;
  if not fDictionaryTabs.ContainsKey(tag2) then Exit;
  if (not fDictionaryTabs.Items[tag2].CanClose)
     and (not forceDelete) then
       Exit;

  if not Assigned(fDictionaryFrames) then Exit;
  if not fDictionaryFrames.ContainsKey(tag2) then Exit;

  if Assigned(fOnBeforeDelete) then
    if not fOnBeforeDelete(fDictionaryTabs.Items[tag2]) then
      Exit;

  deleteindex:=FindTabOrderFromTag(fDictionaryTabs.Items[tag2].TagString);
  currentindex:=FindTabOrderFromTag(self.ActiveTab.TagString);

  tmpItem:=fDictionaryTabs.Items[tag2];
  deletedItem:=nil;
  if Assigned(tmpItem) then
  begin
    deletedItem:=TneTabItem.Create(nil);
    deletedItem.Text:=tmpItem.Text;
    deletedItem.CanClose:=tmpItem.CanClose;
    deletedItem.TagString:=tmpItem.TagString;
  end;

  deletedFrame:=nil;
 //dletedFrame:=fDictionaryFrames.Items[tag2].Clone
   //                   (fDictionaryFrames.Items[tag2]);


//When Delete is called directly from the CloseIcon it generates an access
//violation error because the OnClick event deleted the TImage and returns to nil
//In order to avoid this, we hide the tabItem and don't delete
//So, instead of this: self.Delete(FindTabOrderFromTag(tag2));
//we do this:

  Self.GetTab(tag2).Visible:=false;
  if fDictionaryTabs.ContainsKey(tag2) then
    fDictionaryTabs.Items[tag2].Deleted:=true;

  if deleteindex=currentIndex then
  begin
    lastvisitedTag:=GetLastVisitedTag;
    if Trim(lastvisitedTag)<>'' then
        self.ActiveTab:=self.Tabs[
            FindTabOrderFromTag(lastvisitedTag)]
    else
      if self.TabCount>0 then
        self.ActiveTab:=self.Tabs[0];
  end;

  if Assigned(fOnAfterDelete) then
    fOnAfterDelete(deletedItem, deletedFrame)
  else
    if Assigned(deletedItem) then
       deletedItem.Free;
end;

destructor TneTabControl.Destroy;
var
  tmpItem: TneTabItem;
begin
  for tmpItem in fDictionaryTabs.Values do
    tmpItem.Free;
  if Assigned(fCloseImageNormal) then
    fCloseImageNormal.Free;
  if Assigned(fCloseImageHover) then
    fCloseImageHover.Free;
  if Assigned(fCloseImagePressed) then
    fCloseImagePressed.Free;
  fDictionaryTabs.Free;
  fDictionaryFrames.Free;
  fHistoryTags.Free;
  inherited;
end;

function TneTabControl.FindTabOrderFromTag(const Tag: string): Integer;
var
  I: Integer;
begin
  result:=-1;
  for I := 0 to Self.TabCount-1 do
    if (trim(Tag)=Trim(self.tabs[i].TagString))
      and (self.Tabs[i].Visible) then
      result:=i;
end;


function TneTabControl.GetFrame(const tag: string): TFrame;
begin
  if not Assigned(fDictionaryFrames) then
    result:=nil
  else
    if (fDictionaryTabs.ContainsKey(trim(tag)))
      and (not fDictionaryTabs.Items[trim(tag)].Deleted) then
        if fDictionaryFrames.ContainsKey(trim(tag)) then
          result:=fDictionaryFrames.Items[trim(tag)]
        else
          result:=nil
    else
      result:=nil;
end;

function TneTabControl.GetLastVisitedTag: string;
begin
    if Assigned(fHistoryTags) then
    begin
       if (fHistoryTags.Count>0) then
        begin
          fHistoryTags.Delete(fHistoryTags.Count-1);
          if fHistoryTags.Count>0 then
          begin
            if (fDictionaryTabs.ContainsKey(fHistoryTags.Items[fHistoryTags.Count-1]))
                  and (not fDictionaryTabs.Items[fHistoryTags.Items[fHistoryTags.count-1]].Deleted) then
              result:=GetLastVisitedTag
            else
              result:=fHistoryTags.Items[fHistoryTags.Count-1];
          end
          else
            result:='';
        end
      else
        result:='';
    end
    else
      Result:='';
end;

function TneTabControl.GetTab(const tag: string): TneTabItem;
begin
  if not Assigned(fDictionaryTabs) then
    result:=nil
  else
    if (fDictionaryTabs.ContainsKey(Trim(tag))) then
      if (not fDictionaryTabs.Items[trim(tag)].Deleted) then
        result:=fDictionaryTabs.Items[trim(tag)]
      else
        result:=nil
    else
      result:=nil;
end;

function TneTabControl.GetTabsTags: TStringList;
var
  tmpList: TStringList;
  i: Integer;
begin
  tmpList:=TStringList.Create;
  for i := 0 to self.TabCount-1 do
    if self.Tabs[i].Visible then
      tmpList.Add(self.Tabs[i].TagString);
  result:=tmpList;
end;

function TneTabControl.GetTabsText: TStringList;
var
  tmpList: TStringList;
  i: Integer;
begin
  tmpList:=TStringList.Create;
  for i := 0 to self.TabCount-1 do
    if self.Tabs[i].Visible then
      tmpList.Add(self.Tabs[i].Text);
  result:=tmpList;
end;

function TneTabControl.GetVersion: string;
begin
  result:=MajorVersion+'.'+MinorVersion+'.'+BugVersion;
end;

procedure TneTabControl.InsertTab(const tag: string; const index: Integer;
  var newItem: TneTabItem; var newFrame: TFrame);
begin
  if trim(tag)='' then Exit;
  if not Assigned(newitem) then Exit;
  if ((index<0) or (index>TabCount-1)) and (self.TabCount>0) then
    Exit;

//InsertObject has a bug as it doesn't insert tabs in the index-location
//self.InsertObject(index, newItem);
//We first add the tab and then rearrange it by changing the index property

  self.AddTab(tag, newItem, newFrame);
  newItem.Index:=index;
end;

procedure TneTabControl.MouseExitTabItem;
begin
  if Assigned(fHintContainer) then
    fHintContainer.Visible:=False;
end;

procedure TneTabControl.MouseOverTabItem(const tag: string; const X,
  Y: Single);
//X, Y are local to the tabItem
var
  tmpForm: TForm;
  tmpFMX: TFmxObject;
  tmpImage: TImage;
  tmpItem: TneTabItem;
  tmpText: TLabel;
  tmpBitmap: TBitmap;
  FP: TPointF;

begin
  inherited;

  //Disable showHint
  fHintStyle:=THintStyle.None;

  if fHintStyle=THintStyle.None then
    Exit;

  if not Assigned(self.parent) then
        Exit;

  tmpForm:=FindParentForm(self);

  if not Assigned(tmpForm) then
    Exit;

  if Assigned(fHintContainer) then
      fHintContainer.Free;

  if fDictionaryTabs.containskey(tag) then
    tmpItem:=fDictionaryTabs.Items[Tag]
  else
    Exit;

  fHintContainer:=TPanel.Create(nil);
  fHintContainer.Parent:=tmpForm;

  fHintContainer.StyleLookup:='nehintstyle';

  tmpFMX:=fHintContainer.FindStyleResource('image');
  if (tmpFMX is TImage) then
    tmpImage:=TImage(tmpFMX)
  else
    tmpImage:=nil;

  tmpFMX:=fHintContainer.FindStyleResource('text');
  if (tmpFMX is TLabel) then
    tmpText:=TLabel(tmpFMX)
  else
    tmpText:=nil;

  if (not Assigned(tmpImage)) or (not Assigned(tmpText)) then
    Exit;

  if fHintStyle=THintStyle.ShowTitle then
  begin
      fHintContainer.width:=tmpImage.Width;
      fHintContainer.Height:=tmpImage.Height;

       tmpText.Text:=tmpItem.Text;
   end
  else
  if fHintStyle=THintStyle.ShowPreview then
  begin
    tmpBitmap:=GetFrame(tag).MakeScreenshot;
    if Assigned(tmpBitmap) then
    begin
      fHintContainer.Height:=200;
      fHintContainer.Width:=100;
      tmpImage.Bitmap:=tmpBitmap;
      tmpText.Visible:=false;
      tmpBitmap.Free;
    end;
  end;

  if Assigned(tmpForm) then
  begin
//Disabled. Need to work out the correct coordinates.
//Becomes complex when the tab is within frames, grids, etc.
//    FP:=TPointF.Create(X,Y);
//    FP:=self.LocalToAbsolute(FP);
////
////    fHintContainer.Position.X:=fp.X-fHintContainer.Width/2;
////    fHintContainer.Position.Y:=FP.Y;
//
//    fHintContainer.Position.X:=FP.X;//+self.Position.X;
//    fHintContainer.Position.Y:=Y+self.Position.Y;
//
//    fHintContainer.Visible:=true;
  end;

end;

procedure TneTabControl.InsertTab(const tag: string; const index: Integer;
  var newFrame: TFrame);
var
  tmpItem: TNeTabItem;
  str: string;
begin
  tmpItem:=TneTabItem.create(self);
  str:='Tab '+self.TabCount.ToString;
  tmpItem.Text:=str;
  InsertTab(tag, index, tmpItem, newFrame);
end;

procedure TneTabControl.OnPopUpChangeTab(ASender: TObject);
begin
  if ASender is TMenuItem then
    SetActiveTab((ASender as TMenuItem).TagString);
end;

procedure TneTabControl.OnPopUpMenuClose(ASender: TObject);
begin
  if ASender is TMenuItem then
    DeleteTab((ASender as TMenuItem).TagString);
end;

procedure TneTabControl.OnPopUpMenuCloseAllOtherTabs(ASender: TObject);
var
  key: string;
begin
  if ASender is TMenuItem then
  begin
     for key in fDictionaryTabs.Keys do
       if trim(key)<>trim((ASender as TMenuItem).TagString) then
          DeleteTab(key);
     SetActiveTab((ASender as TMenuItem).TagString);
  end;
end;

procedure TneTabControl.OnTabChangeInternal(Sender: TObject);
var
  key: string;
  i: Integer;
begin
inherited;
  if Self.HasActiveTab then
    fHistoryTags.Add(self.ActiveTab.TagString);

  //Tide up the dictionaries
  //Delete the invisible tabs
  for key in fDictionaryTabs.Keys do
    if fDictionaryTabs.Items[key].Deleted then
    begin
      fDictionaryTabs.Remove(key);
      if fdictionaryFrames.containsKey(key) then
        fDictionaryFrames.Remove(key);

      i:=FindTabOrderFromTag(key);
      if i<>-1 then
        self.Delete(i);
    end;

  inherited;
end;

procedure TneTabControl.SetActiveTab(const tag: string);
var
  tag2: string;
begin
  tag2:=trim(tag);
  if tag2='' then
    exit
  else
  begin
    if (fDictionaryTabs.ContainsKey(tag2)) and
      (fDictionaryTabs.Items[tag2].Visible) then
      self.ActiveTab:=self.Tabs[FindTabOrderFromTag(tag2)];
  end;
end;


procedure TneTabControl.SetMaxTabWidth(const newW: Single);
begin
  if newW=0 then
    fMaxTabWidth:=120
  else
    fMaxTabWidth:=newW;
end;

procedure TneTabControl.SetMinTabWidth(const newW: Single);
begin
  if newW=0 then
    fMinTabWidth:=80
  else
    fMinTabWidth:=newW;
end;

procedure TneTabControl.SetHintStyle(const showH: THintStyle);
var
  tmpItem: TneTabItem;
begin
  fHintStyle:=showH;
  if fHintStyle=THintStyle.ShowTitle then
   for tmpItem in fDictionaryTabs.Values do
   begin
      tmpItem.ShowHint:=true;
      tmpItem.Hint:=tmpItem.Text;
   end;
end;

procedure TneTabControl.ShowPopUpMenu(const ASender: TNETabItem; const X,
  Y: Single);
var
  tmpPopMenu: TPopUpMenu;
  tmpMenuItem: TMenuItem;
  FP: TPointF;
  tmpForm: TForm;
  i: Integer;
  tmpItem: TNETabItem;
  AtLeastOneTabCanClose: boolean;
  key: string;
begin
  if not Assigned(ASender) then Exit;

  if fDisablePopupMenu then
     Exit;

  tmpPopMenu:=TPopupMenu.Create(Self);
  tmpPopMenu.Parent:=self;

  if Assigned(fPopupBeforeDefaultMenu) then
  for i := 0 to fPopupBeforeDefaultMenu.ItemsCount-1 do
  begin
    tmpMenuItem:=TMenuItem(fpopupBeforeDefaultMenu.Items[i].Clone(
                                  fPopupBeforeDefaultMenu.Items[i]));
    tmpPopMenu.AddObject(tmpMenuItem);
  end;

  //Close menu item
  if ASender.CanClose then
  begin
    tmpMenuItem:=TMenuItem.Create(tmpPopMenu);
    tmpMenuItem.Text:=fCloseTabLabel;
    tmpMenuItem.TagString:=ASender.TagString;
    tmpMenuItem.OnClick:=OnPopUpMenuClose;

    tmpPopMenu.AddObject(tmpMenuItem);
  end;

  //Close All Other Tabs item
  AtLeastOneTabCanClose:=false;
  for key in fDictionaryTabs.Keys do
  begin
    tmpItem:=fDictionaryTabs.Items[key];
    if Assigned(tmpItem) then
       if tmpItem.CanClose and (tmpItem<>ASender) then
          AtLeastOneTabCanClose:=true;
       end;

  if AtLeastOneTabCanClose then
  begin
    tmpMenuItem:=TMenuItem.Create(tmpPopMenu);
    tmpMenuItem.Text:=fCloseAllOtherTabsLabel;
    tmpMenuItem.TagString:=ASender.TagString;
    tmpMenuItem.OnClick:=OnPopUpMenuCloseAllOtherTabs;
    tmpPopMenu.AddObject(tmpMenuItem);
  end;


  if tmpPopMenu.ItemsCount>0 then
  begin
    tmpMenuItem:=tMenuItem.create(tmpPopMenu);
    tmpMenuItem.Text:='-';
    tmpPopMenu.AddObject(tmpMenuItem);
  end;

  for i := 0 to Self.TabCount-1 do
  begin
    tmpitem:=self.Tabs[i] as TNETabItem;
    if assigned (tmpItem) and (tmpItem.Visible) then
    begin
      tmpMenuItem:=TMenuItem.Create(tmpPopMenu);
      tmpMenuItem.Text:=tmpItem.Text;
      tmpMenuItem.TagString:=tmpItem.TagString;
      tmpMenuItem.OnClick:=OnPopUpChangeTab;
      if Self.HasActiveTab then
        if tmpItem=(Self.ActiveTab as TneTabItem) then
          tmpMenuItem.IsChecked:=True;
      tmpPopMenu.AddObject(tmpMenuItem);
    end;
  end;

  if Assigned(fPopupAfterDefaultMenu) then
  for i := 0 to fPopupAfterDefaultMenu.ItemsCount-1 do
  begin
    tmpMenuItem:=TMenuItem(fPopupAfterDefaultMenu.Items[i].Clone(
                                  fPopupAfterDefaultMenu.Items[i]));
    tmpPopMenu.AddObject(tmpMenuItem);
  end;

  FP := TPointF.Create(X, Y);
  FP := ASender.LocalToAbsolute(FP);

  tmpForm:=FindParentForm(self);
  if Assigned(tmpForm) then
  begin
    FP:=tmpForm.ClientToScreen(FP);
    tmpPopMenu.Popup(FP.X, FP.Y);
  end;

end;

{ TneTabItem }

procedure TneTabItem.AdjustTabWidth(const minW: single; const maxW: Single);
var
  tmpItem: TneTabItem;
  tmpWidth,
  tmpHeight: single;
  tmpFMX: TFmxObject;
  tmpImage: TImage;
begin

  tmpItem:=self;
  tmpheight:=self.Height;

  tmpItem.AutoSize:=true;
  tmpWidth:=self.Width;
  tmpWidth:=Min(maxW, tmpWidth);
  tmpWidth:=Max(minW, tmpWidth);

  tmpFMX:=self.FindStyleResource('closeimage');
  if tmpFMX is TImage then
  begin
    tmpImage:=TImage(tmpFMX);
    if not Assigned(tmpImage) then Exit;
    tmpWidth:=tmpWidth+tmpimage.Width+tmpimage.Padding.Left+
                tmpImage.Padding.right;
    tmpImage.Free;
  end;

  tmpFMX:=self.FindStyleResource('iconimage');
  if (tmpFMX is TImage) then
  begin
    tmpImage:=TImage(tmpFMX);
    if Assigned(tmpImage) then
    begin
      if fShowIcon then
      begin
        tmpWidth:=tmpWidth+tmpimage.Width+tmpimage.Padding.Left+
                  tmpImage.Padding.Right;
        tmpImage.Visible:=true;
      end
      else
        tmpImage.Visible:=false;
      tmpImage.Free;
    end;
  end;

  self.AutoSize:=false;
  self.Width:=round(tmpWidth);
  Self.Height:=round(tmpHeight);

end;


procedure TneTabItem.ApplyStyle;
var
  tmpFMX: TFMXObject;
  tmpImage: TImage;
  Image2: TBitmap;
begin
  inherited;
  //close image
  tmpFMX:=FindStyleResource('closeimage');
  if (tmpFMX is TImage) then
  begin
    tmpImage:=TImage(tmpFMX);
    tmpImage.OnClick:=OnCloseImageClick;
    tmpImage.OnMouseEnter:=OnCloseImageHoverClick;
    tmpImage.OnMouseLeave:=OnCloseImageLeave;
    tmpImage.OnMouseUp:=OnCloseImageMouseUp;
    tmpImage.OnMouseDown:=OnCloseImageMouseDown;
    if CanClose then
    begin
     if Assigned(fCloseImageNormal) then
     begin
      Image2:=ResizeBitmap(fCloseImageNormal, 16, 16);
      tmpImage.Bitmap:=Image2;
      if Assigned(Image2) then
        Image2.free;
     end;
    end
    else
      tmpImage.Visible:=false;
  end;

  //icon image
  tmpFMX:=FindStyleResource('iconimage');
  if (tmpFMX is TImage) then
  begin
    tmpImage:=TImage(tmpFMX);
    if Assigned(fIcon) then
      tmpImage.Bitmap:=fIcon;
    if fShowIcon then
      tmpImage.Visible:=true
    else
      tmpImage.Visible:=false;
  end;

end;

constructor TneTabItem.Create(AOwner: TComponent);
begin
  inherited;

  fCanClose:=True;
  fTabControlParent:=AOwner as TTabControl;

  Self.OnMouseEnter:=NewOnMouseEnter;
  Self.OnMouseLeave:=NewOnMouseLeave;
  Self.OnMouseMove:=NewOnMouseMove;

  Self.StyleLookup:='netabitemstyle';
  CloseImageNormal:=nil;
  CloseImageHover:=nil;
  CloseImagePressed:=nil;
  ShowIcon:=true;

end;


function TneTabItem.GetVersion: string;
begin
  result:=MajorVersion+'.'+MinorVersion+'.'+BugVersion;
end;

procedure TneTabItem.MouseClick(Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
var
  tmp: TneTabControl;
begin
  inherited;

  if Assigned(fTabControlParent) and (fTabControlParent is TneTabControl) then
    tmp:=fTabControlParent as TNETabControl
  else
    tmp:=nil;

  if not Assigned(tmp) then
    Exit;

  if Button=TMouseButton.mbRight then
    tmp.ShowPopUpMenu(self,X,Y);
end;

procedure TneTabItem.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  inherited;
  fIsMousePressed:=true;
end;

procedure TneTabItem.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  inherited;
  fIsMousePressed:=false;
end;

procedure TneTabItem.OnCloseImageClick(ASender: TObject);
begin
  if Assigned(fTabControlParent) and (fTabControlParent is TneTabControl) then
    (fTabControlParent as TneTabControl).DeleteTab(self.TagString);
end;

procedure TneTabItem.OnCloseImageHoverClick(ASender: TObject);
var
  tmpFMX: TFMXObject;
  tmpImage: TImage;
  Image2: TBitmap;
begin
  inherited;
  //close image
  tmpFMX:=FindStyleResource('closeimage');
  if (tmpFMX is TImage) then
  begin
    tmpImage:=TImage(tmpFMX);
    if CanClose then
    begin
     if Assigned(fCloseImageHover) then
     begin
      Image2:=ResizeBitmap(fCloseImageHover, 16, 16);
      tmpImage.Bitmap:=Image2;
      if Assigned(Image2) then
        Image2.Free;
     end;
    end
end;
end;

procedure TneTabItem.OnCloseImageLeave(ASender: TObject);
begin
  inherited;
  ApplyStyle;
end;

procedure TneTabItem.OnCloseImageMouseDown(ASender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  tmpFMX: TFMXObject;
  tmpImage: TImage;
  Image2: TBitmap;
begin
  inherited;
  //close image
  tmpFMX:=FindStyleResource('closeimage');
  if (tmpFMX is TImage) then
  begin
    tmpImage:=TImage(tmpFMX);
    if CanClose then
    begin
     if Assigned(fCloseImagePressed) then
     begin
      Image2:=ResizeBitmap(fCloseImagePressed, 16, 16);
      tmpImage.Bitmap:=Image2;
      if Assigned(Image2) then
        Image2.Free;
     end;
    end
end;
end;

procedure TneTabItem.OnCloseImageMouseUp(ASender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  OnCloseImageHoverClick(ASender);
end;

procedure TneTabItem.NewOnMouseEnter(ASender: TObject);
begin
  inherited;
  fIsMouseOver:=true;
end;

procedure TneTabItem.NewOnMouseLeave(ASender: TObject);
begin
  inherited;
  fIsMouseOver:=false;
  if Assigned(fTabControlParent) and (fTabControlParent is TneTabControl) then
    (fTabControlParent as TneTabControl).MouseExitTabItem;
  ApplyStyle;
end;

procedure TneTabItem.NewOnMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
 if Assigned(fTabControlParent) and (fTabControlParent is TneTabControl) then
    (fTabControlParent as TneTabControl).MouseOverTabItem
      (self.TagString, X, Y);
  ApplyStyle;
end;

procedure TneTabItem.SetCanClose(const can: Boolean);
begin
  fCanClose:=can;
  SetCloseImageNormal(fCloseImageNormal);
end;

procedure TneTabItem.SetCloseImageHover(const newImage: TBitmap);
begin
  fCloseImageHover:=newImage;
  ApplyStyle;
end;

procedure TneTabItem.SetCloseImageNormal(const newImage: TBitmap);
begin
  fCloseImageNormal:=newImage;
  ApplyStyle;
end;


procedure TneTabItem.SetCloseImagePressed(const newImage: TBitMap);
begin
  fCloseImagePressed:=newImage;
  ApplyStyle;
end;

procedure TneTabItem.SetIconImage(const newImage: TBitmap);
begin
  fIcon:=newImage;
  ApplyStyle;
end;

procedure TneTabItem.SetShowIcon(const can: Boolean);
begin
  fShowIcon:=can;
  ApplyStyle;
end;

end.
