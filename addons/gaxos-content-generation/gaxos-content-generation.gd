@tool
extends EditorPlugin

const MainPanel = preload("res://addons/gaxos-content-generation/window/gcg-window.tscn")
var main_panel_instance: Control

func _enter_tree() -> void:
	add_autoload_singleton("GaxosContentGeneration", "res://addons/gaxos-content-generation/GaxosContentGeneration.tscn")
	
	main_panel_instance = MainPanel.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)
	
#func _open_tool() -> void:
	#if !dock:
		#dock = load("res://addons/gaxos-content-generation/window/gcg-window.tscn").instantiate()
		#add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)

func _exit_tree() -> void:
	remove_autoload_singleton("GaxosContentGeneration")

	if main_panel_instance:
		main_panel_instance.queue_free()
	
func _has_main_screen():
	return true

func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible

func _get_plugin_name():
	return "Gaxos Content Generation"


func _get_plugin_icon():
	return load("res://addons/gaxos-content-generation/window/Gaxos Labs AI Icon.png")
