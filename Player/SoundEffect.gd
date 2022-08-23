extends AudioStreamPlayer

const notice_sound = preload("res://Sound Audio/WarningSound.wav")
const dead_sound = preload("res://Sound Audio/AlarmOnWatch.wav")

func sound_dead():
	self.set_stream(dead_sound)
	self.play(0.0)

func sound_notice():
	self.set_stream(notice_sound)
	self.play(0.0)


func _on_SoundEffect_finished():
	if self.get_stream() == dead_sound:
		self.play()


