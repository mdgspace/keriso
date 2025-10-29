extends Node
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func play_audio(audio:AudioStream, volume_linear: float):
	if audio_stream_player.stream == audio:
		return
	#return if it is the same track
	audio_stream_player.stream = audio
	audio_stream_player.volume_linear = volume_linear
	audio_stream_player.play()
	
func stop_audio():
	audio_stream_player.stop()
	
func play_sfx(sfx_stream: AudioStream, volume_linear: float):
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = sfx_stream
	sfx_player.volume_db = volume_linear
	
	#Assign it to the SFX bus by name
	sfx_player.bus = "SFX"
	add_child(sfx_player)
	sfx_player.play()
	
	await sfx_player.finished
	sfx_player.queue_free() # add temp node and remove after audio is finished(this allows multiple audio to play at once)
	
func set_master_vol(val:float):
		AudioServer.set_bus_volume_linear(0, val) #bw 0 to 1
		
func set_background_vol(val:float):
	var index = AudioServer.get_bus_index("Background")
	AudioServer.set_bus_volume_linear(index,val)
	
func set_SFX_vol(val:float):
	var index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_linear(index,val)
