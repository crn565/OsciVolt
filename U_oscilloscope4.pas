unit U_Oscilloscope4;
{Copyright 2002-2006, Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A simple Oscilloscope using  TWaveIn class.
 More info at http://www.delphiforfun.org/programs/oscilloscope.htm
     This simple oscilloscope uses the, Menus, ufrmOscilloscope4, StdCtrls,
 ComCtrls, Buttons, Controls, Forms, ufrmInputControl4, Classes, ExtCtrls
 Windows Wavein API to capture data from
a sound card and display it in the screen area above.   Use the Windows
"Volume Controls - Options - Properties"  dialog and select "Recording
Controls" to select input source(s) to be displayed.    After the Start button
is clicked, any messages describing capture problems will be displayed here.

Version  2: A "Trigger" capability has been added.  Each scan is triggered
when the signal rises above (+) or below (-) the preset trigger level.  To
improve the image capture of transient events, there is now a "Capture
Single Frame" button.  Use he "Trigger" feature to control when the frame
will be captured.

Version 3  Spectrum analysis of Captured frames.  User selectable Sample
rates.  Time scale ref.lines on display.

Version 4:  Dual trace function added.  Improved visual layout.   Improved
controls.  Input signal selectable via buttons.    Settings saved from run to
run.  Many thanks to "Krille", a very sharp Delphi programmer from Sweden
}


interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UWaveIn4 ,mmsystem,  ExtCtrls, ComCtrls, shellApi, Menus, Buttons,
  ufrmOscilloscope4, ufrmInputControl4,   IniFiles;


  
const
  SETTINGS_FILE = 'osc.ini';


type
  PBufArray=PByteARRAY;
  TfrmMain = class(TForm)
    Label2: TLabel;
    SweepEdt: TEdit;
    SweepUD: TUpDown;
    Label3: TLabel;
    TrigLevelBar: TTrackBar;
    Label4: TLabel;
    ScaleLbl: TLabel;
    Panel2: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    menuSaveImage1: TMenuItem;
    N1: TMenuItem;
    menuExit: TMenuItem;
    statustext: TPanel;
    btnRun: TSpeedButton;
    Panel3: TPanel;
    GrpChannel1: TGroupBox;
    Panel5: TPanel;
    Panel6: TPanel;
    grpChannel2: TGroupBox;
    btnTriggCh1: TSpeedButton;
    btnTriggCh2: TSpeedButton;
    btnTrigPositiv: TSpeedButton;
    btnTrigNegativ: TSpeedButton;
    GroupBox1: TGroupBox;
    btnTrigerOn: TSpeedButton;
    trOfsCh1: TTrackBar;
    trOfsCh2: TTrackBar;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    upGainCh1: TUpDown;
    upGainCh2: TUpDown;
    edtGainCh1: TEdit;
    edtGainCh2: TEdit;
    GroupBox2: TGroupBox;
    sp11025Sample: TSpeedButton;
    sp22050Sample: TSpeedButton;
    sp44100Sample: TSpeedButton;
    upBeamLight: TUpDown;
    btnCh1On: TSpeedButton;
    btnCh2On: TSpeedButton;
    Label1: TLabel;
    UpScaleLight: TUpDown;
    Panel1: TPanel;
    Panel4: TPanel;
    frmOscilloscope1: TfrmOscilloscope;
    Label9: TLabel;
    trStartPos: TTrackBar;
    frmInputControl1: TfrmInputControl;
    Screen1: TMenuItem;
    Color1: TMenuItem;
    menuBlack: TMenuItem;
    MenuGreen: TMenuItem;
    upFocus: TUpDown;
    Label10: TLabel;
    btnExpand2: TSpeedButton;
    btnExpand4: TSpeedButton;
    btnExpand1: TSpeedButton;
    btnExpand8: TSpeedButton;
    Label12: TLabel;
    Data1: TMenuItem;
    MenuData_Time: TMenuItem;
    PageControl1: TPageControl;
    Runsheet: TTabSheet;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label13: TLabel;
    btnGain0: TSpeedButton;
    btnGain1: TSpeedButton;
    btnGain2: TSpeedButton;
    GroupBox4: TGroupBox;
    SpectrumBtn: TBitBtn;
    BtnOneFrame: TSpeedButton;
    CalibrateBtn: TBitBtn;
    btnDual: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Edit4: TEdit;
    Edit3: TEdit;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure upFocusClick(Sender: TObject; Button: TUDBtnType);

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SweepEdtChange(Sender: TObject);

    {Message handler for "buffers ready to process" message}
    procedure Bufferfull(var Message: TMessage); message MM_WIM_DATA;
    procedure BtnOneFrameClick(Sender: TObject);
    procedure TrigLevelBarChange(Sender: TObject);
    procedure CalibrateBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SpectrumBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure menuExitClick(Sender: TObject);
    procedure menuSaveImage1Click(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnDualClick(Sender: TObject);
    procedure btnTrigerOnClick(Sender: TObject);
    procedure edtGainCh1Change(Sender: TObject);
    procedure edtGainCh2Change(Sender: TObject);
    procedure sp11025SampleClick(Sender: TObject);
    procedure sp22050SampleClick(Sender: TObject);
    procedure sp44100SampleClick(Sender: TObject);
    procedure trOfsCh1Change(Sender: TObject);
    procedure trOfsCh2Change(Sender: TObject);
    procedure upBeamLightClick(Sender: TObject; Button: TUDBtnType);
    procedure btnCh2OnClick(Sender: TObject);
    procedure btnCh1OnClick(Sender: TObject);
    procedure btnCH2GndClick(Sender: TObject);
    procedure MenuGreenClick(Sender: TObject);
    procedure menuBlackClick(Sender: TObject);
    procedure trStartPosChange(Sender: TObject);
    procedure btnExpand2Click(Sender: TObject);
    procedure btnExpand1Click(Sender: TObject);
    procedure btnExpand4Click(Sender: TObject);
    procedure btnExpand8Click(Sender: TObject);
    procedure UpScaleLightChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure MenuData_TimeClick(Sender: TObject);
    procedure btnGain0Click(Sender: TObject);
    procedure btnGain1Click(Sender: TObject);
    procedure btnGain2Click(Sender: TObject);
    procedure Label12DblClick(Sender: TObject);

     procedure SpeedButton1Click(Sender: TObject);
   procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
       procedure SpeedButton6Click(Sender: TObject);
      procedure   SpeedButton7Click     (Sender: TObject);


    procedure PageControl1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure frmInputControl1trInpVoumeChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);


  private
    BeamA: array of TPoint; //Array of data for the beam at channel1
    BeamB: array of TPoint; //Array of data for the beam at channel2
    StoredExpand :integer;     // Expand level of the capured frame
    StoredCH1Offs:integer;
    StoredCH2Offs:integer;

         valorpuerto:integer;



    procedure DoDrawBeamText(Sender:Tobject);
    procedure SaveImage;
    procedure ChangeSampleRate;
    procedure Start;
    procedure Stop;
    procedure SetButtonstate;
    procedure ShowStored;
    function GetExpand: integer;
    procedure CenterAdjust;
    function GetGain: double;
    procedure Recalc;
    procedure ShowScaleValue;
    procedure Pinta;


  public
    WaveIn : TWavein;
    {variables used by Bufferfull procedure}
      cy:integer;  //Center Y
      hInc:single; {seconds per time scale line}
      //ppL:single; {points per time scale line}
      //nbrVLines:Integer; {number of time scale lines}
      //pgL:single;  {points per gain scale line}

      errcount:integer;
      Ch1Gain:integer;
      Ch2Gain:integer;
      origbufsize,bufsize:integer;
      framesize:integer; {number of input points per frame}
      xinc:integer;
      X,Y:integer;
      PlotPtsPerFrame:integer;
      nbrframes:integer; {we'll draw this many frames from this buffer}
      time1,time2:TTime;
      singleframe:boolean;

      trigsign:integer; {+1 for + trigger, 0 for no trigger test, -1 for - trigger}
      triglevel:integer;  {current trigger level}
      triggered:boolean; {trigger had been tripped}
      triggerindex:integer; {bytes saved from 1st buffer when a frame must span buffers}
      trigbarchanging, trigGrpchanging:boolean;  {Change flags to synchronize changes}
      frameSaveBuf:array of {integer} byte; {space to save couple of buffers for single
                                   frame processing}
      calibrate:boolean;
      Offsety:integer;
      savedframedata:array of integer;

      {debug} buffer1found:boolean;

   Procedure Posterror(S:string);
    procedure setup;
    Procedure setmaxPtsToAvg;
    procedure SetOscState;
  end;

var frmMain: TfrmMain;

implementation

uses U_Spectrum4,uSettings ;

{$R *.DFM}


function inportb(EndPorta: Integer): BYTE stdcall; external 'inpout32.DLL' name 'Inp32';

procedure outportb(EndPorta: Integer; Valor:BYTE); stdcall; external 'inpout32.DLL' name 'Out32';


var
  framesPerBuffer:integer=2;
  numbuffers :integer=4;

  valorpuerto1 :  integer=0;
 valorpuerto2 :integer=0;
 valorpuerto3:integer=0;
 valorpuerto4: integer=0;
  valorpuerto5: integer=0;

 valorpuerto : integer=0;


const
  nbrHLines = 10;




procedure TfrmMain.Pinta;
begin
//showmessage(IntToStr( valorpuerto3));
//showmessage(IntToStr( valorpuerto4));

//label15.caption:=IntToStr(valorpuerto);


//label16.caption:=IntToStr(valorpuerto1);
//label17.caption:=IntToStr(valorpuerto2);
//label18.caption:=IntToStr(valorpuerto3);
//label19.caption:=IntToStr(valorpuerto4);



//if valorpuerto1+valorpuerto2=0 then
//begin
//label17.caption:='1/1' ;
//end;

//if valorpuerto1=1 then
//begin
//label17.caption:='1/10';
//end;

//if valorpuerto2=1 then
//begin
//label17.caption:='1/20';
//end;

//if valorpuerto3+valorpuerto4=0 then
//begin
//label19.caption:='1/1';
//end;

//if valorpuerto3=1 then
//begin
//label19.caption:='1/10';
//end;

//if valorpuerto4=1 then
//begin
//label19.caption:='1/20';
//end;

end;



{********************* FormCreate ************}
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  doublebuffered := true;
 // origbufsize    := framesperbuffer*image1.width;
  origbufsize    := framesperbuffer*frmOscilloscope1.imgScreen.width;
  bufsize        := origbufsize;
  setlength(framesaveBuf,2*bufsize);
  xinc           := SweepUD.position;
  setmaxptstoavg;

  offsety := 128;  {vertical center of screen assuming 8-bit data collection}
  StoredExpand :=1;
  setup;

  uSettings.GetSettings;

  frmOscilloscope1.OnAfterBeamDraw := DoDrawBeamText;
valorpuerto1:=0;
valorpuerto2:=0;
valorpuerto3:=0;
valorpuerto4:=0;
valorpuerto5:=0;
Pinta;
end;




procedure TfrmMain.FormActivate(Sender: TObject);
begin
 // windowstate:=wsmaximized;
  SetButtonState;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{ Stop the recorder first}
begin
  if assigned(wavein) then
  begin
    Wavein.StopInput;
    FreeAndNil(Wavein);
  end;

  canclose := true;

  if CanClose then
    uSettings.SaveSettings;

end;


  {***************** Setup ****************}
procedure TfrmMain.setup;
{Initialize the TWaveIn class and initial the image area}
begin
  errcount := 0;
  x := 0;

  if not assigned(Wavein) then
    Wavein := TWavein.create(handle,{orig}bufsize,numbuffers);

  With Wavein, ptrWavefmtEx^ Do
  Begin
    wFormatTag := WAVE_FORMAT_PCM;

    if btnDual.Down then
      nChannels  := 2
    else
      nChannels  := 1;

    if sp11025sample.Down then
    begin
      nSamplesPerSec := 11025;
      hinc           := 0.004;
    end
    else if sp22050Sample.Down then
    begin
      nSamplesPerSec := 22050;
      hinc           := 0.002;
    end
    else if sp44100Sample.Down then
    begin
      nSamplesPerSec := 44100;
      hinc           := 0.001;
    end;

    ShowScaleValue;
    SetOscState;

    wBitsPerSample  := 8;

    nAvgBytesPerSec := nSamplesPerSec*(wBitsPerSample div 8)*nChannels;
    onerror := Posterror;

    if setupInput then
      statustext.caption:='Parado'
    else
      statustext.caption:='Error - Porfavor inténtelo otra vez';

    {Initialize image}


    setlength(framesaveBuf,2*bufsize);

     cy  := frmOscilloscope1.imgScreen.height div 2;

  end;

  setlength(savedframedata,0); {forget about any saved data}
end;

procedure TfrmMain.ShowScaleValue;
begin

  if btnDual.Down then
    scalelbl.caption := format('Scale: %5.2f ms/div',[hinc*1000/xinc/2 ])
  else
    scalelbl.caption := format('Scale: %5.2f ms/div',[hinc*1000/xinc ]);
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
begin
  Recalc;


  if btnRun.Down then
    Start
  else
  begin
    Stop;
  end;

  SetButtonstate;
end;

procedure TfrmMain.Recalc;
begin

  if btnDual.Down then
  begin
    PlotPtsPerFrame := (frmOscilloscope1.imgScreen.width )*2;
  end
  else
  begin
     PlotPtsPerFrame := (frmOscilloscope1.imgScreen.width );
  end;
  setmaxptstoavg;
end;


Procedure TfrmMain.Start; {Start the recorder}
begin
   Setup; {opens wavein and prepare buffers}

  singleframe := false;
  triggered   := false;

  if wavein.recordactive then
  begin
    wavein.stopinput; {just in case}
    application.processmessages;
  end;

  Wavein.StartInput; {start recording}
  statustext.caption := 'Capturando';
end;


procedure TfrmMain.Stop;
begin
  if assigned(wavein) then
    Wavein.StopInput;

  statustext.caption := 'Parado';
end;

{************** OneFrameBtnClick ***********}
procedure TfrmMain.BtnOneFrameClick(Sender: TObject);
begin

  if BtnOneFrame.Down then
  begin
    StoredCH1Offs :=trOfsCh1.Position;
    StoredCH2Offs :=trOfsCh2.Position;

    SetButtonstate;
    Recalc;

    btnExpand1.Down := True;
    btnGain1.Down   := True;

    Setup; {opens wavein and prepare buffers}

    singleframe  := true;
    triggered    := false;
    triggerindex := 0;

    if assigned(wavein) and wavein.recordactive then
    begin
      Wavein.stopinput;
      application.processmessages;
    end;

    {debug}
    Buffer1found := false;
    if assigned(wavein) then
      Wavein.StartInput; {start recording}
    statustext.caption := 'Captura de Marcos - esperando disparo';
  end
  else
  begin
    singleframe  := false;

    if assigned(wavein) and wavein.recordactive then
    begin
      Wavein.stopinput;
      application.processmessages;
    end;
    SetButtonstate;
  end;

end;

{**********************************************}
{****************** BufferFull ****************}
{**********************************************}
procedure TfrmMain.Bufferfull(var Message: TMessage);
{Called when a buffer fills (a MM_WIN_DATA mesage is received)}
var
  i:integer;
  p:PBufArray {pByteArray};
  pstart:integer;
  framestoscan:integer;


      {Local function:  ScanBufferForTrigger}
      function scanBufferfortrigger(p:PBufArray{PByteArray}):integer;
      var  i:integer;
      begin
        result := -1;
        for i :=1 to bufsize-1 do
        begin
           if (P^[i-1]<triglevel) and (P^[i]>=triglevel)
           then
           begin
             result := i;
             break;
           end;
        end;
      end;

      {Local function:  Scale, scale the amplitude value for plotting}
      function Ch1scale(x:integer):integer;
      var N:integer;
      begin
         N := offsety-x; {just sample for now}
             {adjust gain using gain value as a power of 2}
        if Ch1Gain<3 then
          N := N shr (3-Ch1Gain)
        else if Ch1Gain>3 then
          N := N shl (Ch1Gain-3);

        result := Cy+ N;
      end;

      function Ch2scale(x:integer):integer;
      var N:integer;
      begin
         N := offsety-x; {just sample for now}
             {adjust gain using gain value as a power of 2}
        if Ch2Gain < 3 then
          N := N shr (3-Ch2Gain)
        else if Ch2Gain > 3 then
          N := N shl (Ch2Gain-3);

        result := Cy+ N;
      end;

var
  BeamI:integer;
  valor:Integer;
  valorf :real;
  cero:integer;
  valora:integer;
  valord:integer;
  tipo:integer;
   cadena:string;
begin   {BufferFull}
  {Let program respond to btn clicks once per second (in case we're swamped)}
  time2 := now;

  if (time2-time1)>1/secsperday then
  begin
    application.processmessages;
    time1 := time2;

  //----------------------------------------
  if not btnRun.Down or (Panel3.Color = clRed) then
    Panel3.Color := clMaroon
  else
    Panel3.Color := clRed;
  //----------------------------------------

  end;


  Framestoscan := nbrframes-1;

  if assigned(wavein) and (wavein.recordactive) then
    with Wavein do   {if  recordactive then  }
    begin

      {lparam of the the message contains a pointer to a waveHdr structure whose
       first entry is a pointer to the buffer}
      p := pointer(pwavehdr(message.lparam)^.lpdata); {pointer to filled buffer}
      {bufsize:=pwavehdr(message.lparam)^.dwbytesrecorded; }
      {we should also get the size from wavehdr since, in theory, final buffers
       might be truncated}
       x := 0;

       if calibrate then {reset zero level}
       begin
         offsety := 0;
         for i := 0 to bufsize-1 do
           inc(offsety,p^[i]);

         offsety := offsety div bufsize;
         calibrate := false;
       end;

      if btnTrigerOn.Down then
      begin
        if btnTrigPositiv.Down then
          trigsign := +1
        else if btnTrigNegativ.Down then
          trigsign := -1
      end
      else
        trigsign := 0;

      triglevel := -triglevelbar.position + offsetY; {make trigger level a variable} {gdd}

      //--------------------------------------

      if singleframe then
      begin
        if not triggered then
        begin {scan to see if this buffer will trigger}
          triggerindex := scanbufferfortrigger(p);
          if triggerindex >= 0 then
          begin
            move(p^[triggerindex],framesavebuf[0],bufsize-triggerindex);
            triggered:=true;
          end;
          framestoscan := -1; {draw nothing for this case - single frame and
                             not triggered or triggered with partial buffer}
          Buffer1found := true;  {Debug}
        end
        else
        begin  {we have saved buffer previously and were waiting for this one to
                  ensure that we can draw a full frame.  (The first buffer may have
                  found the trigger event near the end of the buffer and did not
                  have enough data to draw a full frame)}
          move(p^,frameSavebuf[bufsize-triggerindex],bufsize);
          p := @frameSavebuf[0];
          framestoscan := 0; {scan only one frame}
        end;
      end;

      //--------------------------------------

      pstart :=  width;

      x := trStartPos.Position;
      BeamI := -1;
      i     := 0;

      triggered := trigsign=0;

      if btnDual.Down then  //Dual trace
      begin
        SetLength(BeamA, round(PlotPtsPerFrame/2)-2  );
        SetLength(BeamB, round(PlotPtsPerFrame/2)-2  );

        while i <= PlotPtsPerFrame-6  do
        begin
          inc(i,2);
          inc(BeamI);

          if (not triggered) and (i>0)then
          begin
            if btnTriggCh1.Down then
            begin
              if (((trigsign>0) and(P^[i-2]<triglevel) and (P^[i]>=triglevel))
                or ((trigsign<0) and (P^[i-2]>triglevel) and (P^[i]<=triglevel)))
              then
                triggered := true;
             end
            else
            begin
              if (((trigsign>0) and(P^[i-1]<triglevel) and (P^[i+1]>=triglevel))
                or ((trigsign<0) and (P^[i-1]>triglevel) and (P^[i+1]<=triglevel)))
              then
                triggered := true;
            end;
          end;

          if triggered then
          begin
            BeamA[BeamI].X := x;
            BeamA[BeamI].Y := Ch1scale(p^[i])+trOfsCh1.Position;

            BeamB[BeamI].X := x;
            BeamB[BeamI].Y := Ch2scale(p^[i+1])+trOfsCh2.Position;
            inc(x,xinc*2);
          end
          else
          begin
            BeamA[BeamI].X := trStartPos.Position;
            BeamA[BeamI].Y := Ch1scale(triglevel)+trOfsCh1.Position;

            BeamB[BeamI].X := trStartPos.Position;
            BeamB[BeamI].Y := Ch2scale(triglevel)+trOfsCh2.Position;
          end;
        end;
           //pintamos los valores instantaneos de ambos canales

          dec(BeamI);
        valor:=  BeamA[beamI].y;

      edit1.text:=    inttostr( valor);

       //  edit1.text:=    inttostr( BeamA[BeamI].y );
         edit2.text:=    inttostr( BeamB[BeamI].y );


      end
      else
      begin //singe trace
        SetLength(BeamA, round(PlotPtsPerFrame)-3 );

        while i <= PlotPtsPerFrame-4  do
        begin
          inc(i);
          inc(BeamI);

          if (not triggered) and (i>0)
               and (((trigsign>0) and(P^[i-1]<triglevel) and (P^[i]>=triglevel))
                  or ((trigsign<0) and (P^[i-1]>triglevel) and (P^[i]<=triglevel)))
            then
              triggered := true;

          if triggered then
          begin
            BeamA[BeamI].X := x;
            BeamA[BeamI].Y := Ch1scale(p^[i])+trOfsCh1.Position;   //este es el valor que pintaremos
            inc(x,xinc);
          end
          else
          begin
            BeamA[BeamI].X := trStartPos.Position;
            BeamA[BeamI].Y := Ch1scale(triglevel )+trOfsCh1.Position;
          end;
        end;
       ///pintamos el valor instantaneo del primer canal
       //se correalcionan  con los resultados
       //obtenidos de forma experimental
       //ojo el valor depende de la escala
       //y de la ganancia

      dec(i);
  //    edit1.text:=    inttostr( BeamA[i].y );      //valor independiente de escala
  // edit1.text:=   CURRtostr( p^[i]  )   ;        //valor independiente de escala sin corealcionar
   //      edit1.text:=   CURRtostr(valorpuerto  ) ;    //valor de escala 1,2,4,8 16

         // cada escala define unos nuevos valores de configuracion



                    if frmMain.speedbutton4.Down then
                    begin
      cero:=strtoint(frmMain.label14.caption ) ;
      valora:=strtoint(frmMain.label15.caption );
      valord:=strtoint(frmMain.label16.caption ) ;
        tipo:= strtoint( frmMain.label29.caption );
                                             end;


      if frmMain.speedbutton5.Down then
      begin

   cero:=strtoint(frmMain.label17.caption )  ;
      valora:=strtoint(frmMain.label18.caption );
       valord:=strtoint(frmMain.label19.caption );
       tipo:=strtoint ( frmMain.label30.caption );
       end;

      if frmMain.speedbutton6.Down then
          begin
      cero:=strtoint(frmMain.label20.caption )  ;
      valora:=strtoint(frmMain.label21.caption ) ;
      valord:=strtoint(frmMain.label22.caption )  ;
      tipo:=strtoint ( frmMain.label31.caption );
      end;

  if frmMain.speedbutton7.Down then
        begin
     cero:=strtoint(frmMain.label23.caption )  ;
      valora:=strtoint(frmMain.label24.caption );
      valord:=strtoint(frmMain.label25.caption ) ;
      tipo:=strtoint ( frmMain.label32.caption );
      end;
   if frmMain.speedbutton8.Down then
   begin
    cero:=strtoint(frmMain.label26.caption ) ;
      valora:=strtoint(frmMain.label27.caption ) ;
      valord:=strtoint(frmMain.label28.caption );
      tipo:=strtoint ( frmMain.label33.caption );
        end;




       valorf:= p^[i]-cero;        //128;       //valor cero
      if valord<>0 then
      begin
       valorf:=  valorf*valora/valord;    //1425/14300;    //correlacion    vlaor en voltios //valor numerico
        // edit1.Text:=CURRtostr(upGainCh1.Position);     //ganancia   de 1  6
       end;

        edit1.text:=    CURRtostr( valorf );


if tipo=1 then
begin
cadena:='vol';
edit4.Text:=   cadena;
end;
 
if tipo=2 then
begin
cadena:='amp';
edit4.Text:=   cadena;
end;


    
if tipo=3 then
begin
cadena:='ohm';
edit4.Text:=   cadena;
end;


if tipo=4 then
begin
cadena:='bin';
edit4.Text:=   cadena;
end;





       //showMessage( CURRtostr(valorpuerto));
       end;




      //Draw trace
      frmOscilloscope1.BeamData(BeamA,BeamB);
     // end;

       //--------------------------------------

      {Always include the next statements - needed for TWavein to
       add buffer back in }
      inc(ProcessedBuffers); {required - count buffers}
      AddNextBuffer; {required - put buffer back in the queue}

      if singleframe  {singleframe mode}
         and triggered  {it has been triggered}
         and (framestoscan >= 0) {we have drawn the image} then
      begin
        {save the frame of data for further analysis}

        setlength(SavedFrameData,PlotPtsPerFrame);

        for i := pstart to pstart + PlotPtsPerFrame-1 do
          savedframedata[i-pstart]:=p^[i]-128;


       Stop;  {then stop}
       statustext.caption:='Parado - Marco capturado';
       BtnOneFrame.Down := false;
       SetButtonstate;
       ShowStored;
      end;
    end //Wavein
end;



{**************** PostError *************}
Procedure TfrmMain.PostError(s:string);
{Called by Wavein when error in encountered }
begin
  inc(errcount);
  if errcount<100 then
  begin
   // PageControl1.Activepage:=Introsheet;

  end
  else
  begin
    showmessage('Possible error count loop, recording stopping');

    if assigned(wavein) then
      Wavein.StopInput;
  end;

  statustext.caption:='Errores - Porfavor,inténtelo otra vez';
end;

{*********************** SetMaxPtsToAvg ************}
Procedure TfrmMain.setmaxPtsToAvg;
{set the maximum number of points to average for each plotted point}
{set to ensure that each buffer draws at least one full trace}
{call when bufsize, or xinc changes}
//var
//  exp:integer;
begin



  if btnDual.Down then
    framesize := frmOscilloscope1.imgScreen.width*2 {number of input points per frame}
  else
    framesize := frmOscilloscope1.imgScreen.width; {number of input points per frame}

  nbrframes := framesperbuffer {bufsize div framesize}; {we'll draw this many frames from this buffer}


end;


{******************* SweepEdtChange *************}
procedure TfrmMain.SweepEdtChange(Sender: TObject);
begin
  xinc := SweepUD.position;
  SetMaxPtstoavg;

  ShowScaleValue;

  SetOscState;
end;




procedure TfrmMain.SaveImage;
{save scope image}
var
  i:integer;
  s:string;
  path:string;
begin
  {Make a new file name}
  i:=0;
  path := extractfilepath(application.exename);

  while (i<9) and fileexists(path+'Oscope'+inttostr(i)+'.bmp') do
    inc(i);

  s:=path+'Oscope'+inttostr(i)+'.bmp';

  if not fileexists(s) then
    with frmOscilloscope1.imgScreen.picture.bitmap do
    begin
      pixelformat := pf24bit;
      savetofile(s);
      statustext.caption:= 'La imagen de la pantalla ha sido salvada en el fichero '+s;
    end
    else
      statustext.Caption:='El salvado de la imgen de la pantalla fallo (existe el maximo de 10 ficheros)';
end;


{************** TrigLevelBarChange ************}
procedure TfrmMain.TrigLevelBarChange(Sender: TObject);
{Trigger level changed by user, change trigger level display}
{Kind of tricky here, we want reset the trigger level bar, but
   the trigger level change tries to reset the trigger sign radiogroup
   index, and we have to prevent loops where each change to one of the
   controls causes a change to the other, which causes a change to the
   first,... etc.}
begin
  if trigbarchanging then
    Exit;

  if not triggrpchanging then
  begin
    trigbarchanging := True;

    if triglevelbar.position*-1 > 0 then
    begin
      btnTrigerOn.Down := True;
      btnTrigPositiv.Down := True;

      SetButtonstate;
    end
    else if triglevelbar.position*-1 < 0 then
    begin
      btnTrigerOn.Down := True;
      btnTrigNegativ.Down := True;

      SetButtonstate;
    end
    else
    begin
      btnTrigPositiv.Down := False;
      btnTrigNegativ.Down := False;
      btnTrigerOn.Down := False;
   SetButtonstate;
    end;

    label4.caption := inttostr(triglevelbar.position*-1);
    trigbarchanging := False;
  end;
end;


{*********** CalibrateBtnClick ***********}
procedure TfrmMain.CalibrateBtnClick(Sender: TObject);
{Set flag to cause recalculation  of vertical offset}
begin
  calibrate := true;
end;

{************** StaticText1Click ************}
procedure TfrmMain.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL);
end;

{************ SpectrumBtnClick *************}
procedure TfrmMain.SpectrumBtnClick(Sender: TObject);
var
  i,oldlen,n:integer;
    sum:integer;
begin
  {round nbrpoints up to next higher power of 2}
  oldlen:= length(savedframedata);

  if oldlen>0 then
  begin
      n:=2;
    while n<oldlen do
    begin
      n:=n*2;
    end;

    setlength(savedframedata,n);

    for i:=oldlen to n-1 do
      savedframedata[i]:=0;

    with form2 do
    begin
      nbrpoints:=n;
      setlength(XReal,n);
      sum:=0;

      for i:=0 to n-1 do
      begin
        XReal[i]:=savedframedata[i];
        sum:=sum+savedframedata[i];
      end;

      DCOffset:=sum/n;

      if assigned(wavein) then
        form2.samplerate:= Wavein.ptrWavefmtEx^.nsamplespersec;

      form2.showmodal;
    end;
  end;
end;

{*************** RateGrpClick **********}
procedure TfrmMain.ChangeSampleRate;
{Sampling rate changed, reset everything}
begin
  if assigned(wavein) then
  if (wavein.recordactive) then
  begin
    wavein.stopinput; {just in case}
    application.processmessages;
    start;
  end {force recalc of paramters}
  else if not singleframe then
    setup
  else
    freeandnil(wavein);
end;

//Dual input
procedure TfrmMain.btnDualClick(Sender: TObject);
begin
  if not btnDual.Down then
    btnCh1On.Down := true;

  singleframe  := false;

     edit2.Visible:=true;
      edit3.Visible:=true;
       
  ShowScaleValue;
   SetButtonstate;
end;

//Trigger on/off
procedure TfrmMain.btnTrigerOnClick(Sender: TObject);
begin
  SetButtonstate;
end;

// Input Gain
procedure TfrmMain.edtGainCh1Change(Sender: TObject);
begin
  Ch1Gain := upGainCh1.Position;
end;

procedure TfrmMain.edtGainCh2Change(Sender: TObject);
begin
  Ch2Gain := upGainCh2.Position;
end;

// Input Y ofset
procedure TfrmMain.trOfsCh1Change(Sender: TObject);
begin
  SetOscState;
  ShowStored;
end;

procedure TfrmMain.trOfsCh2Change(Sender: TObject);
begin
  SetOscState;
  ShowStored;
end;

// <-- X --> ofset
procedure TfrmMain.trStartPosChange(Sender: TObject);
begin
  ShowStored;
end;

// Screen controls
procedure TfrmMain.upFocusClick(Sender: TObject; Button: TUDBtnType);
begin
  SetOscState;
  ShowStored;
end;

procedure TfrmMain.upBeamLightClick(Sender: TObject; Button: TUDBtnType);
begin
  SetOscState;
  ShowStored;
end;

procedure TfrmMain.UpScaleLightChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  SetOscState;
  ShowStored;
end;

//Input sample
procedure TfrmMain.sp11025SampleClick(Sender: TObject);
begin
  ChangeSampleRate;
end;

procedure TfrmMain.sp22050SampleClick(Sender: TObject);
begin
  ChangeSampleRate;
end;

procedure TfrmMain.sp44100SampleClick(Sender: TObject);
begin
  ChangeSampleRate;
end;



//CANAL 1
procedure TfrmMain.btnCh1OnClick(Sender: TObject);
begin
  SetButtonstate;
  SetOscState;
  ShowStored;
end;

//Input grounded


procedure TfrmMain.SpeedButton4Click(Sender: TObject);
begin
valorpuerto1:=1;
valorpuerto2:=0;
valorpuerto3:=0;
valorpuerto4:=0;
valorpuerto5:=0;
valorpuerto:=1*valorpuerto1+2*valorpuerto2+4*valorpuerto3 +8*valorpuerto4 +16*valorpuerto5;


    Pinta;
//showMessage( CURRtostr(valorpuerto));
outportb($378,valorpuerto); //pone el byte del puerto paralelo D0...D7 en alto (5 volts)


end;


procedure TfrmMain.SpeedButton5Click(Sender: TObject);
begin
valorpuerto1:=0;
valorpuerto2:=1;
valorpuerto3:=0;
valorpuerto4:=0;
valorpuerto5:=0;
valorpuerto:=1*valorpuerto1+2*valorpuerto2+4*valorpuerto3 +8*valorpuerto4 +16*valorpuerto5;

Pinta;
//showMessage( CURRtostr(valorpuerto));
//showMessage('canal 2 ,escala de 5voltios');
outportb($378,valorpuerto); //pone el byte del puerto paralelo D0...D7 en alto (5 volts)

end;


procedure TfrmMain.SpeedButton6click(Sender: TObject);


begin
valorpuerto1:=0;
valorpuerto2:=0;
valorpuerto3:=1;
valorpuerto4:=0;
valorpuerto5:=0;
valorpuerto:=1*valorpuerto1+2*valorpuerto2+4*valorpuerto3 +8*valorpuerto4 +16*valorpuerto5;
Pinta;
//showMessage( CURRtostr(valorpuerto));
//showMessage('canal 2 ,escala de 5voltios');
outportb($378,valorpuerto); //pone el byte del puerto paralelo D0...D7 en alto (5 volts)

end;



 procedure TfrmMain.SpeedButton7Click(Sender: TObject);


begin
valorpuerto1:=0;
valorpuerto2:=0;
valorpuerto3:=0;
valorpuerto4:=1;
valorpuerto5:=0;
valorpuerto:=1*valorpuerto1+2*valorpuerto2+4*valorpuerto3 +8*valorpuerto4 +16*valorpuerto5;
Pinta;
//showMessage( CURRtostr(valorpuerto));
//showMessage('canal 2 ,escala de 5voltios');
outportb($378,valorpuerto); //pone el byte del puerto paralelo D0...D7 en alto (5 volts)

end;

  procedure TfrmMain.SpeedButton8Click(Sender: TObject);


begin
valorpuerto1:=0;
valorpuerto2:=0;
valorpuerto3:=0;
valorpuerto4:=0;
valorpuerto5:=1;
valorpuerto:=1*valorpuerto1+2*valorpuerto2+4*valorpuerto3 +8*valorpuerto4 +16*valorpuerto5;
Pinta;
//showMessage( CURRtostr(valorpuerto));
//showMessage('canal 2 ,escala de 5voltios');
outportb($378,valorpuerto); //pone el byte del puerto paralelo D0...D7 en alto (5 volts)

end;





//CANAL 2 

//Input on/off
procedure TfrmMain.btnCh2OnClick(Sender: TObject);
begin
SetButtonstate;
  SetOscState;
  ShowStored;
end;

procedure TfrmMain.btnCH2GndClick(Sender: TObject);
begin
//showMessage('gnd canal 2');
  SetOscState;
  ShowStored;
end;




procedure TfrmMain.SpeedButton1Click(Sender: TObject);

begin
//canal 2 ,escala de 5voltios
valorpuerto:=0;
valorpuerto3:=0;
valorpuerto4:=0;
valorpuerto:=1*valorpuerto1 + 2*valorpuerto2 + 4*valorpuerto3 +8*valorpuerto4 +16*valorpuerto5;

Pinta;
//showMessage('canal 2 ,escala de 5voltios');
outportb($378,valorpuerto); //pone el byte del puerto paralelo D0...D7 en alto (5 volts)
end;


procedure TfrmMain.SpeedButton2Click(Sender: TObject);

begin
//canal 2,escala 50 voltios
//showMessage('50v canal 2');
valorpuerto:=0;
valorpuerto3:=1;
valorpuerto4:=0;
valorpuerto:=1*valorpuerto1 + 2*valorpuerto2 + 4*valorpuerto3 +8*valorpuerto4 +16*valorpuerto5;
Pinta;

outportb($378,valorpuerto); //pone el byte del puerto paralelo D0.
end;


procedure TfrmMain.SpeedButton3Click(Sender: TObject);

begin
//  canal 2,escala 100 voltios
//showMessage('100v canal 2');
valorpuerto:=0;
valorpuerto3:=0;
valorpuerto4:=1;
valorpuerto:=1*valorpuerto1 + 2*valorpuerto2 + 4*valorpuerto3 +8*valorpuerto4 +16*valorpuerto5;

Pinta;
outportb($378,valorpuerto); //pone el byte del puerto paralelo D0.
end;



// Menu functions-----------------------
procedure TfrmMain.menuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.menuSaveImage1Click(Sender: TObject);
begin
  SaveImage;
end;

procedure TfrmMain.MenuGreenClick(Sender: TObject);
begin
  frmOscilloscope1.ScreenColor := clGreen;
  ShowStored;
end;

procedure TfrmMain.menuBlackClick(Sender: TObject);
begin
  frmOscilloscope1.ScreenColor := clBlack;
  ShowStored;
end;

procedure TfrmMain.MenuData_TimeClick(Sender: TObject);
begin
  menuData_Time.Checked := not menuData_Time.Checked;
  SetOscState;
  ShowStored;
end;

//Change the expantion of an capure frame
procedure TfrmMain.btnExpand1Click(Sender: TObject);
begin
  CenterAdjust;
  trStartPos.Max := 400;
  trStartPos.Min := -400;
  ShowStored;
end;

procedure TfrmMain.btnExpand2Click(Sender: TObject);
begin
  CenterAdjust;
  trStartPos.Max := 200;
  trStartPos.Min := -450;
  ShowStored;
end;

procedure TfrmMain.btnExpand4Click(Sender: TObject);
begin
  CenterAdjust;
  trStartPos.Max := 100;
  trStartPos.Min := -450;
  ShowStored;
end;

procedure TfrmMain.btnExpand8Click(Sender: TObject);
begin
  CenterAdjust;
  trStartPos.Max := 50;
  trStartPos.Min := -470;
  ShowStored;
end;

//Change the gain of an capure frame
procedure TfrmMain.btnGain0Click(Sender: TObject);
begin
  ShowStored;
end;

procedure TfrmMain.btnGain1Click(Sender: TObject);
begin
  ShowStored;
end;

procedure TfrmMain.btnGain2Click(Sender: TObject);
begin
  ShowStored;
end;

//--------------------------------------------------------------------

procedure TfrmMain.SetButtonstate;
begin

  btnRun.Enabled := not BtnOneFrame.Down;

  if not btnRun.Down then
    Panel3.Color := clMaroon;

  SpectrumBtn.Enabled := (length(savedframedata)>0)and not btnDual.Down ;

  BtnOneFrame.Enabled := assigned(wavein) and not wavein.recordactive;
  //fix if wawein is nil
  if not BtnOneFrame.Enabled and not btnRun.Enabled and not assigned(wavein) then
    btnRun.Enabled := true;

  btnDual.Enabled := not btnRun.Down;
  //btnCh1On.Enabled := btnDual.Down;
  if not btnDual.Down then
    btnTriggCh1.Down := True ;

     if not btnDual.Down then
     begin
      edit2.Visible:=FALSE;

     edit3.Visible:=FALSE;

        end;

  btnTriggCh1.Enabled := btnTrigerOn.Down;
  btnTriggCh2.Enabled := btnTrigerOn.Down and btnDual.Down;
  btnTrigPositiv.Enabled := btnTrigerOn.Down;
  btnTrigNegativ.Enabled := btnTrigerOn.Down;
  btnTriggCh2.Enabled := btnDual.Down;
  grpChannel2.Visible := btnDual.Down;

  frmOscilloscope1.Ch1On := btnCh1On.Down;
  frmOscilloscope1.Ch2On := btnCh2On.Down and btnDual.Down;

  btnExpand1.Enabled := singleframe and triggered;
  btnExpand2.Enabled := singleframe and triggered;
  btnExpand4.Enabled := singleframe and triggered;
  btnExpand8.Enabled := singleframe and triggered;

  btnGain0.Enabled := singleframe and triggered;
  btnGain1.Enabled := singleframe and triggered;
  btnGain2.Enabled := singleframe and triggered;

  if not trigbarchanging then {if  a click caused this call, then we can
                              reset the trigger level bar}
  begin
    trigGrpchanging := true;
    with triglevelbar do
    begin
      if btnTrigerOn.Down then
      begin
        if btnTrigPositiv.Down then
          If position < 0 then position:= position
        else
          if position > 0 then position :=-position;
      end
      else
        triglevelbar.position :=0;
    end;
    triggrpchanging := false;
  end;
end;




procedure TfrmMain.SetOscState;
begin
  frmOscilloscope1.ScaleLight := UpScaleLight.Position;
  frmOscilloscope1.BeamLight  := upBeamLight.Position;
  frmOscilloscope1.Focus      := upFocus.Position;

  frmOscilloscope1.Ch1On := btnCh1On.Down;
  frmOscilloscope1.Ch2On := (btnCh2On.Down and btnDual.Down)
         ; //and  not btnXYmode.Down and not btnAddSignal.Down;
end;


//Draw text at the oscilloscope screen
procedure TfrmMain.DoDrawBeamText(Sender: Tobject);
var
  s:string;
  Expand:integer;
begin
  if menuData_Time.Checked then
  begin
    frmOscilloscope1.imgScreen.Canvas.Brush.Style := bsClear;
    frmOscilloscope1.imgScreen.Canvas.Font.Color  := clLime;
    frmOscilloscope1.imgScreen.Canvas.Font.Name   := 'Verdana';
    frmOscilloscope1.imgScreen.Canvas.Font.Size   := 7;
    s:= ScaleLbl.Caption;

    if singleframe and triggered then
    begin
      expand := GetExpand;
      if Expand >1 then
        s := s + '   Expand: X' + IntToStr(Expand);
    end;

    frmOscilloscope1.imgScreen.Canvas.TextOut(10,10,s);
  end;
end;

// show capured frame
procedure TfrmMain.ShowStored;
var
  myBeamA: array of TPoint;
  myBeamB: array of TPoint;
  Loop:integer;
  Gain :double;
  ofs:integer;
  valor:integer;
begin
  if singleframe then
  begin
    if btnDual.Down then
    begin
      SetLength(myBeamA,high(BeamA));
      SetLength(myBeamB,high(BeamA));
    end
    else
    begin
      SetLength(myBeamA,high(BeamA));
      SetLength(myBeamB,1);
    end;

    Gain := GetGain;
    StoredExpand := GetExpand;

    //Adjust Y ofset
    if Gain = 0.5 then
      ofs := Trunc(frmOscilloscope1.imgScreen.Height /4)
    else if Gain = 2 then
      ofs := Trunc(frmOscilloscope1.imgScreen.Height/4)*-2
    else
      ofs := 0;

    //ReCalc Beeam
    for Loop:=0 to high(BeamA)-1 do
    begin
      myBeamA[Loop].X := (BeamA[Loop].X +trStartPos.Position) * StoredExpand   ;
      myBeamA[Loop].Y := Trunc(BeamA[Loop].Y *Gain)-StoredCH1Offs + trOfsCh1.Position+ofs;
      valor:=  myBeamA[Loop].X;
      edit1.text:=    CURRtostr( valor);




      if btnDual.Down then
      begin
        myBeamB[Loop].X := (BeamB[Loop].X +trStartPos.Position) * StoredExpand;
        myBeamB[Loop].Y := Trunc(BeamB[Loop].Y*Gain)-StoredCH2Offs + trOfsCh2.Position +ofs ;

      end;
    end;


     
    //Draw beam
    frmOscilloscope1.BeamData(myBeamA,myBeamB);
  end;
end;

function TfrmMain.GetExpand:integer ;
begin
  Result :=0;

  if btnExpand1.Down then
    Result := 1
  else if btnExpand2.Down then
    Result := 2
  else if btnExpand4.Down then
    Result := 4
  else if btnExpand8.Down then
    Result := 8;
end;

function TfrmMain.GetGain:double ;
begin
  Result :=1;

  if btnGain0.Down then
    Result := 0.5
  else if btnGain1.Down then
    Result := 1
  else if btnGain2.Down then
    Result := 2;
end;

procedure TfrmMain.CenterAdjust;
var
  NewExpand:integer;
  myPos:integer;
  myCenter:integer;
  myOldCenter:integer;
begin
  NewExpand := GetExpand;
  myPos := trStartPos.Position;
  myCenter := Trunc(frmOscilloscope1.imgScreen.Width/2);
  myOldCenter := (myCenter+ myPos)* StoredExpand;
  trStartPos.Position := trunc(myOldCenter/NewExpand) -  myCenter;
end;


procedure TfrmMain.Label12DblClick(Sender: TObject);
begin
  trStartPos.Position := 0;

end;








procedure TfrmMain.PageControl1Change(Sender: TObject);
begin
//label16.caption:=IntToStr(valorpuerto1);
//label17.caption:=IntToStr(valorpuerto2);
//label18.caption:=IntToStr(valorpuerto3);
//label19.caption:=IntToStr(valorpuerto4);


//if pagecontrol1.ActivePage=IntroSheet then
//begin
//ShowMessage('IntroSheet');
//edit1.Visible:=true;
//edit2.Visible:=true;

//end
//else
//begin
//edit1.Visible:=false;
//edit2.Visible:=false;
//ShowMessage('osci');

//end;
//end;

    end;







procedure TfrmMain.Button1Click(Sender: TObject);


begin
valorpuerto1:=0;
valorpuerto2:=0;           valorpuerto3:=0;
valorpuerto4:=1;
valorpuerto5:=0;
valorpuerto:=1*valorpuerto1+2*valorpuerto2+4*valorpuerto3 +8*valorpuerto4 +16*valorpuerto5;
Pinta;
//showMessage('canal 2 ,escala de 5voltios');
outportb($378,valorpuerto); //pone el byte del puerto paralelo D0...D7 en alto (5 volts)

end;




       procedure TfrmMain.Button2Click(Sender: TObject);

       var
  IniFile:TIniFile;

begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+ SETTINGS_FILE);


            //escala 1000
           frmMain.Label14.Caption:= inttostr(IniFile.ReadInteger('div1000','cero',3));
      frmMain.Label15.Caption:= inttostr(IniFile.ReadInteger('div1000','valoran',3));
           frmMain.Label16.Caption:=  inttostr(IniFile.ReadInteger('div1000','valordig',3));
            frmMain.Label29.Caption:=  inttostr(IniFile.ReadInteger('div1000','tipo',3));

       //escala 100
     frmMain.Label17.Caption:= inttostr(IniFile.ReadInteger('div100','cero',3));
frmMain.Label18.Caption:=  inttostr(IniFile.ReadInteger('div100','valoran',3));
frmMain.Label19.Caption:=  inttostr(IniFile.ReadInteger('div100','valordig',3));
       frmMain.Label30.Caption:=  inttostr(IniFile.ReadInteger('div100','tipo',3));



 //            //escala 50
frmMain.Label20.Caption:= inttostr(IniFile.ReadInteger('div50','cero',3));
frmMain.Label21.Caption:=  inttostr(IniFile.ReadInteger('div50','valoran',3));
 frmMain.Label22.Caption:=  inttostr(IniFile.ReadInteger('div50','valordig',3));
        frmMain.Label31.Caption:=  inttostr(IniFile.ReadInteger('div50','tipo',3));



             //escala 10
  frmMain.Label23.Caption:= inttostr( IniFile.ReadInteger('div10','cero',3));
frmMain.Label24.Caption:=  inttostr(IniFile.ReadInteger('div10','valoran',3));
frmMain.Label25.Caption:=  inttostr(IniFile.ReadInteger('div10','valordig',3));
       frmMain.Label32.Caption:=  inttostr(IniFile.ReadInteger('div10','tipo',3));



           //escala 5
    frmMain.Label26.Caption:=  inttostr(IniFile.ReadInteger('div5','cero',3));
frmMain.Label27.Caption:=  inttostr(IniFile.ReadInteger('div5','valoran',3));
frmMain.Label28.Caption:=  inttostr(IniFile.ReadInteger('div5','valordig',3));
       frmMain.Label33.Caption:=  inttostr(IniFile.ReadInteger('div5','tipo',3));



end;

procedure TfrmMain.frmInputControl1trInpVoumeChange(Sender: TObject);
begin
  frmInputControl1.trInpVoumeChange(Sender);

end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  IniFile:TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+ SETTINGS_FILE);


            //escala 1000
           frmMain.Label14.Caption:='0' ;
      frmMain.Label15.Caption:='0' ;
           frmMain.Label16.Caption:= '0' ;
            frmMain.Label29.Caption:= '4' ;

       //escala 100
     frmMain.Label17.Caption:='0' ;
frmMain.Label18.Caption:= '0' ;
frmMain.Label19.Caption:= '0' ;
       frmMain.Label30.Caption:= '4' ;



 //            //escala 50
frmMain.Label20.Caption:= '0';
frmMain.Label21.Caption:='0'  ;
 frmMain.Label22.Caption:= '0';
        frmMain.Label31.Caption:= '4' ;



             //escala 10
  frmMain.Label23.Caption:='0' ;
frmMain.Label24.Caption:= '0' ;
frmMain.Label25.Caption:= '0' ;
       frmMain.Label32.Caption:= '4' ;



           //escala 5
    frmMain.Label26.Caption:='0'  ;
frmMain.Label27.Caption:= '0' ;
frmMain.Label28.Caption:= '0' ;
       frmMain.Label33.Caption:='4'  ;



end;

end.



