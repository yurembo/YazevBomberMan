(********************************YazevBomberMan********************************)
(*********************developed in YazevSoft by Yazev Yuriy********************)
(*******************************new Yazev's game*******************************)
(*********************Bomberman is a classic computer game*********************)
(**********I'll develop my version of this game, new and more powerful*********)
(***in this game I use OpenGL for graphics output and DirectInput to control***)
(****************in this game all events happen in 3D - space******************)
(******************************3D is better than 2D****************************)
(******************************Explode The World!!!****************************)
(*BAM!!!*BAM!!!*BAM!!!*BAM!!!*BAM!!!*BAM!!!*BAM!!!*BAM!!!*BAM!!!*BAM!!!*BAM!!!*)

//_begin : 16.08.2006                {*I'm Eighteen*}  ___  Yazev Yuriy
//_end   : 05.03.2007                {*I'm Nineteen*}  ___  Yazev Yuriy

//_begin of a development YazevBomberMan v1.5 : 08.03.2008
//                                    {*I'm Twenty*} _____  Yazev Yuriy
// 09.03.2008: реализовал механизм загрузки уровня: "YazevLoadLevelEngine"
//___end of a development YazevBomberMan v1.5 : 21.05.2008
//                                    {*I'm Twenty*} _____  Yazev Yuriy
// modified: 09.06.2008

unit YazevBomber01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OpenGL, AppEvnts, DirectInput8, ExtCtrls, StdCtrls, ComCtrls, MPlayer, jpeg;

type
  TYazevBombField = class(TForm)
    YazevAE: TApplicationEvents;
    YazevBombMine: TTimer;
    YazevPanel: TPanel;
    YazevScore: TLabel;
    YazevLife: TLabel;
    YazevBomberManActive: TTimer;
    YazevProgressLoading: TProgressBar;
    YazevLoadScreen: TPanel;
    YazevProgressTimer: TTimer;
    YazevVictoryScreen: TPanel;
    YazevGameComplete: TTimer;
    YazevGameOverScreen: TPanel;
    YazevGameOver: TTimer;
    YazevThanksScreen: TPanel;
    YazevMenu: TPanel;
    YazevResumeGameBut: TRadioButton;
    YazevNewGameBut: TRadioButton;
    YazevExitBut: TRadioButton;
    YazevKeyDelay: TTimer;
    YazevThanks: TTimer;
    YazevMusicPlayer: TMediaPlayer;
    YazevAuthorTitle: TPanel;
    Panel2: TPanel;
    YazevBomberManText: TLabel;
    Panel3: TPanel;
    YazevDeveloperText: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    YazevLoadLevelEngine: TListBox;
    YazevScreen: TPanel;
    Image5: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure YazevAEIdle(Sender: TObject; var Done: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure YazevBombMineTimer(Sender: TObject);
    procedure YazevBomberManActiveTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure YazevLoadScreenMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure YazevProgressTimerTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure YazevGameCompleteTimer(Sender: TObject);
    procedure YazevGameOverTimer(Sender: TObject);
    procedure YazevResumeGameButEnter(Sender: TObject);
    procedure YazevResumeGameButExit(Sender: TObject);
    procedure YazevMenuMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure YazevResumeGameButMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure YazevNewGameButMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure YazevExitButMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure YazevKeyDelayTimer(Sender: TObject);
    procedure YazevResumeGameButMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure YazevExitButMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure YazevNewGameButMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure YazevThanksTimer(Sender: TObject);
    procedure YazevMusicPlayerNotify(Sender: TObject);
  private
    { Private declarations }
    DC : HDC;
    rc : HGLRC;
    DI : IDirectInput8;
    DID : IDirectInputDevice8;
    GameNumber : Integer;

    procedure GetPixelFormatforOpenGL;
    procedure Init_DirectInput;
    procedure Check_Device;
    procedure Create_World;
    procedure Draw_World;
    procedure Destroy_World;
    procedure Start_Game;
    procedure Exit_Game;
    procedure Resume_Game;
    procedure New_Game;
    procedure StartUp_Music(songnum : Integer);
  public
    { Public declarations }
    GLactive, CanDrawScreen, KeyDelay  : Bool;
    xcam, ycam, zcam, lxcam, lycam, lzcam : GLfloat;
    SongNumber : Integer;
    protected
      procedure Mouse_Catch(var Msg : TMessage); message WM_SetCursor; 
  end;

  TYazevGameObject = class
    xpos, ypos, zpos, ydeg, w, h, v : GLfloat;
  end;

  TYazevLevel = class(TYazevGameObject)
       score, high_score : Integer;
       constructor Create;
       destructor Clean_Memory;
       procedure Draw;
       procedure Create_Monster_Cyl;
       procedure Create_Monster_Sph;
       procedure Create_Monster_Drop;
       procedure Create_Brick_Wall;
       procedure Create_GoldHeap;
       procedure Score_Plus;
       procedure Check_Win;
       procedure Create_ExitDoor;
       procedure LoadLevel(levname : String);
  end;

  TYazevCube = class(TYazevGameObject)
       constructor Create(x, z : GLfloat);
       destructor Clean_Memory(i : Integer);
       procedure Draw;
  end;

  TYazevBomberMan = class(TYazevGameObject)
    constructor Create(x, y, z, yd : GLfloat);
    destructor Clean_Memory;
    procedure Draw;
    procedure Mine;
    procedure KickedByMonster(mov : Integer);
   private
    lxpos, lypos, lzpos, rs, ls, rpl, lpl, rl, prl, ll, pll, rk, prk, lk, plk,
     hj, phj : GLfloat;
    GO, ahead, CanMine, active : Bool;
    life : Integer;
  end;

  TYazevBomb = class(TYazevGameObject)
      constructor Create(num : Integer; time : DWord; x, y, z : GLfloat);
      destructor Clean_Memory(i : Integer);
      procedure Draw;
      procedure Explode;
    private
    number : Integer;
    ThisSec, LastSec, timetoexplode : DWord;
    factor, degree : Single;
    limit : Bool;
  end;

  TYazevFire = class(TYazevGameObject)
      constructor Create(num, di, pnum : Integer; x, y, z : GLfloat);
      destructor Clean_Memory(num, pnum : Integer);
      function Draw : Bool;
      procedure Kill_Monsters;
      private
      number, dir, pnumber : Integer;
      zoom, zz : Single;
  end;

  TYazevFireFlame = class(TYazevGameObject)
      constructor Create(num, count : Integer; x, y, z : GLfloat);
      destructor Clean_Memory(num : Integer);
      procedure Draw;
      private
      number, amount, MaxFires : Integer;
      fires : Array of TYazevFire;
      ThisSec, LastSec : DWord;
   end;

   TYazevBrickWall = class(TYazevGameObject)
      constructor Create(num : Integer; x, z : GLfloat);
      destructor Clean_Memory(num : Integer);
      procedure Draw;
   end;

   TEnemy = class(TYazevGameObject)
     number, shape, lifesCount, move : Integer;
     sp_var : Single;
     change : Bool;
     lxpos, lzpos : GLfloat;
     ThisSec, LastSec : DWord;
     constructor Create(num, lifes, sh : Integer;
                        x, y, z, ww, hh, vv, degree : GLfloat); virtual; abstract;
     destructor Clean_Memory(num : Integer); virtual; abstract;
     procedure Draw; virtual; abstract;
     procedure Check_Clash; virtual; abstract;
     function Select_Way : Integer; virtual; abstract;
   end;

   TEnemyCyl = class(TEnemy)
     constructor Create(num, lifes, sh : Integer;
                        x, y, z, ww, hh, vv, degree : GLfloat); override;
     destructor Clean_Memory(num : Integer); override;
     procedure Draw; override;
     procedure Check_Clash; override;
     function Select_Way : Integer; override;
   end;

   TEnemySph = class(TEnemy)
     constructor Create(num, lifes, sh : Integer;
                        x, y, z, ww, hh, vv, degree : GLfloat); override;
     destructor Clean_Memory(num : Integer); override;
     procedure Draw; override;
     procedure Check_Clash; override;
     function Select_Way : Integer; override;
   end;

   TEnemyDrop = class(TEnemy)
     constructor Create(num, lifes, sh : Integer;
                        x, y, z, ww, hh, vv, degree : GLfloat); override;
     destructor Clean_Memory(num : Integer); override;
     procedure Draw; override;
     procedure Check_Clash; override;
     function Select_Way : Integer; override;
   end;

   TGold = class(TYazevGameObject)
     constructor Create(num : Integer; x, z : GLfloat);
     destructor Clean_Memory(num : Integer);
     procedure Draw;
   end;

   TExitDoor = class(TYazevGameObject)
      constructor Create(x, z : GLfloat);
      destructor Clean_Memory;
      procedure Draw;
   end;

   const
    ground = 1;
    cube = 2;
    bomb = 3;
    fire = 4;
    // enemys shapes
    cyl = 5;
    sph = 6;
    drop = 7;
    // wall
    brickwall = 8;
    // gold
    goldheap = 9;

    exdoor = 10;

    GL_LETTERS = 1000;
    //**************************************************************************
    encylinc : Array [0..2] of Integer = (3, 2, 2);

    ensphinc : Array [0..2] of Integer = (3, 0, 2);

    endropinc : Array [0..2] of Integer = (1, 1, 2);
    //**************************************************************************
(*    wallspos : Array [0..44, 0..1] of GLfloat = ((-12.5, -2.8), (-11.0, -2.8),
                                                (-9.7, -2.8), (-9.7, -1.5),
                                                (-9.7, -0.2), (-9.7, 1.1),
                                                (-9.7, 2.4), (-11.0, 2.4),
                                                (-12.5, 2.4),{}(-6.0, 4.7),
                                                (-4.8, 4.7), (-3.6, 4.7),
                                                (-2.4, 4.7), (-1.2, 4.7),
                                                (-4.8, 3.5), (-4.8, 2.3),
                                                (-4.8, 6.0), (-4.8, 7.3),
                                                (-2.4, 6.0), (-2.4, 7.3),{}
                                                (9.0, -5.3), (7.7, -5.3),
                                                (6.4, -5.3), (5.1, -5.3),
                                                (7.7, -4.0), (7.7, -2.7),
                                                (7.7, -1.5),{}(12.7, 7.2),
                                                (11.4, 7.2), (10.1, 7.2),
                                                (8.8, 7.2), (7.5, 7.2),
                                                (7.8, 6.0), (12.7, 4.8),
                                                (11.4, 4.8), (10.1, 4.8),
                                                (8.8, 4.8), (7.5, 4.8),{}
                                                (-4.7, -5.3), (-4.7, -4.1),
                                                (-4.7, -2.9), (-3.4, -2.9),
                                                (-2.1, -2.9), (-2.1, -4.1),
                                                (-2.1, -5.3));       *)
    //**************************************************************************
var
  YazevBombField: TYazevBombField;
  // game objects
   qO : GLUquadricObj;
  YazevBomberMan : TYazevBomberMan = nil;
  Level : TYazevLevel = nil;
  cubes : Array of TYazevCube;
  MaxBombs : Integer = 0;
  bombs : Array of TYazevBomb;
  fflames : Array of TYazevFireFlame;
  MaxFlames : Integer = 0;
  // enemys
  encyl : Array of TEnemyCyl;
  ensph : Array of TEnemySph;
  endrop : Array of TEnemyDrop;
  // wall
  walls : Array of TYazevBrickWall;
  // gold
  gold : Array of TGold;

  exitdoor : TExitDoor = nil;

  gameactive : Bool = false;
  // дополнительные переменные
  wii, vii, ybmpx, ybmpz, ybmry  : Single;
  GameStart : Bool = false;

implementation

uses DGLUT;

{$R *.DFM}

{ TYazevBomb }

procedure TYazevBombField.GetPixelFormatforOpenGL;
var
zPixel : Integer;
pfd : TPixelFormatDescriptor;
begin
FillChar(pfd, SizeOf(pfd), 0);
pfd.dwFlags := PFD_DRAW_TO_WINDOW OR PFD_SUPPORT_OPENGL OR PFD_DOUBLEBUFFER;
pfd.cColorBits := 32;
pfd.cDepthBits := 32;
zPixel := ChoosePixelFormat(DC, @pfd);
SetPixelFormat(DC, zPixel, @pfd);
end;

procedure TYazevBombField.FormCreate(Sender: TObject);
begin
WindowState := wsMaximized;// ~~~ потом раскомментирую
// Loading images
{
Image1.Picture.LoadFromFile('YazevBomberManGameLoading.bmp');
Image3.Picture.LoadFromFile('YazevBomberManWin.bmp');
Image2.Picture.LoadFromFile('YazevBomberManGameOver.bmp');
Image4.Picture.LoadFromFile('YazevBomberManThanks.bmp');
Image5.Picture.LoadFromFile('YazevBomberManGameStartUp.bmp');
}
Image1.Picture.LoadFromFile('YazevBomberManGameLoading.jpg');
Image3.Picture.LoadFromFile('YazevBomberManWin.jpg');
Image2.Picture.LoadFromFile('YazevBomberManGameOver.jpg');
Image4.Picture.LoadFromFile('YazevBomberManThanks.jpg');
Image5.Picture.LoadFromFile('YazevBomberManGameStartUp.jpg');
Application.ProcessMessages;
//
DC := GetDC(Handle);
GetPixelFormatforOpenGL;
rc := wglCreateContext(DC);
wglMakeCurrent(DC, rc);
Init_DirectInput;
Randomize;
SongNumber := 0;
GameNumber := 0;
Create_World;
end;

procedure TYazevBombField.FormDestroy(Sender: TObject);
begin
Destroy_World;
wglMakeCurrent(0, 0);
wglDeleteContext(rc);
ReleaseDC(Handle, DC);
DeleteDC(DC);
end;

procedure TYazevBombField.Create_World;
begin
glEnable(GL_DEPTH_TEST);
//glEnable(GL_COLOR_MATERIAL);
glEnable(GL_LIGHTING);
glEnable(GL_LIGHT0);
qO := gluNewQuadric;
GLactive := true;
CanDrawScreen := true;
KeyDelay := false;
glClearColor(0.3, 0.9, 1.0, 1.0);
end;

procedure TYazevBombField.YazevAEIdle(Sender: TObject; var Done: Boolean);
begin
if GLactive then begin
if (GameStart) then Draw_World;
Check_Device;
end;
Done := false;
end;

procedure TYazevBombField.Draw_World;
var
tps : TPaintStruct;
i : Integer;
begin
glClear(GL_COLOR_BUFFER_BIT OR GL_DEPTH_BUFFER_BIT);
if CanDrawScreen then begin
// Clash

if (YazevBomberMan <> nil) then begin
if (YazevBomberMan.zpos > Level.v + 0.3) or
   (YazevBomberMan.zpos < 1.6) then
YazevBomberMan.zpos := YazevBomberMan.lzpos;

if (YazevBomberMan.xpos > Level.w - 0.65) or
   (YazevBomberMan.xpos < 0.65) then
YazevBomberMan.xpos := YazevBomberMan.lxpos;

//glPushMatrix;
//glTranslatef(-10.0, 0.0, -3.5);
//if (YazevBomberMan <> nil) then begin
for i := Low(cubes) to High(cubes) do
if (YazevBomberMan <> nil) and (cubes[i] <> nil) then begin
if (YazevBomberMan.xpos + YazevBomberMan.w  > cubes[i].xpos - cubes[i].w )
and (YazevBomberMan.xpos{ - YazevBomberMan.w}  < cubes[i].xpos{ + cubes[0].w})
and (YazevBomberMan.zpos + YazevBomberMan.v  > cubes[i].zpos - cubes[i].v / 2 )
and (YazevBomberMan.zpos - YazevBomberMan.v / 2  < cubes[i].zpos {+ cubes[0].v})

or (YazevBomberMan.zpos > Level.v + 0.3) or
   (YazevBomberMan.zpos < 1.6)

or (YazevBomberMan.xpos > Level.w - 0.65) or
   (YazevBomberMan.xpos < 0.65)

 then begin
  YazevBomberMan.xpos := YazevBomberMan.lxpos;
    if YazevBomberMan.ahead then
  YazevBomberMan.zpos := YazevBomberMan.zpos + (sin(YazevBomberMan.ydeg / 57.3) * 0.01) else
  YazevBomberMan.zpos := YazevBomberMan.zpos - (sin(YazevBomberMan.ydeg / 57.3) * 0.01) / 2
 end;
if (YazevBomberMan.xpos + YazevBomberMan.w  > cubes[i].xpos - cubes[i].w )
and (YazevBomberMan.xpos{ - YazevBomberMan.w}  < cubes[i].xpos{ + cubes[0].w})
and (YazevBomberMan.zpos + YazevBomberMan.v  > cubes[i].zpos - cubes[i].v / 2 )
and (YazevBomberMan.zpos - YazevBomberMan.v / 2  < cubes[i].zpos {+ cubes[0].v})

or (YazevBomberMan.zpos > Level.v + 0.3) or
   (YazevBomberMan.zpos < 1.6)

or (YazevBomberMan.xpos > Level.w - 0.65) or
   (YazevBomberMan.xpos < 0.65)
   
 then begin
  YazevBomberMan.zpos := YazevBomberMan.lzpos;
      if YazevBomberMan.ahead then
  YazevBomberMan.xpos := YazevBomberMan.xpos + (cos(YazevBomberMan.ydeg / 57.3) * 0.01) else
  YazevBomberMan.xpos := YazevBomberMan.xpos - (cos(YazevBomberMan.ydeg / 57.3) * 0.01) / 2
  end;
if (YazevBomberMan.xpos + YazevBomberMan.w  > cubes[i].xpos - cubes[i].w )
and (YazevBomberMan.xpos{ - YazevBomberMan.w}  < cubes[i].xpos{ + cubes[0].w})
and (YazevBomberMan.zpos + YazevBomberMan.v  > cubes[i].zpos - cubes[i].v / 2 )
and (YazevBomberMan.zpos - YazevBomberMan.v / 2  < cubes[i].zpos {+ cubes[0].v})

or (YazevBomberMan.zpos > Level.v + 0.3) or
   (YazevBomberMan.zpos < 1.6)

or (YazevBomberMan.xpos > Level.w - 0.65) or
   (YazevBomberMan.xpos < 0.65)

 then begin
 YazevBomberMan.xpos := YazevBomberMan.lxpos;
 YazevBomberMan.zpos := YazevBomberMan.lzpos;
 end
end;
for i := Low(walls) to High(walls) do
if (walls[i] <> nil)
and (walls[i].xpos + walls[i].w / 2 > YazevBomberMan.xpos - YazevBomberMan.w / 2)
and (walls[i].xpos - walls[i].w / 2 < YazevBomberMan.xpos + YazevBomberMan.w / 2)
and (walls[i].zpos + walls[i].v / 2 > YazevBomberMan.zpos - YazevBomberMan.v / 2)
and (walls[i].zpos - walls[i].v / 2 < YazevBomberMan.zpos + YazevBomberMan.v / 2)

or (YazevBomberMan.zpos > Level.v + 0.3) or
   (YazevBomberMan.zpos < 1.6)

or (YazevBomberMan.xpos > Level.w - 0.65) or
   (YazevBomberMan.xpos < 0.65)

 then begin
 YazevBomberMan.xpos := YazevBomberMan.lxpos;
 YazevBomberMan.zpos := YazevBomberMan.lzpos;
 end;
end;
//glPopMatrix;
//Caption := FloatToStr(cubes[31].zpos) + '  ' + FloatToStr(YazevBomberMan.zpos);

BeginPaint(Handle, tps);
if Level <> nil then Level.Draw;
if YazevBomberMan <> nil then YazevBomberMan.Draw;
EndPaint(Handle, tps);
end;
SwapBuffers(DC);
end;

procedure TYazevBombField.FormActivate(Sender: TObject);
begin
GLactive := true
end;

procedure TYazevBombField.FormDeactivate(Sender: TObject);
begin
GLactive := false
end;

procedure TYazevBombField.Check_Device;
const
m = 0.025;// 0.02
r = 1.4;// 0.8
var
buts : Array [0..255] of Byte;
itog : HResult;
//z, x : Bool;
curpos : TPoint;
begin
curpos.x := ClientWidth div 2;
curpos.y := ClientHeight div 2;
ZeroMemory(@buts, SizeOf(buts));
itog := DID.GetDeviceState(SizeOf(buts), @buts);
if Failed (itog) then begin
itog := DID.Acquire;
while itog = DIERR_INPUTLOST do DID.Acquire;
end;
if (buts[DIK_ESCAPE] and $80 <> 0) and (not KeyDelay) and (gameactive) and (GameStart) then
if not YazevMenu.Visible then begin
CanDrawScreen := false;
YazevMenu.Left := ClientWidth div 2 - YazevMenu.Width div 2;
YazevMenu.Top := ClientHeight div 2 - YazevMenu.Height div 2;
YazevMenu.Visible := true;
YazevResumeGameBut.Checked := true;
YazevNewGameBut.Checked := false;
YazevExitBut.Checked := false;
YazevResumeGameBut.Color := clRed;
YazevNewGameBut.Color := clBlack;
YazevExitBut.Color := clBlack;
KeyDelay := true;
YazevKeyDelay.Enabled := true;
Mouse.CursorPos := curpos;
//
//Close
//
end else begin
YazevMenu.Visible := false;
CanDrawScreen := true;
KeyDelay := true;
YazevKeyDelay.Enabled := true;
end;
if ((buts[DIK_LEFT] or buts[DIK_A]) and $80 <> 0) and (YazevBomberMan <> nil)
and (GameStart) then YazevBomberMan.ydeg := YazevBomberMan.ydeg + r;
if ((buts[DIK_RIGHT] or buts[DIK_D]) and $80 <> 0) and (YazevBomberMan <> nil)
and (GameStart) then YazevBomberMan.ydeg := YazevBomberMan.ydeg - r;
if (((buts[DIK_UP] or buts[DIK_W]) and $80 <> 0) and (YazevBomberMan <> nil) and (GameStart)) or
((buts[DIK_RETURN] and $80 <> 0) and (not GameStart)) then begin
if not GameStart then begin
YazevScreen.Visible := false;
GameStart := true;
end;
with YazevBomberMan do begin
ahead := true;
//z := false;
//x := false;
lxcam := xcam;
lycam := ycam;
lzcam := zcam;
GO := true;
//if zpos <> lzpos then z := true;
//if xpos <> lxpos then x := true;
lxpos := xpos;
lzpos := zpos;
zpos := zpos + cos(ydeg / 57.3) * m;
xpos := xpos + sin(ydeg / 57.3) * m;
{
xcam := xcam - sin(ydeg / 57.3) * 0.01;
zcam := zcam - cos(ydeg / 57.3) * 0.01;
if not z then begin
zcam := 0.0;
lzcam := 0.0;
end;
if not x then begin
xcam := 0.0;
lxcam := 0.0;
end;
}
xcam := -xpos - 0.3;
zcam := -zpos - 3.0;
glTranslatef(xcam, ycam, zcam);
glTranslatef(-lxcam, -lycam, -lzcam);
end;
end else
if ((buts[DIK_DOWN] or buts[DIK_S]) and $80 <> 0) and (YazevBomberMan <> nil)
and (GameStart) then begin
with YazevBomberMan do begin
ahead := false;
//z := false;
//x := false;
lxcam := xcam;
lycam := ycam;
lzcam := zcam;
GO := true;
//if zpos <> lzpos then z := true;
//if xpos <> lxpos then x := true;
lxpos := xpos;
lzpos := zpos;
zpos := zpos - cos(ydeg / 57.3) * m;
xpos := xpos - sin(ydeg / 57.3) * m;
{
xcam := xcam + sin(ydeg / 57.3) * 0.005;
zcam := zcam + cos(ydeg / 57.3) * 0.005;
if not z then begin
zcam := 0.0;
lzcam := 0.0;
end;
if not x then begin
xcam := 0.0;
lxcam := 0.0;
end;
}
xcam := -xpos - 0.3;
zcam := -zpos - 3.0;
glTranslatef(xcam, ycam, zcam);
glTranslatef(-lxcam, -lycam, -lzcam);
end;
end else if YazevBomberMan <> nil then YazevBomberMan.GO := false;
//
if (buts [DIK_SPACE] and $80 <> 0) and (YazevBomberMan <> nil) and (gamestart) then
YazevBomberMan.Mine;
//*****************************************************************************
if (gameactive) and (GameStart) then begin
if (buts [DIK_0] and $80 <> 0) then ShowMessage('w = ' + FloatToStr(Level.w) + '; v = ' + FloatToStr(Level.v));
if (buts [DIK_1] and $80 <> 0) then StartUp_Music(1);
if (buts [DIK_2] and $80 <> 0) then StartUp_Music(2);
if (buts [DIK_3] and $80 <> 0) then StartUp_Music(3);
if (buts [DIK_4] and $80 <> 0) then StartUp_Music(4);
if (buts [DIK_5] and $80 <> 0) then StartUp_Music(5);
if (buts [DIK_6] and $80 <> 0) then StartUp_Music(6);
if (buts [DIK_7] and $80 <> 0) then StartUp_Music(7);
end;
end;

procedure TYazevBombField.Init_DirectInput;
begin
DirectInput8Create(hInstance, DirectInput_Version, IID_IDirectInput8, DI, nil);
DI.CreateDevice(GUID_SysKeyboard, DID, nil);
DID.SetDataFormat(c_dfDIKeyboard);
DID.SetCooperativeLevel(Handle, DISCL_FOREGROUND OR DISCL_EXCLUSIVE);
end;

procedure TYazevBombField.Destroy_World;
begin
gluDeleteQuadric(qO);
if YazevBomberMan <> nil then YazevBomberMan.Clean_Memory;
if Level <> nil then Level.Clean_Memory;
end;

{ TYazevBomb }

destructor TYazevBomb.Clean_Memory(i : Integer);
begin
bombs[i] := nil;
bombs[i].Free;
end;

constructor TYazevBomb.Create(num : Integer; time : DWord; x, y, z: GLfloat);
begin
number := num;
timetoexplode := time;
xpos := x;
ypos := y;
zpos := z;
ydeg := 0.0;
w := 0.8;
h := 0.8;
v := 0.8;
factor := 1.0;
limit := false;
degree := 0.0;
ThisSec := GetTickCount;
LastSec := GetTickCount;
end;

procedure TYazevBomb.Draw;
begin
ThisSec := GetTickCount;
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glScalef(factor, factor, factor);
if (not limit) and (factor < 1.2) then
factor := factor + factor / 150 else
if (not limit) and (factor > 1.2) then
limit := true else
if (limit) and (factor > 0.7) then
factor := factor - factor / 150 else
if (limit) and (factor < 0.7) then
limit := false;
glRotatef(degree, 0.0, -1.0, 0.0);
degree := degree + 5;
if degree > 360.0 then degree := 0.0;
glCallList(bomb);
glPopMatrix;
if ThisSec - LastSec > timetoexplode then Explode;
end;

procedure TYazevBomb.Explode;
begin
MaxFlames := MaxFlames + 1;
SetLength(fflames, MaxFlames);
fflames[MaxFlames - 1] := TYazevFireFlame.Create(MaxFlames - 1, 12, xpos, ypos, zpos);
Clean_Memory(number);
end;

{ TYazevBomberMan }

constructor TYazevBomberMan.Create(x, y, z, yd: GLfloat);
begin
xpos := x;
ypos := y;
zpos := z;
lxpos := x;
lypos := y;
lzpos := z;
ydeg := yd;
{
rs := 0.0;
ls := 0.0;
rpl := 0.6;
lpl := 0.6;
rl := 0.0;
prl := 0.5;
ll := 0.0;
pll := 0.5;
rk := 0.0;
prk := 0.7;
lk := 0.0;
plk := 0.7;

hj := 0.0;
phj := 0.00085;
}//~~~эталон

rs := 0.0;
ls := 0.0;
rpl := 1.8;
lpl := 1.8;
rl := 0.0;
prl := 1.5;
ll := 0.0;
pll := 1.5;
rk := 0.0;
prk := 2.1;
lk := 0.0;
plk := 2.1;

hj := 0.0;
phj := 0.0024;

v := 1.0;
w := 1.0;
h := 2.0;

GO := false;
ahead := true;

CanMine := true;
active := true;

life := 100;
end;

destructor TYazevBomberMan.Clean_Memory;
begin
YazevBomberMan := nil;
YazevBomberMan.Free
end;

procedure TYazevBomberMan.Draw;
const
mat_for_head : Array [0..3] of GLFloat = (1.0, 1.0, 0.0, 1.0);
mat_for_eyes : Array [0..3] of GLFloat = (1.0, 0.0, 0.0, 1.0);
mat_for_body : Array [0..3] of GLFloat = (0.0, 1.0, 0.0, 1.0);
mat_for_arms : Array [0..3] of GLFloat = (0.0, 0.0, 1.0, 1.0);
mat_for_legs : Array [0..3] of GLFloat = (0.0, 0.0, 0.0, 1.0);
mat_for_bots : Array [0..3] of GLFloat = (0.6, 0.3, 0.1, 1.0);
mat_for_black : Array [0..3] of GLfloat = (0.1, 0.1, 0.1, 1.0);
var
i : Integer;
begin
if not active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_black);
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glRotatef(ydeg, 0.0, 1.0, 0.0);//~~~
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_head);
glTranslatef(0.0, -2.0, 0.0);
glPushMatrix;

glTranslatef(0.0, hj, 0.0);
//if GO then begin
if hj > 0.03 then begin
phj := -phj;
hj := hj + phj;
end else
if hj < -0.03 then begin
phj := -phj;
hj := hj + phj;
end else
hj := hj + phj;
//end;
gluSphere(qO, 0.15, 30, 30);
glPushMatrix;
//if active then
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_eyes);
glTranslatef(0.05, 0.0, 0.11);
glutSolidSphere(0.05, 30, 30);
glTranslatef(-0.1, 0.0, 0.0);
glutSolidSphere(0.05, 30, 30);
glPushMatrix;
glTranslatef(0.05, -0.04, 0.02);
glutSolidSphere(0.03, 30, 30);
glPopMatrix;
glPushMatrix;
glTranslatef(0.05, -0.1, -0.05);
glScalef(1.1, 0.5, 1.0);
glutSolidCube(0.1);
glPopMatrix;
glPopMatrix;
glPopMatrix;
glTranslatef(0.0, -0.1, 0.0);
glPushMatrix;
glRotatef(90.0, 1.0, 0.0, 0.0);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_body)
else glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_black);
gluCylinder(qO, 0.05, 0.05, 0.1, 30, 30);
glPopMatrix;
glPushMatrix;
glTranslatef(0.0, -0.38, 0.0);
glScalef(0.9, 1.5, 1.0);
gluSphere(qO, 0.2, 30, 30);
glPopMatrix;
glPushMatrix;
glTranslatef(0.13, -0.24, 0.0);

glRotatef(rs, 1.0, 0.0, 0.0);
if GO then begin
if rs > 120 then begin
rpl := -rpl;
rs := rs + rpl;
end else
if rs < 0 then begin
rpl := -rpl;
rs := rs + rpl;
end else
rs := rs + rpl;
end;
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_head);
glutSolidSphere(0.07, 30, 30);
glPushMatrix;
glTranslatef(0.04, 0.0, 0.0);
glRotatef(20.0, 0.0, 1.0, 0.0);
glRotatef(45.0, 1.0, 0.0, 0.0);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_arms);
gluCylinder(qO, 0.03, 0.03, 0.3, 30, 30);
glPopMatrix;
glPushMatrix;
//glTranslatef(0.28, -0.23, 0.0);
glTranslatef(0.125, -0.25, 0.24);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_head);
glutSolidSphere(0.07, 30, 30);
glPushMatrix;
glRotatef(-60.0, 1.0, 0.0, 0.0);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_arms);
gluCylinder(qO, 0.03, 0.03, 0.3, 30, 30);
glPopMatrix;
glPopMatrix;
glPushMatrix;
glTranslatef(0.125, 0.03, 0.4);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_head);
glutSolidSphere(0.07, 30, 30);
glPopMatrix;
glPopMatrix;
glPushMatrix;
glTranslatef(-0.13, -0.24, 0.0);

glRotatef(-rs, 1.0, 0.0, 0.0);
//if rs < 360 then rs := rs + 0.5 else rs := 0;
if GO then begin
if ls > 120 then begin
lpl := -lpl;
ls := ls + lpl;
end else
if ls < 0 then begin
lpl := -lpl;
ls := ls + lpl;
end else
ls := ls + lpl;
end;
glRotatef(180.0, 1.0, 0.0, 0.0);
glutSolidSphere(0.07, 30, 30);
glPushMatrix;
glTranslatef(-0.045, 0.0, 0.0);
glRotatef(-13.5, 0.0, 1.0, 0.0);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_arms);
gluCylinder(qO, 0.03, 0.03, 0.3, 30, 30);
glPopMatrix;
glPushMatrix;
//glTranslatef(-0.28, -0.23, 0.0);
glTranslatef(-0.11, 0.01, 0.3);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_head);
glutSolidSphere(0.07, 30, 30);
glPushMatrix;
//glRotatef(100.0, 0.0, -0.5, -0.5);
glRotatef(-90.0, 1.0, 0.0, 0.0);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_arms);
gluCylinder(qO, 0.03, 0.03, 0.3, 30, 30);
glPopMatrix;
glPopMatrix;
glPushMatrix;
glTranslatef(-0.11, 0.34, 0.3);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_head);
glutSolidSphere(0.07, 30, 30);
glPopMatrix;
glPopMatrix;
glPushMatrix;
glTranslatef(0.09, -0.65, 0.0);

glRotatef(rl, 1.0, 0.0, 0.0);//
if GO then begin
if rl > 50 then begin
prl := -prl;
rl := rl + prl;
end else
if rl < -40 then begin
prl := -prl;
rl := rl + prl;
end else
rl := rl + prl;
end;
glutSolidSphere(0.07, 30, 30);
glPushMatrix;
//glRotatef(130.0, 0.0, 0.5, -0.5);
glRotatef(90.0, 1.0, 0.0, 0.0);
glTranslatef(0.01, 0.0, 0.07);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_legs);
gluCylinder(qO, 0.03, 0.03, 0.3, 30, 30);
glPopMatrix;
glPushMatrix;
glTranslatef(0.0, -0.4, 0.0);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_head);

glRotatef(rk, 1.0, 0.0, 0.0);//
if GO then begin
if rk > 60 then begin
prk := -prk;
rk := rk + prk;
end else
if rk < 0 then begin
prk := -prk;
rk := rk + prk;
end else
rk := rk + prk;
end;
glutSolidSphere(0.07, 30, 30);
glPushMatrix;
//glRotatef(200.0, 0.0, 0.5, -0.5);
glRotatef(90.0, 1.0, 0.0, 0.0);
glTranslatef(0.0, 0.0, 0.06);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_legs);
gluCylinder(qO, 0.03, 0.03, 0.3, 30, 30);
glPopMatrix;
glPushMatrix;
glTranslatef(-0.06, -0.35, 0.0);
glScalef(1.0, 1.0, 1.7);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_bots);
glTranslatef(0.05, 0.0, 0.0);
glutSolidCube(0.1);
glPopMatrix;
glPopMatrix;
glPopMatrix;
glPushMatrix;
glTranslatef(-0.09, -0.65, 0.0);

glRotatef(-ll, 1.0, 0.0, 0.0);//
if GO then begin
if ll > 50 then begin
pll := -pll;
ll := ll + pll;
end else
if ll < -40 then begin
pll := -pll;
ll := ll + pll;
end else
ll := ll + pll;
end;
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_head);
glutSolidSphere(0.07, 30, 30);
glPushMatrix;
//glRotatef(130.0, 0.0, -0.5, 0.5);
glRotatef(90.0, 1.0, 0.0, 0.0);
glTranslatef(-0.01, 0.0, 0.05);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_legs);
gluCylinder(qO, 0.03, 0.03, 0.3, 30, 30);
glPopMatrix;
glPushMatrix;
glTranslatef(-0.01, -0.4, 0.0);

glRotatef(rk, 1.0, 0.0, 0.0);//
if GO then begin
if lk > 60 then begin
plk := -plk;
lk := lk + plk;
end else
if lk < 0 then begin
plk := -plk;
lk := lk + plk;
end else
lk := lk + plk;
end;
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_head);
glutSolidSphere(0.07, 30, 30);
glPushMatrix;
//glRotatef(200.0, 0.0, -0.5, 0.5);
glRotatef(90.0, 1.0, 0.0, 0.0);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_legs);
gluCylinder(qO, 0.03, 0.03, 0.3, 30, 30);
glPopMatrix;
glPushMatrix;
glTranslatef(0.06, -0.3, 0.0);
glScalef(1.0, 1.0, 1.7);
glTranslatef(-0.05, -0.05, 0.0);
if active then glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_bots);
glutSolidCube(0.1);
glPopMatrix;
glPopMatrix;
glPopMatrix;
glPopMatrix;
//if Level <> nil then Level.Draw;
for i := Low(bombs) to High(bombs) do
if (bombs[i] <> nil)
and (bombs[i].xpos + bombs[i].w / 2 > xpos - w / 2)
and (bombs[i].xpos - bombs[i].w / 2 < xpos + w / 2)
and (bombs[i].zpos + bombs[i].v / 2 > zpos - v / 2)
and (bombs[i].zpos - bombs[i].v / 2 < zpos + v / 2)
then begin
xpos := lxpos;
zpos := lzpos;
end;
for i := Low(gold) to High(gold) do
if (gold[i] <> nil)
and (gold[i].xpos + gold[i].w / 2 > xpos - w / 2)
and (gold[i].xpos - gold[i].w / 2 < xpos + w / 2)
and (gold[i].zpos + gold[i].v / 2 > zpos - v / 2)
and (gold[i].zpos - gold[i].v / 2 < zpos + v / 2)
then begin
gold[i].Clean_Memory(i);
Level.score := Level.score + 50;
Level.Score_Plus;
if exitdoor = nil then Level.Check_Win;
end;
end;

procedure TYazevBomberMan.Mine;
var
j : Integer;
b : Bool;
begin
b := false;
if CanMine then begin
MaxBombs := MaxBombs + 1;
SetLength(bombs, MaxBombs);
bombs[MaxBombs - 1] := TYazevBomb.Create(MaxBombs - 1, 2000, xpos + sin(ydeg / 57.3), -3.13, zpos + cos(ydeg / 57.3));
CanMine := false;
YazevBombField.YazevBombMine.Enabled := true;
if (bombs[Maxbombs - 1].zpos > Level.v + 0.2) or
   (bombs[Maxbombs - 1].zpos < 1.5)
 then begin
  bombs[Maxbombs - 1].Clean_Memory(Maxbombs - 1);
  Maxbombs := Maxbombs - 1;
  b := true;
//  break;
  end else
if (bombs[Maxbombs - 1].xpos > Level.w - 0.55) or
   (bombs[Maxbombs - 1].xpos < 0.55)
    then begin
  bombs[Maxbombs - 1].Clean_Memory(Maxbombs - 1);
  Maxbombs := Maxbombs - 1;
  b := true;
//  break;
  end else begin
for j := Low(cubes) to High(cubes) do // developed: 6.12.2006
if ((bombs[Maxbombs - 1] <> nil) and (cubes[j] <> nil))
and (bombs[Maxbombs - 1].xpos + bombs[Maxbombs - 1].w  > cubes[j].xpos - cubes[j].w )
and (bombs[Maxbombs - 1].xpos < cubes[j].xpos)
and (bombs[Maxbombs - 1].zpos + bombs[Maxbombs - 1].v  > cubes[j].zpos - cubes[j].v / 2 )
and (bombs[Maxbombs - 1].zpos - bombs[Maxbombs - 1].v / 2  < cubes[j].zpos)
 then begin
  bombs[Maxbombs - 1].Clean_Memory(Maxbombs - 1);
  Maxbombs := Maxbombs - 1;
  b := true;
  break;
  end
end;
if not b then
for j := Low(walls) to High(walls) do // developed: 29.12.2006
if ((bombs[Maxbombs - 1] <> nil) and (walls[j] <> nil))
and (walls[j].xpos + walls[j].w / 2 > bombs[Maxbombs - 1].xpos - bombs[Maxbombs - 1].w / 2)
and (walls[j].xpos - walls[j].w / 2 < bombs[Maxbombs - 1].xpos + bombs[Maxbombs - 1].w / 2)
and (walls[j].zpos + walls[j].v / 2 > bombs[Maxbombs - 1].zpos - bombs[Maxbombs - 1].v / 2)
and (walls[j].zpos - walls[j].v / 2 < bombs[Maxbombs - 1].zpos + bombs[Maxbombs - 1].v / 2)
 then begin
  bombs[Maxbombs - 1].Clean_Memory(Maxbombs - 1);
  Maxbombs := Maxbombs - 1;
  break;
end

end;
end;

procedure TYazevBomberMan.KickedByMonster(mov : Integer);
const
st = 0.3;
begin
active := false;
life := life - 10;
YazevBombField.YazevLife.Caption := 'Life: ' + IntToStr(life) + '%';
if life <= 0 then begin
Clean_Memory;
YazevBombField.YazevGameOver.Enabled := true;
end else begin
YazevBombField.YazevBomberManActive.Enabled := true;
{case mov of
0 : zpos := zpos - st;
1 : xpos := xpos - st;
2 : zpos := zpos + st;
3 : xpos := xpos + st;
end;}
end;
end;

{ TYazevLevel }

procedure TYazevLevel.Check_Win;
var
i : Integer;
begin
if Level.score >= high_score then begin//high_score
i := Random(High(walls));
exitdoor := TExitDoor.Create(walls[i].xpos, walls[i].zpos);
end;
end;

destructor TYazevLevel.Clean_Memory;
var
i : Integer;
begin
Level := nil;
Level.Free;
glDeleteLists(ground, 1);
for i := Low(cubes) to High(cubes) do
if cubes[i] <> nil then cubes[i].Clean_Memory(i);
glDeleteLists(cube, 1);
for i := Low(bombs) to High(bombs) do
if bombs[i] <> nil then bombs[i].Clean_Memory(i);
glDeleteLists(bomb, 1);
for i := Low(fflames) to High(fflames) do
if fflames[i] <> nil then fflames[i].Clean_Memory(i);
glDeleteLists(fire, 1);
for i := Low(walls) to High(walls) do
if walls[i] <> nil then walls[i].Clean_Memory(i);
glDeleteLists(brickwall, 1);
// monsters
for i := Low(encyl) to High(encyl) do
if encyl[i] <> nil then encyl[i].Clean_Memory(i);
glDeleteLists(cyl, 1);
for i := Low(ensph) to High(ensph) do
if ensph[i] <> nil then ensph[i].Clean_Memory(i);
glDeleteLists(sph, 1);
for i := Low(endrop) to High(endrop) do
if endrop[i] <> nil then endrop[i].Clean_Memory(i);
glDeleteLists(drop, 1);
for i := Low(gold) to High(gold) do
if gold[i] <> nil then gold[i].Clean_Memory(i);
glDeleteLists(goldheap, 1);
if exitdoor <> nil then exitdoor.Clean_Memory;
glDeleteLists(exdoor, 1);
end;

constructor TYazevLevel.Create;
const
mat_for_ground : Array [0..3] of GLfloat = (0.7, 0.7, 0.7, 1.0);
mat_for_cube : Array [0..3] of GLfloat = (0.8, 0.8, 0.8, 1.0);
mat_for_bomb : Array [0..3] of GLfloat = (0.3, 0.3, 0.3, 1.0);
mat_for_fire : Array [0..3] of GLfloat = (1.0, 0.4, 0.0, 1.0);
mat_for_hotfire : Array [0..3] of GLfloat = (3.0, 2.0, 0.0, 0.0);
//------------------------------------------------------------------------------
begin
glNewList(cube, GL_COMPILE);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_cube);
glPushMatrix;
glScalef(1.0, 2.0, 1.0);
glutSolidCube(1.0);
glPopMatrix;
glEndList;

Create_Brick_Wall;

glNewList(bomb, GL_COMPILE);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_bomb);
gluSphere(qO, 0.4, 30, 30);
glTranslatef(0.0, 0.4, 0.0);
glutSolidCube(0.2);
glTranslatef(0.0, 0.05, 0.0);
glPushMatrix;
glRotatef(90.0, -1.0, 0.0, 0.0);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_cube);
gluCylinder(qO, 0.02, 0.02, 0.3, 20, 20);
glPopMatrix;
glTranslatef(0.0, 0.3, 0.0);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_fire);
gluSphere(qO, 0.07, 7, 7);
glEndList;

glNewList(fire, GL_COMPILE);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_hotfire);
glPushMatrix;
gluSphere(qO, 0.3, 7, 4);
glPopMatrix;
glEndList;
// enemys_monsters
Create_Monster_Cyl;

Create_Monster_Sph;

Create_Monster_Drop;
// gold
Create_GoldHeap;
//exit
Create_ExitDoor;

high_score := 0;
// Load Level
LoadLevel('Level01.ywf');
// ground and walls
score := 0;
xpos := 0.0;
ypos := -1.77;
zpos := 0.5;
ydeg := 0.0;
w := wii;
h := 0.1;
v := vii;
{
glNewList(ground, GL_COMPILE);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_ground);
glBegin(GL_QUADS);
glNormal3f(0.0, 1.0, 0.0);
glVertex3f(xpos - w / 2, ypos, zpos + v / 2);
glVertex3f(xpos + w / 2, ypos, zpos + v / 2);
glVertex3f(xpos + w / 2, ypos, zpos - v / 2);
glVertex3f(xpos - w / 2, ypos, zpos - v / 2);
glEnd;

glBegin(GL_QUADS);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_cube);
glVertex3f(xpos - w / 2, ypos, zpos - v / 2);
glVertex3f(xpos - w / 2, ypos + 2, zpos - v / 2);
glVertex3f(xpos + w / 2, ypos + 2, zpos - v / 2);
glVertex3f(xpos + w / 2, ypos, zpos - v / 2);
glEnd;

glBegin(GL_QUADS);
glVertex3f(xpos - w / 2, ypos, zpos + v / 2);
glVertex3f(xpos - w / 2, ypos + 2, zpos + v / 2);
glVertex3f(xpos + w / 2, ypos + 2, zpos + v / 2);
glVertex3f(xpos + w / 2, ypos, zpos + v / 2);
glEnd;

glPushMatrix;
glRotatef(90.0, 0.0, 1.0, 0.0);
glBegin(GL_QUADS);
glVertex3f(zpos + v / 2 - 1.0, ypos, xpos - w / 2);
glVertex3f(zpos + v / 2 - 1.0, ypos + 2, xpos - w / 2);
glVertex3f(zpos - v / 2 - 1.0, ypos + 2, xpos - w / 2);
glVertex3f(zpos - v / 2 - 1.0, ypos, xpos - w / 2);
glEnd;

glBegin(GL_QUADS);
glVertex3f(zpos + v / 2 - 1.0, ypos, xpos + w / 2);
glVertex3f(zpos + v / 2 - 1.0, ypos + 2, xpos + w / 2);
glVertex3f(zpos - v / 2 - 1.0, ypos + 2, xpos + w / 2);
glVertex3f(zpos - v / 2 - 1.0, ypos, xpos + w / 2);
glEnd;
glPopMatrix;
glEndList;
}
glNewList(ground, GL_COMPILE);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_ground);
glBegin(GL_QUADS);
glNormal3f(0.0, 1.0, 0.0);
glVertex3f(xpos, ypos, zpos + v);
glVertex3f(xpos + w, ypos, zpos + v);
glVertex3f(xpos + w, ypos, zpos);
glVertex3f(xpos, ypos, zpos);
glEnd;

glBegin(GL_QUADS);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_cube);
glVertex3f(xpos, ypos, zpos);
glVertex3f(xpos, ypos + 2, zpos);
glVertex3f(xpos + w, ypos + 2, zpos);
glVertex3f(xpos + w, ypos, zpos);
glEnd;

glBegin(GL_QUADS);
glVertex3f(xpos, ypos, zpos + v);
glVertex3f(xpos, ypos + 2, zpos + v);
glVertex3f(xpos + w, ypos + 2, zpos + v);
glVertex3f(xpos + w, ypos, zpos + v);
glEnd;

glPushMatrix;
glRotatef(90.0, 0.0, 1.0, 0.0);
glBegin(GL_QUADS);
glVertex3f(zpos - v - 1.0, ypos, xpos);
glVertex3f(zpos - v - 1.0, ypos + 2, xpos);
glVertex3f(zpos - 1.0, ypos + 2, xpos);
glVertex3f(zpos - 1.0, ypos, xpos);
glEnd;

glBegin(GL_QUADS);
glVertex3f(zpos - v - 1.0, ypos, xpos + w);
glVertex3f(zpos - v - 1.0, ypos + 2, xpos + w);
glVertex3f(zpos - 1.0, ypos + 2, xpos + w);
glVertex3f(zpos - 1.0, ypos, xpos + w);
glEnd;
glPopMatrix;
glEndList;
end;

procedure TYazevLevel.Create_Brick_Wall;
const
mat_for_cube : Array [0..3] of GLfloat = (0.8, 0.8, 0.2, 1.0);
begin
glNewList(brickwall, GL_COMPILE);
glPushMatrix;
glScalef(1.0, 2.0, 1.0);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_cube);
glutSolidCube(1.0);
glPopMatrix;
glEndList;
end;

procedure TYazevLevel.Create_ExitDoor;
const
mat_for_door : Array [0..3] of GLfloat = (0.4, 0.4, 0.1, 1.0);
mat_for_handle : Array [0..3] of GLfloat = (1.5, 1.5, 0.0, 1.0);
begin
glNewList(exdoor, GL_COMPILE);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_door);
glPushMatrix;
glScalef(0.9, 1.8, 0.9);
glutSolidCube(1.0);
glPopMatrix;
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_handle);
glPushMatrix;
glTranslatef(-0.25, 0.4, 0.4);
glScalef(0.1, 0.1, 0.2);
glutSolidTorus(0.4, 0.9, 10, 10);
glPopMatrix;
glPushMatrix;
glRotatef(90.0, 0.0, 1.0, 0.0);
glTranslatef(-0.25, 0.4, 0.4);
glScalef(0.1, 0.1, 0.2);
glutSolidTorus(0.4, 0.9, 10, 10);
glPopMatrix;
glEndList;
end;

procedure TYazevLevel.Create_GoldHeap;
const
mat_for_gold : Array [0..3] of GLfloat = (1.1, 1.1, 0.0, 1.0);
begin
glNewList(goldheap, GL_COMPILE);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_gold);
gluCylinder(qO, 0.5, 0.0, 0.8, 10, 10);
glEndList;
end;

procedure TYazevLevel.Create_Monster_Cyl;
const
cyl_mat_for_eyes : Array [0..3] of GLfloat = (0.8, 0.8, 0.8, 1.0);
cyl_mat_for_body : Array [0..3] of GLfloat = (0.5, 0.7, 0.2, 1.0);
cyl_mat_for_head : Array [0..3] of GLfloat = (0.7, 0.9, 0.4, 1.0);
cyl_mat_for_mouth : Array [0..3] of GLfloat = (0.3, 0.1, 0.1, 1.0);
cyl_mat_for_arms : Array [0..3] of GLfloat = (1.0, 1.0, 0.0, 1.0);
cyl_mat_for_hands : Array [0..3] of GLfloat = (1.0, 0.0, 0.0, 1.0);
begin
glNewList(cyl, GL_COMPILE);
glPushMatrix;
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_body);
gluCylinder(qO, 0.35, 0.35, 1.0, 10, 10);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_head);
glutSolidSphere(0.35, 10, 10);
glPushMatrix;
glTranslatef(-0.15, 0.2, -0.175);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_eyes);
glutSolidSphere(0.1, 10, 10);
glTranslatef(0.3, 0.0, 0.0);
glutSolidSphere(0.1, 10, 10);
glPopMatrix;
glTranslatef(0.0, 0.25, 0.1);
glPushMatrix;
glScalef(1.2, 1.0, 0.7);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_mouth);
glutSolidCube(0.3);
glPopMatrix;
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_arms);
glPushMatrix;
glTranslatef(-0.23, -0.1, 0.0);
glRotatef(90.0, -1.0, 0.0, 0.0);
gluCylinder(qO, 0.075, 0.075, 0.5, 10, 10);
glTranslatef(0.0, 0.0, 0.5);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_hands);
glutSolidCube(0.2);
glPopMatrix;
glPushMatrix;
glTranslatef(0.23, -0.1, 0.0);
glRotatef(90.0, -1.0, 0.0, 0.0);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_arms);
gluCylinder(qO, 0.075, 0.075, 0.5, 10, 10);
glTranslatef(0.0, 0.0, 0.5);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_hands);
glutSolidCube(0.2);
glPopMatrix;
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_mouth);
glPushMatrix;
glTranslatef(0.0, -0.25, 0.8);
glScalef(4.0, 6.0, 1.0);
glutSolidCube(0.2);
glPopMatrix;
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @cyl_mat_for_arms);
glPushMatrix;
glRotatef(90.0, 0.0, 1.0, 0.0);
glTranslatef(-0.95, 0.3, -0.35);
glScalef(1.0, 1.0, 1.4);
gluCylinder(qO, 0.085, 0.085, 0.5, 10, 10);
glTranslatef(0.0, -0.2, 0.0);
gluCylinder(qO, 0.085, 0.085, 0.5, 10, 10);
glTranslatef(0.0, -0.2, 0.0);
gluCylinder(qO, 0.085, 0.085, 0.5, 10, 10);
glTranslatef(0.0, -0.2, 0.0);
gluCylinder(qO, 0.085, 0.085, 0.5, 10, 10);
glTranslatef(0.0, -0.2, 0.0);
gluCylinder(qO, 0.085, 0.085, 0.5, 10, 10);
glTranslatef(0.0, -0.2, 0.0);
gluCylinder(qO, 0.085, 0.085, 0.5, 10, 10);
glPopMatrix;
glPopMatrix;
glEndList;
end;

procedure TYazevLevel.Create_Monster_Drop;
const
mat_for_body : Array [0..3] of GLfloat = (0.5, 0.5, 0.9, 1.0);
mat_for_eyes : Array [0..3] of GLfloat = (0.75, 0.75, 0.1, 1.0);
mat_for_arms : Array [0..3] of GLfloat = (0.1, 0.8, 0.3, 1.0);
begin
glNewList(drop, GL_COMPILE);
glPushMatrix;
glPushMatrix;
glRotatef(90.0, -1.0, 0.0, 0.0);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_body);
gluCylinder(qO, 0.0, 0.35, 1.3, 10, 10);
glPopMatrix;
glTranslatef(0.0, 1.4, 0.0);
glutSolidSphere(0.4, 10, 10);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_eyes);
glTranslatef(0.17, 0.17, 0.25);
glutSolidSphere(0.1, 10, 10);
glTranslatef(-0.17 * 2, 0.0, 0.0);
glutSolidSphere(0.1, 10, 10);
glTranslatef(0.17, -0.1, 0.1);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_arms);
glPushMatrix;
glTranslatef(-0.27, -0.2, -0.15);
glPushMatrix;
glRotatef(90.0, 1.0, 0.0, 0.0);
gluCylinder(qO, 0.02, 0.02, 0.5, 10, 10);
glPopMatrix;
glTranslatef(0.0, -0.5, 0.0);
glutSolidSphere(0.05, 10, 10);
glRotatef(-30.0, 1.0, 0.0, 0.0);
gluCylinder(qO, 0.02, 0.02, 0.5, 10, 10);
glTranslatef(0.0, 0.0, 0.5);
glRotatef(30.0, -1.0, 0.0, 0.0);
gluCylinder(qO, 0.02, 0.02, 0.2, 10, 10);
glRotatef(60.0, 1.0, 0.0, 0.0);
gluCylinder(qO, 0.02, 0.02, 0.2, 10, 10);
glPopMatrix;
glTranslatef(0.57, 0.0, 0.0);
glPushMatrix;
glTranslatef(-0.27, -0.2, -0.15);
glPushMatrix;
glRotatef(90.0, 1.0, 0.0, 0.0);
gluCylinder(qO, 0.02, 0.02, 0.5, 10, 10);
glPopMatrix;
glTranslatef(0.0, -0.5, 0.0);
glutSolidSphere(0.05, 10, 10);
glRotatef(-30.0, 1.0, 0.0, 0.0);
gluCylinder(qO, 0.02, 0.02, 0.5, 10, 10);
glTranslatef(0.0, 0.0, 0.5);
glRotatef(30.0, -1.0, 0.0, 0.0);
gluCylinder(qO, 0.02, 0.02, 0.2, 10, 10);
glRotatef(60.0, 1.0, 0.0, 0.0);
gluCylinder(qO, 0.02, 0.02, 0.2, 10, 10);
glPopMatrix;
glPopMatrix;
glEndList;
end;

procedure TYazevLevel.Create_Monster_Sph;
const
mat_for_body : Array [0..3] of GLfloat = (0.8, 0.0, 0.0, 1.0);
mat_for_eyes : Array [0..3] of GLfloat = (0.3, 0.3, 0.8, 1.0);
mat_for_mouth : Array [0..3] of GLfloat = (2.0, 2.0, 2.0, 1.0);
mat_for_peak : Array [0..3] of GLfloat = (3.0, 2.0, 0.0, 1.0);
begin
glNewList(sph, GL_COMPILE);
glPushMatrix;
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_body);
glutSolidSphere(0.5, 10, 10);
glPushMatrix;
glTranslatef(0.2, 0.1, 0.4);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_eyes);
glutSolidSphere(0.1, 10, 10);
glTranslatef(-0.4, 0.0, 0.0);
glutSolidSphere(0.1, 10, 10);
glTranslatef(0.2, -0.2, 0.0);
glPushMatrix;
glScalef(1.5, 1.0, 1.0);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_mouth);
glutSolidCube(0.2);
glPopMatrix;
glTranslatef(-0.13, 0.0, 0.0);
glTranslatef(0.0, 0.35, -0.1);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_peak);
glPushMatrix;
glRotatef(-45.0, 1.0, 1.0, 0.0);
gluCylinder(qO, 0.1, 0.0, 0.4, 10, 10);
glPopMatrix;
glPushMatrix;
glTranslatef(0.25, 0.0, 0.0);
glRotatef(-45.0, 1.0, -1.0, 0.0);
gluCylinder(qO, 0.1, 0.0, 0.4, 10, 10);
glPopMatrix;
glPopMatrix;

glPopMatrix;
glEndList;
end;

procedure TYazevLevel.Draw;
var
i, l : Integer;
begin
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glCallList(ground);
glTranslatef(-1.0, -1.0, -1.0);
glPushMatrix;
//glTranslatef(-10.0, 0.0, -3.5);
for i := Low(cubes) to High(cubes) do
if cubes[i] <> nil then cubes[i].Draw;
glPopMatrix;
glPopMatrix;
l := 0;
for i := Low(bombs) to High(bombs) do
if bombs[i] <> nil then bombs[i].Draw else l := l + 1;
if l = High(bombs) + 1 then begin
MaxBombs := 0;
SetLength(bombs, MaxBombs);
end;
l := 0;
for i := Low(fflames) to High(fflames) do
if fflames[i] <> nil then fflames[i].Draw else l := l + 1;
if l = High(fflames) + 1 then begin
MaxFlames := 0;
SetLength(fflames, MaxFlames);
end;
for i := Low(walls) to High(walls) do
if walls[i] <> nil then walls[i].Draw;
// monsters
for i := Low(encyl) to High(encyl) do
if encyl[i] <> nil then encyl[i].Draw;
//YazevBombField.Caption := IntToStr(High(bombs))
for i := Low(ensph) to High(ensph) do
if ensph[i] <> nil then ensph[i].Draw;
for i := Low(endrop) to High(endrop) do
if endrop[i] <> nil then endrop[i].Draw;
// gold
for i := Low(gold) to High(gold) do
if gold[i] <> nil then gold[i].Draw;
// exit
if exitdoor <> nil then exitdoor.Draw;
end;

procedure TYazevLevel.LoadLevel(levname: String);
var
i, j, lc, numpar, obj_num, count : Integer;
s,  posx, posz, roty, obj_type, obj_count : String;
kreat : Bool;
px, pz, ry : Single;
begin
obj_num := 0;
px := 0;
pz := 0;
ry := 0;
with YazevBombField do begin
YazevLoadLevelEngine.Items.LoadFromFile(levname);
for i := 0 to YazevLoadLevelEngine.Items.Count - 1 do begin
numpar := 0;
kreat := true;
posx := '';
posz := '';
roty := '';
s := YazevLoadLevelEngine.Items.Strings[i];
for j := 1 to Length(s) do
case s[j] of
'#' : begin
kreat := false;
break;
end;
'!' : numpar := numpar + 1;
{',' : begin
Delete(s, j, 1);       параметры зависят от настроек операционной системы
Insert('.', s, j - 1);
end;}
'$' : begin
obj_num := 0;
obj_type := '';
obj_count := '';
lc := j + 1;
while s[lc] <> ':' do begin
Insert(s[lc], obj_type, Length(obj_type) + 1);
lc := lc + 1;
end;
for lc := lc + 1 to Length(s) do Insert(s[lc], obj_count, Length(obj_count) + 1);
count := StrToInt(obj_count);
if obj_type = 'cube' then SetLength(cubes, count) else
if obj_type = 'box' then SetLength(walls, count) else
if obj_type = 'gold' then SetLength(gold, count) else
if obj_type = 'encyl' then SetLength(encyl, count) else
if obj_type = 'ensph' then SetLength(ensph, count) else
if obj_type = 'endrop' then SetLength(endrop, count) else
if obj_type = 'Score' then high_score := count;
kreat := false;
Break;
end else
case numpar of
0 : Insert(s[j], posx, Length(posx) + 1);
1 : Insert(s[j], posz, Length(posz) + 1);
2 : Insert(s[j], roty, Length(roty) + 1);
end; // case
end; // case
if kreat then begin
if posx <> '' then px := StrToFloat(posx);
if posz <> '' then pz := StrToFloat(posz);
if roty <> '' then ry := StrToFloat(roty);
if obj_type = 'cube' then
cubes[obj_num] := TYazevCube.Create(px, pz) else
if obj_type = 'box' then
walls[obj_num] := TYazevBrickWall.Create(obj_num, px, pz) else
if obj_type = 'gold' then
gold[obj_num] := TGold.Create(obj_num, px, pz) else
if obj_type = 'encyl' then
encyl[obj_num] := TEnemyCyl.Create(obj_num, 0, 0, px, -2.15, pz, 1.0, 2.0, 1.0, ry) else
if obj_type = 'ensph' then
ensph[obj_num] := TEnemySph.Create(obj_num, 0, 1, px, -2.5, pz, 1.0, 2.0, 1.0, ry) else
if obj_type = 'endrop' then
endrop[obj_num] := TEnemyDrop.Create(obj_num, 0, 2, px, -3.5, pz, 1.0, 2.0, 1.0, ry) else
if obj_type = 'ground' then begin
wii := px;
vii := pz;
end else
if obj_type = 'YazevBomberMan' then begin
ybmpx := px;
ybmpz := pz;
ybmry := ry;
// YazevBomberMan
YazevBomberMan := TYazevBomberMan.Create(ybmpx, 0, ybmpz, ybmry);
end;
// переменная-счётчик
obj_num := obj_num + 1;
end; // if
end; // for
end; // with
end;

procedure TYazevLevel.Score_Plus;
begin
YazevBombField.YazevScore.Caption := 'Score: ' + IntToStr(score);
end;

{ TYazevCube }

destructor TYazevCube.Clean_Memory(i : Integer);
begin
cubes[i] := nil;
cubes[i].Free
end;

constructor TYazevCube.Create(x, z : GLfloat);
begin
xpos := x;
ypos := 0.0;
zpos := z;
ydeg := 0.0;
w := 1.0;
h := 2.0;
v := 1.0;
end;

procedure TYazevCube.Draw;
begin
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glCallList(cube);
glPopMatrix;
end;

{ TYazevFire }

destructor TYazevFire.Clean_Memory(num, pnum: Integer);
begin
fflames[pnum].fires[num] := nil;
fflames[pnum].fires[num].Free;
end;

constructor TYazevFire.Create(num, di, pnum: Integer; x, y, z: GLfloat);
begin
number := num;
xpos := x;
ypos := y;
zpos := z;
ydeg := 0.0;
w := 0.6;
h := 0.6;
v := 0.6;
zoom := 1.0;
zz := 0.02;
dir := di;
pnumber := pnum
end;

function TYazevFire.Draw : Bool;
var
b : Bool;
i : Integer;
begin
b := false;
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glRotatef(ydeg, -1.0, -1.0, 1.0);
ydeg := ydeg + 5;
if ydeg >= 360.0 then ydeg := 0.0;
glScalef(zoom, zoom, zoom);
zoom := zoom + zz;
if zoom > 2.0 then begin
zoom := 2.0;
zz := 0.0;
b := true;
end;
glCallList(fire);
glPopMatrix;
if (YazevBomberMan <> nil)
and (YazevBomberMan.xpos + YazevBomberMan.w / 2 > xpos - w / 2)
and (YazevBomberMan.xpos - YazevBomberMan.w / 2 < xpos + w / 2)
and (YazevBomberMan.zpos + YazevBomberMan.v / 2 > zpos - v / 2)
and (YazevBomberMan.zpos - YazevBomberMan.v / 2 < zpos + v / 2)
 then begin
  YazevBombField.YazevLife.Caption := 'Life: 0%';
  YazevBomberMan.Clean_Memory;
  Clean_Memory(number, pnumber);
  YazevBombField.YazevGameOver.Enabled := true;
  end;
for i := Low(walls) to High(walls) do
if (walls[i] <> nil)
and (walls[i].xpos + walls[i].w / 2 > xpos - w / 2)
and (walls[i].xpos - walls[i].w / 2 < xpos + w / 2)
and (walls[i].zpos + walls[i].v / 2 > zpos - v / 2)
and (walls[i].zpos - walls[i].v / 2 < zpos + v / 2)
 then begin
  walls[i].Clean_Memory(i);
  Clean_Memory(number, pnumber);
  Level.score := Level.score + 10;
  Level.Score_Plus;
  end;
//********************************\\
Kill_Monsters;
if exitdoor = nil then Level.Check_Win;
//********************************\\
Result := b;
end;

procedure TYazevFire.Kill_Monsters;
var
i : Integer;
begin
for i := Low(encyl) to High(encyl) do
if (encyl[i] <> nil)
and (encyl[i].xpos + encyl[i].w / 2 > xpos - w / 2)
and (encyl[i].xpos - encyl[i].w / 2 < xpos + w / 2)
and (encyl[i].zpos + encyl[i].v / 2 > zpos - v / 2)
and (encyl[i].zpos - encyl[i].v / 2 < zpos + v / 2)
 then begin
  encyl[i].Clean_Memory(i);
  Clean_Memory(number, pnumber);
  Level.score := Level.score + 100;
  Level.Score_Plus;
  end;
for i := Low(ensph) to High(ensph) do
if (ensph[i] <> nil)
and (ensph[i].xpos + ensph[i].w / 2 > xpos - w / 2)
and (ensph[i].xpos - ensph[i].w / 2 < xpos + w / 2)
and (ensph[i].zpos + ensph[i].v / 2 > zpos - v / 2)
and (ensph[i].zpos - ensph[i].v / 2 < zpos + v / 2)
 then begin
  ensph[i].Clean_Memory(i);
  Clean_Memory(number, pnumber);
  Level.score := Level.score + 150;
  Level.Score_Plus;
  end;
for i := Low(endrop) to High(endrop) do
if (endrop[i] <> nil)
and (endrop[i].xpos + endrop[i].w / 2 > xpos - w / 2)
and (endrop[i].xpos - endrop[i].w / 2 < xpos + w / 2)
and (endrop[i].zpos + endrop[i].v / 2 > zpos - v / 2)
and (endrop[i].zpos - endrop[i].v / 2 < zpos + v / 2)
 then begin
  endrop[i].Clean_Memory(i);
  Clean_Memory(number, pnumber);
  Level.score := Level.score + 200;
  Level.Score_Plus;
  end;
end;

{ TYazevFireFlame }

destructor TYazevFireFlame.Clean_Memory(num: Integer);
var
i : Integer;
begin
for i := Low(fires) to High(fires) do
if fires[i] <> nil then fires[i].Clean_Memory(i, number);
MaxFires := 0;
SetLength(fires, MaxFires);
fflames[num] := nil;
fflames[num].Free;
end;

constructor TYazevFireFlame.Create(num, count: Integer; x, y, z: GLfloat);
const
di : Array [0..3] of Integer = (1, 2, 3, 4);
var
i : Integer;
begin
number := num;
xpos := x;
ypos := y;
zpos := z;
w := 0.1;
h := 0.1;
v := 0.1;
amount := count;
MaxFires := 4;
SetLength(fires, MaxFires);
for i := 0 to 3 do
fires[i] := TYazevFire.Create(i, di[i], number, x, y, z);
ThisSec := GetTickCount;
LastSec := GetTickCount;
end;

procedure TYazevFireFlame.Draw;
const
//a = 0.4;
b = 0.8;
var
i, j, count : Integer;
x, z : Single;
begin
ThisSec := GetTickCount;
count := High(fires);
for i := Low(fires) to count do begin
x := 0.0;
z := 0.0;
if fires[i] <> nil then begin
if fires[i].Draw then
if MaxFires < amount then begin
case fires[i].dir of
1 : x := b;
2 : z := b;
3 : x := -b;
4 : z := -b;
end;
MaxFires := MaxFires + 1;
SetLength(fires, MaxFires);
fires[MaxFires - 1] := TYazevFire.Create(MaxFires - 1, fires[i].dir, number,
fires[i].xpos + x, fires[i].ypos, fires[i].zpos + z);
if (fires[MaxFires - 1] <> nil) and (YazevBomberMan <> nil) then begin
if (fires[MaxFires - 1].zpos > Level.v + 0.2) or
   (fires[MaxFires - 1].zpos < 1.5)
 then begin
  fires[MaxFires - 1].Clean_Memory(MaxFires - 1, number);
  MaxFires := MaxFires - 1;
  break;
  end else
if (fires[MaxFires - 1].xpos > Level.w - 0.55) or
   (fires[MaxFires - 1].xpos < 0.55)
    then begin
  fires[MaxFires - 1].Clean_Memory(MaxFires - 1, number);
  MaxFires := MaxFires - 1;
  break;
  end else begin
for j := Low(cubes) to High(cubes) do // developed: 6.12.2006
if ((fires[MaxFires - 1] <> nil) and (cubes[j] <> nil))
and (fires[MaxFires - 1].xpos + fires[MaxFires - 1].w  > cubes[j].xpos - cubes[j].w )
and (fires[MaxFires - 1].xpos < cubes[j].xpos)
and (fires[MaxFires - 1].zpos + fires[MaxFires - 1].v  > cubes[j].zpos - cubes[j].v / 2 )
and (fires[MaxFires - 1].zpos - fires[MaxFires - 1].v / 2  < cubes[j].zpos)
 then begin
  fires[MaxFires - 1].Clean_Memory(MaxFires - 1, number);
  MaxFires := MaxFires - 1;
  break;
end
end
end
end else begin
 Clean_Memory(number);
 exit;
 end;
end;
end;
if ThisSec - LastSec > 3000 then begin
 Clean_Memory(number);
 exit;
 end;
end;

procedure TYazevBombField.YazevBombMineTimer(Sender: TObject);
begin
if YazevBomberMan <> nil then YazevBomberMan.CanMine := true;
YazevBombMine.Enabled := false;
end;

{ TEnemyCyl }

procedure TEnemyCyl.Check_Clash;
const
st = 0.6;
var
i : Integer;
begin
for i := Low(cubes) to High(cubes) do
if (cubes[i] <> nil)
and (xpos + w > cubes[i].xpos - cubes[i].w )
and (xpos{ - YazevBomberMan.w}  < cubes[i].xpos{ + cubes[0].w})
and (zpos + v > cubes[i].zpos - cubes[i].v / 2 )
and (zpos - v / 2 < cubes[i].zpos {+ cubes[0].v})
 then begin
  move := Select_Way;
   xpos := lxpos;
   zpos := lzpos;
   end;

for i := Low(walls) to High(walls) do
if (walls[i] <> nil)
and (walls[i].xpos + walls[i].w / 2 > xpos - w / 1.5)
and (walls[i].xpos - walls[i].w / 2 < xpos + w / 1.5)
and (walls[i].zpos + walls[i].v / 2 > zpos - v / 1.5)
and (walls[i].zpos - walls[i].v / 2 < zpos + v / 1.5)
 then begin
  move := Select_Way;
   xpos := lxpos;
   zpos := lzpos;
   end;

if (zpos > Level.v + 0.2) or
   (zpos < 1.7) then begin
    zpos := lzpos;
    move := Select_Way;
end;

if (xpos > Level.w - 0.55) or
   (xpos < 0.75) then begin
    xpos := lxpos;
    move := Select_Way;
end;

for i := Low(bombs) to High(bombs) do
if (bombs[i] <> nil)
and (bombs[i].xpos + bombs[i].w / 2 > xpos - w / 2)
and (bombs[i].xpos - bombs[i].w / 2 < xpos + w / 2)
and (bombs[i].zpos + bombs[i].v / 2 > zpos - v / 2)
and (bombs[i].zpos - bombs[i].v / 2 < zpos + v / 2)
then begin
xpos := lxpos;
zpos := lzpos;
end;
end;

destructor TEnemyCyl.Clean_Memory(num: Integer);
begin
encyl[num] := nil;
encyl[num].Free;
end;

constructor TEnemyCyl.Create(num, lifes, sh: Integer; x, y, z, ww, hh,
  vv, degree: GLfloat);
begin
number := num;
lifescount := lifes;
shape := sh;
xpos := x;
lxpos := x;
ypos := y;
zpos := z;
lzpos := z;
ydeg := degree;
w := ww;
h := hh;
v := vv;
Change := false;
sp_var := 1.2;
move := encylinc[num];
ThisSec := GetTickCount;
LastSec := ThisSec;
end;

procedure TEnemyCyl.Draw;
const
mat_for_lamp : Array [0..3] of GLfloat = (1.5, 0.5, 0.0, 1.0);
st = 0.02;
begin
lxpos := xpos;
lzpos := zpos;
ThisSec := GetTickCount;
if ThisSec - LastSec > 1000 then begin
move := Select_Way;
LastSec := GetTickCount;
end;
case move of
0 : zpos := zpos - st;
1 : xpos := xpos - st;
2 : zpos := zpos + st;
3 : xpos := xpos + st;
end;
Check_Clash;
if not change then sp_var := sp_var - 0.004 else sp_var := sp_var + 0.004;
if sp_var < 0.7 then change := true else
if sp_var > 1.0 then change := false;
if (YazevBomberMan <> nil) and (YazevBomberMan.active)
and (YazevBomberMan.xpos + YazevBomberMan.w / 2 > xpos - w / 2)
and (YazevBomberMan.xpos - YazevBomberMan.w / 2 < xpos + w / 2)
and (YazevBomberMan.zpos + YazevBomberMan.v / 2 > zpos - v / 2)
and (YazevBomberMan.zpos - YazevBomberMan.v / 2 < zpos + v / 2)
 then YazevBomberMan.KickedByMonster(move);
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glRotatef(90.0, 1.0, 0.0, 0.0);
glRotatef(ydeg, 0.0, 0.0, 1.0);
glScalef(1.0, 1.0, 1.2);
glCallList(cyl);
glPushMatrix;
glTranslatef(0.0, 0.0, -0.25);
glScalef(sp_var, sp_var, sp_var);    // Look Out!!! "scale" is used here
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_lamp);
glutSolidSphere(0.2, 10, 10);
glPopMatrix;
glPopMatrix;
end;

function TEnemyCyl.Select_Way: Integer;
var
rec, m : Integer;
begin
m := 0;
rec := random(39);
   if (rec >= 0) and (rec < 10) then m := 0 else
   if (rec >= 10) and (rec < 20) then m := 1 else
   if (rec >= 20) and (rec < 30) then m := 2 else
   if (rec >= 30) and (rec <= 39) then m := 3;
 case m of
  0 : ydeg := 180.0;
  1 : ydeg := 90.0;
  2 : ydeg := 0.0;
  3 : ydeg := 270.0;
 end;
Result := m;
end;

{ TEnemySph }

procedure TEnemySph.Check_Clash;
const
st = 0.6;
var
i : Integer;
begin
for i := Low(cubes) to High(cubes) do
if (cubes[i] <> nil)
and (xpos + w > cubes[i].xpos - cubes[i].w )
and (xpos{ - YazevBomberMan.w}  < cubes[i].xpos{ + cubes[0].w})
and (zpos + v > cubes[i].zpos - cubes[i].v / 2 )
and (zpos - v / 2 < cubes[i].zpos {+ cubes[0].v})
 then begin
  move := Select_Way;
   xpos := lxpos;
   zpos := lzpos;
   end;

for i := Low(walls) to High(walls) do
if (walls[i] <> nil)
and (walls[i].xpos + walls[i].w / 2 > xpos - w / 1.5)
and (walls[i].xpos - walls[i].w / 2 < xpos + w / 1.5)
and (walls[i].zpos + walls[i].v / 2 > zpos - v / 1.5)
and (walls[i].zpos - walls[i].v / 2 < zpos + v / 1.5)
 then begin
  move := Select_Way;
   xpos := lxpos;
   zpos := lzpos;
   end;

if (zpos > Level.v + 0.2) or
   (zpos < 1.7) then begin
    zpos := lzpos;
    move := Select_Way;
end;

if (xpos > Level.w - 0.55) or
   (xpos < 0.75) then begin
    xpos := lxpos;
    move := Select_Way;
end;

for i := Low(bombs) to High(bombs) do
if (bombs[i] <> nil)
and (bombs[i].xpos + bombs[i].w / 2 > xpos - w / 2)
and (bombs[i].xpos - bombs[i].w / 2 < xpos + w / 2)
and (bombs[i].zpos + bombs[i].v / 2 > zpos - v / 2)
and (bombs[i].zpos - bombs[i].v / 2 < zpos + v / 2)
then begin
xpos := lxpos;
zpos := lzpos;
end;
end;

destructor TEnemySph.Clean_Memory(num: Integer);
begin
ensph[num] := nil;
ensph[num].Free
end;

constructor TEnemySph.Create(num, lifes, sh: Integer; x, y, z, ww, hh,
  vv, degree: GLfloat);
begin
number := num;
lifescount := lifes;
shape := sh;
xpos := x;
ypos := y;
zpos := z;
ydeg := degree;
w := ww;
h := hh;
v := vv;
Change := false;
sp_var := 0.0;
move := ensphinc[num];
ThisSec := GetTickCount;
LastSec := ThisSec;
end;

procedure TEnemySph.Draw;
const
step = 0.5;
st = 0.02;
begin
lxpos := xpos;
lzpos := zpos;
ThisSec := GetTickCount;
if ThisSec - LastSec > 500 then begin
move := Select_Way;
LastSec := GetTickCount;
end;
case move of
0 : zpos := zpos - st;
1 : xpos := xpos - st;
2 : zpos := zpos + st;
3 : xpos := xpos + st;
end;
Check_Clash;
if not Change then begin
if sp_var > -30.0 then sp_var := sp_var - step else Change := true;
end else begin
if sp_var < 30.0 then sp_var := sp_var + step else Change := false;
end;
if (YazevBomberMan <> nil) and (YazevBomberMan.active)
and (YazevBomberMan.xpos + YazevBomberMan.w / 2 > xpos - w / 2)
and (YazevBomberMan.xpos - YazevBomberMan.w / 2 < xpos + w / 2)
and (YazevBomberMan.zpos + YazevBomberMan.v / 2 > zpos - v / 2)
and (YazevBomberMan.zpos - YazevBomberMan.v / 2 < zpos + v / 2)
 then YazevBomberMan.KickedByMonster(move);
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glRotatef(ydeg, 0.0, 1.0, 0.0);
glRotatef(sp_var, 0.0, 0.0, 1.0);
glCallList(sph);
glPopMatrix;
end;

function TEnemySph.Select_Way: Integer;
var
rec, m : Integer;
begin
m := 0;
rec := random(39);
   if (rec >= 0) and (rec < 10) then m := 0 else
   if (rec >= 10) and (rec < 20) then m := 1 else
   if (rec >= 20) and (rec < 30) then m := 2 else
   if (rec >= 30) and (rec <= 39) then m := 3;
 case m of
  0 : ydeg := 180.0;
  1 : ydeg := 270.0;
  2 : ydeg := 0.0;
  3 : ydeg := 90.0;
 end;
Result := m;
end;

{ TEnemyDrop }

procedure TEnemyDrop.Check_Clash;
const
st = 0.6;
var
i : Integer;
begin
for i := Low(cubes) to High(cubes) do
if (cubes[i] <> nil)
and (xpos + w > cubes[i].xpos - cubes[i].w )
and (xpos{ - YazevBomberMan.w}  < cubes[i].xpos{ + cubes[0].w})
and (zpos + v > cubes[i].zpos - cubes[i].v / 2 )
and (zpos - v / 2 < cubes[i].zpos {+ cubes[0].v})
 then begin
  move := Select_Way;
   xpos := lxpos;
   zpos := lzpos;
   end;

for i := Low(walls) to High(walls) do
if (walls[i] <> nil)
and (walls[i].xpos + walls[i].w / 2 > xpos - w / 1.5)
and (walls[i].xpos - walls[i].w / 2 < xpos + w / 1.5)
and (walls[i].zpos + walls[i].v / 2 > zpos - v / 1.5)
and (walls[i].zpos - walls[i].v / 2 < zpos + v / 1.5)
 then begin
  move := Select_Way;
   xpos := lxpos;
   zpos := lzpos;
   end;

if (zpos > Level.v + 0.2) or
   (zpos < 1.7) then begin
    zpos := lzpos;
    move := Select_Way;
end;

if (xpos > Level.w - 0.55) or
   (xpos < 0.75) then begin
    xpos := lxpos;
    move := Select_Way;
end;

for i := Low(bombs) to High(bombs) do
if (bombs[i] <> nil)
and (bombs[i].xpos + bombs[i].w / 2 > xpos - w / 2)
and (bombs[i].xpos - bombs[i].w / 2 < xpos + w / 2)
and (bombs[i].zpos + bombs[i].v / 2 > zpos - v / 2)
and (bombs[i].zpos - bombs[i].v / 2 < zpos + v / 2)
then begin
xpos := lxpos;
zpos := lzpos;
end;
end;

destructor TEnemyDrop.Clean_Memory(num: Integer);
begin
endrop[num] := nil;
endrop[num].Free;
end;

constructor TEnemyDrop.Create(num, lifes, sh: Integer; x, y, z, ww, hh,
  vv, degree: GLfloat);
begin
number := num;
lifescount := lifes;
shape := sh;
xpos := x;
ypos := y;
zpos := z;
ydeg := degree;
w := ww;
h := hh;
v := vv;
Change := false;
sp_var := 0.0;
move := endropinc[num];
ThisSec := GetTickCount;
LastSec := ThisSec;
end;

procedure TEnemyDrop.Draw;
const
mat_for_mouth : Array [0..3] of GLfloat = (0.9, 0.0, 0.0, 1.0);
m_o = 0.003;
st = 0.02;
begin
lxpos := xpos;
lzpos := zpos;
ThisSec := GetTickCount;
if ThisSec - LastSec > 1500 then begin
move := Select_Way;
LastSec := GetTickCount;
end;
case move of
0 : zpos := zpos - st;
1 : xpos := xpos - st;
2 : zpos := zpos + st;
3 : xpos := xpos + st;
end;
Check_Clash;
if not Change then begin
if sp_var > -0.07 then sp_var := sp_var - m_o else Change := true
end else begin
if sp_var < 0.07 then sp_var := sp_var + m_o else Change := false;
end;
if (YazevBomberMan <> nil) and (YazevBomberMan.active)
and (YazevBomberMan.xpos + YazevBomberMan.w / 2 > xpos - w / 2)
and (YazevBomberMan.xpos - YazevBomberMan.w / 2 < xpos + w / 2)
and (YazevBomberMan.zpos + YazevBomberMan.v / 2 > zpos - v / 2)
and (YazevBomberMan.zpos - YazevBomberMan.v / 2 < zpos + v / 2)
 then YazevBomberMan.KickedByMonster(move);
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glRotatef(ydeg, 0.0, 1.0, 0.0);
glCallList(drop);
glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mat_for_mouth);
glTranslatef(0.0, 1.35 + sp_var, 0.35);
glPushMatrix;
glScalef(1.0, 0.4, 0.5);
glutSolidCube(0.2);
glPopMatrix;
glTranslatef(0.0, 0.1 - sp_var, 0.0);
glPushMatrix;
glScalef(1.0, 0.4, 0.5);
glutSolidCube(0.2);
glPopMatrix;
glPopMatrix
end;

function TEnemyDrop.Select_Way: Integer;
var
rec, m : Integer;
begin
m := 0;
rec := random(39);
   if (rec >= 0) and (rec < 10) then m := 0 else
   if (rec >= 10) and (rec < 20) then m := 1 else
   if (rec >= 20) and (rec < 30) then m := 2 else
   if (rec >= 30) and (rec <= 39) then m := 3;
 case m of
  0 : ydeg := 180.0;
  1 : ydeg := 270.0;
  2 : ydeg := 0.0;
  3 : ydeg := 90.0;
 end;
Result := m;
end;

{ TYazevBrickWall }

destructor TYazevBrickWall.Clean_Memory(num: Integer);
begin
walls[num] := nil;
walls[num].Free
end;

constructor TYazevBrickWall.Create(num: Integer; x, z: GLfloat);
begin
xpos := x;
ypos := -3.0;
zpos := z;
ydeg := 0.0;
w := 1.0;
h := 2.0;
v := 1.0;
end;

procedure TYazevBrickWall.Draw;
begin
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glCallList(brickwall);
glPopMatrix;
end;

{ TGold }

destructor TGold.Clean_Memory(num: Integer);
begin
gold[num] := nil;
gold[num].Free;
end;

constructor TGold.Create(num: Integer; x, z: GLfloat);
begin
xpos := x;
ypos := -3.55;
zpos := z;
ydeg := 0.0;
w := 0.5;
h := 0.5;
v := 0.5;
end;

procedure TGold.Draw;
begin
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glRotatef(ydeg, 0.0, 1.0, 0.0);
glRotatef(90.0, -1.0, 0.0, 0.0);
glCallList(goldheap);
glPopMatrix;
end;

procedure TYazevBombField.YazevBomberManActiveTimer(Sender: TObject);
begin
YazevBomberMan.active := true;
YazevBomberManActive.Enabled := false;
end;

{ TExitDoor }

destructor TExitDoor.Clean_Memory;
begin
exitdoor := nil;
exitdoor.Free;
end;

constructor TExitDoor.Create(x, z: GLfloat);
begin
xpos := x;
ypos := -3.0;
zpos := z;
ydeg := 0.0;
w := 0.9;
h := 1.9;
v := 0.9;
end;

procedure TExitDoor.Draw;
begin
glPushMatrix;
glTranslatef(xpos, ypos, zpos);
glRotatef(ydeg, 0.0, 1.0, 0.0);
glCallList(exdoor);
glPopMatrix;
if (YazevBomberMan <> nil)
and (YazevBomberMan.xpos + YazevBomberMan.w / 2 > xpos - w / 2)
and (YazevBomberMan.xpos - YazevBomberMan.w / 2 < xpos + w / 2)
and (YazevBomberMan.zpos + YazevBomberMan.v / 2 > zpos - v / 2)
and (YazevBomberMan.zpos - YazevBomberMan.v / 2 < zpos + v / 2)
 then begin
    YazevBomberMan.Clean_Memory;
    YazevBombField.YazevGameComplete.Enabled := true;
 end;
end;

procedure TYazevBombField.Mouse_Catch(var Msg: TMessage);
begin
SetCursor(0);
end;

procedure TYazevBombField.FormShow(Sender: TObject);
begin
YazevProgressTimer.Enabled := true;
end;

procedure TYazevBombField.Start_Game;
begin
glViewPort(0, 0, ClientWidth, ClientHeight);
glMatrixMode(GL_PROJECTION);
glLoadIdentity;
gluPerspective(80.0, 1.0, 0.01, 22.0);
glMatrixMode(GL_MODELVIEW);
glLoadIdentity;
//**********************************************************
glRotatef(30.0, 1.0, 0.0, 0.0); //~~~ эталон
//glTranslatef(-0.5, 1.6, -2.2); ~~~ эталон{}
{
if YazevBomberMan <> nil then
with YazevBomberMan do begin
xcam := -xpos - 0.3;
zcam := -zpos - 3.0;
end;
}
xcam := -0.2;
ycam := 1.3;
zcam := -2.7;
lxcam := 0.0;
lycam := 0.0;
lzcam := 0.0;
 glTranslatef(xcam, ycam, zcam);// ~~~ эталон
//glTranslatef(0.0, 0.0, 0.0);
//glTranslatef(xcam + 1.7, ycam, zcam - 4);

//********************************************************
glRotatef(30.0, 0.0, -1.0, 0.0); //потом раскомментирую
glRotatef(20.0, 1.0, 0.0, 0.0);  // эталон
//********************************************************

//glTranslatef(0.0, 3.5, -5.0);// пробная установка
//glRotatef(90.0, 0.0, 1.0, 0.0);

//glRotatef(90.0, 1.0, 0.0, 0.0);  // пробная установка
//glTranslatef(0.0, -15.0, 0.0);  // пробная установка
//glRotatef(90.0, 1.0, 0.0, 0.0);
InvalidateRect(Handle, nil, false);

YazevScreen.Visible := true;
end;

procedure TYazevBombField.YazevLoadScreenMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
Cursor := crNone
end;

procedure TYazevBombField.YazevProgressTimerTimer(Sender: TObject);
begin
if YazevProgressLoading.Position < YazevProgressLoading.Max then
YazevProgressLoading.Position := YazevProgressLoading.Position + 1
else begin
YazevProgressTimer.Enabled := false;
YazevLoadScreen.Visible := false;
YazevProgressLoading.Visible := false;
YazevScore.Visible := true;
YazevLife.Visible := true;
YazevAuthorTitle.Visible := true;
StartUp_Music(1);
Level := TYazevLevel.Create;
Start_Game;
gameactive := true;
end;
end;

procedure TYazevBombField.FormResize(Sender: TObject);
begin
//Start_Game;
end;

procedure TYazevBombField.YazevGameCompleteTimer(Sender: TObject);
begin
Level.Clean_Memory;
YazevVictoryScreen.Visible := true;
StartUp_Music(8);
YazevGameComplete.Enabled := false;
end;

procedure TYazevBombField.YazevGameOverTimer(Sender: TObject);
begin
Level.Clean_Memory;
YazevGameOverScreen.Visible := true;
StartUp_Music(9);
YazevGameOver.Enabled := false;
end;

procedure TYazevBombField.YazevResumeGameButEnter(Sender: TObject);
begin
(Sender as TRadioButton).Color := clRed;
end;

procedure TYazevBombField.YazevResumeGameButExit(Sender: TObject);
begin
(Sender as TRadioButton).Color := clBlack;
end;

procedure TYazevBombField.YazevMenuMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
YazevResumeGameBut.Color := clBlack;
YazevNewGameBut.Color := clBlack;
YazevExitBut.Color := clBlack;
end;

procedure TYazevBombField.YazevResumeGameButMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
YazevResumeGameBut.Color := clRed;
YazevNewGameBut.Color := clBlack;
YazevExitBut.Color := clBlack;
YazevResumeGameBut.Checked := true;
YazevNewGameBut.Checked := false;
YazevExitBut.Checked := false;
end;

procedure TYazevBombField.YazevNewGameButMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
YazevResumeGameBut.Color := clBlack;
YazevNewGameBut.Color := clRed;
YazevExitBut.Color := clBlack;
YazevResumeGameBut.Checked := false;
YazevNewGameBut.Checked := true;
YazevExitBut.Checked := false;
end;

procedure TYazevBombField.YazevExitButMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
YazevResumeGameBut.Color := clBlack;
YazevNewGameBut.Color := clBlack;
YazevExitBut.Color := clRed;
YazevResumeGameBut.Checked := false;
YazevNewGameBut.Checked := false;
YazevExitBut.Checked := true;
end;

procedure TYazevBombField.Exit_Game;
begin
gameactive := false;
GameStart := false;
YazevMenu.Visible := false;
if YazevBomberMan <> nil then YazevBomberMan.Clean_Memory;
if Level <> nil then Level.Clean_Memory;
YazevGameOverScreen.Visible := false;
YazevVictoryScreen.Visible := false;
YazevThanksScreen.Visible := true;
YazevThanks.Enabled := true;
end;

procedure TYazevBombField.YazevKeyDelayTimer(Sender: TObject);
begin
KeyDelay := false;
YazevKeyDelay.Enabled := false;
end;

procedure TYazevBombField.Resume_Game;
begin
YazevMenu.Visible := false;
CanDrawScreen := true;
end;

procedure TYazevBombField.YazevResumeGameButMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
Resume_Game;
end;

procedure TYazevBombField.YazevExitButMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
Exit_Game
end;

procedure TYazevBombField.New_Game;
begin
if YazevBomberMan <> nil then YazevBomberMan.Clean_Memory;
if Level <> nil then Level.Clean_Memory;
YazevMusicPlayer.Close;
gameactive := false;
GameStart := false;
CanDrawScreen := true;
GameNumber := GameNumber + 1;
KeyDelay := false;
YazevScore.Caption := 'Score: 0';
YazevLife.Caption := 'Life: 100%';
YazevAuthorTitle.Visible := false;
YazevScore.Visible := false;
YazevLife.Visible := false;
YazevMenu.Visible := false;
YazevProgressLoading.Position := 0;
YazevProgressLoading.Visible := true;
YazevLoadScreen.Visible := true;
YazevVictoryScreen.Visible := false;
YazevGameOverScreen.Visible := false;
YazevProgressTimer.Enabled := true;
end;

procedure TYazevBombField.YazevNewGameButMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
New_Game;
end;

procedure TYazevBombField.YazevThanksTimer(Sender: TObject);
begin
Close;
end;

procedure TYazevBombField.StartUp_Music(songnum: Integer);
var
s : String;
begin
SongNumber := songnum;
case songnum of
1 : s := '01_Motorhead_Bomber';
2 : s := '02_Exodus_Fabulous Disaster';
3 : s := '03_Motorhead_Born To Raise Hell';
4 : s := '04_Exodus_The Toxic Waltz';
5 : s := '05_Motorhead_Going To Brazil';
6 : s := '06_Exodus_Impaler';
7 : s := '07_Motorhead_We Are Motorhead';
8 : s := '08_Metallica_last caress - green hell';
9 : s := '09_Alice Cooper_Years Ago';
end;
s := s + '.mp3';
if FileExists(s) then begin
with YazevMusicPlayer do begin
Close;
FileName := s;
Open;
//Play;
end;
end else YazevMusicPlayer.Close;
end;

procedure TYazevBombField.YazevMusicPlayerNotify(Sender: TObject);
begin
if (YazevMusicPlayer.NotifyValue = nvSuccessful)
and (YazevMusicPlayer.Position = YazevMusicPlayer.Length) then
if SongNumber < 7 then StartUp_Music(SongNumber + 1) else
if SongNumber = 7 then StartUp_Music(1) else
if SongNumber > 7 then StartUp_Music(SongNumber);
end;

end.
