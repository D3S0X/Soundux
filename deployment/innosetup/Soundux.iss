; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Soundux"
#define MyAppVersion "0.2.2_b3"
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
AppVerName={#MyAppName} {#MyAppVersion}
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
Name: "armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "$PATH\build\Release\soundux.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "$PATH\build\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{tmp}\VBCABLE_Driver_Pack43.zip"; DestDir: "{app}"; Flags: external deleteafterinstall; Components: VBCable
Source: "{tmp}\MicrosoftEdgeWebView2RuntimeInstallerX64.exe"; DestDir: "{tmp}"; Flags: external deleteafterinstall; Components: MicrosoftEdgeWebView2Runtime
Source: "{tmp}\youtube-dl.exe"; DestDir: "{app}"; Flags: external ignoreversion; Components: FfmpegYouTubeDL
Source: "{tmp}\ffmpeg.exe"; DestDir: "{app}"; Flags: external ignoreversion; Components: FfmpegYouTubeDL

[Dirs]
Name: "{app}"; Permissions: users-full

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Code]

function IsWebView2NotInstalled: boolean;
begin
  result := not RegKeyExists(HKEY_LOCAL_MACHINE,
    'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView');
end;


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
    if (WizardIsComponentSelected('MicrosoftEdgeWebView2Runtime')) then begin
      DownloadPage.Add('https://go.microsoft.com/fwlink/?linkid=2124701', 'MicrosoftEdgeWebView2RuntimeInstallerX64.exe', '');
    end;
    if WizardIsComponentSelected('VBCable') then begin
      DownloadPage.Add('https://download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack43.zip', 'VBCABLE_Driver_Pack43.zip', '')
    end;
    if WizardIsComponentSelected('FfmpegYouTubeDL') then begin
      DownloadPage.Add('https://github.com/eugeneware/ffmpeg-static/releases/download/b4.3.2/win32-x64', 'ffmpeg.exe', '')
      DownloadPage.Add('https://github.com/ytdl-org/youtube-dl/releases/download/2021.04.01/youtube-dl.exe', 'youtube-dl.exe', '')
    end;
    DownloadPage.Show;
    try
      try
        DownloadPage.Download;
        Result := True;
      except
        Result := False;
      end;
    finally
      if (Result and WizardIsComponentSelected('VBCable')) then begin
        UnZip(ExpandConstant('{tmp}') + '\VBCABLE_Driver_Pack43.zip', ExpandConstant('{tmp}'))
      end;
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
Name: "MicrosoftEdgeWebView2Runtime"; Description: "Install Microsoft Edge WebView2 Runtime (mandatory)"; Types: custom full compact; Flags: fixed disablenouninstallwarning; Check: IsWebView2NotInstalled
Name: "VBCable"; Description: "Install VBCable (recommended)"; Types: full; Flags: disablenouninstallwarning
Name: "FfmpegYouTubeDL"; Description: "Install ffmpeg and youtube-dl (for Downloader support)"; Types: full; Flags: disablenouninstallwarning
