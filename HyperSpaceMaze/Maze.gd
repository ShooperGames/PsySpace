extends Node2D


var hWalls = []
var vWalls = []
var cells = []
export var sight = 1# At some point this will be based on character skill
var rng = RandomNumberGenerator.new()
export var mazeDem = 10#Pass in a value for this for 'difficulty'
var hsmomentum
# Called when the node enters the scene tree for the first time.
func _ready():
	sight = Global.player.skills['Sight']
	mazeDem = Global.hsd
	hsmomentum = Global.hsm
	$TileMap/Ship/MomLab.text = hsmomentum as String
	rng.randomize()
	var wallCounter = 0
	var cellCounter = 0
	var randWall
	var hWall
	var walli
	var wallj
	var fromCell
	var toCell
	for i in range(mazeDem-1):
		hWalls.append([])
		for _j in range(mazeDem):
			hWalls[i].append(-1)
			wallCounter += 1
	for i in range(mazeDem):
		vWalls.append([])
		cells.append([])
		for _j in range(mazeDem-1):
			vWalls[i].append(-1)
			wallCounter += 1
			cells[i].append(cellCounter)
			cellCounter += 1
		cells[i].append(cellCounter)
		cellCounter += 1
	while wallCounter > 0:
		randWall = rng.randi_range(1, wallCounter)
		for i in range(mazeDem-1):
			for j in range(mazeDem):
				if not hWalls[i][j] is bool:
					randWall -= 1
					if randWall == 0:
						hWall = true
						walli = i
						wallj = j
						break
				if not vWalls[j][i] is bool:
					randWall -= 1
					if randWall == 0:
						hWall = false
						walli = j
						wallj = i
						break
			if randWall == 0:
				break
		if hWall:
			if cells[wallj][walli] == cells[wallj][walli+1]:
				hWalls[walli][wallj] = true
			else:
				hWalls[walli][wallj] = false
				toCell = cells[wallj][walli]
				fromCell = cells[wallj][walli+1]
				for i in range(mazeDem):
					for j in range(mazeDem):
						if cells[i][j] == fromCell:
							cells[i][j] = toCell
		elif cells[wallj][walli] == cells[wallj+1][walli]:
			vWalls[walli][wallj] = true
		else:
			vWalls[walli][wallj] = false
			toCell = cells[wallj][walli]
			fromCell = cells[wallj+1][walli]
			for i in range(mazeDem):
				for j in range(mazeDem):
					if cells[i][j] == fromCell:
						cells[i][j] = toCell
		wallCounter -= 1
	$TileMap.clear()
	var up
	var down
	var left
	var right
	for x in range(mazeDem):
		for y in range(mazeDem):
			up = y == 0 or hWalls[y-1][x]
			down = y == mazeDem-1 or hWalls[y][x]
			left = x == 0 or vWalls[y][x-1]
			right = x == mazeDem-1 or vWalls[y][x]
			if up:
				if down:
					if left:
						cells[x][y] = 0
					elif right:
						cells[x][y] = 3
					else:
						cells[x][y] = 9
				elif left:
					if right:
						cells[x][y] = 1
					else:
						cells[x][y] = 4
				elif right:
					cells[x][y] = 7
				else:
					cells[x][y] = 13
			elif down:
				if left:
					if right:
						cells[x][y] = 2
					else:
						cells[x][y] = 5
				elif right:
					cells[x][y] = 6
				else:
					cells[x][y] = 14
			elif left:
				if right:
					cells[x][y] = 8
				else:
					cells[x][y] = 12
			elif right:
				cells[x][y] = 15
			else:
				cells[x][y] = 10
			if abs($TileMap/Ship.loc.x - x) <= sight and abs($TileMap/Ship.loc.y - y) <= sight:
				$TileMap.set_cell(x,y,cells[x][y])
			else: #maybe extend sight by an extra square, but make it unreliable? e.g. grey and 50% chance of being wrong.
				$TileMap.set_cell(x,y,11)

func reDraw(): #pass in x and y, and make this smarter
	hsmomentum -= 1
	if hsmomentum <= 0:
		get_tree().change_scene("res://TestMenu.tscn")
		Global.hsm = hsmomentum
	if $TileMap/Ship.loc.x == 4 and $TileMap/Ship.loc.y == 4:
		get_tree().change_scene("res://TestMenu.tscn")
		Global.hsm = hsmomentum
	for x in range(mazeDem):
		for y in range(mazeDem):
			if $TileMap.get_cell(x,y) == 11 and abs($TileMap/Ship.loc.x - x) <= sight and abs($TileMap/Ship.loc.y - y) <= sight:
				$TileMap.set_cell(x,y,cells[x][y])
	$TileMap/Ship/MomLab.text = hsmomentum as String
	$TileMap/Ship.position.x = $TileMap/Ship.loc.x * 64 + 12
	$TileMap/Ship.position.y = $TileMap/Ship.loc.y * 64 + 12

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_left") and $TileMap/Ship.loc.x > 0 and not vWalls[$TileMap/Ship.loc.y][$TileMap/Ship.loc.x - 1]:
		$TileMap/Ship.loc.x -= 1
		$TileMap/Ship/TextureRect.set_texture($TileMap/Ship.rightTexture)
		$TileMap/Ship/TextureRect.flip_h = true
		$TileMap/Ship/MomLab.rect_position = Vector2(15, 0)
		$TileMap/Ship/MomLab.rect_size = Vector2(17, 40)
		reDraw()
	if Input.is_action_just_pressed("ui_right") and $TileMap/Ship.loc.x < mazeDem-1 and not vWalls[$TileMap/Ship.loc.y][$TileMap/Ship.loc.x]:
		$TileMap/Ship.loc.x += 1
		$TileMap/Ship/TextureRect.set_texture($TileMap/Ship.rightTexture)
		$TileMap/Ship/TextureRect.flip_h = false
		$TileMap/Ship/MomLab.rect_position = Vector2(7, 0)
		$TileMap/Ship/MomLab.rect_size = Vector2(17, 40)
		reDraw()
	if Input.is_action_just_pressed("ui_up") and $TileMap/Ship.loc.y > 0 and not hWalls[$TileMap/Ship.loc.y - 1][$TileMap/Ship.loc.x]:
		$TileMap/Ship.loc.y -= 1
		$TileMap/Ship/TextureRect.set_texture($TileMap/Ship.upTexture)
		$TileMap/Ship/TextureRect.flip_v = false
		$TileMap/Ship/MomLab.rect_position = Vector2(0, 17)
		$TileMap/Ship/MomLab.rect_size = Vector2(40, 14)
		reDraw()
	if Input.is_action_just_pressed("ui_down") and $TileMap/Ship.loc.y < mazeDem-1 and not hWalls[$TileMap/Ship.loc.y][$TileMap/Ship.loc.x]:
		$TileMap/Ship.loc.y += 1
		$TileMap/Ship/TextureRect.set_texture($TileMap/Ship.upTexture)
		$TileMap/Ship/TextureRect.flip_v = true
		$TileMap/Ship/MomLab.rect_position = Vector2(0, 9)
		$TileMap/Ship/MomLab.rect_size = Vector2(40, 14)
		reDraw()
