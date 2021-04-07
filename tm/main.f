REQUIRE FrameWindow ~nn/lib/win/framewindow.f
REQUIRE Control ~nn/lib/win/control.f
REQUIRE MENU ~nn/lib/win/menu.f
REQUIRE ToolBar ~nn/lib/win/controls/ToolBar.f
REQUIRE StatusBar ~nn/lib/win/controls/StatusBar.f
REQUIRE ListView ~nn/lib/win/controls/ListView.f
\ REQUIRE TreeView ~nn/lib/win/controls/TreeView.f
REQUIRE FOR-FILES: ~nn/lib/for-files3.f
REQUIRE LoadImageListBMP ~nn/lib/win/controls/imagelist.f

CLASS: MainFrame <SUPER FrameWindow
350 VALUE width
200 VALUE height
70 VALUE lc_width

ToolBar OBJ tb
    :init a v 
\        -4 -4 pos
        TBSTYLE_FLAT vStyle !
\        TBSTYLE_EX_MIXEDBUTTONS vExStyle !
        ;

\ ListBox OBJ lv_job
ListView OBJ lv_job
   :init a v  0 0 pos  200 100 size tabstop
        LVS_EX_FULLROWSELECT v_ex_style !
    ;

StatusBar OBJ sb    :init a v ;


105 CONSTANT MI_CLOSE
106 CONSTANT MI_EXIT
107 CONSTANT MI_CUT
108 CONSTANT MI_PASTE
109 CONSTANT MI_CONTENT
110 CONSTANT MI_ABOUT
111 CONSTANT MI_TEXTFILE
111 CONSTANT MI_BINARY
112 CONSTANT MI_LARGEICONS
113 CONSTANT MI_SMALLICONS
114 CONSTANT MI_LIST      
115 CONSTANT MI_DETAILS   
116 CONSTANT MI_FILENEW
117 CONSTANT MI_FILEOPEN


VM: CreateMenu
    MENU
    POPUP
      POPUP
        S" &Text file"          MI_TEXTFILE     MENUITEM
        S" &Binary data"        MI_BINARY       MENUITEM
      S" &Open" END-POPUP
      S" &Close"        MI_CLOSE        MENUITEM
      MENUSEPARATOR
      S" &Exit"         MI_EXIT         MENUITEM
    S" &File" END-POPUP
    POPUP
      S" &Cut"          MI_CUT          MENUITEM
      S" &Paste"        MI_PASTE        MENUITEM
    S" &Edit" END-POPUP
    POPUP
      31 RES  MI_LARGEICONS   MENUITEM
      32 RES  MI_SMALLICONS   MENUITEM
      33 RES  MI_LIST         MENUITEM
      34 RES  MI_DETAILS      MENUITEM
    30 RES END-POPUP

    POPUP
      S" &Content"      MI_CONTENT      MENUITEM
      S" &About"        MI_ABOUT        MENUITEM
    S" &Help" END-POPUP
    END-MENU
    DUP vMenu !

;

MM: MI_LARGEICONS  lv_job IconStyle ; 
MM: MI_SMALLICONS  lv_job SmallIconStyle ;
MM: MI_LIST        lv_job ListStyle  ;
MM: MI_DETAILS     lv_job ReportStyle ;

MM: MI_ABOUT (About) ;

MM: MI_EXIT BYE ;

MM: MI_FILENEW 0 S" NEW" DROP DUP 0 MessageBoxA DROP ;

M: SetStyle
    WS_CAPTION  WS_SYSMENU OR WS_THICKFRAME OR WS_MINIMIZEBOX OR
    WS_OVERLAPPEDWINDOW OR
    WS_MAXIMIZEBOX OR  vStyle !
    WS_EX_CLIENTEDGE   vExStyle !
\    WS_EX_WINDOWEDGE
;


W: WM_SIZE { \ w h h_sb w_lc h_tb hclient -- }
    lparam @ LOWORD TO w 
    lparam @ HIWORD TO h
    tb GetWindowSize NIP TO h_tb
    0 -1 w h_tb tb MovePixels
\ 1. status bar
    sb GetWindowSize TO h_sb DROP
    h h_sb sb SetSizePixels
\    0 h h_sb - 2+ sb SetPos

    h h_sb - h_tb - TO hclient

\ 2. tv_cat - категории
\    tv_cat GetWindowSize DROP TO w_lc 
\    0 h_tb w_lc hclient tv_cat MovePixels

\ 3. list_job    
\    w_lc h_tb lv_job SetPos
\    w w_lc - hclient lv_job SetSizePixels
    0 h_tb w hclient lv_job MovePixels
;

CREATE but1
    STD_FILENEW , 1 , 0 C, 0 C, 0 , 0 ,

\ CREATE tbSTRINGS
\ CREATE tbs1 S" button1" SZ",
\ CREATE tbs2 S" button2" SZ",
\ CREATE tbs3 S" button3" SZ",
\ CREATE tbs4 S" button4" SZ",
\ 0 C, 

CREATE tbBUTTONS
STD_FILENEW , MI_FILENEW , TBSTATE_ENABLED  C, 0 C, 0 , 0 , 
STD_FILEOPEN , MI_FILEOPEN , TBSTATE_ENABLED  C, 0 C, 0 , 0 , 
5 , 0 , TBSTATE_ENABLED  C, TBSTYLE_SEP C, 0 ,  0 ,  
VIEW_LARGEICONS 15 + , MI_LARGEICONS , TBSTATE_ENABLED  C, 0 C, 0 , 0 , 
VIEW_SMALLICONS 15 + , MI_SMALLICONS , TBSTATE_ENABLED  C, 0 C, 0 , 0 , 
VIEW_LIST       15 + , MI_LIST       , TBSTATE_ENABLED  C, 0 C, 0 , 0 , 
VIEW_DETAILS    15 + , MI_DETAILS    , TBSTATE_ENABLED  C, 0 C, 0 , 0 , 
5 , 0 , TBSTATE_ENABLED  C, TBSTYLE_SEP C, 0 , 0 ,  

WINAPI: ImageList_Create comctl32.dll
WINAPI: ImageList_Add comctl32.dll
WINAPI: ImageList_AddIcon comctl32.dll
WINAPI: ImageList_LoadImageA comctl32.dll
USER-VALUE img_s
USER-VALUE img_l

\ : .nn NodeValue NodeValue ASCIIZ> TYPE CR ;

VARIABLE task-name
VARIABLE task-time
VARIABLE task-command
VARIABLE task-icon
VARIABLE icon-list
VARIABLE icon-cnt

0 
1 CELLS -- icon-idx
1 CELLS -- icon-path
CONSTANT /ICON-NODE
: skip-bl ( a u -- a1 u1) 
    BEGIN DUP IF OVER C@ BL = ELSE FALSE THEN WHILE
      1 /STRING
    REPEAT
;

: get-time&command { a u \ ibl -- }
    S" -" DROP DUP DUP task-time ! task-command ! task-name !
    0 task-icon !
    0 TO ibl
    a u
    BEGIN ?DUP WHILE
       OVER C@ BL =
       IF ibl 1+ TO ibl 
          ibl 5 =
          IF OVER a - a SWAP S>ZALLOC task-time ! 
             skip-bl
             2DUP S>ZALLOC task-command !
             2DUP 0 0 EXE-PATH 
             ?DUP IF  2DUP FILE-ICONS
                      ?DUP IF 
                                DUP img_l ImageList_AddIcon DROP
                                DestroyIcon DROP
                                DUP img_s ImageList_AddIcon task-icon !
                                DestroyIcon DROP
                                icon-cnt 1+!
                           ELSE DROP THEN             
                      ONLYNAME ELSE DROP task-command @ ASCIIZ> THEN
             S>ZALLOC task-name !
             DROP 1
          THEN
          skip-bl
       THEN
       1 /STRING
    REPEAT
    DROP
\    S>ZALLOC DUP task-time ! task-command !
;

M: refresh-jobs { \ idx -- }
    lv_job ClearAll
\    ['] .nn task-list DoList
    0 TO idx
    task-list
    BEGIN @ ?DUP WHILE
        DUP NodeValue NodeValue ASCIIZ> get-time&command
\        ASCIIZ> TYPE CR
        task-icon @ task-name @ ASCIIZ> idx lv_job InsertItem

\        DUP NodeValue NodeValue
        idx 1 task-time @ ASCIIZ> lv_job SetItem
        idx 2 task-command @ ASCIIZ> lv_job SetItem

        idx 1+ TO idx
    REPEAT
;

: Popup1
   POPUPMENU
    POPUP
      S" &he he"                MI_CUT          MENUITEM
      S" &ha ha"        MI_PASTE        MENUITEM
    S" &yahho" END-POPUP
    POPUP
      S" &ku ku"        MI_CONTENT      MENUITEM
      S" &la la"        MI_ABOUT        MENUITEM
    S" &uhha" END-POPUP
   END-MENU   
;


M: lv_popup 
    Popup1 >R
    0 handle @ 0 
    0 0 SP@ GetCursorPos DROP TPM_RETURNCMD R@ TrackPopupMenu DROP
    R> DestroyMenu DROP
;

M: Create
    SetStyle
    0 Create
    1 RES SetText
\    10001 TBSTYLE_FLAT handle @ CreateToolbarEx
    
\    AddTaskPos XY? 
\    IF MainPos XY@ SetPos 
\       width height SetSize
\    ELSE 
        width height Center 
\    THEN 
    AutoCreate

    S" icon32" DROP HINST LoadIconA GCL_HICON   handle @ SetClassLongA DROP
    S" icon16" DROP HINST LoadIconA GCL_HICONSM handle @ SetClassLongA DROP

\    LR_DEFAULTCOLOR IMAGE_BITMAP CLR_DEFAULT 0 16 S" hha" DROP HINST ImageList_LoadImageA DUP . CR TO imgl


\    list_cat SetOwnProc
\    0 /TBBUTTON TB_BUTTONSTRUCTSIZE tb SendMessage GetLastError . CR . CR 
\    but1 1 TB_ADDBUTTONS but1 tb SendMessage GetLastError . CR . CR 

    110 RES 150 0 lv_job InsertColumn
    111 RES 50 1  lv_job InsertColumn
    112 RES 450 2  lv_job InsertColumn

    1024 1 ILC_COLOR 16 16 ImageList_Create TO img_s
    1024 1 ILC_COLOR 32 32 ImageList_Create TO img_l

    1 icon-cnt !
    IDI_APPLICATION 0 LoadIconA  >R
    R@ img_s ImageList_AddIcon DROP
    R@ img_l ImageList_AddIcon DROP
    RDROP

    img_s lv_job SetILSmall
    img_l lv_job SetILNormal

    lv_job ReportStyle

    load-crontab

    refresh-jobs

    ['] lv_popup lv_job OnRClick !
    ['] lv_popup lv_job OnDoubleClick !


\    tbSTRINGS 0 TB_ADDSTRINGA tb SendMessage DROP
    HINST_COMMCTRL IDB_STD_SMALL_COLOR TB_LOADIMAGES tb SendMessage DROP
    HINST_COMMCTRL IDB_VIEW_SMALL_COLOR TB_LOADIMAGES tb SendMessage DROP
\    VIEW_LARGEICONS IDB_VIEW_SMALL_COLOR tb AddBMP
\    VIEW_SMALLICONS IDB_VIEW_SMALL_COLOR tb AddBMP
\    VIEW_LIST       IDB_VIEW_SMALL_COLOR tb AddBMP
\    VIEW_DETAILS    IDB_VIEW_SMALL_COLOR tb AddBMP

    tbBUTTONS 7 TB_ADDBUTTONS tb SendMessage DROP

;

;CLASS


MainFrame POINTER mw

: MAIN
\    AT-PROCESS-STARTING
\    AT-THREAD-STARTING

    MainFrame NEW TO mw
    mw Create
    mw Show
\    mw vNoNotify 0!
    mw Run
    mw SELF DELETE
    BYE
;

