class_name LanguagePicker
extends OptionButton

var languages := {
	"English" : "en_US",
	"Deutsch" : "deu"
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for lang_name in languages.keys():
		add_item(lang_name)
	
	var current_locale := TranslationServer.get_locale()
	for i in range(item_count):
		var lang_name := get_item_text(i)
		if current_locale.begins_with(languages[lang_name]):
			select(i)
			break
	
	item_selected.connect(_on_language_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_language_selected(index : int):
	var lang_name := get_item_text(index)
	var locale = languages[lang_name]
	TranslationServer.set_locale(locale)
	print("Locale set to: ", locale)
