tool
extends VisualScriptCustomNode

func _get_caption():
	return "Pause"

func _get_input_value_port_count():
	return 1
	
func _get_input_value_port_name(idx):
	return "value"
	
func _get_input_value_port_type(idx):
	return TYPE_BOOL
	
func _has_input_sequence_port():
	return true

func _get_output_sequence_port_count():
	return 1

func _step(inputs, outputs, start_mode, working_mem):
	var paused = inputs[0]
