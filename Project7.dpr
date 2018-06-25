program Project7;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows;
type
  TZakazInfo = record          // �������������� ����� ������ �������
    Num:integer;
    Adres:ShortString;
    Time1:integer;
    Time2:integer;
    V:integer;
    Massa:integer;
  end;
  PListZ=^TListZ;              //��������� �� ������
  TListZ = record
    Info:TZakazInfo;
    Adr:PListZ;
  end;

  TKuryerInfo = record         // �������������� ����� ������ ��������
    Num:integer;
    FIO:ShortString;
    Time1:integer;
    Time2:integer;
    Massa:integer;
    V:integer;
  end;
  PListK=^TListK;               //��������� �� ������
  TListK = record
    Info:TKuryerInfo;
    Adr:PListK;
  end;
  TM = Set of byte;
var
  HeadZakaz : PListZ;
  HeadKuryer : PListK;
  Mn:TM;

// �������� ������ ��������
procedure CreateKuryerList;
begin
  New(HeadKuryer);
  HeadKuryer.Adr := nil;
end;

// ������� ������ �������
procedure CreateZakazList;
begin
  New(HeadZakaz);
  HeadZakaz.Adr := nil;
end;

// ������ ������ ������� �� �����
procedure ReadZakazFile(const head:PListZ);
var
  f: file of TZakazInfo;
  ZTemp: PListZ;
begin
  AssignFile (f,'FileRecordZakaz.data');
  if fileExists ('FileRecordZakaz.data') then
  begin
    Reset(f);
    ZTemp := head;
    head^.Adr := nil;
    while not EOF(f) do
    begin
      new(ZTemp^.adr);
      ZTemp:=ZTemp^.adr;
      ZTemp^.adr:=nil;
      read(f, ZTemp^.info);
    end;
    close(f);
  end
  else
  begin
    writeln('���� �� ������� ������� �� ������!');
  end;
end;

// ������ ������ �������� �� �����
procedure ReadKuryerFile(const head:PListK);
var
  f: file of TKuryerInfo;
  KTemp: PListK;
begin
  AssignFile (f,'FileRecordKuryer.data');
  if fileExists ('FileRecordKuryer.data') then
  begin
    Reset(f);
    KTemp := head;
    head^.Adr := nil;
    while not EOF(f) do
    begin
      new(KTemp^.adr);
      KTemp:=KTemp^.adr;
      KTemp^.adr:=nil;
      read(f,KTemp^.info);
    end;
    close(f);
  end
  else
  begin
    writeln('���� �� ������� �������� �� ������!');
  end;
end;

// ����� ������ �������
procedure WriteZakazList (const head: PListZ);
var
  temp:PListZ;
begin
  temp := head;
  if temp^.Adr = nil  then
    writeln('������ ������� ����!')
  else
  begin
    writeln('�':3,'|','����� ��������':20,'|','����� c..':9,'|','����� ..��':10,'|','�����.,�3':9,'|','�����,��':9,'|');
    writeln('---+--------------------+---------+----------+---------+---------+');
    while temp^.Adr <> nil do
    begin
      temp:=temp^.adr;
      writeln(temp.Info.Num:3,'|',temp.Info.Adres:20,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.V:9,'|',temp.Info.Massa:9,'|');
    end;
  end;
end;

// ����� ������ ��������
procedure WriteKuryerList (const head: PListK);
var
  temp:PListK;
begin
  temp := head;
  if temp^.Adr = nil  then
    writeln('������ �������� ����!')
  else
  begin
    writeln('�':3,'|','��� �������':16,'|','����� c..':9,'|','����� ..��':10,'|','������������.,��':16,'|','�����,�3':8,'|');
    writeln('---+----------------+---------+----------+----------------+--------+');
    while temp^.Adr <> nil do
    begin
      temp:=temp^.adr;
      writeln(temp.Info.Num:3,'|',temp.Info.FIO:16,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.Massa:16,'|',temp.Info.V:8,'|');
    end;
  end;
end;

//�������� ����� ������ �������
procedure DeleteAllZakazList(head:PListZ);
var
  temp, temp2: PListZ;
begin
  temp := head^.Adr;
  while temp <> nil do
  begin
    temp2 := temp^.Adr;
    dispose(temp);
    temp := temp2;
  end;
  head.Adr := nil;
end;

//�������� ����� ������ ��������
procedure DeleteAllKuryerList(head:PListK);
var
  temp, temp2: PListK;
begin
  temp := head^.Adr;
  while temp <> nil do
  begin
    temp2 := temp^.Adr;
    dispose(temp);
    temp := temp2;
  end;
  head.Adr := nil;
end;

// �������� �� ������ ������ �� ������ �������
procedure DeleteNumZakazList(head:PListZ;num:integer);
var
  temp,temp2:PListZ;
  i:integer;
begin
  temp:=head;
  while temp^.adr <> nil do
  begin
    temp2:= temp^.adr;
    if temp2^.Info.Num = num then
    begin
      temp^.adr:=temp2^.adr;
      dispose(temp2);
    end
    else
      temp:= temp^.adr;
  end;
end;

// �������� �� ������ ������ �� ������ ��������
procedure DeleteNumKuryerList(head:PListK;num:integer);
var
  temp,temp2:PListK;
  i:integer;
begin
  temp:=head;
  while temp^.adr <> nil do
  begin
    temp2:=temp^.adr;
    if temp2^.Info.Num = num then
    begin
      temp^.adr:= temp2^.adr;
      dispose(temp2);
    end
    else
      temp:=temp^.adr;
  end;
end;

// ���������� ������ � ������ �������
Procedure AddZakazList(const head:PListZ);
var
  temp: PListZ;
  numZ,time1Z,time2Z,vZ,massaZ:integer;
  adresZ:ShortString;
begin
  Writeln('������� ������ �� ������');
  try
    write('����� ������: ');
    readln(numZ);
    write('����� ��������: ');
    readln(adresZ);
    write('����� �������� ��..: ');
    readln(time1Z);
    write('����� �������� ..��: ');
    readln(time2Z);
    write('����,�3: ');
    readln(vZ);
    write('�����,��: ');
    readln(massaZ);
  except
    writeln('������ �����!');
  end;
  temp := head;
  while temp^.adr <> nil do
    temp := temp^.adr;
  new(temp^.adr);
  temp:=temp^.adr;
  temp^.adr:=nil;
  temp^.Info.Num := numZ;
  temp^.Info.Adres := adresZ;
  temp^.Info.Time1 := time1Z;
  temp^.Info.Time2 := time2Z;
  temp^.Info.V := vZ;
  temp^.Info.Massa := massaZ;
end;

// ���������� ������ � ������ ��������
Procedure AddKuryerList(const head:PListK);
var
  temp: PListK;
  numK,time1K,time2K,vK,massaK:integer;
  fioK:ShortString;
begin
  Writeln('������� ������ �� ������');
  try
    write('����� ������: ');
    readln(numK);
    write('��� �������: ');
    readln(fioK);
    write('����� ������ ��..: ');
    readln(time1K);
    write('����� ������ ..��: ');
    readln(time2K);
    write('����������������,��: ');
    readln(massaK);
    write('����,�3: ');
    readln(vK);
  except
    writeln('������ �����!');
  end;
  temp := head;
  while temp^.adr <> nil do
    temp := temp^.adr;
  new(temp^.adr);
  temp:=temp^.adr;
  temp^.adr:=nil;
  temp^.Info.Num := numK;
  temp^.Info.FIO := fioK;
  temp^.Info.Time1 := time1K;
  temp^.Info.Time2 := time2K;
  temp^.Info.Massa := massaK;
  temp^.Info.V := vK;
end;

// ���������� ������ ������� � �������������� ����
procedure SaveZakazFile(const head:PListZ);
var
  f: file of TZakazInfo;
  temp: PListZ;
begin
  AssignFile(f,'FileRecordZakaz.data');
  rewrite(f);
  temp := head^.adr;
  while temp <> nil do
  begin
    write(f,temp^.info);
    temp:=temp^.adr;
  end;
  close(F);
end;

// ���������� ������ �������� � �������������� ����
procedure SaveKuryerFile(const head:PListK);
var
  f: file of TKuryerInfo;
  temp: PListK;
begin
  AssignFile(f,'FileRecordKuryer.data');
  rewrite(f);
  temp := head^.adr;
  while temp <> nil do
  begin
    write(f,temp^.info);
    temp:=temp^.adr;
  end;
  close(F);
end;

// ����� ������ � ������ ������� �� ��������
procedure PoiskZakaz(Head:PListZ; number:integer; str:ShortString);
var
  temp : PListZ;
begin
  temp := head^.adr;
  writeln('�':3,'|','����� ��������':20,'|','����� c..':9,'|','����� ..��':10,'|','�����.,�3':9,'|','�����,��':9,'|');
  while temp <> nil do
  begin
    case number of
      1:
        if temp^.info.Num = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.Adres:20,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.V:9,'|',temp.Info.Massa:9,'|');
      2:
        if temp^.info.Adres = str then
          writeln(temp.Info.Num:3,'|',temp.Info.Adres:20,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.V:9,'|',temp.Info.Massa:9,'|');
      3:
        if temp^.info.Time1 = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.Adres:20,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.V:9,'|',temp.Info.Massa:9,'|');
      4:
        if temp^.info.Time2 = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.Adres:20,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.V:9,'|',temp.Info.Massa:9,'|');
      5:
        if temp^.info.V = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.Adres:20,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.V:9,'|',temp.Info.Massa:9,'|');
      6:
        if temp^.info.Massa = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.Adres:20,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.V:9,'|',temp.Info.Massa:9,'|');
    end;
    temp := temp^.adr
  end;
end;

// ����� ������ � ������ �������� �� ��������
procedure PoiskKuryer(Head:PListK; number:integer; str:ShortString);
var
  temp : PListK;
begin
  temp := head^.adr;
  writeln('�':3,'|','��� �������':16,'|','����� c..':9,'|','����� ..��':10,'|','������������.,��':16,'|','�����,�3':8,'|');
  while temp <> nil do
  begin
    case number of
      1:
        if temp^.info.Num = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.FIO:16,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.Massa:16,'|',temp.Info.V:8,'|');
      2:
        if temp^.info.FIO = str then
          writeln(temp.Info.Num:3,'|',temp.Info.FIO:16,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.Massa:16,'|',temp.Info.V:8,'|');
      3:
        if temp^.info.Time1 = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.FIO:16,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.Massa:16,'|',temp.Info.V:8,'|');
      4:
        if temp^.info.Time2 = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.FIO:16,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.Massa:16,'|',temp.Info.V:8,'|');
      5:
        if temp^.info.Massa = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.FIO:16,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.Massa:16,'|',temp.Info.V:8,'|');
      6:
        if temp^.info.V = StrToInt(str) then
          writeln(temp.Info.Num:3,'|',temp.Info.FIO:16,'|',temp.Info.Time1:9,'|',temp.Info.Time2:10,'|',temp.Info.Massa:16,'|',temp.Info.V:8,'|');
    end;
    temp := temp^.adr
  end;
end;

// �������������� ������ �������
procedure RedactZakaz (head:PListZ; const num:integer);
var
  temp:PListZ;
  i: integer;
  flagok: integer;
begin
  temp:= head;
  for i := 1 to num  do
    temp := temp^.Adr;
  writeln('�������� ���� ��� ��������������');
  writeln('1- ����� ������');
  writeln('2- ����� ��������');
  writeln('3- ����� �������� ��..');
  writeln('4- ����� �������� ..��');
  writeln('5- �����,�3');
  writeln('6- �����,��');
  try
    readln(flagok);
    writeln('������� ����� ��������');
    case flagok of
      1:
        readln(temp^.Info.Num);
      2:
        readln(temp^.Info.Adres);
      3:
        readln(temp^.Info.Time1);
      4:
        readln(temp^.Info.Time2);
      5:
        readln(temp^.Info.V);
      6:
        readln(temp^.Info.Massa);
      end;
  except
    writeln('������ �����!');
  end;
end;

// �������������� ������ ��������
procedure RedactKuryer (head:PListK; const num:integer);
var
  temp:PListK;
  i: integer;
  flagok: integer;
begin
  temp:= head;
  for i := 1 to num  do
    temp := temp^.Adr;
  writeln('�������� ���� ��� ��������������');
  writeln('1- ����� ������');
  writeln('2- ��� �������');
  writeln('3- ����� ������ �..');
  writeln('4- ����� ������ ..��');
  writeln('5- �����,��');
  writeln('6- �����,�3');
  try
    readln(flagok);
    writeln('������� ����� ��������');
    case flagok of
      1:
        readln(temp^.Info.Num);
      2:
        readln(temp^.Info.FIO);
      3:
        readln(temp^.Info.Time1);
      4:
        readln(temp^.Info.Time2);
      5:
        readln(temp^.Info.Massa);
      6:
        readln(temp^.Info.V);
      end;
  except
    writeln('������ �����!');
  end;
end;

//���������� ������ ������� �� ��������
procedure SortirovkaZakazov(headZ:PListZ; headK:PListK; str:ShortString);
var tempZ:PListZ;
    tempK:PListK;
    Pole3,Pole4,Pole5,Pole6,count:integer;
begin
  writeln;
  writeln('������:');
  writeln('�':3,'|','��� �������':16,'|','����� c..':9,'|','����� ..��':10,'|','������������.,��':16,'|','�����,�3':8,'|');
  tempK:= headK^.adr;
  while tempK <> nil do
  begin
    if tempK^.info.FIO = str then
    begin
      writeln(tempK.Info.Num:3,'|',tempK.Info.FIO:16,'|',tempK.Info.Time1:9,'|',tempK.Info.Time2:10,'|',tempK.Info.Massa:16,'|',tempK.Info.V:8,'|');
      Pole3:=tempK.Info.Time1;
      Pole4:=tempK.Info.Time2;
      Pole5:=tempK.Info.Massa;
      Pole6:=tempK.Info.V;
    end;
    tempK:=tempK^.adr;
  end;

  count:=0;
  writeln('������ �������:');
  writeln('�':3,'|','����� ��������':20,'|','����� c..':9,'|','����� ..��':10,'|','�����.,�3':9,'|','�����,��':9,'|');
  tempZ:= headZ^.adr;
  while tempZ <> nil do
  begin
    if (tempZ^.Info.Time1>=Pole3)and(tempZ^.Info.Time2<=Pole4)and(tempZ^.Info.V<=Pole6)and(tempZ^.Info.Massa<=Pole5)and(not(tempZ^.Info.Num in Mn)) then
    begin
      writeln(tempZ.Info.Num:3,'|',tempZ.Info.Adres:20,'|',tempZ.Info.Time1:9,'|',tempZ.Info.Time2:10,'|',tempZ.Info.V:9,'|',tempZ.Info.Massa:9,'|');
      inc(count);
      Mn:=Mn+[tempZ^.Info.Num];
    end;
    tempZ:=tempZ^.adr;
  end;
  if count=0 then
    writeln('� ������� ��� ���������� �������(����� ��� ����), �������� ��� ������ ������, ����� ����� ������ ��� ������� ���');
end;

// ���������� ������� �� ������� ����������
procedure SortZakaz(const head: PListZ);
var
  i:integer;
  temp: PListZ;
  temp2: PListZ;
  t1: PListZ;
begin
  temp:= head;
  while temp.adr <> nil do
  begin
    temp2:= temp.adr;
    while temp2.adr <> nil do
    begin
      if (temp2^.Adr.info.Time2)<(temp^.Adr.info.Time2) then
      begin
        t1:= temp2^.adr;
        temp2^.adr:= temp^.adr;
        temp^.adr:= t1;
        t1:= temp^.adr^.adr;
        temp^.adr^.adr:= temp2^.adr.adr;
        temp2^.adr^.adr:= t1;
        temp2:= temp;
      end;
      temp2:= temp2^.adr;
    end;
    temp:= temp^.adr;
  end;
end;

// ���� ���������
Procedure MainMenu;
var
  flagok, flagok2, flagok3, num : integer;
  s : ShortString;
begin
  repeat
    writeln;
    writeln('�������� ��������');
    writeln('  1.  ������ ������ �� �����');
    writeln('  2.  �������� �������');
    writeln('  3.  ���������� ������ ������� �� ����� ����������');
    writeln('  4.  ����� ������ �� ��������');
    writeln('  5.  ���������� ������ � ������');
    writeln('  6.  �������� ������ �� ������');
    writeln('  7.  �������������� ������ � ������');
    writeln('  8.  ������ ������ ���� ������� �������');
    writeln('  9.  ����� c ����������� ���������');
    writeln('  10. ����� ��� ����������');
    write('��������: ');
    readln(flagok);
    writeln;
    case flagok of
      1:
        begin
          ReadZakazFile(HeadZakaz);
          ReadKuryerFile(HeadKuryer);
          writeln('������ ���������');
        end;
      2:
        begin
          writeln('      �������� ������');
          writeln('      1. ������ �������');
          writeln('      2. ������ ��������');
          write('������: ');
          readln(flagok2);
          if flagok2 = 1 then
            WriteZakazList(HeadZakaz);
          if flagok2 = 2 then
            WriteKuryerList(HeadKuryer);
        end;
      3:
        begin
          SortZakaz(HeadZakaz);
          writeln('������ �������������!');
        end;
      4:
        begin
          writeln('      �������� ������');
          writeln('      1. ������ �������');
          writeln('      2. ������ ��������');
          readln(flagok2);
          writeln('�������� ���� ��� ������');
          if flagok2 = 1 then
          begin
            writeln('1- ����� ������');
            writeln('2- ����� ��������');
            writeln('3- ����� �������� ��..');
            writeln('4- ����� �������� ..��');
            writeln('5- �����,�3');
            writeln('6- �����,��');
            readln(flagok3);
            writeln('������� ��� ������:');
            readln(s);
            PoiskZakaz(HeadZakaz, flagok3, s);
          end;
          if flagok2 = 2 then
          begin
            writeln('1- ����� ������');
            writeln('2- ��� �������');
            writeln('3- ����� ������ ��..');
            writeln('4- ����� ������ ..��');
            writeln('5- ����������������,��');
            writeln('6- �����,�3');
            readln(flagok3);
            writeln('������� ��� ������:');
            readln(s);
            PoiskKuryer(HeadKuryer, flagok3, s);
          end;
        end;
      5:
        begin
          writeln('      �������� ������');
          writeln('      1. ������ �������');
          writeln('      2. ������ ��������');
          readln(flagok2);
          if flagok2 = 1 then
            AddZakazList(HeadZakaz);
          if flagok2 = 2 then
            AddKuryerList(HeadKuryer);
        end;
      6:
        begin
          writeln(' �������� ������ ��� ��������');
          writeln(' 1. ������ �������');
          writeln(' 2. ������ ��������');
          readln(flagok2);
          writeln(' �������� ��������');
          writeln(' 1. ������� ������ ���������');
          writeln(' 2. ������� ������');
          readln(flagok3);
          if flagok2 = 1 then
          begin
            if flagok3 = 1 then
              DeleteAllZakazList(HeadZakaz);
            if flagok3 = 2 then
            begin
              writeln('������� ����� ��������� ������');
              readln(num);
              DeleteNumZakazList(HeadZakaz,num);
            end;
          end;
          if flagok2 = 2 then
          begin
            if flagok3 = 1 then
              DeleteAllKuryerList(HeadKuryer);
            if flagok3 = 2 then
            begin
              writeln('������� ����� ��������� ������');
              readln(num);
              DeleteNumKuryerList(HeadKuryer,num);
            end;
          end;
        end;
      7:
        begin
          writeln('      �������� ������');
          writeln('      1. ������ �������');
          writeln('      2. ������ ��������');
          readln(flagok2);
          writeln('������� ����� ������ ��� ��������������');
          readln(num);

            if flagok2 = 1 then
            begin
              if HeadZakaz^.adr = nil then
                writeln('��� ���������')
              else
              RedactZakaz(HeadZakaz,num);
            end;
            if flagok2 = 2 then
            begin
              if HeadKuryer^.adr = nil then
                writeln('��� ���������');
              RedactKuryer(HeadKuryer,num);
            end;
        end;
      8:
        begin
          Mn:=[];
          repeat;
            writeln('      ��������: ��� ������������� ������� � ������� �� ���������� ������������ �� �������!');
            writeln('      �������� ��������');
            writeln('      1. �������� ������ ������� �������');
            writeln('      2. ��������� � ������� ����');
            readln(flagok2);
            if flagok2 = 1 then
            begin
              WriteKuryerList(HeadKuryer);
              write('������� ��� �������: ');
              readln(s);
              SortirovkaZakazov(HeadZakaz,HeadKuryer,s);
            end;
          until(flagok2=2);
        end;
      9:
        begin
          SaveZakazFile(HeadZakaz);
          SaveKuryerFile(HeadKuryer);
        end;
    end;
  until (flagok = 10) or (flagok = 9);
end;

begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  CreateKuryerList;
  CreateZakazList;
  MainMenu;
end.

