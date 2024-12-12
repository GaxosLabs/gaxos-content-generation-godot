@tool
extends Control

var subwindows: Array[Control]

func _enter_tree() -> void:
	subwindows = [
		$Root/Gaxos, $"Root/Dall-E", $"Root/Stability AI", $"Root/Meshy",
		$"Root/Eleven Labs", 
		$"Root/Multiple Text To Image", $"Root/Multiple Masking",
		$"Root/Requests List", $"Root/Requests List",
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
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Content/Generators/ElevenLabs".pressed.connect(func (): self._show_subwindow(5))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Multiple Content/Generators/Multi Text To Image".pressed.connect(func (): self._show_subwindow(6))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Generate Multiple Content/Generators/Multi Masking".pressed.connect(func (): self._show_subwindow(7))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Requests List/Button".pressed.connect(func (): self._show_subwindow(8))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Basic Examples/Button".pressed.connect(func (): self._show_subwindow(9))
	$"Root/SideMenu/SideMenuScroll/SideMenu/Settings/Button".pressed.connect(func (): self._show_subwindow(10))
	
	$"Root/SideMenu/SideMenuScroll/SideMenu/Credits/Credits container/Refresh".pressed.connect(func (): $Root/Configuration/Contents.refresh())
	$Root/Configuration/Contents.refreshing.connect(_refresingStats)
	$Root/Configuration/Contents.refreshed.connect(_statsRefreshed)

	$Root/Configuration/Contents.refresh()
	
	$"Root/Basic Examples/TabContainer/Image To Image".generated.connect(_refreshList)
	$"Root/Basic Examples/TabContainer/Text To Image".generated.connect(_refreshList)
	$"Root/Basic Examples/TabContainer/Masking".generated.connect(_refreshList)

var disabledButton
	
func _refresingStats() -> void:
	disabledButton = Scheduler.temporarily_disable_button($"Root/SideMenu/SideMenuScroll/SideMenu/Credits/Credits container/Refresh")
	$"Root/SideMenu/SideMenuScroll/SideMenu/Credits/Credits container/Credits Text Box".text = "..."
	
func _statsRefreshed(stats: Dictionary) -> void:
	Scheduler.enable_button(disabledButton)
	$"Root/SideMenu/SideMenuScroll/SideMenu/Credits/Credits container/Credits Text Box".text = "%.2f / %.2f" % [(stats["credits"]["total"] - stats["credits"]["used"]), (stats["credits"]["total"])]

func _refreshList() -> void:
	$"Root/Requests List".refresh()

func _show_subwindow(subwindow_index: int) -> void:
	for i in subwindows.size():
		if i == subwindow_index:
			subwindows[i].show()
		else:
			subwindows[i].hide()
