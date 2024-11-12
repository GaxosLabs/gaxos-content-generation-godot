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
			if response_code != 200:
				var request_data_log : String = request_data
				if len(request_data_log) > 400:
					var request_data_dict = JSON.parse_string(request_data)
					request_data_log = "{"
					for key in request_data_dict:
						request_data_log += "\t\"" + key + "\" = "
						var data = JSON.stringify(request_data_dict[key])
						if len(data) > 100:
							request_data_log += "..."
						else:
							request_data_log += data
						request_data_log += ",\n"
					request_data_log += "}"
				printerr(method, " ", url, "\n", custom_headers, "\n\n", request_data_log, "\n\n===============\n",  response_code, "\n", headers, "\n", data)
			task_finished.emit()
			queue_free()
	)
	request(url, custom_headers, method, request_data)
	await task_finished
	return data
