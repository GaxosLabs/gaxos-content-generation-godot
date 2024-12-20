@tool
extends VBoxContainer

signal refreshing
signal refreshed(stats)

func _ready() -> void:
	$Refresh.pressed.connect(refresh)
	
func refresh() -> void:
	var b = Scheduler.temporarily_disable_button($Refresh)
	refreshing.emit()
	$"Credits Container/TextEdit".text = "..."
	$"Storage Container/TextEdit".text = "..."
	$"Requests Container/TextEdit".text = "..."
	var stats = await GaxosContentGeneration.get_stats()
	$"Credits Container/TextEdit".text = str(stats["credits"]["total"] - stats["credits"]["used"]) + " / " + str(stats["credits"]["total"])
	$"Storage Container/TextEdit".text = str(stats["storage"]["total"] - stats["storage"]["used"]) + " / " + str(stats["storage"]["total"])
	$"Requests Container/TextEdit".text = str(stats["requests"]["total"] - stats["requests"]["used"]) + " / " + str(stats["requests"]["total"])
	refreshed.emit(stats)
	Scheduler.enable_button(b)
