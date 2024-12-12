@tool
extends Node

func schedule(scheduledFunction: Callable, delaySeconds: float):
	var tree = get_tree()
	if tree == null: 
		scheduledFunction.call()
		return null

	var timer = Timer.new()
	timer.timeout.connect(scheduledFunction)
	timer.timeout.connect(func (): timer.queue_free())
	get_tree().root.add_child(timer)
	timer.start(delaySeconds)
	return timer

func temporarily_disable_button(button: BaseButton):
	button.disabled = true
	var timer = self.schedule(func (): button.disabled = false, 5)
	return [button, timer]

func enable_button(buttonAndTimer):
	if buttonAndTimer == null:
		return
	buttonAndTimer[0].disabled = false
	var timer = buttonAndTimer[1]
	timer.stop()
	timer.queue_free()
