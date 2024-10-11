@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("GaxosContentGeneration", "res://addons/gaxos-content-generation/GaxosContentGeneration.tscn")

func _exit_tree() -> void:
	remove_autoload_singleton("GaxosContentGeneration")
