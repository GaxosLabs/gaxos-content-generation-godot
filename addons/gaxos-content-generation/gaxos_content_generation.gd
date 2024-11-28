@tool
extends Node

signal error(code, status, message)

const CONFIGURATION_FILE : String = "res://addons/gaxos-content-generation/.env"

#var BASE_URL : String = "https://dev.gaxoslabs.ai/api/connect/v1/"
var BASE_URL : String = "https://gaxoslabs.ai/api/connect/v1/";

var _headers : PackedStringArray = [
	"Content-Type: application/json",
	"Accept: application/json",
]

func _ready() -> void:
	var _apiKey = _load_api_key()
	_headers = [
		"Content-Type: application/json",
		"Accept: application/json",
		"Authorization: Bearer " + _apiKey
	]

func _load_api_key() -> String:
	var env = ConfigFile.new()
	var err = env.load(CONFIGURATION_FILE)
	if err == OK:
		var _apiKey = env.get_value("gaxos", "apiKey", "")
		if _apiKey == "":
			_printerr("The value for 'apiKey' is not configured.")
		return _apiKey
	else:
		_printerr("Unable to read .env file at path `%s`" % CONFIGURATION_FILE)
		return ""

func _printerr(error : String) -> void:
	printerr("[Gaxos Error] >> " + error)

func _print(msg : String) -> void:
	print("[Gaxos] >> " + str(msg))

func get_stats() -> Dictionary:
	var request : GaxosRequest = GaxosRequest.new(self)
	var str : String = await request.send_request(
		BASE_URL + "stats", 
		_headers)
	return JSON.parse_string(str)
	
func improve_prompt(prompt: String, generator: String) -> String:
	var request : GaxosRequest = GaxosRequest.new(self)
	var str : String = await request.send_request(
		BASE_URL + "improve-prompt?prompt=" + prompt.uri_encode() + "&generator=" + generator.uri_encode(), 
		_headers)
	return str
	
func request_generation(generator: String, parameters: Dictionary, options: Dictionary = {}, data: Dictionary = {}) -> String:
	var request : GaxosRequest = GaxosRequest.new(self)
	var str : String = await request.send_request(
		BASE_URL + "request", 
		_headers,
		HTTPClient.METHOD_POST, 
		JSON.stringify({
			"generator": generator,
			"generator_parameters": parameters,
			"options": options,
			"data": data
		}))
	return str	
	
func get_requests(limit: int = 100, offset: int = 0, sort_by: String = "", sort_asc : bool = true, filter_by_player_id: String = "", filter_by_asset_type : String = "") -> Array:
	var request : GaxosRequest = GaxosRequest.new(self)
	var url : String = BASE_URL + "request" + _get_query_string(limit, offset, sort_by, sort_asc, filter_by_player_id, filter_by_asset_type)
	var str : String = await request.send_request(
		url, 
		_headers)
	var ret = JSON.parse_string(str)
	if typeof(ret) == TYPE_NIL:
		return []
	return ret
	
func get_published_assets(limit: int = 100, offset: int = 0, sort_by: String = "", sort_asc : bool = true, filter_by_player_id: String = "", filter_by_asset_type : String = "") -> Array:
	var request : GaxosRequest = GaxosRequest.new(self)
	var url : String = BASE_URL + "asset" + _get_query_string(limit, offset, sort_by, sort_asc, filter_by_player_id, filter_by_asset_type)
	var str : String = await request.send_request(
		url, 
		_headers)
	var ret = JSON.parse_string(str)
	if typeof(ret) == TYPE_NIL:
		return []
	return JSON.parse_string(str)
	
func _get_query_string(limit: int, offset: int, sort_by: String, sort_asc : bool, filter_by_player_id: String, filter_by_asset_type : String) -> String:
	var ret : String = "?limit=" + str(limit) + "&offset=" + str(offset)
	if sort_by != "":
		ret += "&sortBy=" + sort_by.uri_encode() + "." + ("asc" if sort_asc else "desc")
	if filter_by_player_id != "":
		ret += "&filter=player_id." + filter_by_player_id
	if filter_by_asset_type != "":
		ret += "&filter=asset_type." + filter_by_asset_type
	return ret

func get_request(id: String) -> Dictionary:
	var request : GaxosRequest = GaxosRequest.new(self)
	var str : String = await request.send_request(
		BASE_URL + "request/" + id.uri_encode(), 
		_headers)
	var ret = JSON.parse_string(str)
	if typeof(ret) == TYPE_NIL:
		return {}
	return ret
	
func get_published_asset(id: String) -> Dictionary:
	var request : GaxosRequest = GaxosRequest.new(self)
	var str : String = await request.send_request(
		BASE_URL + "asset/" + id.uri_encode(), 
		_headers)
	var ret = JSON.parse_string(str)
	if typeof(ret) == TYPE_NIL:
		return {}
	return ret

func delete_request(id: String) -> void:
	var request : GaxosRequest = GaxosRequest.new(self)
	await request.send_request(
		BASE_URL + "request/" + id.uri_encode(), 
		_headers,
		HTTPClient.METHOD_DELETE)

func make_asset_public(request_id: String, asset_id: String, make_it_public: bool):
	var request : GaxosRequest = GaxosRequest.new(self)
	var ret = await request.send_request(
		BASE_URL + "request/" + request_id.uri_encode() + "/" + ("publish" if make_it_public else "publish") + "/" + asset_id.uri_encode(), 
		_headers,
		HTTPClient.METHOD_PATCH)
	print(ret)
