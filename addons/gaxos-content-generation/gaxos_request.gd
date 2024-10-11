@tool
class_name GaxosRequest
extends HTTPRequest

var data: String
var parent: Node

func _init(parent: Node):
	self.parent = parent
	parent.add_child(self)
	
signal task_finished()

func send_request(url: String, custom_headers: PackedStringArray = PackedStringArray(), method: HTTPClient.Method = 0, request_data: String = ""):
	request_completed.connect(
		func(result, response_code, headers, body): 
			data = body.get_string_from_utf8()	
			task_finished.emit()
			queue_free()
	)
	request(url, custom_headers, method, request_data)
	await task_finished
	return data
