; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Soundux"
#define MyAppVersion "0.2"
#define MyAppPublisher "Soundux"
#define MyAppURL "https://soundux.rocks"
#define MyAppExeName "soundux.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{CEF755B2-DDD3-4E35-8DF7-3BDBF86893DE}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
WizardStyle=modern
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=$PATH\LICENSE
OutputBaseFilename=setup
SetupIconFile=$PATH\assets\icon.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "$PATH\build\Release\soundux.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "$PATH\build\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{tmp}\VBCABLE_Driver_Pack43.zip"; DestDir: "{app}"; Flags: external deleteafterinstall
Source: "{tmp}\MicrosoftEdgeWebView2RuntimeInstallerX64.exe"; DestDir: "{tmp}"; Flags: external deleteafterinstall
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Dirs]
Name: "{app}"; Permissions: users-full

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Code]

const
  SHCONTCH_NOPROGRESSBOX = 4;
  SHCONTCH_RESPONDYESTOALL = 16;

procedure UnZip(ZipPath, TargetPath: string); 
var
  Shell: Variant;
  ZipFile: Variant;
  TargetFolder: Variant;
begin
  Shell := CreateOleObject('Shell.Application');

  ZipFile := Shell.NameSpace(ZipPath);
  if VarIsClear(ZipFile) then
    RaiseException(Format('ZIP file "%s" does not exist or cannot be opened', [ZipPath]));

  TargetFolder := Shell.NameSpace(TargetPath);
  if VarIsClear(TargetFolder) then
    RaiseException(Format('Target path "%s" does not exist', [TargetPath]));

  TargetFolder.CopyHere(ZipFile.Items, SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL);
end;


var
  DownloadPage: TDownloadWizardPage;
function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
  if Progress = ProgressMax then
    Log(Format('Successfully downloaded file to {tmp}: %s', [FileName]));
  Result := True;
end;
procedure InitializeWizard;
begin
  DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
end;
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = wpReady then begin
    DownloadPage.Clear;
    DownloadPage.Add('https://go.microsoft.com/fwlink/?linkid=2124701', 'MicrosoftEdgeWebView2RuntimeInstallerX64.exe', '');
    DownloadPage.Add('https://download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack43.zip', 'VBCABLE_Driver_Pack43.zip', '')
    DownloadPage.Show;
    try
      try
        DownloadPage.Download;
        Result := True;
      except
        Result := False;
      end;
    finally
      UnZip(ExpandConstant('{tmp}') + '\VBCABLE_Driver_Pack43.zip', ExpandConstant('{tmp}'))
      DownloadPage.Hide;
    end;
  end else
    Result := True;
end;

[Run]
Filename: "{tmp}\MicrosoftEdgeWebView2RuntimeInstallerX64.exe"; WorkingDir: "{tmp}"; Flags: 64bit; Description: "Install Microsoft Edge WebView2 Runtime"; Components: MicrosoftEdgeWebView2Runtime
Filename: "{tmp}\VBCABLE_Setup_x64.exe"; WorkingDir: "{tmp}"; Flags: 64bit; Description: "Install VB Cable"; Components: VBCable
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"

[Components]
Name: "MicrosoftEdgeWebView2Runtime"; Description: "Install Microsoft Edge WebView2 Runtime (mandatory)"; Types: full; Flags: fixed
Name: "VBCable"; Description: "Install VBCable (recommended)"; Types: full
