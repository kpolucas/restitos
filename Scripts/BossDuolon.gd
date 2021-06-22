extends KinematicBody2D

var health = 100

var actions = ["gancho","kick","sweep","mirror","explosion"]
var lastAttack
var nextAttack
var rng = RandomNumberGenerator.new()
onready var Player = get_node("/root/Main/World/Player")
onready var animationTree = $AnimationTree.get("parameters/playback")
onready var currentAnimation


func _ready():
	rng.randomize()


func _process(delta):
	var currentAnimation = animationTree.get_current_node()	
	
	match currentAnimation:
		'dying':
			pass
		'intro':
			pass
		'idle':
			if $IdleTimer.is_stopped():
				#$IdleTimer.start(rng.randi_range(2,4))
				$IdleTimer.start(rng.randi_range(1,1))
		'teleportOut':
			pass
		'teleportIn':
			pass
		'gancho':
			pass
		'kick':
			pass
		'sweep':
			pass
		'mirror':
			pass
		'explosion':
			pass
		'stunned':
			pass
	# ANY state
	if health <= 0:
		pass

	
func set_next_attack_position(): # se dispara desde animationPlayer teleportOut+explosion
	var newPosition
	
	if actions[0] == "mirror":
		newPosition = Vector2(100,self.get_position().y) # armar la logica mirror desp
	else:
		var _playerPos = Player.get_position().x	
		var offSet = rng.randf_range(-55.0, 55.0)
		newPosition = Vector2(_playerPos + offSet , self.get_position().y)
		$Sprite.scale.x = -1 if offSet < 0 else 1
	self.set_position(newPosition) 


func _on_IdleTimer_timeout():
	actions.shuffle()
	lastAttack = nextAttack
	nextAttack = actions[0]
	animationTree.travel(nextAttack)
	
