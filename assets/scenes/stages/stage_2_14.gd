extends Stage

var newsFlavor : Array[String] = [
	"Good evening citizens, we've got the most breakingest news for you today... this rambunctious canny little fella over here is causing all sorts of mayhem and mischief... we've got all of our Grade-A guys on him, so rest assured, he will be caught and brought to justice.",
	"Hi everyone this is the news and UGGGGGHHHHH that STUPID DUMB CANNY GUY I HATE him man I HATE him SO MUCH and I have all my pretty fingers crossed I'm really hoping that something bad happens to him maybe I hope I dream a little bit maybe",
	"Uhhhhhh I forgot what I was going to say... uhhhhhh... hmmmmmm... hrmmmmmmmmmmmm... this is awkward........... uh................... uhm............................",
	"This is a test of the Emergency Alert System. This is only a test. The message you are hearing is part of a nationwide, live code test of Emergency Alert System capabilities. This test message has been initiated by national alert and warning authorities. In coordination with Emergency Alert System participants including broadcasts, cable, sattelite, and wire line participants in your area. Had this been an actual emergency, the attention signal you'd just heard would have been followed by emergency information, news, or instructions. This is only a test. We now return you to your regular programming."
]

var scrollspeed := 2.0
var offset
var scrollboundary = 0.0

func _ready():
	super._ready()
	offset = get_parent().get_node("HUD").get_node("HudBG").texture.get_width()
	news_reset()
	color_set()

func _process(delta : float):
	super._process(delta)

func color_set():
	RenderingServer.set_default_clear_color(Color.from_hsv(randf_range(0.0, 1.0), 0.25, 1, 1))
	await get_tree().create_timer(0.5).timeout
	color_set()

func _physics_process(delta : float):
	super._physics_process(delta)
	$News/NewsText.position.x -= scrollspeed
	if $News/NewsText.position.x < scrollboundary:
		news_reset()

func news_reset():
	$News/NewsText.position.x = 800
	$News/NewsText.text = ""
	$News/NewsText.size.x = 0
	$News/NewsText.text = newsFlavor.pick_random()
	await get_tree().create_timer(0.1).timeout
	scrollboundary = offset - $News/NewsText.size.x
