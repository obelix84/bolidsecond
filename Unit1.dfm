object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 448
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Button1: TButton
    Left = 32
    Top = 16
    Width = 89
    Height = 25
    Caption = 'Create Tree'
    TabOrder = 0
    OnClick = Button1Click
  end
  object TreeView1: TTreeView
    Left = 160
    Top = 8
    Width = 353
    Height = 432
    Indent = 19
    ReadOnly = True
    TabOrder = 1
    OnClick = TreeClick
  end
  object Button2: TButton
    Left = 32
    Top = 56
    Width = 89
    Height = 25
    Caption = 'Get Parent'
    Enabled = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 32
    Top = 96
    Width = 89
    Height = 25
    Caption = 'Get Childs'
    Enabled = False
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 32
    Top = 136
    Width = 89
    Height = 25
    Caption = 'Get Data'
    Enabled = False
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 32
    Top = 176
    Width = 89
    Height = 25
    Caption = 'Destroy Tree'
    Enabled = False
    TabOrder = 5
    OnClick = Button5Click
  end
end
