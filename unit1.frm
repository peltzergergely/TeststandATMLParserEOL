object XMLParserMain: TXMLParserMain
  Left = 86
  Height = 808
  Top = 85
  Width = 1450
  BorderStyle = bsDialog
  Caption = 'EOL XML Parser and UTF Converter'
  ClientHeight = 808
  ClientWidth = 1450
  Position = poMainFormCenter
  LCLVersion = '6.1'
  Scaled = False
  object LoadFile: TButton
    Left = 8
    Height = 25
    Top = 8
    Width = 80
    Caption = 'Open File'
    OnClick = LoadFileClick
    TabOrder = 0
  end
  object FileNameLabel: TLabel
    Left = 88
    Height = 40
    Top = 0
    Width = 1156
    AutoSize = False
    Caption = 'FileName'
    Font.Height = -11
    Layout = tlCenter
    ParentColor = False
    ParentFont = False
    WordWrap = True
    OnClick = FileNameLabelClick
  end
  object Memo: TMemo
    Left = 8
    Height = 726
    Top = 72
    Width = 340
    Lines.Strings = (
      'Initial Debug Window'
    )
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 1
    WordWrap = False
  end
  object Parse: TButton
    Left = 160
    Height = 25
    Top = 41
    Width = 72
    Caption = 'Parse'
    OnClick = ParseClick
    TabOrder = 2
  end
  object SaveStatHeader: TButton
    Left = 414
    Height = 25
    Top = 41
    Width = 97
    Caption = 'SaveStatHeader'
    OnClick = SaveStatHeaderClick
    TabOrder = 3
  end
  object StatusHeader: TMemo
    Left = 462
    Height = 726
    Top = 72
    Width = 110
    Lines.Strings = (
      'Status File Header Generator'
    )
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 4
    WordWrap = False
  end
  object StatusData: TMemo
    Left = 574
    Height = 726
    Top = 72
    Width = 220
    Lines.Strings = (
      'Status File Data Generator'
    )
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 5
    WordWrap = False
  end
  object MeasureHeader: TMemo
    Left = 908
    Height = 726
    Top = 72
    Width = 110
    Lines.Strings = (
      'Measure Header Generator'
    )
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 6
    WordWrap = False
  end
  object MeasureData: TMemo
    Left = 1208
    Height = 726
    Top = 72
    Width = 220
    Lines.Strings = (
      'Measure Header Generator'
    )
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 7
    WordWrap = False
  end
  object SaveStatData: TButton
    Left = 639
    Height = 25
    Top = 41
    Width = 94
    Caption = 'SaveStatData'
    OnClick = SaveStatDataClick
    TabOrder = 8
  end
  object SaveMeasHeader: TButton
    Left = 861
    Height = 25
    Top = 41
    Width = 98
    Caption = 'SaveMeasHeader'
    OnClick = SaveMeasHeaderClick
    TabOrder = 9
  end
  object SaveMeasData: TButton
    Left = 1274
    Height = 25
    Top = 41
    Width = 96
    Caption = 'SaveMeasData'
    OnClick = SaveMeasDataClick
    TabOrder = 10
  end
  object FileType: TLabel
    Left = 240
    Height = 21
    Top = 43
    Width = 56
    Caption = 'FileType'
    Font.Height = -16
    ParentColor = False
    ParentFont = False
  end
  object NextBtn: TButton
    Left = 80
    Height = 25
    Top = 41
    Width = 75
    Caption = 'NextBtn'
    OnClick = NextBtnClick
    TabOrder = 11
  end
  object PrevBtn: TButton
    Left = 8
    Height = 25
    Top = 41
    Width = 75
    Caption = 'PrevBtn'
    OnClick = PrevBtnClick
    TabOrder = 12
  end
  object fileCountLabel: TLabel
    Left = 1272
    Height = 15
    Top = 13
    Width = 77
    Caption = 'fileCountLabel'
    ParentColor = False
  end
  object ParseAll: TButton
    Left = 1357
    Height = 25
    Top = 8
    Width = 75
    Caption = 'ParseAll'
    OnClick = ParseAllClick
    TabOrder = 13
  end
  object MeasLimitHeadHi: TMemo
    Left = 1020
    Height = 726
    Top = 72
    Width = 96
    Lines.Strings = (
      'Measure Limit Header Generator'
    )
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 14
    WordWrap = False
  end
  object SaveMeasLimit: TButton
    Left = 1079
    Height = 25
    Top = 41
    Width = 75
    Caption = 'SaveLimit'
    OnClick = SaveMeasLimitClick
    TabOrder = 15
  end
  object HideStatHead: TCheckBox
    Left = 527
    Height = 19
    Top = 44
    Width = 45
    Caption = 'Hide'
    OnChange = HideStatHeadChange
    TabOrder = 16
  end
  object HideDebug: TCheckBox
    Left = 346
    Height = 19
    Top = 44
    Width = 45
    Caption = 'Hide'
    OnChange = HideDebugChange
    TabOrder = 17
  end
  object HideStatData: TCheckBox
    Left = 751
    Height = 19
    Top = 44
    Width = 45
    Caption = 'Hide'
    OnChange = HideStatDataChange
    TabOrder = 18
  end
  object HideMeasHead: TCheckBox
    Left = 975
    Height = 19
    Top = 44
    Width = 45
    Caption = 'Hide'
    OnChange = HideMeasHeadChange
    TabOrder = 19
  end
  object HideLimitHead: TCheckBox
    Left = 1163
    Height = 19
    Top = 44
    Width = 45
    Caption = 'Hide'
    OnChange = HideLimitHeadChange
    TabOrder = 20
  end
  object HideMeasData: TCheckBox
    Left = 1387
    Height = 19
    Top = 44
    Width = 45
    Caption = 'Hide'
    OnChange = HideMeasDataChange
    TabOrder = 21
  end
  object MeasLimitHeadLo: TMemo
    Left = 1118
    Height = 726
    Top = 72
    Width = 88
    Lines.Strings = (
      'Measure Limit Header Generator'
    )
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 22
    WordWrap = False
  end
  object StatusHeaderParent: TMemo
    Left = 350
    Height = 726
    Top = 72
    Width = 110
    Lines.Strings = (
      'Status File Header Generator'
    )
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 23
    WordWrap = False
  end
  object MeasureHeaderParent: TMemo
    Left = 796
    Height = 726
    Top = 72
    Width = 110
    Lines.Strings = (
      'Measure Header Generator'
    )
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 24
    WordWrap = False
  end
  object OpenDialog1: TOpenDialog
    Options = [ofAllowMultiSelect, ofEnableSizing, ofViewDetail, ofAutoPreview]
    Left = 8
    Top = 6
  end
end
