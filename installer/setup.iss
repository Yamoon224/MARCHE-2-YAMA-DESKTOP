; Installateur Windows du backoffice Marché de Yama.
; Prérequis : `flutter build windows --release`, puis compiler ce script avec Inno Setup 6 (ISCC.exe installer\setup.iss).
#define AppName "Marché de Yama - Backoffice"
#define AppVersion "1.0.0"
#define AppExe "marche_yama_backoffice.exe"
#define BuildDir "..\build\windows\x64\runner\Release"

[Setup]
AppId={{6C1F5E0A-3B7D-4F58-9A41-2D8E7B0C94A1}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=Marché de Yama
DefaultDirName={autopf}\Marche de Yama Backoffice
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputDir=output
OutputBaseFilename=Setup_Backoffice_Marche_de_Yama
SetupIconFile=..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExe}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "Créer un raccourci sur le Bureau"; GroupDescription: "Raccourcis :"

[Files]
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "Lancer {#AppName}"; Flags: nowait postinstall skipifsilent
