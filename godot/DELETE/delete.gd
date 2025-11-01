extends Node

func _ready() -> void:
	var tree = $AnimationTree
	for path in tree.tree_root.get_node_paths():
		var node = tree.tree_root.get_node(path)
		if node is AnimationNodeAnimation:
			if not $AnimationPlayer.has_animation(node.animation):
				print("Broken reference in", path, " -> ", node.animation)
