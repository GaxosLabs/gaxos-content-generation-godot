@tool
extends HBoxContainer

const CONFIGURATION_FILE : String = "res://addons/gaxos-content-generation/.env"

func _ready() -> void:
	$"TextEdit".text = _load_api_key()
	$"TextEdit".text_changed.connect(_set_api_key)

func _load_api_key() -> String:
	var env = ConfigFile.new()
	var err = env.load(CONFIGURATION_FILE)
	if err == OK:
		var _apiKey = env.get_value("gaxos", "apiKey", "")
		return _apiKey
	else:
		return ""

func _set_api_key() -> void:
	var env = ConfigFile.new()
	var err = env.load(CONFIGURATION_FILE)
	env.set_value("gaxos", "apiKey", $"TextEdit".text)
	env.save(CONFIGURATION_FILE)
