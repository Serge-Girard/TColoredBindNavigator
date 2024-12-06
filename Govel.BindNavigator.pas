unit Govel.BindNavigator;

{TODO -oOwner -cGeneral : Ordering TBtnsHints and TGlyphColors properties}

interface

uses
  System.SysUtils, System.Classes,
  System.UITypes, System.Math, System.UIConsts, System.StrUtils,
  FMX.Types, FMX.Controls, FMX.Layouts, FMX.Objects, FMX.StdCtrls, FMX.Graphics,
  Data.Bind.Controls, Data.Bind.Components, Data.Bind.Consts,
  FMX.Bind.Navigator, DesignIntf;

/// range TNavigateButton in three groups
const   NavigatorScrollings = [nbFirst, nbPrior, nbNext, nbLast,nbRefresh];
        NavigatorValidations = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel,
                                nbApplyUpdates];
        NavigatorCancelations = [nbDelete,nbCancel,nbCancelUpdates];

// property names ???
//        HintsArray : Array [TNavigateButton] of String = ('First', 'Prior', 'Next', 'Last', 'Insert', 'Delete', 'Edit', 'Post', 'Cancel', 'Refresh', 'ApplyUpdates', 'CancelUpdates');




type

  TColoredBindNavigator = class;

  TBtnsHints = class (TPersistent)
  private
    FOwner : TColoredBindNavigator;
    FButtonHints : Array [0..11] of String;
    function GetHint(const index : Integer) : String;
    function HintisStored(const index: Integer) : Boolean;
    procedure SetHint(const index : Integer; const Value : String) ;
   public
    constructor Create(aOwner : TColoredBindNavigator);
    destructor Destroy; override;
  published
    property _01First : String index 0 read GetHint write SetHint stored HintisStored;
    property _02Prior : String index 1 read GetHint write SetHint stored HintisStored;
    property _03Next : String index 2 read GetHint write SetHint stored HintisStored;
    property _04Last : String index 3 read GetHint write SetHint stored HintisStored;
    property _05Insert : String index 4 read GetHint write SetHint stored HintisStored;
    property _06Delete : String index 5 read GetHint write SetHint stored HintisStored;
    property _07Edit : String index 6 read GetHint write SetHint stored HintisStored;
    property _08Post : String index 7 read GetHint write SetHint stored HintisStored;
    property _09Cancel : String index 8 read GetHint write SetHint stored HintisStored;
    property _10Refresh : String index 9 read GetHint write SetHint stored HintisStored;
    property _11ApplyUpdate : String index 10 read GetHint write SetHint stored HintisStored;
    property _12CancelUpdate : String index 11 read GetHint write SetHint stored HintisStored;
  end;

  TGlyphColors = class(TPersistent)
  private
    FOwner : TColoredBindNavigator;
    FColors: array [0 .. 2] of TAlphaColor;
    FUseColors: Boolean;
    FThemeSensitive: Boolean;
    function GetColor(const index : Integer) : TAlphaColor;
    procedure SetColor(const Index: Integer; const Value: TAlphaColor);
    procedure SetThemeSensitive(const Value: Boolean);
    procedure SetUseColors(const Value: Boolean);
  public
    constructor Create(aOwner : TColoredBindNavigator);
    destructor Destroy; override;
  published
    property Navigation: TAlphaColor index 0 read GetColor write SetColor default TAlphaColors.Blue;
    property Edit: TAlphaColor index 1 read GetColor write SetColor default TAlphaColors.Green;
    property Cancel: TAlphaColor index 2 read GetColor write SetColor default TAlphaColors.Red;
    property UseColors : Boolean read FUseColors write SetUseColors default True;
    property ThemeSensitive : Boolean read FThemeSensitive write SetThemeSensitive default False;
  end;

  TColorNavButton = class helper for TBindNavButton
    /// set the color of the Tpath.fill.color property
   procedure setcolor(const c : TAlphaColor);
    /// apply the custom colors corresponding to the TNavigateButton type
    /// Three groups NavigatorScrollings,NavigatorValidations,NavigatorCancelations
    /// see const part
   procedure ApplyColorStyle(const customcolors : TGlyphColors; const background : TBrush=nil);
  end;


  [ComponentPlatforms(pidAllPlatforms)]
  TColoredBindNavigator = class(TCustomBindNavigator)
  private
    FNavigatorGlyphColors: TGlyphColors;
    FBtnHints : TBtnsHints;
    FOverrideBackground : TBrush;
    procedure SetGlyphColors(const Value: TGlyphColors);
    procedure SetBrushBackground(const Value: TBrush);
    procedure SetBtnHints(const Value: TBtnsHints);
  protected
    procedure Loaded; override;
    procedure Paint ; override;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure customcolors(scrollcolor, Updatecolor, cancelcolor : TAlphaColor);
    procedure ApplyColors;
    procedure SetButtonHints(const Show : Boolean = false);
    function GetDefaultGlyphColor : TAlphaColor;
  published
    property NavigatorGlyphColors: TGlyphColors read FNavigatorGlyphColors write SetGlyphColors stored true;
    property Hints : TBtnsHints read FBtnHints write SetBtnHints stored true;
    property OverrideBackGround : TBrush read FOverrideBackGround write SetBrushBackground default nil;
    property DataSource;
    property VisibleButtons;
    property Align;
    property Enabled;
    property CornerType;
    property Corners;
    property xRadius;
    property yRadius;
    property ConfirmDelete;
    property Visible;
    property BeforeAction;
    property ShowHint;
    property OnClick;
  end;

procedure Register;

implementation

procedure Register;
begin
//  RegisterPropertiesInCategory('Hints',TBtnsHints,HintsArray);
  RegisterComponents('Govel', [TColoredBindNavigator]);
end;

{ TColoredBindNavigator }

procedure TColoredBindNavigator.ApplyColors;
begin
  for var aButton  in Buttons do
     if OverrideBackground.Kind=TBrushKind.None
       then aButton.ApplyColorStyle(NavigatorGlyphColors)
       else aButton.ApplyColorStyle(NavigatorGlyphColors,OverrideBackGround);
end;

constructor TColoredBindNavigator.Create(AOwner: TComponent);
begin
    inherited;
    if not assigned(FNavigatorGlyphColors)
                then FNavigatorGlyphColors:=TGlyphColors.Create(Self);
    if not assigned(FBtnHints)
                then FBtnHints:=TBtnsHints.Create(Self);
    if not assigned(FOverrideBackground) then
                 FOverrideBackground:=TBrush.Create(TBrushKind.None,TAlphaColors.Null);
    ApplyColors;
end;

destructor TColoredBindNavigator.Destroy;
begin
  FreeAndNil(FNavigatorGlyphColors);
  FreeAndNil(FBtnHints);
  FreeAndNil(FOverrideBackground);
  inherited;
end;

function TColoredBindNavigator.GetDefaultGlyphColor: TAlphaColor;
begin
var d := TCornerButton.Create(Self);
d.Parent:=Self;
d.ApplyStyleLookup;
var S := d.FindStyleResource('text');
if (S <> nil) and (S is TText) then
      result:= TText(S).Color
 else result:=TAlphaColors.Null;
FreeAndNil(d);
end;

procedure TColoredBindNavigator.Loaded;
begin
  inherited Loaded;
  ApplyColors;
  SetButtonHints(Self.ShowHint);
end;

procedure TColoredBindNavigator.Paint;
begin
  inherited Paint;
  ApplyColors;
end;

procedure TColoredBindNavigator.SetBrushBackground(const Value: TBrush);
begin
  FOverrideBackGround.Assign(Value);
end;

procedure TColoredBindNavigator.SetBtnHints(const Value: TBtnsHints);
begin
  FBtnHints.Assign(Value);
end;

procedure TColoredBindNavigator.SetButtonHints(const Show : Boolean = false);
var indx : Integer;
begin
{$IF defined(ANDROID) OR defined(IOS)} exit; {$ENDIF}
for var b in Buttons do
 begin
  // b.ShowHint:=Show;  // ParentShowHint is true so useful ?
  indx:=Ord(TBindNavButton(B).Index);
  b.Hint:=FBtnHints.FButtonHints[indx];
 end;
end;

procedure TColoredBindNavigator.SetGlyphColors(const Value: TGlyphColors);
begin
  FNavigatorGlyphColors.Assign(Value);
  ApplyColors;
end;


procedure TColoredBindNavigator.customcolors(scrollcolor, Updatecolor,
  cancelcolor: TAlphaColor);
begin
  FNavigatorGlyphColors.Navigation:=ScrollColor;
  FNavigatorGlyphColors.Edit:=UpdateColor;
  FNavigatorGlyphColors.Cancel:=CancelColor;
  ApplyColors;
end;

{ TGlyphColors }

constructor TGlyphColors.Create(aOwner : TColoredBindNavigator);
begin
  FOwner:=aOwner;
  FColors[0] := TalphaColors.Blue;
  FColors[1] := TalphaColors.Green;
  FColors[2] := TalphaColors.Red;
  FThemeSensitive:=False;
  FUseColors:=True;
end;

destructor TGlyphColors.Destroy;
begin
  inherited;
end;


function TGlyphColors.GetColor(const Index: Integer): TAlphaColor;
begin
  Result := FColors[Index];
end;

procedure TGlyphColors.SetColor(const Index: Integer;const Value: TAlphaColor);
begin
  FColors[Index] := Value;
  FOwner.ApplyColors;
end;

procedure TGlyphColors.SetThemeSensitive(const Value: Boolean);
begin
  FThemeSensitive := Value;
  FOwner.ApplyColors;
end;

procedure TGlyphColors.SetUseColors(const Value: Boolean);
begin
  FUseColors := Value;
  FOwner.ApplyColors;
end;

{ TColorNavButton }
procedure TColorNavButton.ApplyColorStyle(const customcolors : TGlyphColors; const background : TBrush=nil);
var cdefault : TAlphaColor;
    nc,ec,cc : TAlphaColor;
{TODO -oOwner -cGeneral : Is that sufficient ?}
    function Light(const Col : TAlphaColor) : TAlphaColor;
    var  H,S,L : Single;
    begin
        RGBToHSL(col,H,S,L);
        Result := HSLtoRGB(H,0.75,0.75);
    end;

begin
nc:=customcolors.Navigation;
ec:=customcolors.Edit;
cc:=customcolors.Cancel;
cdefault:=customcolors.FOwner.GetDefaultGlyphColor;
if customcolors.ThemeSensitive
  AND (cdefault=TAlphaColors.White)  {todo -oOwner -cGeneral : Test HSL values instead ?}
then
begin
  nc:=Light(nc);
  ec:=Light(ec);
  cc:=Light(cc);
end;
if backGround<>nil then
 begin
    var s:=Self.FindStyleResource('background');
    if Assigned(s) AND (s is TRectangle)
       then TRectangle(s).Fill:=background;
 end;
if (TNavigateButton(Self.index) in NavigatorScrollings)
    AND (customcolors.Navigation<>TAlphacolors.Alpha)
 then Setcolor(IfThen(customcolors.UseColors,nc,cdefault));
if (TNavigateButton(Self.index) in NavigatorValidations)
    AND (customcolors.Edit<>TAlphacolors.Alpha)
 then Setcolor(IfThen(customcolors.UseColors,ec,cdefault));
if (TNavigateButton(Self.index) in NavigatorCancelations)
    AND (customcolors.cancel<>TAlphacolors.Alpha)
 then Setcolor(IfThen(customcolors.UseColors,cc,cdefault));
end;

procedure TColorNavButton.setcolor(const c: TAlphaColor);
begin
with Self do
   FPath.Fill.Color:=c;
end;


{ TBtnsHints }

constructor TBtnsHints.Create(aOwner: TColoredBindNavigator);
begin
  FOwner:=aOwner;
//  for var i:=0 to 12 do FBtnHints[i]:='';
end;

destructor TBtnsHints.Destroy;
begin
  inherited;
end;

function TBtnsHints.GetHint(const index: Integer): String;
begin
result:=FButtonHints[index];
end;

function TBtnsHints.HintisStored(const index: Integer) : Boolean;
begin
Result := FButtonHints[index]<>EmptyStr;
end;

procedure TBtnsHints.SetHint(const index: Integer; const Value: String);
begin
FButtonHints[index]:=Value;
end;


end.
