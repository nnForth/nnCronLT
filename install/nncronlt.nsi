; creates nncronltxxx.exe
;
;--------------------------------

!define VER_MAJOR 1
!define VER_MINOR 17
!define PROG_NAME "nnCron LITE"
!define PROG_SHORT_NAME "nncronlt"
!define PROG_SHORTEST_NAME "cron"
!define COMPILE_DIR "e:\home\SRC\CronLT\install\image\data"

; allowing us to use SF_SELECTED constant
!include "Sections.nsh"

LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
Name "${PROG_NAME} ${VER_MAJOR}.${VER_MINOR}"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"
Name "${PROG_NAME} ${VER_MAJOR}.${VER_MINOR}"

; The file to write
OutFile "${PROG_SHORT_NAME}${VER_MAJOR}${VER_MINOR}.exe"

; license
LangString ReadLicenseText ${LANG_ENGLISH} "Please, review the license terms before installing ${PROG_NAME}."
LangString ReadLicenseText ${LANG_RUSSIAN} "??????????, ??????????? ???????? ???????? ????? ??? ??? ?????????? ????????? ${PROG_NAME}."
LicenseText $(ReadLicenseText)
LicenseLangString LicenseSource ${LANG_ENGLISH} "${COMPILE_DIR}\..\presetup\license.txt"
LicenseLangString LicenseSource ${LANG_RUSSIAN} "${COMPILE_DIR}\..\presetup\license.rus"
LicenseData $(LicenseSource) 

; The default installation directory
InstallDir "$PROGRAMFILES\${PROG_SHORTEST_NAME}\"

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically}
InstallDirRegKey HKLM "SOFTWARE\nnSoft\${PROG_NAME}" "path"

; The text to prompt the user to enter a directory
ComponentText /LANG=${LANG_ENGLISH} "Check the components you want to install and uncheck the components you don't want to install. Click Next to continue."
ComponentText /LANG=${LANG_RUSSIAN} "???????? ??????????, ??????? ?????? ??????????.$\r$\n??????? ????? ??? ???????????."

; The text to prompt the user to enter a directory
DirText /LANG=${LANG_ENGLISH} "Choose the folder in which to install ${PROG_NAME}.$\r$\nTo install in a different folder, click Browse and select another folder.$\r$\nClick Install to start the installation."
DirText /LANG=${LANG_RUSSIAN} "???????? ?????, ? ??????? ????? ?????????? ${PROG_NAME}.$\r$\n?????????????? ??????? ?????, ????? ??????? ?????? ?????.$\r$\n??????? ??????????, ????? ?????? ??????? ???????????."

; show the "show details" box
ShowInstDetails show
ShowUninstDetails show

;--------------------------------
; LangStrings
;

LangString AbortMessage ${LANG_ENGLISH} "Are you sure you want to quit ${PROG_NAME} ${VER_MAJOR}.${VER_MINOR} Setup?"
LangString AbortMessage ${LANG_RUSSIAN} "?? ???????, ??? ?????? ???????? ??????? ????????? ${PROG_NAME} ${VER_MAJOR}.${VER_MINOR}?"
LangString AnotherInstanceMessage1 ${LANG_ENGLISH} "Another instance of ${PROG_NAME} is running on your computer.$\r$\nPlease, close ${PROG_NAME} and start setup program again."
LangString AnotherInstanceMessage1 ${LANG_RUSSIAN} "????????? ${PROG_NAME} ?????????? ??? ?????????? ??????????.$\r$\n??????????, ???????? ${PROG_NAME} ? ????????????? ??????? ???????????."
LangString AnotherInstanceMessage2 ${LANG_ENGLISH} "Another instance of ${PROG_NAME} is running on your computer.$\r$\nPress Yes to close ${PROG_NAME} automatically and continue with Setup.$\r$\nPress No to quit Setup."
LangString AnotherInstanceMessage2 ${LANG_RUSSIAN} "????????? ${PROG_NAME} ?????????? ??? ?????????? ??????????.$\r$\n??????? Yes, ????? ????????????? ??????? ${PROG_NAME} ? ?????????? ?????????.$\r$\n??????? No, ????? ????? ?? ????????? ?????????."
LangString AdministratorMessage ${LANG_ENGLISH} "For installation of ${PROG_NAME}  it is necessary to have administrator rights on this computer."
LangString AdministratorMessage ${LANG_RUSSIAN} "??? ????????? ${PROG_NAME}  ?????????? ????? ????? ?????????????? ?? ???? ??????????."
LangString Sec1Name ${LANG_ENGLISH} "Program Files (required)"
LangString Sec1Name ${LANG_RUSSIAN} "???????? ????? ${PROG_NAME}"
LangString Sec2Name ${LANG_ENGLISH} "Documentation"
LangString Sec2Name ${LANG_RUSSIAN} "????????????"
;LangString Sec3Name ${LANG_ENGLISH} "Start Menu Shortcuts"
;LangString Sec3Name ${LANG_RUSSIAN} "?????? ? ???? ????"

LangString Sec3Name ${LANG_ENGLISH} "Start Menu Shortcuts"
LangString Sec3Name ${LANG_RUSSIAN} "?????? ? ???? ????"
LangString Sec31Name ${LANG_ENGLISH} "For current user only"
LangString Sec31Name ${LANG_RUSSIAN} "?????? ??? ???????? ????????????"
LangString Sec32Name ${LANG_ENGLISH} "For all users"
LangString Sec32Name ${LANG_RUSSIAN} "??? ???? ?????????????"
LangString Sec33Name ${LANG_ENGLISH} "Do not create shortcuts"
LangString Sec33Name ${LANG_RUSSIAN} "?? ????????? ??????"

LangString ServiceStartMessage ${LANG_ENGLISH} "Installing and starting ${PROG_NAME} service"
LangString ServiceStartMessage ${LANG_RUSSIAN} "????????? ? ?????? ??????? ${PROG_NAME}"
LangString un.ServiceStopMessage ${LANG_ENGLISH} "Stopping and uninstalling ${PROG_NAME} service..."
LangString un.ServiceStopMessage ${LANG_RUSSIAN} "????????? ? ???????? ??????? ${PROG_NAME}..."
LangString un.ServiceDoneMessage ${LANG_ENGLISH} "...completed"
LangString un.ServiceDoneMessage ${LANG_RUSSIAN} "...?????????"

;--------------------------------
;
; The stuff to install

Section !$(Sec1Name) sec1
  ; read-only section
  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put file there
  File "${COMPILE_DIR}\*.exe"
  File "${COMPILE_DIR}\*.bat"
  ; this file will not be overwrited if exist
  SetOverwrite off
  File "${COMPILE_DIR}\cron.tab"
  SetOverwrite on

  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\nnSoft\${PROG_NAME}" "path" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROG_NAME}" "DisplayName" "${PROG_NAME} (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROG_NAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
SectionEnd

Section $(Sec2Name) sec2
; optional section (can be disabled by the user)
  SetOutPath $INSTDIR\doc
  File "${COMPILE_DIR}\doc\*.chm"
  File "${COMPILE_DIR}\doc\*.txt"
SectionEnd


SubSection /e $(Sec3Name) sec3

    Section $(Sec31Name) sec31
        Call createShortCuts
    SectionEnd

    Section $(Sec32Name) sec32
        ; RMDir /r "$SMPROGRAMS\${PROG_NAME}"
        SetShellVarContext all
        Call createShortCuts
    SectionEnd

    Section $(Sec33Name) sec33
    SectionEnd

SubSectionEnd

Section
; unnamed section - the default one
  WriteUninstaller "uninstall.exe"
  ; installing program service and writing output to the log
  SetOutPath $INSTDIR
  DetailPrint $(ServiceStartMessage)
  nsExec::Exec '"$INSTDIR\install_svc.bat"'
SectionEnd

;--------------------------------
;
; Uninstaller

UninstallText /LANG=${LANG_ENGLISH} "This will uninstall ${PROG_NAME} ${VER_MAJOR}.${VER_MINOR} from your computer. Click Uninstall to start the uninstallation."
UninstallText /LANG=${LANG_RUSSIAN} "?????? ????????? ${PROG_NAME} ${VER_MAJOR}.${VER_MINOR} ????? ??????? ? ?????? ??????????. ??????? ??????? ??? ?????? ???????? ?????????????."

; Uninstall section
Section "Uninstall"
  ; uninstalling program service and writing output to the log
  SetOutPath $INSTDIR
  DetailPrint $(un.ServiceStopMessage)
  nsExec::Exec '"$INSTDIR\uninstall_svc.bat"'
  DetailPrint $(un.ServiceDoneMessage)

  ; remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROG_NAME}"
  DeleteRegKey HKLM "SOFTWARE\nnSoft\${PROG_NAME}"
  ; this key will be deleted only if it is empty
  DeleteRegKey /ifempty HKLM "SOFTWARE\nnSoft"

  ; remove all the files
  Delete "$INSTDIR\*.exe"
  Delete "$INSTDIR\*.bat"

  ; remove directories used
  RMDir /r "$SMPROGRAMS\${PROG_NAME}"
  RMDir /r "$INSTDIR\doc"
  RMDir "$INSTDIR"
SectionEnd

;--------------------------------
; Functions
;

; warning when cancelling installation manually
Function .onUserAbort
   MessageBox MB_YESNO $(AbortMessage) IDYES NoCancelAbort
     Abort ; causes installer to not quit.
   NoCancelAbort:
FunctionEnd

Function .onInit
    SetOutPath $INSTDIR
    ClearErrors
;** checking for NT/9*
    ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
    StrCmp $0 "" instancecheck

;** checking if current user has Administartor rights
    UserInfo::GetName
    Pop $0
    UserInfo::GetAccountType
;    IfErrors instancecheck
    Pop $1
    StrCmp $1 "Admin" instancecheck
    StrCmp $1 "Power" instancecheck
    MessageBox MB_OK|MB_ICONSTOP $(AdministratorMessage)
    Abort

    instancecheck:
    ; cheking for another program instance running
    FindWindow $R9 "" "NNCronLTCtrlWindow"
    IntCmp $R9 0 done
    ; checking if we can access previous installation dir
    ReadRegStr $R8 HKLM "SOFTWARE\nnSoft\${PROG_NAME}" "path"
    StrCmp $R8 "" instanceabort1 instanceabort2

    instanceabort1:
    MessageBox MB_OK|MB_ICONEXCLAMATION $(AnotherInstanceMessage1)
    Abort

    instanceabort2:
    MessageBox MB_YESNO|MB_ICONEXCLAMATION $(AnotherInstanceMessage2) IDYES StopAnotherInstance
    Abort

    StopAnotherInstance:
    ; stopping another program instance
    nsExec::Exec '"$INSTDIR\stopcron.bat"'

    done:
    ; creating language selection dialog
    Call IsSilent
    Pop $0
    StrCmp $0 1 initexit 0

    Push ""
    Push ${LANG_ENGLISH}
    Push English
    Push ${LANG_RUSSIAN}
    Push Russian
    Push A ; A means auto count languages
           ; for the auto count to work the first empty push (Push "") must remain
    LangDLL::LangDialog "Installer Language" "Please select the language of the installer"

    Pop $LANGUAGE
    StrCmp $LANGUAGE "cancel" 0 +2
        Abort
initexit:

    Push $0

    StrCpy $1 ${sec31} ; Gotta remember which section we are at now...
    SectionGetFlags ${sec31} $0
    IntOp $0 $0 | ${SF_SELECTED}
    SectionSetFlags ${sec31} $0

    SectionGetFlags ${sec32} $0
    IntOp $0 $0 & ${SECTION_OFF}
    SectionSetFlags ${sec32} $0

    SectionGetFlags ${sec33} $0
    IntOp $0 $0 & ${SECTION_OFF}
    SectionSetFlags ${sec33} $0

    Pop $0

FunctionEnd



Function .onSelChange
    Push $0

    Push $2
    StrCpy $2 ${SF_SELECTED}
    SectionGetFlags ${sec31} $0
    IntOp $2 $2 & $0
    SectionGetFlags ${sec32} $0
    IntOp $2 $2 & $0
    SectionGetFlags ${sec33} $0
    IntOp $2 $2 & $0
    StrCmp $2 0 skip
        SectionSetFlags ${sec31} 0
        SectionSetFlags ${sec32} 0
        SectionSetFlags ${sec33} 0
    skip:
    Pop $2

    ; Turn off old selected section
    SectionGetFlags $1 $0
    IntOp $0 $0 & ${SECTION_OFF}
    SectionSetFlags $1 $0
    # !insertmacro UnselectSection $1

    ; Now remember the current selection
    Push $2
    StrCpy $2 $1

    SectionGetFlags ${sec31} $0
    IntOp $0 $0 & ${SF_SELECTED}
    IntCmp $0 ${SF_SELECTED} 0 +2 +2
        StrCpy $1 ${sec31}
    SectionGetFlags ${sec32} $0
    IntOp $0 $0 & ${SF_SELECTED}
    IntCmp $0 ${SF_SELECTED} 0 +2 +2
        StrCpy $1 ${sec32}
    SectionGetFlags ${sec33} $0
    IntOp $0 $0 & ${SF_SELECTED}
    IntCmp $0 ${SF_SELECTED} 0 +2 +2
        StrCpy $1 ${sec33}

    StrCmp $2 $1 0 +4 ; selection hasn't changed
        SectionGetFlags $1 $0
        IntOp $0 $0 | ${SF_SELECTED}
        SectionSetFlags $1 $0
        # !insertmacro SelectSection $1
    Pop $2
    Pop $0
FunctionEnd

Function createShortcuts
  RMDir /r "$SMPROGRAMS\${PROG_NAME}"
  CreateDirectory "$SMPROGRAMS\${PROG_NAME}"
  CreateShortCut "$SMPROGRAMS\${PROG_NAME}\Uninstall ${PROG_NAME}.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${PROG_NAME}\Start ${PROG_NAME}.lnk" "$INSTDIR\startcron.bat" "" "$INSTDIR\startcron.bat" 0
  CreateShortCut "$SMPROGRAMS\${PROG_NAME}\Stop ${PROG_NAME}.lnk" "$INSTDIR\stopcron.bat" "" "$INSTDIR\stopcron.bat" 0
  SectionGetFlags ${Sec2} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  StrCmp $R0 ${SF_SELECTED} "" +5
  CreateShortCut "$SMPROGRAMS\${PROG_NAME}\${PROG_NAME} Readme.lnk" "$INSTDIR\doc\readme.txt" "" "$INSTDIR\doc\readme.txt" 0
  CreateShortCut "$SMPROGRAMS\${PROG_NAME}\${PROG_NAME} Readme (rus).lnk" "$INSTDIR\doc\readme.rus.txt" "" "$INSTDIR\doc\readme.rus.txt" 0
  CreateShortCut "$SMPROGRAMS\${PROG_NAME}\${PROG_NAME} Help.lnk" "$INSTDIR\doc\help.chm" "" "$INSTDIR\doc\help.chm" 0
  CreateShortCut "$SMPROGRAMS\${PROG_NAME}\${PROG_NAME} Help (rus).lnk" "$INSTDIR\doc\help_ru.chm" "" "$INSTDIR\doc\help_ru.chm" 0
FunctionEnd


Function IsSilent
  Push $0
  Push $CMDLINE
  Push "/S"
  Call StrStr
  Pop $0
  StrCpy $0 $0 3
  StrCmp $0 "/S" silent
  StrCmp $0 "/S " silent
    StrCpy $0 0
    Goto notsilent
  silent: StrCpy $0 1
  notsilent: Exch $0
FunctionEnd

Function StrStr
  Exch $R1 ; st=haystack,old$R1, $R1=needle
  Exch    ; st=old$R1,haystack
  Exch $R2 ; st=old$R1,old$R2, $R2=haystack
  Push $R3
  Push $R4
  Push $R5
  StrLen $R3 $R1
  StrCpy $R4 0
  ; $R1=needle
  ; $R2=haystack
  ; $R3=len(needle)
  ; $R4=cnt
  ; $R5=tmp
  loop:
    StrCpy $R5 $R2 $R3 $R4
    StrCmp $R5 $R1 done
    StrCmp $R5 "" done
    IntOp $R4 $R4 + 1
    Goto loop
  done:
  StrCpy $R1 $R2 "" $R4
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch $R1
FunctionEnd
