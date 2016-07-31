Global $version, $oldversion
If RegRead("HKLM\SOFTWARE\Wow6432Node\Wizet\MapleStory", "ExecPath") Then
	FileChangeDir(RegRead("HKLM\SOFTWARE\Wow6432Node\Wizet\MapleStory", "ExecPath"))
Else
	FileChangeDir(RegRead("HKLM\SOFTWARE\Wizet\MapleStory", "ExecPath"))
EndIf
Global $save = FileSelectFolder("Browse to MapleStory Directory", @WorkingDir, "", @WorkingDir)
WinWaitClose("Browse to MapleStory Directory")
If $save = "" Then Exit
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("MapleMods Updater", 197, 180, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
$Button1 = GUICtrlCreateButton("Install", 8, 30, 180, 33)
$Button2 = GUICtrlCreateButton("Revert", 8, 70, 180, 33)
$Button3 = GUICtrlCreateButton("More Info", 8, 110, 180, 25)
$Button4 = GUICtrlCreateButton("Prepare Maple for Patching", 8, 140, 180, 33)

$Label1 = GUICtrlCreateLabel("Item.wz", 16, 8, 40, 17, $SS_CENTER)
$Label2 = GUICtrlCreateLabel("Etc.wz", 140, 8, 36, 17, $SS_CENTER)
$Label3 = GUICtrlCreateLabel("Version " & $version, 58, 8, 80, 17, $SS_CENTER)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
AdlibRegister("CheckUpdate", "60000")
CheckUpdate()
main()
Func main()
	While 1
		GUISetState(@SW_SHOW)
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Button1
				GUISetState(@SW_HIDE)
				Global $Url = "https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/CurrentEtc.wz"
				Global $mod = "Etc.wz"
				If save() = 1 Then
					$version = BinaryToString(InetRead("https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/Version.txt", 1))
					$hFile = FileOpen("Version.txt", 2)
					FileWrite($hFile, $version)
					FileClose($hFile)
					GUICtrlSetData($Label3, "Version " & $version)
					If FileRead("OldVersion.txt") <> FileRead("Version.txt") Then
						$oldversion = BinaryToString(InetRead("https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/OldVersion.txt", 1))
						$hFile = FileOpen("OldVersion.txt", 2)
						FileWrite($hFile, $oldversion)
						FileClose($hFile)
					EndIf
				EndIf
			Case $Button2
				GUISetState(@SW_HIDE)
				Global $Url = "https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/OriginalEtc.wz"
				Global $mod = "Etc.wz"
				If save() = 1 Then
					$version = BinaryToString(InetRead("https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/Version.txt", 1))
					$hFile = FileOpen("Version.txt", 2)
					FileWrite($hFile, BinaryToString(InetRead("https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/Version.txt", 1)))
					FileClose($hFile)
					GUICtrlSetData($Label3, "Version " & $version)
					If FileRead("OldVersion.txt") <> FileRead("Version.txt") Then
						$oldversion = BinaryToString(InetRead("https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/OldVersion.txt", 1))
						$hFile = FileOpen("OldVersion.txt", 2)
						FileWrite($hFile, $oldversion)
						FileClose($hFile)
					EndIf
				EndIf
			Case $Button3
				GUISetState(@SW_HIDE)
				MsgBox(64, "MapleMods Updater", "These mods for MapleStory will do the following things:" & @CRLF & _
						"Remove the Curse Filter (able to see all other censored words)" & @CRLF & _
						"Remove the MapleTips (the yellow tips in the chat log)" & @CRLF & _
						"Remove Eileen Tips (Eileen in the Group/1-on-1 chat)")
				GUISetState(@SW_SHOW)
			Case $Button4
				GUISetState(@SW_HIDE)
				Global $Url = "https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/PreviousEtc.wz"
				Global $mod = "Etc.wz"
				If save() = 1 Then
					$version = BinaryToString(InetRead("https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/OldVersion.txt", 1))
					$hFile = FileOpen("Version.txt", 2)
					FileWrite($hFile, $version)
					FileClose($hFile)
					GUICtrlSetData($Label3, "Version " & $version)
					AdlibUnRegister("CheckUpdate")
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>main
Func save()
	If @error = 1 Then Exit
	If ProcessExists("MapleStory.exe") Then
		MsgBox(0, "MapleMods Updater", "MapleStory is Running. Please close MapleStory and try again.")
		main()
	EndIf
	TrayTip("MapleMods Updater", "Patching " & $mod & ". Please Wait.", "10")
	InetGet($Url, $save & "\" & $mod, 1)
	If @error = 0 Then
		MsgBox(0, "MapleMods Updater", "Success")
		GUICtrlSetData($Label3, "Version " & $version)
		Return 1
	EndIf
	If @error = 13 Then
		MsgBox(0, "MapleMods Updater", "Failed because a previous version does not exist on the server.")
		Return -1
	ElseIf Not @error = 0 Then
		Return -2
		MsgBox(0, "MapleMods Updater", "Error: " & @error)
	EndIf
EndFunc   ;==>save
Func CheckUpdate()
	$oldversion = FileRead("OldVersion.txt")
	$Currentversion = FileRead("Version.txt")
	$version = BinaryToString(InetRead("https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/Version.txt", 1))
	If $oldversion = "" Then
		$oldversion = BinaryToString(InetRead("https://github.com/BetaLeaf/betaleaf.github.com/releases/download/0/OldVersion.txt", 1))
		$hFile = FileOpen("OldVersion.txt", 2)
		FileWrite($hFile, $oldversion)
		FileClose($hFile)
		$FirstRun = 1
		GUICtrlSetData($Label3, "Version " & $version)
	EndIf
	If $Currentversion = "" Then
		$hFile2 = FileOpen("Version.txt", 2)
		FileWrite($hFile2, $version)
		FileClose($hFile2)
		$FirstRun = 1
		GUICtrlSetData($Label3, "Version " & $version)
	EndIf
	If IsDeclared("Firstrun") And $FirstRun = 1 Then Return 1
	If $version <> $Currentversion Then
		GUISetState(@SW_HIDE)
		MsgBox(0, "MapleMods Updater", "New Updates Released. Please restore the original files, patch your game, and then install the current version again.")
		GUISetState(@SW_SHOW)
		AdlibUnRegister("CheckUpdate")
		GUICtrlSetData($Label3, "Version " & $oldversion)
	Else
		GUICtrlSetData($Label3, "Version " & $version)
	EndIf
EndFunc   ;==>CheckUpdate
