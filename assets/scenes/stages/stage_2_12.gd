extends Stage

var newsFlavor : Array[String] = [
	"Good evening citizens, we've got the most breakingest news for you today... this rambunctious canny little fella over here is causing all sorts of mayhem and mischief... we've got all of our Grade-A guys on him, so rest assured, he will be caught and brought to justice.",
	"Hi everyone this is the news and UGGGGGHHHHH that STUPID DUMB CANNY GUY I HATE him man I HATE him SO MUCH and I have all my pretty fingers crossed I'm really hoping that something bad happens to him maybe I hope I dream a little bit maybe",
	"Uhhhhhh I forgot what I was going to say... uhhhhhh... hmmmmmm... hrmmmmmmmmmmmm... this is awkward........... uh................... uhm............................",
	"This is a test of the Emergency Alert System. This is only a test. The message you are hearing is part of a nationwide, live code test of Emergency Alert System capabilities. This test message has been initiated by national alert and warning authorities. In coordination with Emergency Alert System participants including broadcasts, cable, sattelite, and wire line participants in your area. Had this been an actual emergency, the attention signal you'd just heard would have been followed by emergency information, news, or instructions. This is only a test. We now return you to your regular programming.",
	"The FitnessGram™ Pacer Test is a multistage aerobic capacity test that progressively gets more difficult as it continues. The 20 meter pacer test will begin in 30 seconds. Line up at the start. The running speed starts slowly, but gets faster each minute after you hear this signal. [beep] A single lap should be completed each time you hear this sound. [ding] Remember to run in a straight line, and run as long as possible. The second time you fail to complete a lap before the sound, your test is over. The test will begin on the word start. On your mark, get ready, start.",
	"This is the uncanny transformation text",
	"Hi! Hello! You there! Have YOU ever wanted to watch movies in the comfort of your own home... without paying any money! Well, boy oh boy, do we have the solution for you! Go to freemovies.com to download all of your favorite blockbusters with NO CHARGE! No difficulty, no hassle, and no strings attached! It's truly uncanny how easy it is",
	"Uncanny Cat News would like to take a moment to talk about our sponsor... me! I am the sponsor! I funded this news network with my own blood, sweat, and tears... with a pinch of blood, sweat, and tears of others for good measure! Do not check my closet btw there is nothing in there at all",
	"PEANUT BUTTER COOKIES - Ingredients: 1 cup butter, 1 cup white sugar, 1 cup brown sugar, 2 eggs, 3 1/4 cup flour, 2 tsp baking soda, 1/4 tsp salt, 1 tsp vanilla, 1 cup peanut butter. Directions: Mix all ingredients until smooth. Chill. Heat oven to 350 degrees Fahrenheit. Roll into balls, place on cookie sheet, and flatten gently with fork. Bake until browned.",
	"I can........ SMELL you....... through you're .... COMPUTER SCREEN........ yeesh.... you smell, REAL bad, buddy. It's very nearly uncanny, please take a shower immediately",
	"In the event that a swarm of babies rapidly approaches your locations, please review the safety guidelines to ensure that you and your loved ones are completely and totally safe. Firstly, barricade all of your doors and windows. Secondly, leave all of the milk and diapers outside of your home, so as to not activate the primal rage of the babies. Oh. Oh no. The diapers. I left the diapers in my bedroom. Oh NO OH GOD I CAN HEAR THEM BREAKING IN AHHHHHHBHJGHDFJDGDKFJGDFBGDFKBGSDNFSD",
	"Hello everybody, my name is Canniplier and welcome to Uncanny Cat Golf... this game blows. This game is badf and sucky. Wgh",
	"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
	"Studies show that cats, if called cars, get sentenced to hell immediately.",
	"There are bugs in your skin There are bugs in your skin There are bugs in your skin There are bugs in your skin There are bugs in your skin There are bugs in your skin There are bugs in your skin",
	"Bruh"
]

var scrollspeed := 2.0
var offset
var scrollboundary = 0.0

func _ready():
	super._ready()
	offset = get_parent().get_node("HUD").get_node("HudBG").texture.get_width()
	news_reset()

func _process(delta : float):
	super._process(delta)

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
	

