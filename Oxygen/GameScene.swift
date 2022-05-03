//
//  GameScene.swift
//  Oxygen
//
//  Created by Y3858230 on 12/11/2019.
//  Copyright © 2019 Y3858230. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioKit

class GameScene: SKScene {
    
    // Instantiate the other classes
    var audioLibrary: MainAudioEngine!          // Create global variable to access sound processing file
    var viewController: GameViewController!    // Allows communication between game scene and UI controller
    
    
    // Instantiate the animation nodes for the interface
    
    // Background Nodes
    private var rainAnimation: SKEmitterNode!
    private var forestBackgroundAnimation: SKEmitterNode!
    private var caveDropsAnimation: SKEmitterNode!
    private var spaceAnimation: SKEmitterNode!
    private var cometAnimation: SKEmitterNode!
    private var sunsetAnimation: SKEmitterNode!
    private var ravineAnimation: SKEmitterNode!
    
    // Touch Nodes
    private var sparkAnimation: SKEmitterNode?  // Touch down node
    private var flamesAnimation: SKEmitterNode? // Touch move node
    private var ensoAnimation: SKEmitterNode?   // Touch up node
    private var outlineNode: SKShapeNode?        // Outline node

    // Instantiate label to show welcome text
    private var welcomeLabel : SKLabelNode?
    
    
    // Instantiate background images from their file names
    // See README.txt for image copyright information
    let forestBackground = SKSpriteNode(imageNamed: "forestBackground.jpg")
    let caveBackground = SKSpriteNode(imageNamed: "caveBackground.jpg")
    let spaceBackground = SKSpriteNode(imageNamed: "spaceBackground.jpg")
    let sunsetBackground = SKSpriteNode(imageNamed: "sunsetBackground.jpg")
    let ravineBackground = SKSpriteNode(imageNamed: "ravineBackground.jpg")
    
    // Create tags for each wallpaper for segmented control conditions
    var forestTag = 1
    var caveTag = 0
    var spaceTag = 0
    var sunsetTag = 0
    var ravineTag = 0
    
    
    override func didMove(to view: SKView) {
        
        // Create an instance of the AudioEngine class in the GameScene
        audioLibrary = MainAudioEngine()
        
        // Set zPosition so background images appear behind every other feature
        forestBackground.zPosition = -1
        caveBackground.zPosition = -1
        spaceBackground.zPosition = -1
        sunsetBackground.zPosition = -1
        ravineBackground.zPosition = -1
        
        // Initialise all nodes from their file names and set positions for animaiton
        setupNodes()
        
        // Initially add forest background
        self.addChild(forestBackground)
        
        // Add the background effects to the scene
        self.addChild(rainAnimation)
        self.addChild(forestBackgroundAnimation)
        
        
        
        // Get nodes from scene and store for use later
    
        // Welcome text
        self.welcomeLabel = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let welcomeLabel = self.welcomeLabel {
            welcomeLabel.alpha = 0.0
            welcomeLabel.run(SKAction.sequence([SKAction.fadeIn(withDuration: 2.0),
                                         SKAction.wait(forDuration: 3.0),
                                         SKAction.fadeOut(withDuration: 2.0)]))
        }
        
        // Touch down animation
        self.sparkAnimation = SKEmitterNode(fileNamed: "SparkAnimation")
        if let sparkAnimation = self.sparkAnimation {
            sparkAnimation.run(SKAction.sequence([SKAction.wait (forDuration: 0.5),
                                                  SKAction.fadeOut(withDuration: 0.5),
                                                  SKAction.removeFromParent()]))
        }
        
        // Touch moved animation
        self.flamesAnimation = SKEmitterNode(fileNamed: "FireAnimation")
        if let flamesAnimation = self.flamesAnimation {
            flamesAnimation.run(SKAction.sequence([SKAction.wait (forDuration: 1.0),
                                                   SKAction.fadeOut(withDuration: 0.5),
                                                   SKAction.removeFromParent()]))
        }
        
        // Touch up animation
        self.ensoAnimation = SKEmitterNode(fileNamed: "EnsoAnimation")
        if let ensoAnimation = self.ensoAnimation {
            ensoAnimation.run(SKAction.repeatForever(SKAction.scale(to: 3, duration: 1.5)))
            ensoAnimation.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                 SKAction.fadeOut(withDuration: 0.5),
                                                 SKAction.removeFromParent()]))
        }
        
        // Outline node animation (needed as iPad GPU creates some delay in animation nodes)
        let w = (self.size.width + self.size.height) * 0.02
        self.outlineNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let outlineNode = self.outlineNode {
            outlineNode.lineWidth = 1.7
            outlineNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            outlineNode.run(SKAction.repeatForever(SKAction.scale(to: 3, duration: 1.5)))
            outlineNode.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    // Function for when the user touches the screen
    func touchDown(atPoint pos : CGPoint) {
        
        // Creat a copy of the touch down animation and add it at the touch position
        if let n = self.sparkAnimation?.copy() as! SKEmitterNode? {
            n.position = pos
            self.addChild(n)
        }
    
        // Call the start function in the AudioEngine class
        audioLibrary.start(currentPosition: pos)
    }
    
    // Function for when the user moves their finger along the screen
    func touchMoved(fromPoint currentPos : CGPoint, toPoint newPos : CGPoint) {

        // Create a copy of the touch moved animation and add it to each new position
        if let n = self.flamesAnimation?.copy() as! SKEmitterNode? {
            n.position = newPos
            self.addChild(n)
        }
        
        // Create a copy of the outline node and add it to each new position
        if let n = self.outlineNode?.copy() as! SKShapeNode? {
            n.position = newPos
            n.strokeColor = SKColor.gray
            n.glowWidth = 2.0
            self.addChild(n)
        }

        // Update the AudioEngine based on new location
        audioLibrary.update(currentPosition: currentPos, newPosition: newPos)
        
    }
    
    // Function for when the user releases their touch
    func touchUp(fromPoint currentPos : CGPoint, toPoint newPos : CGPoint) {
        
        // Create a copy of the touch up animation and add it at the release position
        if let n = self.ensoAnimation?.copy() as! SKEmitterNode? {
            n.position = newPos
            self.addChild(n)
        }
        
        // Call the stop function in AudioEngine
        audioLibrary.stop(currentPosition: currentPos, newPosition: newPos)
    }
    
    
    // Function to remove current background image and replace with forest backgorund
    open func selectForestBackground() {
        
        // First need to remove currently existing wallpaper
        if caveTag == 1 {
            caveBackground.removeFromParent()
            caveTag = 0
        } else if spaceTag == 1 {
            spaceBackground.removeFromParent()
            spaceTag = 0
        } else if sunsetTag == 1 {
            sunsetBackground.removeFromParent()
            sunsetTag = 0
        } else if ravineTag == 1 {
            ravineBackground.removeFromParent()
            ravineTag = 0
        }
        // Once background removed add the forest background
        self.addChild(forestBackground)
        forestTag = 1
    }
    
    // Function to remove current background image and replace with cave backgorund
    open func selectCaveBackground() {
        
        // First need to remove currently existing wallpaper
        if forestTag == 1 {
            forestBackground.removeFromParent()
            forestTag = 0
        } else if spaceTag == 1 {
            spaceBackground.removeFromParent()
            spaceTag = 0
        } else if sunsetTag == 1 {
            sunsetBackground.removeFromParent()
            sunsetTag = 0
        } else if ravineTag == 1 {
            ravineBackground.removeFromParent()
            ravineTag = 0
        }
        // Once background removed add the cave background
        self.addChild(caveBackground)
        caveTag = 1
    }
    
    
    // Function to remove current background image and replace with space backgorund
    open func selectSpaceBackground() {
        
        // First need to remove currently existing wallpaper
        if forestTag == 1 {
            forestBackground.removeFromParent()
            forestTag = 0
        } else if caveTag == 1 {
            caveBackground.removeFromParent()
            caveTag = 0
        } else if sunsetTag == 1 {
            sunsetBackground.removeFromParent()
            sunsetTag = 0
        } else if ravineTag == 1 {
            ravineBackground.removeFromParent()
            ravineTag = 0
        }
        // Once background removed add the space background
        self.addChild(spaceBackground)
        spaceTag = 1
    }
    
    
    // Function to remove current background image and replace with sunset backgorund
    open func selectSunsetBackground() {
        
        // First need to remove currently existing wallpaper
        if forestTag == 1 {
            forestBackground.removeFromParent()
            forestTag = 0
        } else if caveTag == 1 {
            caveBackground.removeFromParent()
            caveTag = 0
        } else if spaceTag == 1 {
            spaceBackground.removeFromParent()
            spaceTag = 0
        } else if ravineTag == 1 {
            ravineBackground.removeFromParent()
            ravineTag = 0
        }
        // Once background removed add the sunset background
        self.addChild(sunsetBackground)
        sunsetTag = 1
    }
    
    
    // Function to remove current background image and replace with ravine backgorund
    open func selectRavineBackground() {
        
        // First need to remove currently existing wallpaper
        if forestTag == 1 {
            forestBackground.removeFromParent()
            forestTag = 0
        } else if caveTag == 1 {
            caveBackground.removeFromParent()
            caveTag = 0
        } else if spaceTag == 1 {
            spaceBackground.removeFromParent()
            spaceTag = 0
        } else if sunsetTag == 1 {
            sunsetBackground.removeFromParent()
            sunsetTag = 0
        }
        // Once background removed add the ravine background
        self.addChild(ravineBackground)
        ravineTag = 1
    }
    
    // Function to initialise all animation nodes and set up initial position
    open func setupNodes() {
        
        // Create animation nodes based on corresponding .sks files
        rainAnimation = SKEmitterNode(fileNamed: "RainAnimation")
        forestBackgroundAnimation = SKEmitterNode(fileNamed: "FloatingForestAnimation")
        caveDropsAnimation = SKEmitterNode(fileNamed: "CaveDropsAnimation")
        spaceAnimation = SKEmitterNode(fileNamed: "FloatingStarsAnimation")
        cometAnimation = SKEmitterNode(fileNamed: "CometAnimation")
        sunsetAnimation = SKEmitterNode(fileNamed: "FloatingFirefliesAnimation")
        ravineAnimation = SKEmitterNode(fileNamed: "LeavesAnimation")
        
        // Set initial locations of animations if necessary
        rainAnimation.position = CGPoint(x: 0, y: size.height/2)
        rainAnimation.particleSpeed = 3.0 // Set initial speed
        caveDropsAnimation.position = CGPoint(x: 0, y: 50)
        ravineAnimation.position = CGPoint(x:-size.width, y: 0)
    }
    

    // Functions to add the animation nodes to a particular environment
    
    // Rainforest environment
    open func addRainNodes() {
        self.addChild(rainAnimation)
        self.addChild(forestBackgroundAnimation)
    }
    
    // Cavern environment
    open func addCaveNode() {
        self.addChild(caveDropsAnimation)
    }
    
    // Space environment
    open func addSpaceNodes() {
        self.addChild(spaceAnimation)
        self.addChild(cometAnimation)
    }
    
    // Sunset environment
    open func addSunsetNode() {
        self.addChild(sunsetAnimation)
    }
    
    // Ravine environment
    open func addRavineNode() {
        self.addChild(ravineAnimation)
    }
    
    
    
    // Preset GameScene fucntions //
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(fromPoint: t.previousLocation(in:self), toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(fromPoint: t.previousLocation(in:self), toPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(fromPoint: t.previousLocation(in:self), toPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
