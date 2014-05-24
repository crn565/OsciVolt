unit uSettings;

interface
  uses IniFiles,Graphics,forms;

  procedure SaveSettings;
  procedure GetSettings;


implementation

uses U_Oscilloscope4,ufrmOscilloscope4,   Windows, Messages, SysUtils, Classes, Controls,  Dialogs,
  StdCtrls, UWaveIn4 ,mmsystem,  ExtCtrls, ComCtrls, shellApi, Menus, Buttons,
   ufrmInputControl4;




const
  SETTINGS_FILE = 'osc.ini';




procedure SaveSettings;
var
  IniFile:TIniFile;
  Ts:integer;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+ SETTINGS_FILE);
  try
    IniFile.WriteBool('Mode','Dual',frmMain.btnDual.Down);

    IniFile.WriteInteger('Channel1','Gain',frmMain.upGainCh1.Position);
    IniFile.WriteInteger('Channel1','ofset',frmMain.trOfsCh1.Position);
    IniFile.WriteBool('Channel1','On',frmMain.btnCh1On.Down);

    IniFile.WriteInteger('Channel2','Gain',frmMain.upGainCh2.Position);
    IniFile.WriteInteger('Channel2','ofset',frmMain.trOfsCh2.Position);
    IniFile.WriteBool('Channel2','On',frmMain.btnCh2On.Down);

    IniFile.WriteInteger('Trigger','Level',frmMain.TrigLevelBar.Position);

    Ts:=0;
    if frmMain.sp11025Sample.Down then
      Ts:=11
    else if frmMain.sp22050Sample.Down then
      Ts:=22
    else if frmMain.sp44100Sample.Down then
      Ts:=44;

    IniFile.WriteInteger('Time','Scale',Ts);
    IniFile.WriteInteger('Time','Gain',frmMain.SweepUD.Position);

    IniFile.WriteInteger('Screen','Scale',frmMain.UpScaleLight.Position);
    IniFile.WriteInteger('Screen','Beam',frmMain.upBeamLight.Position);
    IniFile.WriteInteger('Screen','focus',frmMain.upFocus.Position);
    IniFile.WriteString('Screen','color',  ColorToString(frmMain.frmOscilloscope1.ScreenColor));

    IniFile.WriteBool('ScreenData','Time',frmMain.menuData_Time.checked);

            Ts:=0;
    if frmMain.speedbutton4.Down then
      Ts:=1
      else if frmMain.speedbutton5.Down then
      Ts:=2
      else if frmMain.speedbutton6.Down then
      Ts:=4
   else if frmMain.speedbutton7.Down then
      Ts:=8
   else if frmMain.speedbutton8.Down then
      Ts:=16 ;





     IniFile.WriteInteger('escala','es1',Ts);

  finally
    FreeAndNil(IniFile);
  end;
end;

procedure GetSettings;
var
  IniFile:TIniFile;
  Ts:integer;

   c1:integer;
   va1:integer;
   vd1:integer;
  c2:integer;
  va2:integer;
  vd2:integer;
  c3:integer;
  va3:integer;
  vd3:integer;
  c4:integer;
  va4:integer;
  vd4:integer;
  c5:integer;
  va5:integer;
  vd5:integer;

begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+ SETTINGS_FILE);
  try
    frmMain.btnDual.Down := IniFile.ReadBool('Mode','Dual',False);

    frmMain.upGainCh1.Position := IniFile.ReadInteger('Channel1','Gain',3);
    frmMain.trOfsCh1.Position  := IniFile.ReadInteger('Channel1','ofset',0);
     frmMain.btnCh1On.Down      := IniFile.ReadBool('Channel1','On',True);

    frmMain.upGainCh2.Position := IniFile.ReadInteger('Channel2','Gain',3);
    frmMain.trOfsCh2.Position  := IniFile.ReadInteger('Channel2','ofset',0);
     frmMain.btnCh2On.Down      := IniFile.ReadBool('Channel2','On',True);

    frmMain.TrigLevelBar.Position := IniFile.ReadInteger('Trigger','Level',0);

    Ts := IniFile.ReadInteger('Time','Scale',11);

    if Ts= 11 then
      frmMain.sp11025Sample.Down := True
    else if Ts= 22 then
      frmMain.sp22050Sample.Down := True
    else if Ts= 44 then
      frmMain.sp44100Sample.Down := True;

    frmMain.SweepUD.Position      := IniFile.ReadInteger('Time','Gain',1);
    frmMain.UpScaleLight.Position := IniFile.ReadInteger('Screen','Scale',70);
    frmMain.upBeamLight.Position  := IniFile.ReadInteger('Screen','Beam',1);
    frmMain.upFocus.Position      := IniFile.ReadInteger('Screen','focus',1);

    frmMain.frmOscilloscope1.ScreenColor :=
                StringToColor(IniFile.ReadString('Screen','color','clBlack'));

    frmMain.menuData_Time.checked := IniFile.ReadBool('ScreenData','Time',True);

     Ts := IniFile.ReadInteger('escala','es1',11);

    if Ts= 1 then
      frmMain.speedbutton4.Down := True
    else if Ts= 2 then
      frmMain.speedbutton5.Down := True
  else if Ts= 4 then
      frmMain.speedbutton6.Down := True
  else if Ts= 8 then
      frmMain.speedbutton7.Down := True
  else if Ts= 16 then
      frmMain.speedbutton8.Down := True ;




            //escala 1000
           frmMain.Label14.Caption:= inttostr(IniFile.ReadInteger('div1000','cero',3));
      frmMain.Label15.Caption:= inttostr(IniFile.ReadInteger('div1000','valoran',3));
           frmMain.Label16.Caption:=  inttostr(IniFile.ReadInteger('div1000','valordig',3));
            frmMain.Label29.Caption:=  inttostr(IniFile.ReadInteger('div1000','tipo',3));

       //escala 100
     frmMain.Label17.Caption:= inttostr(IniFile.ReadInteger('div100','cero',3));
frmMain.Label18.Caption:=  inttostr(IniFile.ReadInteger('div100','valoran',3));
frmMain.Label19.Caption:=  inttostr(IniFile.ReadInteger('div100','valordig',3));
       frmMain.Label30.Caption:=  inttostr(IniFile.ReadInteger('div1000','tipo',3));



 //            //escala 50
frmMain.Label20.Caption:= inttostr(IniFile.ReadInteger('div50','cero',3));
frmMain.Label21.Caption:=  inttostr(IniFile.ReadInteger('div50','valoran',3));
 frmMain.Label22.Caption:=  inttostr(IniFile.ReadInteger('div50','valordig',3));
        frmMain.Label31.Caption:=  inttostr(IniFile.ReadInteger('div1000','tipo',3));



             //escala 10
  frmMain.Label23.Caption:= inttostr( IniFile.ReadInteger('div10','cero',3));
frmMain.Label24.Caption:=  inttostr(IniFile.ReadInteger('div10','valoran',3));
frmMain.Label25.Caption:=  inttostr(IniFile.ReadInteger('div10','valordig',3));
       frmMain.Label32.Caption:=  inttostr(IniFile.ReadInteger('div1000','tipo',3));



           //escala 5
    frmMain.Label26.Caption:=  inttostr(IniFile.ReadInteger('div5','cero',3));
frmMain.Label27.Caption:=  inttostr(IniFile.ReadInteger('div5','valoran',3));
frmMain.Label28.Caption:=  inttostr(IniFile.ReadInteger('div5','valordig',3));
       frmMain.Label33.Caption:=  inttostr(IniFile.ReadInteger('div1000','tipo',3));



   //   showmessage(inttostr(vd5));


    frmMain.SetOscState;
  finally
    FreeAndNil(IniFile);
  end;
end;

end.
