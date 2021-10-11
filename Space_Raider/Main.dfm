object Form1: TForm1
  Left = 229
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Space Raider'
  ClientHeight = 864
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 120
  TextHeight = 16
  object ImgPanel: TPanel
    Left = 0
    Top = 0
    Width = 495
    Height = 864
    Align = alClient
    Color = clBlack
    TabOrder = 0
    object Img: TImage
      Left = 1
      Top = 1
      Width = 493
      Height = 616
      Align = alClient
    end
    object GamePanel: TPanel
      Left = 1
      Top = 617
      Width = 493
      Height = 246
      Align = alBottom
      Color = clGreen
      TabOrder = 0
      object LifesLabel: TLabel
        Left = 59
        Top = 10
        Width = 138
        Height = 24
        Caption = 'Shield power: '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
      end
      object Bevel1: TBevel
        Left = 367
        Top = 2
        Width = 5
        Height = 239
      end
      object DistanceInfo: TLabel
        Left = 10
        Top = 111
        Width = 79
        Height = 19
        Caption = 'Distance: '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object FireLabel: TLabel
        Left = 79
        Top = 158
        Width = 94
        Height = 24
        Caption = 'Weapons:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
      end
      object StarsChkBox: TCheckBox
        Left = 377
        Top = 10
        Width = 112
        Height = 21
        Caption = 'Show stars'
        TabOrder = 0
        OnClick = StarsChkBoxClick
      end
      object New_btn: TButton
        Left = 377
        Top = 39
        Width = 109
        Height = 31
        Caption = 'New GAME!'
        TabOrder = 1
        OnClick = New_btnClick
      end
      object Quit_btn: TButton
        Left = 377
        Top = 118
        Width = 109
        Height = 31
        Caption = 'Exit'
        TabOrder = 2
        OnClick = Quit_btnClick
      end
      object Pause_btn: TButton
        Left = 377
        Top = 79
        Width = 109
        Height = 31
        Caption = 'Pause'
        Enabled = False
        TabOrder = 3
        OnClick = Pause_btnClick
      end
      object LifesPanel: TPanel
        Left = 10
        Top = 37
        Width = 349
        Height = 54
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clGreen
        TabOrder = 4
        object LifesImg: TImage
          Left = 2
          Top = 2
          Width = 345
          Height = 50
          Align = alClient
        end
      end
      object FirePanel: TPanel
        Left = 10
        Top = 185
        Width = 349
        Height = 54
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clGreen
        TabOrder = 5
        object FireImg: TImage
          Left = 2
          Top = 2
          Width = 345
          Height = 50
          Align = alClient
        end
      end
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerTimer
    Left = 8
    Top = 8
  end
  object ExpTimer: TTimer
    Enabled = False
    Interval = 70
    OnTimer = ExpTimerTimer
    Left = 40
    Top = 8
  end
  object BaseTimer: TTimer
    Enabled = False
    Interval = 30
    OnTimer = BaseTimerTimer
    Left = 72
    Top = 8
  end
end
