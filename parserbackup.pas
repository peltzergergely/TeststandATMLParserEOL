unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, DOM, XMLRead, XMLUtils, StrUtils;


type

  { TXMLParserMain }

  TXMLParserMain = class(TForm)
    Parse: TButton;
    ConvertBtn: TButton;
    FileNameLabel: TLabel;
    LoadFile: TButton;
    MemoOut: TMemo;
    OpenDialog1: TOpenDialog;
    procedure ConvertBtnClick(Sender: TObject);
    procedure LoadFileClick(Sender: TObject);
    procedure ParseClick(Sender: TObject);
  private

  public

  end;

var
  XMLParserMain: TXMLParserMain;
  FileName: string = 'C:\Users\l-gpeltzer\Downloads\reports\EOL TEST parsable\LTC EOL Test b2-5 110717_Report[13 06 05][2017.08.16.]_00002_UTF8.xml';

implementation

{$R *.frm}

{ TForm1 }
procedure TXMLParserMain.ParseClick(Sender: TObject);
  var
  Child: TDOMNode;
  NodeList: TDOMNodeList;
  Doc: TXMLDocument;

  //TESTRESULT
  procedure TestResult(child: TDOMNode);
  var
   resultChild, dataChild: TDOMNode;
  begin
    resultChild := child.FirstChild;
    while Assigned(resultChild) do
      begin
       if resultChild.NodeName = 'tr:Outcome' then
            MemoOut.Lines.Add(TDOMelement(resultChild).GetAttribute('value'));
       if resultChild.HasChildNodes then
         begin
         dataChild := resultChild.FirstChild;
         while Assigned(dataChild) do
           begin
           if dataChild.NodeName = 'c:Datum' then
              if TDOMElement(dataChild).HasAttribute('value') then
                 MemoOut.Lines.Add(TDOMElement(dataChild).GetAttribute('value'))
              else
                 MemoOut.Lines.Add(TDOMElement(dataChild).TextContent);
           datachild := dataChild.NextSibling;
           end;
         end;
       if resultChild.NodeName = 'tr:TestResult' then
               TestResult(resultChild);
       resultChild := resultChild.NextSibling;
      end;
  end;

  //TEST
  procedure Test(child: TDOMNode);
    var
       testChild: TDOMNode;
    begin
       testChild := child.FirstChild;
       while Assigned(testChild) do
         begin
             if testChild.NodeName = 'tr:Outcome' then
               MemoOut.Lines.Add(TDOMelement(testChild).GetAttribute('value'));
             if testChild.NodeName = 'tr:TestResult' then
               TestResult(testChild);
             testChild := testChild.NextSibling;
         end;
  end;

  //TESTGROUP
  procedure TestGroup(child: TDOMNode);
    var
       child1: TDOMNode;
    begin
         Child1 := child.FirstChild;
         if tdomelement(child).hasAttribute('callerName') then
            MemoOut.Lines.Add(tdomElement(child).GetAttribute('callerName'));
         while Assigned(Child1) do
           begin
            if child1.NodeName = 'tr:Outcome' then //testgroup outcome
               memoOut.Lines.Add(Child1.Attributes[0].NodeValue);
            if child1.NodeName = 'tr:Test' then //should i make this a procedure?
              begin
               memoOut.Lines.Add(tdomelement(child1).GetAttribute('name'));
               Test(Child1);
              end;
            if child1.NodeName = 'tr:TestGroup' then //if testgroup within testgroup then recursive
               TestGroup(child1);
            child1 := child1.NextSibling;
           end;
    end;

begin
  //lets try to do it recursively
    MemoOut.Clear;
    try
      ReadXMLFile(Doc, FileName);
      NodeList := Doc.GetChildNodes;
      Child := NodeList[1].GetChildNodes[0].GetChildNodes[1].FirstChild;
      while Assigned(Child) do
        begin
         if Child.NodeName = 'tr:TestGroup' then
           TestGroup(child);
         Child := Child.NextSibling;
        end;
    finally
      Doc.Free;
    end;
end;

procedure TXMLParserMain.LoadFileClick(Sender: TObject);
begin
    //opendialog and load it into FileName variable
  if OpenDialog1.Execute then
    begin
    FileName := OpenDialog1.Filename;
    FileNameLabel.Caption := FileName;
    end;
end;

procedure TXMLParserMain.ConvertBtnClick(Sender: TObject);
  var
  StrList: TStringList;
  InsertToFileName, NewFileName: string;
  FileNameInserterIdx: integer;
begin
  StrList:=TStringList.Create;
  if (FileName <> '') then
    begin
    StrList.LoadFromFile(FileName);
    if (AnsiContainsStr(StrList[0], 'Windows-1250')) then
      begin
      StrList[0]:=StringReplace(StrList[0],'Windows-1250', 'UTF-8', [rfReplaceAll, rfIgnoreCase]);
      NewFileName := FileName;
      InsertToFileName:='_UTF8';
      FileNameInserterIdx := NewFileName.Length-3;
      Insert(InsertToFileName, NewFileName, FileNameInserterIdx);
      MemoOut.clear;
      MemoOut.Lines.Add('New Filename: ' + NewFileName);
      MemoOut.Lines.Add('XML Header changed to Encoding: UTF-8');
      MemoOut.Lines.Add('New File created and saved! You can now start Parsing!');
      FileName := NewFileName;
      FileNameLabel.Caption := FileName;
      StrList.SaveToFile(NewFileName);
      end
    ELSE begin
      MemoOut.Lines.Add('Incorrect format, please add a correct XML file');
    end;
    StrList.free;
    end;
end;

end.
