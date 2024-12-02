@tool
extends Node

func schedule(function: Callable, delaySeconds: float):
	var timer = Timer.new()
	timer.timeout.connect(function)
	timer.timeout.connect(func (): timer.queue_free())
	get_tree().root.add_child(timer)
	timer.start(delaySeconds)
	return timer

func temporarily_disable_button(button: BaseButton):
	button.disabled = true
	var timer = Scheduler.schedule(func (): button.disabled = false, 5)
	return [button, timer]

func enable_button(buttonAndTimer):
	buttonAndTimer[0].disabled = false
	var timer = buttonAndTimer[1]
	timer.stop()
	timer.queue_free()
