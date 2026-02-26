extends Control

@onready var q_label: Label = $Panel/QuestionLabel
@onready var hint: Label = $Panel/HintLabel
@onready var btns := [
	$Panel/AnswersBox/Ans0,
	$Panel/AnswersBox/Ans1,
	$Panel/AnswersBox/Ans2,
	$Panel/AnswersBox/Ans3,
]

var total_questions := 5
var current_question := 0
var correct_count := 0

var _current_gate: Node = null
var _current_teacher := ""
var _current_q := {}
var _lock_input := false

# ✅ เก็บ index ของคำถามที่ถูกถามไปแล้ว เพื่อไม่ให้ซ้ำในรอบเดียว
var asked_indices: Array[int] = []

var bank := {
	"math": [
		{"q":"2+5 = ?", "a":["6","7","8","9"], "c":1},
		{"q":"10/2 = ?", "a":["2","4","5","8"], "c":2},
		{"q":"9-3 = ?", "a":["5","6","7","8"], "c":1},
		{"q":"3×4 = ?", "a":["7","10","12","14"], "c":2},
		{"q":"15-8 = ?", "a":["5","6","7","8"], "c":2},
	],
	"science": [
		{"q":"น้ำเดือดที่กี่องศา (°C)?", "a":["50","80","100","120"], "c":2},
		{"q":"พืชใช้แก๊สอะไรในการสังเคราะห์แสง?", "a":["O2","CO2","N2","H2"], "c":1},
		{"q":"โลกมีดาวบริวารชื่ออะไร?", "a":["ไททัน","ดวงจันทร์","ยูโรปา","ไอโอ"], "c":1},
		{"q":"อวัยวะที่ใช้หายใจหลักของคนคือ?", "a":["หัวใจ","ปอด","ตับ","ไต"], "c":1},
		{"q":"สิ่งมีชีวิตต้องการอะไรเพื่อมีพลังงาน?", "a":["อาหาร","หิน","โลหะ","พลาสติก"], "c":0},
	],
}

func _ready() -> void:
	randomize() # ✅ ให้การสุ่มไม่ซ้ำรูปแบบเดิมทุกครั้งที่เปิดเกม
	for i in range(4):
		btns[i].pressed.connect(func(): _choose(i))

func start_quiz(teacher_id: String, gate_node: Node) -> void:
	_current_teacher = teacher_id
	_current_gate = gate_node

	current_question = 0
	correct_count = 0
	_lock_input = false
	asked_indices.clear() # ✅ เคลียร์รายการที่ถามไปแล้วตอนเริ่มรอบใหม่

	hint.text = "ตอบให้ถูกอย่างน้อย 3 จาก 5 ข้อ"
	_pick_question()
	_show(true)

func _pick_question() -> void:
	hint.text = "ข้อที่ %d / %d" % [current_question + 1, total_questions]

	var list: Array = bank.get(_current_teacher, [])
	# ✅ กันพลาด ถ้าคำถามในวิชานั้นมีน้อยกว่า total_questions
	if list.size() < total_questions:
		hint.text = "⚠ วิชา %s มีคำถาม %d ข้อ ต้องมีอย่างน้อย %d ข้อ" % [_current_teacher, list.size(), total_questions]
		# ปิดปุ่มกันกดต่อ (กัน error)
		for b in btns:
			b.disabled = true
		return

	# ✅ สุ่มแบบไม่ซ้ำในรอบเดียว
	var q_idx := randi() % list.size()
	while asked_indices.has(q_idx):
		q_idx = randi() % list.size()

	asked_indices.append(q_idx)
	_current_q = list[q_idx]

	q_label.text = _current_q["q"]
	var answers: Array = _current_q["a"]
	for i in range(4):
		btns[i].text = answers[i]
		btns[i].disabled = false

func _choose(idx: int) -> void:
	if _lock_input:
		return

	_lock_input = true
	for b in btns:
		b.disabled = true

	if idx == int(_current_q["c"]):
		correct_count += 1
		hint.text = "✅ ถูก! (%d/%d)" % [correct_count, current_question + 1]
	else:
		hint.text = "❌ ผิด! (%d/%d)" % [correct_count, current_question + 1]

	await get_tree().create_timer(0.8).timeout

	current_question += 1

	# ถ้าครบ 5 ข้อแล้ว → ตรวจผ่าน/ไม่ผ่าน
	if current_question >= total_questions:
		_check_pass()
	else:
		_lock_input = false
		_pick_question()

func _check_pass() -> void:
	if correct_count >= 3:
		hint.text = "🎉 ผ่านแล้ว! (%d/5)" % correct_count
		if _current_gate and _current_gate.has_method("unlock"):
			_current_gate.unlock()
		await get_tree().create_timer(1.0).timeout
		_show(false)
	else:
		hint.text = "❌ ไม่ผ่าน (%d/5) ต้องถูกอย่างน้อย 3 ข้อ" % correct_count
		await get_tree().create_timer(1.2).timeout
		current_question = 0
		correct_count = 0
		_lock_input = false
		asked_indices.clear() # ✅ รีเซ็ตไม่ให้ติดค้าง
		_pick_question()

func _show(v: bool) -> void:
	visible = v
	get_tree().paused = v
