@tool
extends Control

var subwindows: Array[Control]

func _enter_tree() -> void:
	subwindows = [
		$Root/Gaxos, $"Root/Dall-E", $"Root/Stability AI", $"Root/Meshy",
		$Root/Suno, $"Root/Eleven Labs", 
		$"Root/Multiple Text To Image", $"Root/Multiple Masking",
		$"Root/Requests List", $"Root/Favorites List",
		$"Root/Basic Examples",
		$Root/Configuration
	];

func _ready() -> void:
	for subwindow in subwindows:
		subwindow.hide()
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Content/Generators/Gaxos".pressed.connect(func (): self._show_subwindow(0))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Content/Generators/DallE".pressed.connect(func (): self._show_subwindow(1))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Content/Generators/Stability".pressed.connect(func (): self._show_subwindow(2))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Content/Generators/Meshy".pressed.connect(func (): self._show_subwindow(3))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Content/Generators/Suno".pressed.connect(func (): self._show_subwindow(4))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Content/Generators/ElevenLabs".pressed.connect(func (): self._show_subwindow(5))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Multiple Content/Generators/Multi Text To Image".pressed.connect(func (): self._show_subwindow(6))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Multiple Content/Generators/Multi Masking".pressed.connect(func (): self._show_subwindow(7))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Requests List/Button".pressed.connect(func (): self._show_subwindow(8))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Favorites List/Button".pressed.connect(func (): self._show_subwindow(9))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Basic Examples/Button".pressed.connect(func (): self._show_subwindow(10))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Settings/Button".pressed.connect(func (): self._show_subwindow(11))
	
func _show_subwindow(subwindow_index: int) -> void:
	print("_show_subwindow: " +  str(subwindow_index))
	for i in subwindows.size():
		if i == subwindow_index:
			subwindows[i].show()
		else:
			subwindows[i].hide()

func _process(delta: float) -> void:
	pass
