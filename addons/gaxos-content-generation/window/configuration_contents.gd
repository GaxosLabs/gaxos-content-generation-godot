@tool
extends VBoxContainer

signal refreshing
signal refreshed(stats)

func _ready() -> void:
	$Refresh.pressed.connect(refresh)
	
func refresh() -> void:
	$Refresh.disabled = true
	refreshing.emit()
	var stats = await GaxosContentGeneration.get_stats()
	$"Credits Container/TextEdit".text = str(stats["credits"]["total"] - stats["credits"]["used"]) + " / " + str(stats["credits"]["total"])
	$"Storage Container/TextEdit".text = str(stats["storage"]["total"] - stats["storage"]["used"]) + " / " + str(stats["storage"]["total"])
	$"Requests Container/TextEdit".text = str(stats["requests"]["total"] - stats["requests"]["used"]) + " / " + str(stats["requests"]["total"])
	refreshed.emit(stats)
	$Refresh.disabled = false
