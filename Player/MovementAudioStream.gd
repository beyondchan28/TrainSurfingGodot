extends AudioStreamPlayer3D

var last_pitch = 1.0

func play(from_position=0.0):
	randomize()
	self.pitch_scale = rand_range(0.5, 2.0)
	
	while abs(pitch_scale - last_pitch) < 0.1:
		randomize()
		pitch_scale = rand_range(0.5, 2.0)
	
	last_pitch = pitch_scale
	
	.play(from_position)
