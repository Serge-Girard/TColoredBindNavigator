unit Govel.BindNavigator;

{TODO -oOwner -cGeneral : Ordering TBtnsHints and TGlyphColors properties}

interface

uses
  System.SysUtils, System.Classes,
  System.UITypes, System.Math, System.UIConsts, System.StrUtils,
  FMX.Types, FMX.Controls, FMX.Layouts, FMX.Objects, FMX.StdCtrls, FMX.Graphics,
  Data.Bind.Controls, Data.Bind.Components, Data.Bind.Consts,
  FMX.Bind.Navigator;

/// range TNavigateButton in three groups
const   NavigatorScrollings = [nbFirst, nbPrior, nbNext, nbLast,nbRefresh];
        NavigatorValidations = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel,
                                nbApplyUpdates];
        NavigatorCancelations = [nbDelete,nbCancel,nbCancelUpdates];


  var BtnHintId: array[TNavigateButton] of string = (SFirstRecord, SPriorRecord,
    SNextRecord, SLastRecord, SInsertRecord, SDeleteRecord, SEditRecord,
    SPostEdit, SCancelEdit, SRefreshRecord,
    SApplyUpdates, SCancelUpdates);

type

  TColoredBindNavigator = class;

  TBtnsHints = class (TPersistent)
  private
    FOwner : TColoredBindNavigator;
    FBtnHints : Array [0..11] of String;
    function GetHint(const index : Integer) : String;
    function HintisStored(const index: Integer) : Boolean;
    procedure SetHint(const index : Integer; const Value : String) ;
   public
    constructor Create(aOwner : TColoredBindNavigator);
    destructor Destroy; override;
  published
    property First : String index 0 read GetHint write SetHint stored HintisStored;
    property Prior : String index 1 read GetHint write SetHint stored HintisStored;
    property Next : String index 2 read GetHint write SetHint stored HintisStored;
    property Last : String index 3 read GetHint write SetHint stored HintisStored;
    property Insert : String index 4 read GetHint write SetHint stored HintisStored;
    property Delete : String index 5 read GetHint write SetHint stored HintisStored;
    property Edit : String index 6 read GetHint write SetHint stored HintisStored;
    property Post : String index 7 read GetHint write SetHint stored HintisStored;
    property Cancel : String index 8 read GetHint write SetHint stored HintisStored;
    property Refresh : String index 9 read GetHint write SetHint stored HintisStored;
    property ApplyUpdate : String index 10 read GetHint write SetHint stored HintisStored;
    property CancelUpdate : String index 11 read GetHint write SetHint stored HintisStored;
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
    FHints : TBtnsHints;
    FOverrideBackground : TBrush;
    procedure SetGlyphColors(const Value: TGlyphColors);
    procedure SetHints(const Value: TBtnsHints);
    procedure SetBrushBackground(const Value: TBrush);
  protected
    procedure Loaded; override;
    procedure Paint ; override;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure customcolors(scrollcolor, Updatecolor, cancelcolor : TAlphaColor);
    procedure ApplyColors;
    procedure SetButtonHints;
    function GetDefaultGlyphColor : TAlphaColor;
  published
    property NavigatorGlyphColors: TGlyphColors read FNavigatorGlyphColors write SetGlyphColors stored true;
    property Hints : TBtnsHints read FHints write SetHints stored true;
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
    property OnClick;
  end;

procedure Register;

implementation

procedure Register;
begin
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
    if not assigned(FHints)
                then FHints:=TBtnsHints.Create(Self);
    if not assigned(FOverrideBackground) then
                 FOverrideBackground:=TBrush.Create(TBrushKind.None,TAlphaColors.Null);
    ApplyColors;
end;

destructor TColoredBindNavigator.Destroy;
begin
  FreeAndNil(FNavigatorGlyphColors);
  FreeAndNil(FHints);
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

procedure TColoredBindNavigator.SetButtonHints;
var indx : Integer;
begin
if not self.ShowHint then  exit;
for var b in Buttons do
 begin
  b.ShowHint:=Self.ShowHint;
  indx:=Ord(TBindNavButton(B).Index);
  b.Hint:=FHints.FBtnHints[indx];
 end;
end;

procedure TColoredBindNavigator.SetGlyphColors(const Value: TGlyphColors);
begin
  FNavigatorGlyphColors.Assign(Value);
  ApplyColors;
end;

procedure TColoredBindNavigator.SetHints(const Value: TBtnsHints);
begin
  FHints.Assign(Value);
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
result:=FBtnHints[index];
end;

function TBtnsHints.HintisStored(const index: Integer) : Boolean;
begin
Result := FBtnHints[index]<>EmptyStr;
end;

procedure TBtnsHints.SetHint(const index: Integer; const Value: String);
begin
FBtnHints[index]:=Value;
end;


end.
