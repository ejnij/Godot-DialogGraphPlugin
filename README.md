# [![Plugin icon](/addons/dialog_graph/icon.png)](https://github.com/ejnij/Godot-DialogGraphPlugin) Dialog Graph Plugin for Godot
I needed an easy way to create dialogs for my game. What I needed wasn't that complex, but I did a bit extra for future-proofing.
This is the result - a simple plugin that lets you create dialog graphs.

*Note: This plugin doesn't provide any functionality to display the dialog in-game. This is something you should do yourself!
       I might add some basic example for reference if need be.

## Installation
1) Place the 'addons' folder in your project folder.
2) In the editor - Project -> Project Settings -> Plugins -> Change the status to 'Active'.

*Note: the Graph Editor is on the bottom of Godot's editor, next to the Animation tab. It appears when a Manager node is selected.

## Usage
The plugin has two parts, the editor and the manager, but before that is explained, lets go over the different nodes.
### Dialog Nodes
[![Nodes](/nodes.png)](https://raw.githubusercontent.com/ejnij/Godot-DialogGraphPlugin/master/nodes.png)
#### Conversation
Conversation is the starting point of a dialog graph. You can have multiple Conversations in a single file, but each of them has to have its own unique name.
In every file there's only one Conversation that's set as the default one. This means it would be the default dialog graph that would start in that specific file, unless the Manager node is provided with a name of a different Conversation.
#### Speech
Speech is your NPCs' 'voice'. This is what they'd say in your dialog. If you use Godot's translations, you can press Enter once you enter a key code to display that line's translation in the box below. Sadly, this only works if you run the Editor as a scene, due to Godot's current implementation of translations.
#### Choice
Choice is where your player replies. It lets you have multiple answers, with each being able to branch according to the response.
#### Condition
Condition is used when you want a branching point to depend on a variable. It uses the following format - "path/property", where path can be relative, or absolute. When you use a relative path, it is relative to the PARENT of the manager node.
To use a parent's property, the path should be ".". (This is exactly how it works with get_node())
#### Mux
Mux is used as a many-to-one converter. Because the plugin doesn't allow multiple connections connecting to the same slot, this is the solution when you want to route multiple outcomes to the same point.
#### Jump
Jump allows you to 'jump' to another Conversion, within the same file. This is used to simplify the graph, and lets you set different 'checkpoints' you can return to, or start from, using Conversations.

These are all the available nodes for now!

### Editor
[![Editor](/editor.png)](https://raw.githubusercontent.com/ejnij/Godot-DialogGraphPlugin/master/editor.png)
The editor is used for designing dialog graphs which can then be exported and used by the manager node.
The buttons on the left create graph nodes. The buttons on the right let you load/save the dialog graph, export it for the Manager node, or clear the view.

*Clarification: Save and Load use a different file format from Export. The former holds the visual data for the Editor, and the latter holds less information and is used by the Manager node.

### Manager node
[![Manager](/manager.png)](https://raw.githubusercontent.com/ejnij/Godot-DialogGraphPlugin/master/manager.png)

The manager node is used to manage and communicate with the dialog graph you exported, while your game is running.
You can choose the exported dialog you created in the Manager node's view.
It has signals for when it reaches a Speech node or a Choice node. Each providing the relevant dialog data as an Array of Strings.
To inform it when a choice was chosen, you can use choice_picked(choice_index).

## Bugs / Issues
1. Translation being entered doesn't automatically scale the nodes. It does update when you Load though.
2. The code for the Manager node is pretty hack-y and not OO-y. Might change that later.
3. Graph validity isn't reinforced, so some stuff you can get away with while exporting, that would crash the Manager node.
4. File dialogs require pressing the "Save/Load" button at the end. Adding ".json" is also needed, and there might be an overwrite message for no reason as well.

### Fixed
1. Editor tab doesn't align with other tabs, and starts at 0 height.
