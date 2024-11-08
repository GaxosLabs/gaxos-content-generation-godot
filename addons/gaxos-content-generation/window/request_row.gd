@tool
extends HBoxContainer

func initialize(request: Dictionary, onClick: Callable):
	$Id.text = str(request["id"])
	$Generator.text = str(request["generator"])
	$Created.text = Time.get_datetime_string_from_unix_time(request["created_at"])
	var completedAt = request["completed_at"]
	if completedAt > 0:
		$Completed.text = Time.get_datetime_string_from_unix_time(completedAt)
		$"Time taken".text = str(request["completed_at"] - request["created_at"]) + " seconds"
	else:
		$Completed.text = "---"
		$"Time taken".text = str(Time.get_unix_time_from_system() - request["created_at"]) + " seconds"
	$Cost.text = str(request["deducted_credits"])
	$Status.text = str(request["status"])
	
	$Id.pressed.connect(onClick)
	$Generator.pressed.connect(onClick)
	$Created.pressed.connect(onClick)
	$Completed.pressed.connect(onClick)
	$"Time taken".pressed.connect(onClick)
	$Cost.pressed.connect(onClick)
	$Status.pressed.connect(onClick)