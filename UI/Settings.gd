extends Popup

var music_volume = -3 setget set_music_volume
var sfx_volume = -3 setget set_sfx_volume
var fullscreen = false setget set_fullscreen
var music_mute = false setget set_music_mute
var sfx_mute = false setget set_sfx_mute

onready var music_slider = $Panel/MarginContainer/VSplitContainer/GridContainer/MusSlider
onready var sfx_slider = $Panel/MarginContainer/VSplitContainer/GridContainer/SFXSlider
onready var music_mute_button = $Panel/MarginContainer/VSplitContainer/GridContainer/MuteMusButton
onready var sfx_mute_button = $Panel/MarginContainer/VSplitContainer/GridContainer/MuteSFXButton
onready var fullscreen_button = $Panel/MarginContainer/VSplitContainer/GridContainer/FSBox

var config = ConfigFile.new()
const CONFIG_FILE = "user://twinstick.cfg"

var settings = {
	"audio":
		{"MusicVolume": null, "SFXVolume": null, "MuteMusic": null, "MuteSFX": null},
	"video":
		{"FullScreen": null}
}

var default_settings = {
	"audio":
		{"MusicVolume": -3, "SFXVolume": -3, "MuteMusic": false, "MuteSFX": false},
	"video":
		{"FullScreen": false}
}

func _ready():
	load_settings()
	
	music_volume = settings["audio"]["MusicVolume"]
	sfx_volume = settings["audio"]["SFXVolume"]
	fullscreen = settings["video"]["FullScreen"]
	music_mute = settings["audio"]["MuteMusic"]
	sfx_mute = settings["audio"]["MuteSFX"]
	
	if not music_mute and not MusicPlayer.playing:
		MusicPlayer.play()
	
	get_tree().call_group("UI", "Update_UI")


func load_settings():
	var error = config.load(CONFIG_FILE)
	if error != OK:
		make_default_config()
	
	for section in settings.keys():
		for key in settings[section]:
			settings[section][key] = config.get_value(section, key, default_settings[section][key])

func make_default_config():
	config.save(CONFIG_FILE)

func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
	config.save(CONFIG_FILE)

func Update_UI():
	music_slider.value = music_volume
	sfx_slider.value = sfx_volume
	music_mute_button.pressed = music_mute
	sfx_mute_button.pressed = sfx_mute
	fullscreen_button.pressed = fullscreen

func _on_MusSlider_value_changed(value):
	set_music_volume(value)

func _on_SFXSlider_value_changed(value):
	set_sfx_volume(value)

func _on_MuteMusButton_toggled(button_pressed):
	set_music_mute(button_pressed)

func _on_MuteSFXButton_toggled(button_pressed):
	set_sfx_mute(button_pressed)

func _on_FSBox_toggled(button_pressed):
	set_fullscreen(button_pressed)

func set_music_volume(vol):
	music_volume = vol
	AudioServer.set_bus_volume_db(1, vol)
	settings["audio"]["MusicVolume"] = vol
	save_settings()

func set_sfx_volume(vol):
	sfx_volume = vol
	AudioServer.set_bus_volume_db(2, vol)
	settings["audio"]["SFXVolume"] = vol
	save_settings()

func set_fullscreen(fs):
	fullscreen = fs
	OS.window_fullscreen = fs
	settings["video"]["FullScreen"] = fs
	save_settings()

func set_music_mute(mute):
	music_mute = mute
	if mute:
		MusicPlayer.stop()
	elif not MusicPlayer.is_playing():
		MusicPlayer.play()
	settings["audio"]["MuteMusic"] = mute
	save_settings()
		

func set_sfx_mute(mute):
	sfx_mute = mute
	
	AudioServer.set_bus_mute(2, mute)
	
	settings["audio"]["MuteSFX"] = mute
	save_settings()

func _on_OKButton_pressed():
	unpause()


func _on_QuitButton_pressed():
	get_tree().quit()

func _unhandled_input(event):
	if event.is_action_pressed("pause") && get_tree().paused:
		unpause()
		get_tree().set_input_as_handled()
		

func unpause():
	if get_tree().paused:
		get_tree().paused = false
	self.hide()
		
