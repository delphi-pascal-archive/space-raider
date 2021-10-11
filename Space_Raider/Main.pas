unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Math;

type
        TObjType=(TLifeBonus, TAmmoBonus, TMeteor, TPlayer);

        TObj=record
        ObjType: TObjType;
        PosX, PosY: Integer;
        V: ShortInt;
        end;

        TStar=record
        X, Y: Integer;
        end;

type
  TForm1 = class(TForm)
    ImgPanel: TPanel;
    GamePanel: TPanel;
    StarsChkBox: TCheckBox;
    New_btn: TButton;
    Quit_btn: TButton;
    Timer: TTimer;
    Pause_btn: TButton;
    LifesPanel: TPanel;
    LifesLabel: TLabel;
    Bevel1: TBevel;
    DistanceInfo: TLabel;
    ExpTimer: TTimer;
    BaseTimer: TTimer;
    FireLabel: TLabel;
    FirePanel: TPanel;
    Img: TImage;
    LifesImg: TImage;
    FireImg: TImage;
    procedure Quit_btnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure InitStars;
    procedure InitGame;
    procedure InitImgs;
    procedure InitObjs;
    procedure NewObj(Num: ShortInt);
    procedure DestroyImgs;
    procedure NewStar(Num: ShortInt);
    procedure GiveLife(Num: ShortInt);
    procedure UpdateLifes;
    procedure UpdateAmmo;
    procedure Fire;
    procedure StarsChkBoxClick(Sender: TObject);
    procedure Pause_btnClick(Sender: TObject);
    procedure New_btnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    function Collision(Num: ShortInt): Boolean;
    function FireCollision(Num: ShortInt): Boolean;
    procedure Lose;
    procedure Win;
    procedure ExpTimerTimer(Sender: TObject);
    procedure BaseTimerTimer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  StarsOn: Boolean;
  Stars: array [1..55] of TStar;
  Objs: array [1..6] of TObj;
  Imgs: array [1..6] of TBitmap;
  Lifes: Integer;
  KeyBuffer: String;
  Distance: Integer;
  V: Double;
  ExpX: Integer;
  U: Integer;
  Ammo: ShortInt;
  GameOn: Boolean=False;

implementation

{$R *.dfm}

function MakeRect(OX, OY, S: ShortInt): TRect;
begin
     // On construit le carré
     // OX = Origine X
     // OY = Origine Y
     // S = Taille du carré (ici tout le temps 20)
     Result.TopLeft.X := OX;
     Result.TopLeft.Y := OY;
     Result.BottomRight.X := OX + S;
     Result.BottomRight.Y := OY + S;
end;

{------------------------------------------------------------------------------}
// FONCTIONS COLLISION QUI NE MARCHENT PAS AVEC MOI, MAIS PEUT ETRE AVEC VOUS !!

{function TestCollide(const r1, r2 : TRect) : boolean;
begin
  result := 
    (InRange(r1.left,r2.left,r2.right) OR InRange(r1.right,r2.left,r2.right)) 
    AND
    (InRange(r1.top,r2.top,r2.bottom) OR InRange(r1.bottom,r2.top,r2.bottom));
end;}
// AUTEUR : MOKOST (amélioré par f0xi)


{FUNCTION Hit(Rect1,Rect2 : TRect) : Boolean;
var
 temprect:TRect;
BEGIN
 Result := IntersectRect(temprect,rect1,rect2);
END;}
// AUTEUR : CleyFaye
{------------------------------------------------------------------------------}

function TForm1.Collision(Num: ShortInt): Boolean;
begin
     // Vu que toutes les fonctions de collision que j'avais trouvé ne fonctionnaient pas
     // (en fait il y avait 2 collisions : 1 normale et une autre quand l'objet est à mi chemin entre le haut et le joueur ...)

     // avec celle-là ca marche ! :)

     // Mais je doute qu'elle puisse être compatible avec vos besoins ... Prenez plutot les fonction plus haut, qui ne marchent pas dans mon cas (mais peuvent dans le votre)
     Result := True;
     // On teste la collision !
     if (Objs[Num].PosY < 460) or (Objs[Num].PosY > 495) then Result := False;
     if (Objs[Num].PosX < Objs[6].PosX - 19) or (Objs[Num].PosX > Objs[6].PosX + 19) then Result := False;
end;

function TForm1.FireCollision(Num: ShortInt): Boolean;
begin
     Result := True;
     // On teste la collision !
     if (Objs[Num].PosX < Objs[6].PosX - 19) or (Objs[Num].PosX > Objs[6].PosX + 19) then Result := False;
end;

procedure TForm1.InitGame;
begin
     // On initialise le jeu
     Lifes := 3;
     InitStars;
     Pause_btn.Enabled := True;
     InitObjs;
     InitImgs;
     UpdateLifes;
     UpdateAmmo;
     Timer.Enabled := True;
end;

procedure TForm1.InitImgs;
begin
     // On charge les images en mémoire
     Imgs[1] := TBitmap.Create;
     Imgs[2] := TBitmap.Create;
     Imgs[3] := TBitmap.Create;
     Imgs[4] := TBitmap.Create;
     Imgs[5] := TBitmap.Create;
     Imgs[6] := TBitmap.Create;

     Imgs[1].LoadFromResourceName(HInstance, 'Bonus');
     Imgs[2].LoadFromResourceName(HInstance, 'Meteor');
     Imgs[3].LoadFromResourceName(HInstance, 'Player');
     Imgs[4].LoadFromResourceName(HInstance, 'Life');
     Imgs[5].LoadFromResourceName(HInstance, 'Ammo');
     Imgs[6].LoadFromResourceName(HInstance, 'AmmoPic');
end;

procedure TForm1.DestroyImgs;
Var
        I: ShortInt;
begin
     // Libération des images
     for I := 1 to Length(Imgs) do Imgs[I].Free;
end;

procedure TForm1.InitObjs;
Var
        I: ShortInt;
        Z: ShortInt;
begin
     // On initialise les objets
        for I := 1 to 5 do
        begin
             Z := random(99) + 1;
             if (Z in [1..10]) then Objs[I].ObjType := TLifeBonus;
             if (Z in [11..20]) then Objs[I].ObjType := TAmmoBonus;
             if (Z in [21..100]) then Objs[I].ObjType := TMeteor;  // Disposition aléatoire
             Objs[I].PosX := randomrange((I - 1) * 80, ((I - 1) * 80 + 40));
             Objs[I].PosY := random(30) - 50;
             Objs[I].V := random(3) + 3;
        end;

     // On initialise le joueur
     Objs[6].ObjType := TPlayer;
     Objs[6].PosX := 190;   // Milieu de la carte
     Objs[6].PosY := 480;   // Tout en bas
end;

procedure TForm1.InitStars;
Var

        I: ShortInt;
begin
     // On crée les étoiles
     for I := 1 to Length(Stars) do
        begin
             Stars[I].Y := random(Img.Height);
             Stars[I].X := random(Img.Width);
        end;
end;

procedure TForm1.NewStar(Num: ShortInt);
begin
     Stars[Num].Y := random(100);
     Stars[Num].X := random(Img.Width);
end;

procedure TForm1.NewObj(Num: ShortInt);
Var
        Z: ShortInt;
begin
     // Nouvel objet
     Z := random(99) + 1;
     if (Z in [1..10]) then Objs[Num].ObjType := TLifeBonus;
     if (Z in [11..20]) then Objs[Num].ObjType := TAmmoBonus;
     if (Z in [21..100]) then Objs[Num].ObjType := TMeteor;  // Disposition aléatoire
     Objs[Num].PosX := randomrange((Num - 1) * 80, ((Num - 1) * 80 + 40));
     Objs[Num].PosY := 0;
     Objs[Num].V := random(3) + 3;
end;

procedure TForm1.GiveLife(Num: ShortInt);
begin
     Lifes := Lifes + Num;
     UpdateLifes;
end;

procedure TForm1.UpdateLifes;
Var
        I: ShortInt;
begin
     // On affiche les vies et on voit si il lui en reste ...
     // Maximum 7 vies désolé x)
     if Lifes > 7 then Lifes := 7;
     LifesImg.Canvas.Brush.Color := clBlack;
     LifesImg.Canvas.Pen.Color := clBlack;
     LifesImg.Canvas.FillRect(LifesImg.ClientRect);
     for I := 1 to Lifes do
        begin
             LifesImg.Canvas.Draw((I - 1) * 40, 0, Imgs[4]);
        end;

     if Lifes < 1 then Lose;
end;

procedure TForm1.UpdateAmmo;
Var
        I: ShortInt;
begin
     // On affiche les balles restantes ...
     // Maximum 14 balles
     if Ammo > 14 then Ammo := 14;
     FireImg.Canvas.Brush.Color := clBlack;
     FireImg.Canvas.Pen.Color := clBlack;
     FireImg.Canvas.FillRect(FireImg.ClientRect);
     for I := 1 to Ammo do
        begin
             FireImg.Canvas.Draw((I - 1) * 20, 0, Imgs[6]);
        end;
end;

procedure TForm1.Fire;
Var
        I, Q: ShortInt;
        W: Boolean;
begin
     if Ammo > 0 then    // Si il lui reste des balles (elementaire mon cher Watson !)
     begin
     I := -1;
     Q := -1;
     // On tire sur le météore !!
     // Si on tire sur autre chose ca le détruit quand meme :( alors attention ^^
     for I := 1 to Length(Objs) - 1 do
        if FireCollision(I) then begin Q := I; W := True; end;


     // On affiche un flash rouge pour indiquer qu'on a tiré !
     Img.Canvas.Brush.Color := rgb(127, 0, 0);
     Img.Canvas.Pen.Color := rgb(127, 0, 0);
     Img.Canvas.FillRect(Img.ClientRect);
     sleep(5);
     Ammo := Ammo - 1;
     UpdateAmmo;

     if W = True then // Si effectivement il y a une cible devant alors
     begin
     NewObj(Q); // Nouvel objet puisqu'on vient de le fumer
     end;
     end;
end;

procedure TForm1.Lose;
begin
     // Vous avez perdu lol
     ExpX := Objs[6].PosX; // Lieu de l'explosion
     U := 0;
     ExpTimer.Enabled := True; // Activation de l'explosion
     GameOn := False;
end;

procedure TForm1.Win;
begin
     // Vous avez gagné !
     U := -200;
     BaseTimer.Interval := Timer.Interval;
     BaseTimer.Enabled := True; // Activation de l'explosion
     GameOn := False;
end;

procedure TForm1.Quit_btnClick(Sender: TObject);
begin
        Timer.Enabled := False;
        if MessageDlg('Do you really want exit?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                Close else if GameOn then Timer.Enabled := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        DoubleBuffered := True;
        ImgPanel.DoubleBuffered := True;
        GamePanel.DoubleBuffered := True;
        LifesPanel.DoubleBuffered := True;
        FirePanel.DoubleBuffered := True;
        randomize;
        StarsOn := False;
        InitStars;
end;

procedure TForm1.TimerTimer(Sender: TObject);
Var
        I: Integer;
begin
     // On rend l'image noire
     Img.Canvas.Brush.Color := clBlack;
     Img.Canvas.Pen.Color := clBlack;
     Img.Canvas.FilLRect(Img.ClientRect);
        // Si on a activé les etoiles alors ...
     if StarsOn then
        for I := 1 to Length(Stars) do
                begin
                     Stars[I].Y := Stars[I].Y + 3;            // Ce long rgb sert à donner des teintes legerement différentes aux étoiles à chaque fois (pour les faire scintiller)
                     Img.Canvas.Pixels[Stars[I].X, Stars[I].Y] := rgb(random(55) + 200, random(55) + 200, random(55) + 200);
                     if Stars[I].Y >= Img.Height then NewStar(I);
                     // Si l'étoile disparait du champ de vision, on en recrée une
                end;

     // Partie mouvement des objets
     for I := 1 to 5 do
        begin
             Objs[I].PosY := Objs[I].PosY + Objs[I].V;
             if Objs[I].PosY > 500 then NewObj(I);
             if Collision(I) then
                begin
                     case Objs[I].ObjType of
                     TMeteor: GiveLife(-1); // On enleve une vie
                     TLifeBonus: GiveLife(1); // On donne une vie !
                     TAmmoBonus: Ammo := Ammo + 1; // On donne 1 balle
                     end;

                     // On détruit l'objet qui est rentré en collision !
                     NewObj(I);
                end;
        end;

     // Partie dessin des objets
     for I := 1 to Length(Objs) do
             case Objs[I].ObjType of
             TPlayer: Img.Canvas.Draw(Objs[I].PosX, Objs[I].PosY, Imgs[3]);
             TLifeBonus: Img.Canvas.Draw(Objs[I].PosX, Objs[I].PosY, Imgs[1]);
             TMeteor: Img.Canvas.Draw(Objs[I].PosX, Objs[I].PosY, Imgs[2]);
             TAmmoBonus: Img.Canvas.Draw(Objs[I].PosX, Objs[I].PosY, Imgs[5]);
             end;             // Et voila !

     // Partie traitement du mouvement du joueur

     for I := 1 to Length(KeyBuffer) do
        begin
        if KeyBuffer[I] = 'Q' then
        // Si il décide de bouger à gauche alors ...
        if Objs[6].PosX > 0 then
        // Si il est pas completement à gauche alors
        begin Objs[6].PosX := Objs[6].PosX - 5; Continue; end;

     if KeyBuffer[I] = 'D' then
        // Si il décide de bouger à droite alors ...
        if Objs[6].PosX < 380 then
        // Si il est pas completement à droite alors
        begin Objs[6].PosX := Objs[6].PosX + 5; Continue; end;

     if KeyBuffer[I] = 'Z' then Fire; // On tire !
     end;

     // Derniers traitements
     KeyBuffer := '';
     Dec(Distance);
     V := V - 0.05;
     if Round(V) > 1 then Timer.Interval := Round(V) else Timer.Interval := 1;
     DistanceInfo.Caption := 'Distance galactique: ' + IntToStr(Distance) + ' parsecs.';
     if Distance < 0 then
        begin
             Timer.Enabled := False;
             Win;
        end;

     UpdateLifes;
     UpdateAmmo;
end;

procedure TForm1.StarsChkBoxClick(Sender: TObject);
begin
        StarsOn := StarsChkBox.Checked;
end;

procedure TForm1.Pause_btnClick(Sender: TObject);
begin
        KeyBuffer := '';
        Timer.Enabled := not Timer.Enabled;

        case Timer.Enabled of
        False: Pause_btn.Caption := 'Start';
        True: Pause_btn.Caption := 'Pause';
        end;

        GameOn := Timer.Enabled;
end;

procedure TForm1.New_btnClick(Sender: TObject);
begin
        GameOn := True;
        Ammo := 13;
        UpdateAmmo;
        V := 50;
        Distance := 100; // BIEN CHOISIR
        KeyBuffer := '';
        InitGame;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
        KeyBuffer := KeyBuffer + UpperCase(Key);
end;

procedure TForm1.ExpTimerTimer(Sender: TObject);
Var
        I: Integer;
        Bmp: TBitmap;
begin
     Bmp := TBitmap.Create;
     Inc(U);
     Timer.Enabled := False;
     for I := 1 to 25 do
        begin
             // Effet d'explosion
             Bmp.LoadFromResourceName(HINSTANCE, 'Exp' + IntToStr(U - 1));
             Bmp.TransparentColor := clWhite;
             Bmp.Transparent := True;
             Img.Canvas.Draw(ExpX, 480, Bmp);
        end;
     if U > 19 then
        begin
             ExpTimer.Enabled := False;
             MessageDlg('The ship was !', mtInformation, [mbOk], 0);
             Img.Canvas.Brush.Color := clBlack;
             Img.Canvas.Pen.Color := clBlack;
             Img.Canvas.FillRect(Img.ClientRect);
        end; 
     Bmp.Free;
end;

procedure TForm1.BaseTimerTimer(Sender: TObject);
Var
        Bmp: TBitmap;
        I: Byte;
begin
        Distance := 0;
        DistanceInfo.Caption := 'Distance galactique: null.';
        Inc(U);
        Bmp := TBitmap.Create;
        Bmp.LoadFromResourceName(HINSTANCE, 'Base');
        Img.Canvas.Brush.Color := clBlack;
        Img.Canvas.Pen.Color := clBlack;
        Img.Canvas.FillRect(Img.ClientRect);
                for I := 1 to Length(Stars) do
                begin
                     Stars[I].Y := Stars[I].Y + 3;            // Ce long rgb sert à donner des teintes legerement différentes aux étoiles à chaque fois (pour les faire scintiller)
                     Img.Canvas.Pixels[Stars[I].X, Stars[I].Y] := rgb(random(55) + 200, random(55) + 200, random(55) + 200);
                     if Stars[I].Y >= Img.Height then NewStar(I);
                     // Si l'étoile disparait du champ de vision, on en recrée une
                end;
        Img.Canvas.Draw(0, U, Bmp);
        if U > -1 then
                begin
                        BaseTimer.Enabled := False;
                        MessageDlg('BRAVO!!! Vous avez gagné!!!', mtInformation, [mbOk], 0);
                        Img.Canvas.Brush.Color := clBlack;
                        Img.Canvas.Pen.Color := clBlack;
                        Img.Canvas.FillRect(Img.ClientRect);
                        for I := 1 to 255 do
                                begin
                                Img.Canvas.Pixels[random(400), random(500)] := rgb(random(55) + 200, random(55) + 200, random(55) + 200);
                                end;
                end;
        Bmp.Free;
end;

end.
