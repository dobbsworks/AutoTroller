extends Control


signal click_exit()


@onready var volume_music_slider: HSlider = %VolumeMusicSlider
@onready var volume_sfx_slider: HSlider = %VolumeSfxSlider

func _ready() -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(SaveManager.saveData.volumeSfx))
	AudioServer.set_bus_volume_db(2, linear_to_db(SaveManager.saveData.volumeMusic))
	volume_music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	volume_sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))


func _on_volume_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	SaveManager.saveData.volumeMusic = value
	SaveManager.saveGame()


func _on_volume_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	SaveManager.saveData.volumeSfx = value
	SaveManager.saveGame()


func _on_button_exit_pressed() -> void:
	click_exit.emit()
