extends Node
var player : CharacterBody2D
var camera : Camera2D
var UI : Control
var paused : bool = false
var boss :CharacterBody2D
var Options :Dictionary = {
	"showCursor": true,
	"hold2fire": true
	
}
