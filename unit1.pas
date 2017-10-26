unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, DOM, XMLRead, XMLUtils, StrUtils;

type

  { TXMLParserMain }

  TXMLParserMain = class(TForm)
    HideMeasHead: TCheckBox;
    HideLimitHead: TCheckBox;
    HideMeasData: TCheckBox;
    HideStatData: TCheckBox;
    HideDebug: TCheckBox;
    HideStatHead: TCheckBox;
    MeasLimitHeadLo: TMemo;
    MeasureHeaderParent: TMemo;
    SaveMeasLimit: TButton;
    MeasLimitHeadHi: TMemo;
    NextBtn: TButton;
    ParseAll: TButton;
    fileCountLabel: TLabel;
    PrevBtn: TButton;
    FileType: TLabel;
    SaveStatData: TButton;
    SaveMeasHeader: TButton;
    SaveMeasData: TButton;
    MeasureHeader: TMemo;
    MeasureData: TMemo;
    StatusData: TMemo;
    SaveStatHeader: TButton;
    Parse: TButton;
    ConvertBtn: TButton;
    FileNameLabel: TLabel;
    LoadFile: TButton;
    Memo: TMemo;
    StatusHeader: TMemo;
    OpenDialog1: TOpenDialog;
    StatusHeaderParent: TMemo;
    procedure FileNameLabelClick(Sender: TObject);
    procedure HideDebugChange(Sender: TObject);
    procedure HideLimitHeadChange(Sender: TObject);
    procedure HideMeasDataChange(Sender: TObject);
    procedure HideMeasHeadChange(Sender: TObject);
    procedure HideStatDataChange(Sender: TObject);
    procedure HideStatHeadChange(Sender: TObject);
    procedure SaveMeasLimitClick(Sender: TObject);
    procedure ParseAllClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure PrevBtnClick(Sender: TObject);
    procedure EncodeConverter(Sender: TObject);
    procedure LoadFileClick(Sender: TObject);
    procedure ParseClick(Sender: TObject);
    procedure SaveMeasHeaderClick(Sender: TObject);
    procedure SaveMeasDataClick(Sender: TObject);
    procedure SaveStatHeaderClick(Sender: TObject);
    procedure SaveStatDataClick(Sender: TObject);
    procedure basicdata(Sender: TObject; var doc: tXMLDocument);
  private

  public

  end;

var
  XMLParserMain: TXMLParserMain;
  FileName: string = '';
  fileNameCounter: integer;
   MG, SG, SSG, TNO, TD: integer;

implementation

{$R *.frm}

{ TForm1 }

//lets tidy up this

//PARSER MAIN
procedure TXMLParserMain.ParseClick(Sender: TObject);
var
  ResultSetChild: TDOMNode;
  Doc: TXMLDocument;
  //TEST LIMITS
  procedure testLimit(trchild: tdomnode);
  var
    trLimit: tdomnode;
    tmp: string = '';
  begin
    //testres= testlimits > limits > extension(sibl) > tslimitproperties >  rawlimits > get node values STRING COMP IS DIFF.
    trlimit := trchild;
    trlimit := trlimit.firstchild.FirstChild;
    tmp := tdomelement(trlimit).Attributes[0].NodeValue;
    //MeasLimitHeadHi.lines.add(tmp);
    if (tmp = 'EQ') then  //limits equal and hi lo
    begin
      MeasLimitHeadHi.Lines.Add(' = ');
      MeasLimitHeadLo.Lines.Add(tdomelement(trlimit.NextSibling.FirstChild.FirstChild.FirstChild).GetAttribute('value'));
    end
    else if (tmp = 'AND') then
    begin
      MeasLimitHeadHi.Lines.Add(tdomelement(trlimit.NextSibling.FirstChild.FirstChild.FirstChild).GetAttribute('value'));
      //' > < ' + tdomelement(trlimit.NextSibling.FirstChild.FirstChild.FirstChild.nextsibling).GetAttribute('value'));
      MeasLimitHeadLo.Lines.Add(tdomelement(trlimit.NextSibling.FirstChild.FirstChild.FirstChild.nextsibling).GetAttribute('value'));
    end
    else if (tmp = 'LT') then
    begin
      MeasLimitHeadHi.Lines.Add(' < ');
      MeasLimitHeadLo.Lines.Add(tdomelement(trlimit.firstchild).GetAttribute('value'));
      // + tdomelement(trlimit.NextSibling.FirstChild.FirstChild.FirstChild).GetAttribute('value'));
    end
    else if (tmp = 'CIEQ') then //string comparison
    begin
      MeasLimitHeadHi.Lines.Add('STRING COMP');
      MeasLimitHeadLo.Lines.Add('-');
    end;
  end;

  //TESTRESULTS
  procedure testResult(tnChild: tdomnode);
  var
    trChild: tdomnode;
    tmp: string;
  begin
    trchild := tnchild.Firstchild;
    tmp := tdomelement(tnChild).GetAttribute('name');
    //should be replaceable with a counter if there is more testresultdata get the name, otherwise ignore that text
    if (tdomelement(tnchild.ParentNode).GetElementsByTagName('tr:TestResult').Count > 1) then
    begin
      Memo.Lines.Add(tdomelement(tnChild).getAttribute('name'));
      if (tdomelement(tnChild).getAttribute('name') <> 'Report text') and (tdomelement(tnChild).getAttribute('name') <> 'String') then
      begin
        StatusHeader.Lines.Add(tdomelement(tnChild).getAttribute('name'));
        StatusHeaderParent.Lines.Add(tdomelement(tnChild.ParentNode).getAttribute('name'));
      end;
      MeasureHeader.Lines.Add(tdomelement(tnChild).getAttribute('name'));
      //memo.lines.add('problem is here with the different named testresult values');
      MeasureHeaderParent.Lines.add(tdomelement(tnchild.ParentNode).GetAttribute('name'));
    end
    else if (tdomelement(tnchild.ParentNode).GetElementsByTagName('tr:TestResult').Count = 1) and
      (tdomelement(tnChild).getAttribute('name') = 'Measurement 0') then
    begin
      memo.Lines.add(tdomelement(tnChild).getAttribute('name'));
      StatusHeader.Lines.Add(tdomelement(tnChild).getAttribute('name'));
      StatusHeaderParent.Lines.Add(tdomelement(tnChild.ParentNode).getAttribute('name'));
    end;
    while Assigned(trChild) do
    begin
      if trchild.nodename = 'tr:Outcome' then
      begin
        memo.Lines.Add(tdomelement(trchild).GetAttribute('value'));
        StatusData.Lines.Add(tdomelement(trchild).GetAttribute('value'));
      end;
      if trchild.nodename = 'tr:TestData' then
      begin
        if tdomelement(trchild.firstchild).hasAttribute('value') then
        begin
          //Memo.Lines.Add(tdomelement(trChild.FirstChild).GetAttribute('value'));
          MeasureData.Lines.Add(tdomelement(trChild.FirstChild).GetAttribute('value'));
        end
        else if tdomelement(trchild.ParentNode).GetAttribute('name') <> 'Report text' then
        begin
          //Memo.Lines.Add(tdomelement(trChild.FirstChild.FirstChild).TextContent);
          MeasureData.Lines.Add(tdomelement(trChild.FirstChild.FirstChild).TextContent);
        end
        else
          MeasureData.Lines.Add(tdomelement(trChild.FirstChild.FirstChild).TextContent);
      end;
      // problem that if there is no testlimit node then i need to add an extra line. how to check if it has a child named testlimit?
      if trchild.nodename = 'tr:TestLimits' then
      begin
        testLimit(trchild);
      end;
      trChild := trchild.nextSibling;
    end;
    if tdomelement(tnchild).GetElementsByTagName('tr:TestLimits').Count = 0 then //counts the number of testlimit nodes
    begin
      MeasLimitHeadHi.Lines.Add('No Limits');
      MeasLimitHeadLo.Lines.Add('-');
    end;
  end;
  //TESTNODES
  procedure testMain(tgchild: tdomnode);
  var
    tnChild: tdomnode;
  begin
    Memo.Lines.Add(tdomelement(tgchild).GetAttribute('name'));
    StatusHeader.Lines.Add(tdomelement(tgchild).GetAttribute('name'));
    StatusHeaderParent.Lines.Add(tdomelement(tgchild).GetAttribute('name'));
    //if there are test results then get the name of the test
    if tdomelement(tgchild).GetElementsByTagName('tr:TestResult').Count = 1 then
    begin
      MeasureHeader.Lines.Add(tdomelement(tgchild).GetAttribute('name'));
      MeasureHeaderParent.Lines.Add(tdomelement(tgchild.ParentNode).GetAttribute('callerName'));
    end;
    {this creates a header layer where the name of the parentgroup is displayed}
    tnChild := tgchild.FirstChild;
    while Assigned(tnChild) do
    begin
      if tnChild.NodeName = 'tr:Outcome' then
      begin
        if (tdomelement(tnChild).GetAttribute('value') <> 'Passed') and (tdomelement(tnChild).GetAttribute('value') <> 'Failed') then
        begin
          memo.Lines.add(tdomelement(tnChild).GetAttribute('qualifier'));
          statusdata.Lines.add(tdomelement(tnChild).GetAttribute('qualifier'));
          //MeasureData.Lines.add(tdomelement(tnChild).GetAttribute('qualifier'));
        end
        else
        begin
          Memo.Lines.Add(tdomelement(tnChild).GetAttribute('value'));
          StatusData.Lines.Add(tdomelement(tnChild).GetAttribute('value'));
        end;
      end;
      if (tnChild.NodeName = 'tr:TestResult') then
      begin
        testResult(tnChild);
      end;
      tnChild := tnChild.NextSibling;
    end;
  end;
  //calib subsubtestgroups
  procedure TestGroup3(tg2child: tdomnode);
  var
    tg3Child: tdomnode;
  begin
    Memo.Lines.Add(tdomElement(tg2child).GetAttribute('callerName'));
    StatusHeader.Lines.Add(tdomElement(tg2child).GetAttribute('callerName'));
    StatusHeaderParent.Lines.Add(tdomElement(tg2child).GetAttribute('callerName'));
    tg3child := tg2child.FirstChild;
    while Assigned(tg3child) do
    begin
      if tg3child.NodeName = 'tr:Outcome' then
      begin
        Memo.Lines.Add(tdomelement(tg3child).GetAttribute('value'));
        StatusData.Lines.Add(tdomelement(tg3child).GetAttribute('value'));
      end;
      if tg3child.NodeName = 'tr:Test' then
      begin
        testMain(tg3child);
      end;
      tg3child := tg3child.NextSibling;
    end;
  end;
  //GW SUBTESTGROUPS
  procedure TestGroup2(tg1child: tdomnode);
  var
    tg2child: tdomnode;
  begin
    Memo.Lines.Add(tdomElement(tg1child).GetAttribute('callerName'));
    StatusHeader.Lines.Add(tdomElement(tg1child).GetAttribute('callerName'));
    StatusHeaderParent.Lines.Add(tdomElement(tg1child).GetAttribute('callerName'));
    tg2child := tg1child.FirstChild;
    while Assigned(tg2child) do
    begin
      if tg2Child.NodeName = 'tr:Outcome' then
      begin
        Memo.Lines.Add(tdomelement(tg2Child).GetAttribute('value'));
        StatusData.Lines.Add(tdomelement(tg2Child).GetAttribute('value'));
      end;
      if tg2Child.NodeName = 'tr:Test' then
      begin
        testMain(tg2Child);
      end;
      if tg2Child.NodeName = 'tr:TestGroup' then
      begin
        TestGroup3(tg2Child);
      end;
      tg2child := tg2child.NextSibling;
    end;
  end;
  //MAYOR TESTGROUPS
  procedure TestGroup1(testgroup: tdomnode);
  var
    tg1Child: tdomnode;
  begin
    tg1Child := testgroup.FirstChild;
    while Assigned(tg1Child) do
    begin
      if tg1Child.NodeName = 'tr:Outcome' then
      begin
        Memo.Lines.Add(tdomelement(tg1Child).GetAttribute('value'));
        StatusData.Lines.Add(tdomelement(tg1Child).GetAttribute('value'));
      end;
      if tg1Child.NodeName = 'tr:Test' then
      begin
        testMain(tg1Child);
      end;
      if tg1Child.NodeName = 'tr:TestGroup' then
      begin
        TestGroup2(tg1Child);
      end;
      tg1Child := tg1Child.NextSibling;
    end;
  end;

begin
  EncodeConverter(Self.Parse);
  Memo.Clear;
  StatusHeaderParent.Clear;
  StatusHeader.Clear;
  StatusData.Clear;
  MeasureHeaderParent.Clear;
  MeasureHeader.Clear;
  MeasureData.Clear;
  MeasLimitHeadHi.Clear;
  MeasLimitHeadLo.Clear;
  try
    ReadXMLFile(Doc, FileName);
    basicData(self.Parse, doc);
    ResultSetChild := Doc.GetElementsByTagName('tr:ResultSet')[0].FirstChild; //navigating to the real 'root'
    while Assigned(ResultSetChild) do
    begin
      if ResultSetChild.NodeName = 'tr:TestGroup' then
      begin
        mg := mg + 1;
        Memo.Lines.Add(tdomelement(ResultSetChild).GetAttribute('callerName'));           //CALLERNAME OF THE MAYOR TESTGROUPS
        StatusHeaderParent.Lines.Add(tdomelement(ResultSetChild).GetAttribute('callerName'));
        StatusHeader.Lines.Add(tdomelement(ResultSetChild).GetAttribute('callerName'));
        TestGroup1(ResultSetChild);
      end;
      ResultSetChild := ResultSetChild.NextSibling;
    end;
  finally
    Doc.Free;
  end;
end;

procedure TXMLParserMain.basicData(Sender: TObject; var doc: tXMLDocument);
var
  tempList: tdomnodelist;
begin
  try
    //GET Filename
    tempList := doc.GetChildNodes;
    Memo.Lines.Add('LOG_FNAME');
    StatusHeaderParent.Lines.Add('LOG_FNAME');
    StatusHeader.Lines.Add('-');
    MeasureHeaderParent.Lines.Add('LOG_FNAME');
    MeasureHeader.Lines.Add('-');
    MeasLimitHeadHi.Lines.Add('-');
    MeasLimitHeadLo.Lines.Add('-');
    Memo.Lines.Add(ExtractFileName(FileName));
    StatusData.Lines.Add(ExtractFileName(FileName));
    MeasureData.Lines.Add(ExtractFileName(FileName));
    //SERIAL
    tempList := Doc.GetElementsByTagName('tr:UUT');
    Memo.Lines.Add('SERIAL');
    StatusHeaderParent.Lines.Add('SERIAL');
    StatusHeader.Lines.Add('-');
    MeasureHeaderParent.Lines.Add('SERIAL');
    MeasureHeader.Lines.Add('-');
    MeasLimitHeadHi.Lines.Add('-');
    MeasLimitHeadLo.Lines.Add('-');
    Memo.Lines.Add(TDOMElement(tempList[0].FirstChild).TextContent);
    StatusData.Lines.Add(TDOMElement(tempList[0].FirstChild).TextContent);
    MeasureData.Lines.Add(TDOMElement(tempList[0].FirstChild).TextContent);
    //START DATETIME
    tempList := Doc.GetElementsByTagName('tr:ResultSet');
    Memo.Lines.Add('DATETIME');
    StatusHeaderParent.Lines.Add('DATETIME');
    StatusHeader.Lines.Add('-');
    MeasureHeaderParent.Lines.Add('DATETIME');
    MeasureHeader.Lines.Add('-');
    MeasLimitHeadHi.Lines.Add('-');
    MeasLimitHeadLo.Lines.Add('-');
    Memo.Lines.Add(TDOMElement(tempList[0]).GetAttribute('startDateTime'));
    StatusData.Lines.Add(TDOMElement(tempList[0]).GetAttribute('startDateTime'));
    MeasureData.Lines.Add(TDOMElement(tempList[0]).GetAttribute('startDateTime'));
    //NUMBER OF RESULTS
    tempList := Doc.GetElementsByTagName('ts:NumOfResults');
    Memo.Lines.Add('NUMOFTEST');
    StatusHeaderParent.Lines.Add('NUMOFTEST');
    StatusHeader.Lines.Add('-');
    MeasureHeaderParent.Lines.Add('NUMOFTEST');
    MeasureHeader.Lines.Add('-');
    MeasLimitHeadHi.Lines.Add('-');
    MeasLimitHeadLo.Lines.Add('-');
    Memo.Lines.Add(TDOMElement(tempList[0]).GetAttribute('value'));
    StatusData.Lines.Add(TDOMElement(tempList[0]).GetAttribute('value'));
    MeasureData.Lines.Add(TDOMElement(tempList[0]).GetAttribute('value'));
    //TEST DURATION
    tempList := Doc.GetElementsByTagName('ts:TotalTime');
    Memo.Lines.Add('TESTDURATION');
    StatusHeaderParent.Lines.Add('TESTDURATION');
    StatusHeader.Lines.Add('-');
    MeasureHeaderParent.Lines.Add('TESTDURATION');
    MeasureHeader.Lines.Add('-');
    MeasLimitHeadHi.Lines.Add('-');
    MeasLimitHeadLo.Lines.Add('-');
    Memo.Lines.Add(TDOMElement(tempList[0]).GetAttribute('value'));
    StatusData.Lines.Add(TDOMElement(tempList[0]).GetAttribute('value'));
    MeasureData.Lines.Add(TDOMElement(tempList[0]).GetAttribute('value'));
    //OUTCOME
    tempList := Doc.GetElementsByTagName('tr:Outcome');
    Memo.Lines.Add('OUTCOME');
    StatusHeaderParent.Lines.Add('OUTCOME');
    StatusHeader.Lines.Add('-');
    MeasureHeaderParent.Lines.Add('OUTCOME');
    MeasureHeader.Lines.Add('-');
    MeasLimitHeadHi.Lines.Add('-');
    MeasLimitHeadLo.Lines.Add('-');
    Memo.Lines.Add(TDOMElement(tempList[0]).GetAttribute('value'));
    StatusData.Lines.Add(TDOMElement(tempList[0]).GetAttribute('value'));
    MeasureData.Lines.Add(TDOMElement(tempList[0]).GetAttribute('value'));
  finally
    tempList.Free;
  end;
end;

procedure TXMLParserMain.LoadFileClick(Sender: TObject);
begin
  //opendialog and load it into FileName variable
  if OpenDialog1.Execute then
  begin
    OpenDialog1.Files.Strings[0];
    FileNameLabel.Caption := FileName;
    FileName := opendialog1.Files.strings[0];
    fileCountLabel.Caption := (filenameCounter + 1).tostring + '/' + OpenDialog1.Files.Count.tostring;
    EncodeConverter(Self.Parse);
  end;
  EncodeConverter(Self.Parse);
end;

procedure TXMLParserMain.SaveStatHeaderClick(Sender: TObject);
var
  statOut: TextFile;
  statFile: string = 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_EOL_TEST_PROTO_0918.csv';
  DashString, DashString2: string;
begin
  if FileType.Caption = 'CALIBRATON' then
    statFile := 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_CALIB_TEST_PROTO_0918.csv';
  AssignFile(statOut, statFile);
  if FileExists(statFile) then
    Append(statOut)
  else
    Rewrite(statOut);
  StatusHeader.Lines.Delimiter := ';';
  StatusHeader.Lines.StrictDelimiter := True;
  DashString := StatusHeader.Lines.DelimitedText;
  WriteLN(statOut, DashString);
  StatusHeaderParent.Lines.Delimiter := ';';
  StatusHeaderParent.Lines.StrictDelimiter := True;
  DashString2 := StatusHeaderParent.Lines.DelimitedText;
  WriteLN(statOut, DashString2);
  CloseFile(statOut);
  StatusHeader.Lines.Add('Appended to ' + statFile);
  StatusHeaderParent.Lines.Add('Appended to ' + statFile);
end;

procedure TXMLParserMain.SaveStatDataClick(Sender: TObject);
var
  statOut: TextFile;
  statFile: string = 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_EOL_TEST_PROTO_0918.csv';
  DashString: string;
begin
  if FileType.Caption = 'CALIBRATON' then
    statFile := 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_CALIB_TEST_PROTO_0918.csv';
  AssignFile(statOut, statFile);
  if FileExists(statFile) then
    Append(statOut)
  else
    Rewrite(statOut);
  StatusData.Lines.Delimiter := ';';
  StatusData.Lines.StrictDelimiter := True;
  DashString := StatusData.Lines.DelimitedText;
  WriteLN(statOut, DashString);
  CloseFile(statOut);
  StatusData.Lines.Add('Appended to ' + statFile);
end;

procedure TXMLParserMain.SaveMeasHeaderClick(Sender: TObject);
var
  statOut: TextFile;
  MeasFile: string = 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_EOL_MEAS_PROTO_0918.csv';
  DashString, DashString2: string;
begin
  if FileType.Caption = 'CALIBRATON' then
    MeasFile := 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_CALIB_MEAS_PROTO_0918.csv';
  AssignFile(statOut, MeasFile);
  if FileExists(MeasFile) then
    Append(statOut)
  else
    Rewrite(statOut);
  MeasureHeaderParent.Lines.Delimiter := ';';
  MeasureHeaderParent.Lines.StrictDelimiter := True;
  DashString2 := MeasureHeaderParent.Lines.DelimitedText;
  WriteLN(statOut, DashString2);
  MeasureHeader.Lines.Delimiter := ';';
  MeasureHeader.Lines.StrictDelimiter := True;
  DashString := MeasureHeader.Lines.DelimitedText;
  WriteLN(statOut, DashString);
  CloseFile(statOut);
  MeasureHeader.Lines.Add('Appended to ' + MeasFile);
  MeasureHeaderParent.Lines.Add('Appended to ' + MeasFile);
end;

procedure TXMLParserMain.SaveMeasLimitClick(Sender: TObject);
var
  statOut: TextFile;
  MeasFile: string = 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_EOL_MEAS_PROTO_0918.csv';
  DashString, DashString2: string;
begin
  if FileType.Caption = 'CALIBRATON' then
    MeasFile := 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_CALIB_MEAS_PROTO_0918.csv';
  AssignFile(statOut, MeasFile);
  if FileExists(MeasFile) then
    Append(statOut)
  else
    Rewrite(statOut);
  MeasLimitHeadLo.Lines.Delimiter := ';';
  MeasLimitHeadLo.Lines.StrictDelimiter := True;
  DashString2 := MeasLimitHeadLo.Lines.DelimitedText;
  WriteLN(statOut, DashString2);
  MeasLimitHeadHi.Lines.Delimiter := ';';
  MeasLimitHeadHi.Lines.StrictDelimiter := True;
  DashString := MeasLimitHeadHi.Lines.DelimitedText;
  WriteLN(statOut, DashString);
  CloseFile(statOut);
  MeasLimitHeadHi.Lines.Add('Appended to ' + MeasFile);
  MeasLimitHeadLo.Lines.Add('Appended to ' + MeasFile);
end;

procedure TXMLParserMain.FileNameLabelClick(Sender: TObject);
begin

end;

procedure TXMLParserMain.HideDebugChange(Sender: TObject);
begin
  Memo.Visible := not Memo.Visible;
end;

procedure TXMLParserMain.SaveMeasDataClick(Sender: TObject);
var
  statOut: TextFile;
  MeasFile: string = 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_EOL_MEAS_PROTO_0918.csv';
  DashString: string;
begin
  if FileType.Caption = 'CALIBRATON' then
    MeasFile := 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_CALIB_MEAS_PROTO_0918.csv';
  AssignFile(statOut, MeasFile);
  if FileExists(MeasFile) then
    Append(statOut)
  else
    Rewrite(statOut);
  MeasureData.Lines.Delimiter := ';';
  MeasureData.Lines.StrictDelimiter := True;
  DashString := MeasureData.Lines.DelimitedText;
  WriteLN(statOut, DashString);
  CloseFile(statOut);
  MeasureData.Lines.Add('Appended to ' + MeasFile);
end;

procedure TXMLParserMain.HideLimitHeadChange(Sender: TObject);
begin
  MeasLimitHeadHi.Visible := not MeasLimitHeadHi.Visible;
  MeasLimitHeadLo.Visible := not MeasLimitHeadLo.Visible;
end;

procedure TXMLParserMain.HideMeasDataChange(Sender: TObject);
begin
  MeasureData.Visible := not MeasureData.Visible;
end;

procedure TXMLParserMain.HideMeasHeadChange(Sender: TObject);
begin
  MeasureHeader.Visible := not MeasureHeader.Visible;
  MeasureHeaderParent.Visible := not MeasureHeaderParent.Visible;
end;

procedure TXMLParserMain.HideStatDataChange(Sender: TObject);
begin
  StatusData.Visible := not StatusData.Visible;
end;

procedure TXMLParserMain.HideStatHeadChange(Sender: TObject);
begin
  StatusHeader.Visible := not StatusHeader.Visible;
  StatusHeaderParent.Visible := not StatusHeaderParent.Visible;
end;

procedure TXMLParserMain.EncodeConverter(Sender: TObject);
var
  StrList: TStringList;
  InsertToFileName, NewFileName: string;
  FileNameInserterIdx, i: integer;
  nameofthefile: string;

  function StrippedOfNonAscii(s: string): string;
  var
    i, Count: integer;
  begin
    SetLength(Result, Length(s));
    Count := 0;
    for i := 1 to Length(s) do
    begin
      if (s[i] = '.') then // converting dots to commas
      begin
        s[i] := ',';
      end;
      if ((s[i] >= #32) and (s[i] <= #127)) or (s[i] in [#10, #13]) then //removing non ascii-s
      begin
        Inc(Count);
        Result[Count] := s[i];
      end;
    end;
    SetLength(Result, Count);
  end;

begin
  StrList := TStringList.Create;
  if (FileName <> '') then
  begin
    StrList.LoadFromFile(FileName);
    Memo.Clear;
    Memo.Lines.Add(ExtractFileExt(FileName));
    for i := 1 to StrList.Count - 1 do
    begin
      StrList[i] := StrippedOfNonAscii(StrList[i]);
    end;
    if ExtractFileExt(Filename) = '.xml' then
    begin
      nameofthefile := extractfilename(filename);
      if (AnsiContainsStr(nameofthefile, 'EOL')) then
      begin
        FileType.Caption := 'EOL';
      end
      else if (AnsiContainsStr(nameofthefile, 'CALIBRATON')) then
      begin
        FileType.Caption := 'CALIBRATON';
      end
      else
        FileType.Caption := 'ERROR';
      if (AnsiContainsStr(StrList[0], 'Windows-1250')) then
      begin
        StrList[0] := StringReplace(StrList[0], 'Windows-1250', 'UTF-8', [rfReplaceAll, rfIgnoreCase]);
        NewFileName := FileName;
        InsertToFileName := '_UTF8';
        FileNameInserterIdx := NewFileName.Length - 3;
        Insert(InsertToFileName, NewFileName, FileNameInserterIdx);
        Memo.Clear;
        FileName := NewFileName;
        FileNameLabel.Caption := FileName;
        StrList.SaveToFile(NewFileName);
      end
      else if (AnsiContainsStr(StrList[0], 'UTF-8')) then
      begin
        Memo.Lines.Add('Encoding is correct UTF-8, seems parsable');
      end;
    end
    else
    begin
      Memo.Lines.Add('Incorrect extension please load the right XML');
    end;
    StrList.Free;
  end;
end;

procedure TXMLParserMain.PrevBtnClick(Sender: TObject);
begin
  if fileNameCounter > 0 then
  begin
    fileNameCounter := fileNameCounter - 1;
    Filename := opendialog1.Files.strings[fileNameCounter];
    fileCountLabel.Caption := (filenameCounter + 1).tostring + '/' + OpenDialog1.Files.Count.tostring;
    EncodeConverter(Self.Parse);
  end;
end;

procedure TXMLParserMain.NextBtnClick(Sender: TObject);
begin
  if fileNameCounter < OpenDialog1.Files.Count - 1 then
  begin
    fileNameCounter := fileNameCounter + 1;
    Filename := opendialog1.Files.strings[fileNameCounter];
    fileCountLabel.Caption := (filenameCounter + 1).tostring + '/' + OpenDialog1.Files.Count.tostring;
    EncodeConverter(Self.Parse);
  end;
end;

procedure TXMLParserMain.ParseAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := fileNameCounter to OpenDialog1.Files.Count - 1 do
  begin
    try
      Application.ProcessMessages;
      ParseClick(Self.Parse);
      Application.ProcessMessages;
      NextBtnClick(Self.Parse);
      Application.ProcessMessages;
      SaveMeasDataClick(Self.Parse);
      Application.ProcessMessages;
      SaveStatDataClick(Self.Parse);
      Application.ProcessMessages;
    finally
    end;
  end;
end;

end.
