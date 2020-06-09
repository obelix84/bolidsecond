unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections,
  Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    TreeView1: TTreeView;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure TreeClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  {
   + ������� ������,
   + �������� ��������� ���� �������� ����,
   + �������� ������ � �������� ����� ��������� ����,
   + �������� ������ � ������������� ���� ��������� ����,
   + �������� � �������� ���� ������,
   + �������� ������ � ������� ��������� � �������� ����.
   + ������� ������ � ��� ��� ��������.
  }
  TNode = class
    private
      Node: TObject; //������ �������� � ����
      Parent: TNode; //��������
      Childs: TObjectList<TNode>; //����� � ������� ���������
      procedure TreeInspector(Tree: TNode; stopID: string; var returnNode: TNode); virtual; //��������� ������ � �������
    public
      IdNode: string; //������������� ���� ��� �����������, 2 ����� (ID_��������): (ID_����)
                      //��� ����� ID := (�������)_(�����_����)
      level: integer; //������� �����������
      procedure SetData(data: TObject); virtual; //�������� ������ � ���� ������
      function GetData(): TObject; virtual; //�������� ������ �� ����
      procedure AddChild(); overload;       // �������� �������
      procedure AddChild(data: TObject); overload; //�������� ������� � ����� ������ ������ ������
      procedure SetParent(node: TNode); virtual; //���������� ��������
      function GetParent(): TNode; virtual;// �������� ��������
      function GetRoot(): TNode; virtual;// �������� ������ (��������� � �����)
      function GetNodeByID(id: string): TNode; virtual;// �������� ���� �� ��� ID
      function GetChildsCount(): integer; virtual;// ���-�� �����
      function GetChildNode(number: integer): TNode; virtual;
      constructor Create();
      destructor Destroy();//������� ��� ������� ���� �� ������.
  end;

  //�������� �����, ����� ����������� � �����
  TTest = class
    ID: string;
    function GetID(): string;
    constructor Create(str: string);
  end;

var
  Form1: TForm1;
  Tree1, Tree2: TNode;

implementation

{$R *.dfm}

{ TNode }

procedure TNode.AddChild;
var
  NewNode : TNode;
begin
  NewNode := TNode.Create();
  NewNode.SetParent(self);
  NewNode.level := self.level + 1;
  Childs.Add(NewNode);
  NewNode.IdNode := self.IdNode + ': ' + IntToStr(NewNode.level) + '_' + IntToStr(Childs.Count);
end;

procedure TNode.AddChild(data: TObject);
var
  NewNode : TNode;
begin
  NewNode := TNode.Create();
  NewNode.SetParent(self);
  NewNode.level := self.level + 1;
  NewNode.Node := data;
  Childs.Add(NewNode);
  NewNode.IdNode := self.IdNode + ': ' + IntToStr(NewNode.level) + '_' + IntToStr(Childs.Count);
end;

constructor TNode.Create;
begin
  Childs := TObjectList<TNode>.Create();
  //List.OwnsObjects := true; �� ��������
  level := 0;
  IdNode := 'root';
end;

destructor TNode.Destroy;
var
  i: integer;
  count: integer;
begin
    Node.Free;
    count := Childs.Count;
    for i := 1 to count do
      Childs.Items[count-i].Destroy;
    inherited;
end;

function TNode.GetChildNode(number: integer): TNode;
begin
   if number > Childs.Count then
   begin
    Result := nil;
   end
   else
   begin
    Result := Childs.Items[number];
   end;
end;

function TNode.GetChildsCount: integer;
begin
   Result := Childs.Count;
end;

function TNode.GetData: TObject;
begin
  Result := Node;
end;

function TNode.GetNodeByID(id: string): TNode;
var
  tree: TNode;
  resultNode: TNode;
begin
  tree := self.GetRoot; //�� ��� ������, ���� ������� �� �� �����
  self.TreeInspector(tree, id, resultNode);
  Result := resultNode;
end;

function TNode.GetParent: TNode;
begin
  Result := Parent;
end;

function TNode.GetRoot(): TNode;
var
  res:TNode;
  node:TNode;
begin
  node := self;
  res := node;
  while res <> nil do
  begin
      node := res;
      res := node.GetParent();
  end;
  Result := node;
end;

procedure TNode.SetData(data: TObject);
begin
  self.Node := data;
end;

procedure TNode.SetParent(node: TNode);
begin
  Parent := node;
end;

procedure TNode.TreeInspector(Tree:TNode; stopID: string; var returnNode: TNode);
var
  i:integer;
  Ch:TNode;
begin
   if (Tree <> nil) then
   begin
     if Tree.IdNode = stopID then
     begin
       returnNode := Tree;
     end
     else
     begin
       for i := 0 to Tree.GetChildsCount - 1 do
       begin
        Ch := Tree.GetChildNode(i);
        TreeInspector(Ch, stopID, returnNode);
        end;
     end;
   end;
end;


procedure TreeRound(Tree: TNode; AddTree: TTreeView; AddNodes: TTreeNode);
var
  i:integer;
  Ch:TNode;
  NewNode: TTreeNode;
  data: TTest;
  str: string;
begin
   if Tree <> nil then
    begin
      for i := 0 to Tree.GetChildsCount - 1 do
      begin
        Ch := Tree.GetChildNode(i);
        data := Ch.GetData as TTest;
        if data <> nil then
        begin
          str := data.GetID;
        end
        else
        begin
          str := ' ';
        end;  //����� ���� �� �������������� ToString...
        NewNode := AddTree.Items.AddChild(AddNodes, Ch.IdNode + ' (' + str +')');
        TreeRound(Ch, AddTree, NewNode);
      end;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  data, data2: TTest;
  Temp: TNode;
  RootNode: TTreeNode;
begin
  //������� ������
  data := TTest.Create('one');
  Tree1 := TNode.Create();
  Tree1.SetData(data);
  data := TTest.Create('two');
  Tree1.AddChild(data);

  Tree1.AddChild();
  data := TTest.Create('four');
  Tree1.AddChild(data);
  Temp := Tree1.GetChildNode(0);
  data := TTest.Create('five');
  Temp.AddChild(data);
  Temp := Tree1.GetChildNode(2);
  data := TTest.Create('six');
  Temp.AddChild(data);
  data := TTest.Create('seven');
  Temp.AddChild(data);
  Temp := Temp.GetChildNode(1);
  data := TTest.Create('eight');
  Temp.AddChild(data);
  data := TTest.Create('nine');
  Temp.AddChild(data);
  Button2.Enabled := false;
  Button3.Enabled := false;
  TreeView1.Items.Clear;
  data2 := Tree1.Node as TTest;
  RootNode := TreeView1.Items.Add(Nil, Tree1.IdNode + ' ('+ data2.GetID +')');
  TreeRound(Tree1, TreeView1, RootNode);
  TreeView1.FullExpand;
  Button5.Enabled := true;
end;

{ TTest }

constructor TTest.Create(str:string);
begin
  self.ID := str;
end;

function TTest.GetID: string;
begin
  Result := self.ID;
end;

// ��������������� �������, ������� ID �� ����� TTreeNode
function getIdFromTreeNode(text: string): string;
var
  p: integer;
begin
   p := Pos('(', text);
   Result := Copy(text, 0, p - 2);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  node: TTreeNode;
  nodeID: string;
  mynode: TNode;
begin
  node := TreeView1.Selected;
  if node <> nil then
  begin
    nodeID := getIdFromTreeNode(node.Text);
    mynode := Tree1.GetNodeByID(nodeID);
    if mynode.GetParent() <> nil then
    begin
       ShowMessage('�������� ' + mynode.GetParent.IdNode);
    end
    else
    begin
       ShowMessage('������!');
    end;

  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  node: TTreeNode;
  nodeID: string;
  mynode, ch: TNode;
  count: integer;
  str: string;
begin
  node := TreeView1.Selected;
  if node <> nil then
  begin
    nodeID := getIdFromTreeNode(node.Text);
    mynode := Tree1.GetNodeByID(nodeID);
    count := mynode.GetChildsCount();
    if count > 0 then
    begin
      for ch in mynode.Childs do
      begin
        str := str + ' ('+ ch.IdNode +') ';
      end;
      ShowMessage('���� ������ ������: ' + str);
    end
    else
    begin
       ShowMessage('����!');
    end;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  node: TTreeNode;
  nodeID: string;
  mynode: TNode;
  data: TTest;
begin
  node := TreeView1.Selected;
  if node <> nil then
  begin
    nodeID := getIdFromTreeNode(node.Text);
    mynode := Tree1.GetNodeByID(nodeID);
    data := mynode.GetData as TTest;
    if data <> nil then
    begin
      ShowMessage(data.GetID);
    end
    else
    begin
      ShowMessage('�����!');
    end;

  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  TreeView1.Items.Clear;
  Tree1.Destroy();
  Button2.Enabled := false;
  Button3.Enabled := false;
  Button4.Enabled := false;
  Button5.Enabled := false;
end;

procedure TForm1.TreeClick(Sender: TObject);
begin
  Button2.Enabled := true;
  Button3.Enabled := true;
  Button4.Enabled := true;
end;

end.
