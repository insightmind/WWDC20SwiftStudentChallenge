/*:
 ![Logo](Images/LevelSelection/Standard/Logo.png width="400")

 __Isometric Dimension__ is a teleportation based puzzle game.

 ---

 ## Game:
 In this game, you are a droid which tries to reach the goal of the level. In this effort, you can use portals to teleport yourself to a different location on the map.
 You can choose between two droids on the menu:

 ![D42](Images/Actor/D42/D42-Left-Back-Light.png)

 - __D42__, your red companion droid

 ![T33](Images/Actor/T33/T33-Left-Front-Light.png)

 - __T33__, your golden companion droid

 Just for fun, both droids allow you to spark some lightning strikes on the map by just tapping anywhere on the screen.

 ---

 ## Menu:
 - __Selecting a Level:__
 In the menu tap any number to go to the corresponding level.

 - __Settings:__
 You can also disable the music in the bottom left corner and choose your favourite droid.

 ---

 ## Level Controls:
 - __Move Droid:__ Use the keypad in the bottom right corner to control your droid.

  ![Teleportation Block](Images/Blocks/Red/Red_Block.png height="200")
 - __Teleportation:__  Navigate to a teleportation block to teleport the droid.

 - __Miscellaneous:__ You can pause the level or disable the music at any time.

Make sure to search every path as the level will reveal itself after you interact with it.

 ---

 ## Recommended Way to Play:

 I recommend to play the game, so the live view is fully visible.
 Use some headphones to immerse yourself in the game.

 Please start the playground using the play icon on the bottom bar/

 ---

 ## Notes

 It may take a few seconds to build the playground.

 Make sure to restart the playground manually if it shows a blank screen.
 This will reload the playground if it may get stucked in the playground execution caused by the play button
 on the left.

 */

// Let's first import PlaygroundSupport so we are able to use all the great
// features Xcode Playgrounds offers us.
import PlaygroundSupport

// We now instantiate our Game and keep a reference to it.
let game = IsometricDimensionGame()

// Finally assign the game view, so it is presented in the live view!
PlaygroundSupport.PlaygroundPage.current.setLiveView(game.view)

// Let's Play!

/*:
 ## Technologies:

 This playground uses a variety of different frameworks by Apple.
 It mainly uses SpriteKit and UIKit for the game.

 For mathematical calculations, such as vector and matrix calculations, I used the SIMD library.

 Finally, I applied some features of CoreImage and CoreGraphics frameworks.

 ## Music:
 The background music: Buffering by Quiet Music for Tiny Robots is licensed under a Attribution License. It is licensed under CC-BY.
 */
