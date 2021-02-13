extends Resource
class_name CitizenAI

# The 3 faculties of Citizens:
# Goals, Targets, Focuses

# Conman can see goals in some kind of cryptic form, on top of being more able to plant goals himself.
# Pickpocket can see focuses and targets, on top of being better at shifting targets ( i guess, this needs fleshing out )
# Housebreaker cant see any of this stuff, but can deal with combat magic and stuff

# Goals generate focuses
# Goals + attention events turn focuses into targets
# Completed targets fulfill goals.
# Goals can fullfill other goals
# All citizens have at least 1 core goal, with other goals supporting it, although goals can be distracted

# Goals: The most amorphous and high level of the 3 faculties. Should never include anything that has an obvious action that could completely fulfill it. 
# Core goals should never really be completley fulfilled, instead ebbing around orders of importances as targets get ticked off. 
# Goals contain information, context, and proceedures on how to generate focuses and targets.
#
# Targets: Defines a set of actions a citizen can enter to act out one part of a goal. Essencially an AI state. 
# Targets can be fullfilled, or abandoned, depending on target importance. Either way, it effects the status of its respective goal
#
# Focuses: All focuses are just referencees to objects/nodes, with perhaps superficial information about which goal it regards. 
# The most objective of the 3. No information regarding fulfillment whatsoever. Represents vision.
#
# Example: Shopkeeper
#Goals: Curiosity, Handle Customers, Prevent theft ...
#Targets: Check Chest, Check other citizen, Chase you down, Shoo away hockey kids, Converse with guards...
#Focuses: Chests, Customers (Player), Storage crates, hockey kids, explosion, random ass street band...
#
var citizen:Node

#export(Array) var goals = []
#export(int) var max_goals = 4
#
#export(Array) var targets = []
#export(int) var max_targets = 4
#
#export(Array) var focuses = []
#export(int) var max_focuses = 10
var goals = []
var max_goals = 4

var targets = []
var max_targets = 4

var focuses = []
var max_focuses = 6
onready var CitizenGoalClass = load("res://entities/citizens/shared_ai/citizen_goal.gd")

var active_target: CitizenTarget

func _ready():
	pass
	
func init(_citizen: Node,_goals:Array):
	if !CitizenGoalClass:
		CitizenGoalClass = load("res://entities/citizens/shared_ai/citizen_goal.gd")
	citizen = _citizen
	for goal in _goals:
		assert(goal is CitizenGoalClass)
		goal.init(self)
	goals= _goals
	
func object_attended(obj:Node):
	for focus in focuses:
		if focus.object == obj:
			return focus
	return null
	
func on_object_attend(obj:Node,attention_event): # obj:Node, attention_event:AttentionEvent
	var in_focus := false
	for focus in focuses:
		if focus.object == obj:
			focus.on_attention_event(attention_event)
			in_focus = true
			var in_target:= false
			for target in targets:
				if target.focus == focus:
					target.on_attention_event(attention_event)
					in_target = true
			if not in_target:
				var new_target = focus.goal.focused_event_to_target(focus,attention_event)
				if new_target:
					print("NEW TARGET MADE")
					add_target(new_target)
				
		
	if not in_focus:
		for goal in goals:
#			print("Creating new focus")
			var new_focus = goal.node_to_focus(attention_event.subject,attention_event)
			if new_focus:
				new_focus.goal = goal
				new_focus.ai = self
				new_focus.object.connect("attention_event",self,"_on_attention_event")
				new_focus.on_add()
				focuses.append(new_focus)
#				new_focus.on_attention_event(attention_event)
#				var new_target =  goal.focused_event_to_target(new_focus,attention_event)
#				if new_target:
#					new_target.ai = self
#					add_target(new_target)
			sort_focuses()
			if focuses.size()>max_focuses:
				focuses = focuses.slice(0,max_focuses-1)

func sort_focuses():
	focuses.sort_custom(PrioritiesSorter,"sort_focus_salience")

func on_physics_process(delta):
	if active_target:
		active_target.on_physics_process(delta)
	pass
	
func on_process(delta):
	if active_target:
		active_target.on_process(delta)
	pass


func _on_attention_event(data):
#	assert(data is AttentionEvent)
	print("attention event trigger")
	on_object_attend(data.subject,data)
	
func focused_objs():
	var foc_objs := []
	for focus in focuses:
		foc_objs.append(focus.object)
	return foc_objs

func add_target(targ):# :CitizenTarget
	targ.ai = self
	if targets.size()==0:
		targets.append(targ)
		active_target = targ
		active_target.on_activate()
	else:
		var index = _insert_target(targ)
		var active_target_index = targets.find(active_target)
		if index<active_target_index:
			active_target.replace_with(targ)
		if targets.size()>max_targets:
			for i in range(max_targets,targets.size()-1):
				if targets[i] == active_target:
					active_target.kill_with(null)
			targets = targets.slice(0,max_targets-1)
			
func _insert_target(targ): #:CitizenTarget
	for ind in range(targets.size()):
		if targ.prominence>targets[ind].prominence:
			targets.insert(ind,targ)
			return ind
	targets.append(targ)
	return targets.size()-1
	
func sort_targets():
	targets.sort_custom(PrioritiesSorter,"sort_target_prominence")
	if targets.size()>0:
		if active_target != targets[0]:
			active_target.replace_with(targets[0])

func erase_target(targ): # :CitizenTarget
	if targ in targets:
		if targ == active_target:
			targets.erase(targ)
			if targets.size()>0:
				active_target = targets[0]
				active_target.on_activate()
			else:
				active_target=null
		else:
			targets.erase(targ)
func pass_target(targ):
	if targ == active_target:
		if targets.size()>0:
			active_target = targets[0]
			active_target.on_activate()
		else:
			active_target=null
	
func goal_process(delta):
	for goal in goals:
		goal.goal_process(delta)			

class PrioritiesSorter:
	static func sort_focus_salience(a,b):
		return b.salience< a.salience
	static func sort_target_prominence(a,b):
		return b.prominence< a.prominence

