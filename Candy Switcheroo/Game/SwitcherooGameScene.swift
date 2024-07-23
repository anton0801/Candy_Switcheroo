import SwiftUI
import SpriteKit

enum SwitchType {
    case none, left, right
}

class SwitcherooGameScene: SKScene, SKPhysicsContactDelegate {
    
    private var level: Int
    
    private var rulesPassed = true {
        didSet {
            if rulesPassed {
                UserDefaults.standard.set(true, forKey: "rules_passed")
                let fade = SKAction.fadeOut(withDuration: 0.5)
                rulesNode.run(fade) {
                    self.rulesNode.removeFromParent()
                }
            }
        }
    }
    
    private var passedBalls = 0 {
        didSet {
            passedBallsLabel.text = "\(passedBalls)"
            if passedBalls <= 0 {
                isPaused = true
                NotificationCenter.default.post(name: Notification.Name("game_lose"), object: nil)
            }
        }
    }
    private var passedBallsLabel: SKLabelNode = SKLabelNode(text: "0")
    
    private var greenTexture = SKTexture(imageNamed: "green")
    private var redTexture = SKTexture(imageNamed: "red")
    
    private var switcheroo: SKSpriteNode = SKSpriteNode(imageNamed: "switcheroo")
    private var currentSwitch: SwitchType = .none {
        didSet {
            if currentSwitch == .left {
                switcheroo.run(SKAction.rotate(toAngle: -(CGFloat.pi / 6), duration: 0.5))
                switcheroIndicator.texture = redTexture
            } else {
                switcheroo.run(SKAction.rotate(toAngle: CGFloat.pi / 6, duration: 0.5))
                switcheroIndicator.texture = greenTexture
            }
        }
    }
    private var switcheroIndicator = SKSpriteNode(texture: nil)
    
    private var ballsSpawner = Timer()
    private var gameTimer = Timer()
    private var gameTime = 0 {
        didSet {
            if gameTime == 30 * (level * 2) {
                isPaused = true
                NotificationCenter.default.post(name: Notification.Name("game_win"), object: nil)
            }
        }
    }
    
    private var background: SKSpriteNode {
        get {
            let backgroundNode = SKSpriteNode(imageNamed: "game_background")
            backgroundNode.size = size
            backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
            return backgroundNode
        }
    }
    
    private var pauseBtn: SKSpriteNode {
        get {
            let btn = SKSpriteNode(imageNamed: "pause_btn")
            btn.position = CGPoint(x: 80, y: size.height - 80)
            btn.size = CGSize(width: 150, height: 120)
            btn.name = "game_pause_btn"
            return btn
        }
    }
    
    private var gameFieldBack: SKSpriteNode {
        get {
            let fieldBg = SKSpriteNode(imageNamed: "field_bg")
            fieldBg.position = CGPoint(x: size.width / 2, y: size.height / 2)
            fieldBg.size = CGSize(width: size.width - 120, height: size.height - 500)
            return fieldBg
        }
    }
    
    private var gameLevelLabel: SKLabelNode {
        get {
            let levelLabel = SKLabelNode(text: "Level \(level)")
            levelLabel.fontName = "ChunkyHazelnut"
            levelLabel.fontSize = 140
            levelLabel.fontColor = .white
            levelLabel.position = CGPoint(x: size.width / 2, y: size.height - 200)
            return levelLabel
        }
    }
    
    private var creditsCount = UserDefaults.standard.integer(forKey: "credits")
    private var livesCount = UserDefaults.standard.integer(forKey: "lives")
    
    private var creditsNode: SKSpriteNode {
        get {
            let credits = SKSpriteNode()
            
            let creditsBack = SKSpriteNode(imageNamed: "credits")
            creditsBack.size = CGSize(width: 260, height: 130)
            credits.addChild(creditsBack)
            
            let creditsLabel = SKLabelNode(text: "\(creditsCount)")
            creditsLabel.fontName = "ChunkyHazelnut"
            creditsLabel.fontSize = 62
            creditsLabel.fontColor = .white
            creditsLabel.position = CGPoint(x: 50, y: -10)
            credits.addChild(creditsLabel)
            
            credits.position = CGPoint(x: 160, y: 60)
            return credits
        }
    }
    
    private var livesNode: SKSpriteNode {
        get {
            let lives = SKSpriteNode()
            
            let livesBack = SKSpriteNode(imageNamed: "lives")
            livesBack.size = CGSize(width: 260, height: 130)
            lives.addChild(livesBack)
            
            let creditsLabel = SKLabelNode(text: "\(livesCount)")
            creditsLabel.fontName = "ChunkyHazelnut"
            creditsLabel.fontSize = 62
            creditsLabel.fontColor = .white
            creditsLabel.position = CGPoint(x: 40, y: -10)
            lives.addChild(creditsLabel)
            
            lives.position = CGPoint(x: size.width - 160, y: 60)
            return lives
        }
    }
    
    private var rulesNode: SKSpriteNode!
    
    private var tappedOnRulesCount = 0 {
        didSet {
            if tappedOnRulesCount == 2 {
                rulesPassed = true
                startGame()
            }
        }
    }
    
    private func rulesNodeGet() -> SKSpriteNode {
        let rulesContent = SKSpriteNode()
        
        let boySmall = SKSpriteNode(imageNamed: "boy_small")
        boySmall.position = CGPoint(x: 150, y: 160)
        boySmall.size = CGSize(width: 350, height: 350)
        boySmall.zPosition = 2
        rulesContent.addChild(boySmall)
        
        let rulesContentNode = SKSpriteNode(imageNamed: "rules_content")
        rulesContentNode.position = CGPoint(x: 300, y: 350)
        rulesContentNode.size = CGSize(width: 500, height: 350)
        rulesContentNode.zPosition = 1
        rulesContent.addChild(rulesContentNode)
        
        let rulesArrowIndicator = SKSpriteNode(imageNamed: "arrow")
        rulesArrowIndicator.position = CGPoint(x: size.width / 2 - 50, y: size.height / 2 - 50)
        rulesArrowIndicator.size = CGSize(width: 100, height: 100)
        rulesArrowIndicator.zPosition = 3
        rulesContent.addChild(rulesArrowIndicator)
        
        let actionMoveIndicator = SKAction.move(to: CGPoint(x: rulesArrowIndicator.position.x - 20, y: rulesArrowIndicator.position.y - 20), duration: 1)
        let actionMoveIndicator2 = SKAction.move(to: CGPoint(x: rulesArrowIndicator.position.x + 20, y: rulesArrowIndicator.position.y + 20), duration: 1)
        let seq = SKAction.sequence([actionMoveIndicator, actionMoveIndicator2])
        let repeate = SKAction.repeatForever(seq)
        rulesArrowIndicator.run(repeate)
        
        rulesContent.zPosition = 10
        return rulesContent
    }
    
    init(size: CGSize, level: Int) {
        self.level = level
        rulesPassed = UserDefaults.standard.bool(forKey: "rules_passed")
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        addChild(background)
        addChild(pauseBtn)
        addChild(gameFieldBack)
        addChild(gameLevelLabel)
        addChild(creditsNode)
        addChild(livesNode)
        
        createGameField()
        
        if !rulesPassed {
            rulesNode = rulesNodeGet()
            addChild(rulesNode)
        } else {
            startGame()
        }
    }
    
    private func startGame() {
        ballsSpawner = .scheduledTimer(timeInterval: 2, target: self, selector: #selector(ballFireSpawn), userInfo: nil, repeats: true)
        
        gameTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func fireTimer() {
        if !isPaused {
            gameTime += 1
        }
    }
    
    @objc private func ballFireSpawn() {
        if !isPaused {
            let balls = ["ball_red", "ball_green"]
            let ball = balls.randomElement() ?? "ball_red"
            let ballNode = SKSpriteNode(imageNamed: ball)
            ballNode.size = CGSize(width: 42, height: 40)
            ballNode.position = CGPoint(x: CGFloat.random(in: (size.width / 2 - 70)...(size.width / 2 + 70)), y: size.height - 250)
            ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.size.width / 2)
            ballNode.physicsBody?.isDynamic = true
            ballNode.physicsBody?.affectedByGravity = true
            ballNode.physicsBody?.categoryBitMask = 1
            ballNode.physicsBody?.collisionBitMask = 4
            ballNode.physicsBody?.contactTestBitMask = 4
            ballNode.zPosition = 3
            ballNode.name = ball
            addChild(ballNode)
        }
    }
    
    func continueGame(_ after: @escaping () -> Void) {
        isPaused = false
        after()
    }
    
    func pauseGame() {
        isPaused = true
        NotificationCenter.default.post(name: Notification.Name("game_pause"), object: nil)
    }
    
    func loseGame(_ after: @escaping () -> Void) {
        isPaused = true
        after()
    }
    
    func restartGame() -> SwitcherooGameScene {
        let newScene = SwitcherooGameScene(size: size, level: level)
        view?.presentScene(newScene)
        return newScene
    }
    
    private func createGameField() {
        let leftLineRect = createLineRect()
        leftLineRect.position = CGPoint(x: size.width / 2 - 110, y: size.height - 455)
        addChild(leftLineRect)
        let rightLineRect = createLineRect()
        rightLineRect.position = CGPoint(x: size.width / 2 + 110, y: size.height - 455)
        addChild(rightLineRect)
        
        let left45line = createLine45()
        left45line.position = CGPoint(x: leftLineRect.position.x - 55, y: leftLineRect.position.y - (leftLineRect.size.height / 2) - 35)
        left45line.zPosition = 2
        addChild(left45line)
        let right45line = createLine45_2()
        right45line.zPosition = 2
        right45line.position = CGPoint(x: rightLineRect.position.x + 55, y: rightLineRect.position.y - (rightLineRect.size.height / 2) - 35)
        addChild(right45line)
        
        let leftSmallLine = createSmallLine()
        leftSmallLine.position = CGPoint(x: left45line.position.x - 18, y: left45line.position.y - 68)
        leftSmallLine.zPosition = 1
        addChild(leftSmallLine)
        
        let rightSmallLine = createSmallLine_2()
        rightSmallLine.position = CGPoint(x: right45line.position.x + 18, y: right45line.position.y - 68)
        rightSmallLine.zPosition = 1
        addChild(rightSmallLine)
        
        let bottomPart = SKSpriteNode(imageNamed: "bottom_field")
        bottomPart.position = CGPoint(x: size.width / 2, y: 480)
        bottomPart.size = CGSize(width: 120, height: 300)
        addChild(bottomPart)
        
        let centralLeftSmall = createSmallLine_3()
        centralLeftSmall.position = CGPoint(x: size.width / 2 - 50, y: size.height / 2 - 60)
        addChild(centralLeftSmall)
        
        let centralRightSmall = createSmallLine_4()
        centralRightSmall.position = CGPoint(x: size.width / 2 + 50, y: size.height / 2 - 60)
        addChild(centralRightSmall)
        
        let centralLeft45 = createLine45_3()
        centralLeft45.position = CGPoint(x: size.width / 2 - 33, y: size.height / 2 - 20)
        addChild(centralLeft45)
        
        let centralRight45 = createLine45_4()
        centralRight45.position = CGPoint(x: size.width / 2 + 33, y: size.height / 2 - 20)
        addChild(centralRight45)
        
        passedBallsLabel.fontName = "ChunkyHazelnut"
        passedBallsLabel.fontSize = 62
        passedBallsLabel.fontColor = .white
        passedBallsLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 55)
        addChild(passedBallsLabel)
        
        let green = SKSpriteNode(imageNamed: "green")
        green.position = CGPoint(x: size.width / 2 - 180, y: size.height / 2 + 250)
        addChild(green)
        
        let red = SKSpriteNode(imageNamed: "red")
        red.position = CGPoint(x: size.width / 2 + 180, y: size.height / 2 + 250)
        addChild(red)
        
        switcheroo.position = CGPoint(x: size.width / 2, y: size.height / 2 + 10)
        switcheroo.size = CGSize(width: 200, height: 60)
        switcheroo.zPosition = 5
        switcheroo.physicsBody = SKPhysicsBody(rectangleOf: switcheroo.size)
        switcheroo.physicsBody?.isDynamic = false
        switcheroo.physicsBody?.affectedByGravity = false
        addChild(switcheroo)
        
        switcheroIndicator.size = CGSize(width: 52, height: 50)
        switcheroIndicator.position = switcheroo.position
        switcheroIndicator.zPosition = 6
        addChild(switcheroIndicator)
        
        let leftCatcher = SKSpriteNode(color: .clear, size: CGSize(width: 150, height: 5))
        leftCatcher.position = CGPoint(x: size.width / 2 - 110, y: size.height / 2 - 100)
        leftCatcher.name = "left_catcher"
        leftCatcher.physicsBody = SKPhysicsBody(rectangleOf: leftCatcher.size)
        leftCatcher.physicsBody?.isDynamic = false
        leftCatcher.physicsBody?.affectedByGravity = false
        leftCatcher.physicsBody?.categoryBitMask = 4
        leftCatcher.physicsBody?.collisionBitMask = 1
        leftCatcher.physicsBody?.contactTestBitMask = 1
        addChild(leftCatcher)
        
        let rightCatcher = SKSpriteNode(color: .clear, size: CGSize(width: 150, height: 5))
        rightCatcher.position = CGPoint(x: size.width / 2 + 110, y: size.height / 2 - 100)
        rightCatcher.physicsBody = SKPhysicsBody(rectangleOf: leftCatcher.size)
        rightCatcher.physicsBody?.isDynamic = false
        rightCatcher.physicsBody?.affectedByGravity = false
        rightCatcher.physicsBody?.categoryBitMask = 4
        rightCatcher.physicsBody?.collisionBitMask = 1
        rightCatcher.physicsBody?.contactTestBitMask = 1
        rightCatcher.name = "right_catcher"
        addChild(rightCatcher)
    }
    
    private func createLineRect() -> SKSpriteNode {
        let rectLine = SKSpriteNode(imageNamed: "line_rect")
        rectLine.size = CGSize(width: 15, height: 350)
        rectLine.physicsBody = SKPhysicsBody(rectangleOf: rectLine.size)
        rectLine.physicsBody?.isDynamic = false
        rectLine.physicsBody?.affectedByGravity = false
        rectLine.name = "barrier_line"
        return rectLine
    }
    
    private func createLine45() -> SKSpriteNode {
        let rectLine = SKSpriteNode(imageNamed: "line_rect")
        rectLine.size = CGSize(width: 15, height: 150)
        rectLine.physicsBody = SKPhysicsBody(rectangleOf: rectLine.size)
        rectLine.physicsBody?.isDynamic = false
        rectLine.physicsBody?.affectedByGravity = false
        rectLine.name = "barrier_line"
        rectLine.zRotation = -180
        return rectLine
    }
    
    private func createLine45_2() -> SKSpriteNode {
        let rectLine = SKSpriteNode(imageNamed: "line_rect")
        rectLine.size = CGSize(width: 15, height: 150)
        rectLine.physicsBody = SKPhysicsBody(rectangleOf: rectLine.size)
        rectLine.physicsBody?.isDynamic = false
        rectLine.physicsBody?.affectedByGravity = false
        rectLine.name = "barrier_line"
        rectLine.zRotation = 180
        return rectLine
    }
    
    private func createLine45_3() -> SKSpriteNode {
        let rectLine = SKSpriteNode(imageNamed: "line_rect")
        rectLine.size = CGSize(width: 15, height: 90)
        rectLine.physicsBody = SKPhysicsBody(rectangleOf: rectLine.size)
        rectLine.physicsBody?.isDynamic = false
        rectLine.physicsBody?.affectedByGravity = false
        rectLine.name = "barrier_line"
        rectLine.zRotation = -180
        return rectLine
    }
    
    private func createLine45_4() -> SKSpriteNode {
        let rectLine = SKSpriteNode(imageNamed: "line_rect")
        rectLine.size = CGSize(width: 15, height: 90)
        rectLine.physicsBody = SKPhysicsBody(rectangleOf: rectLine.size)
        rectLine.physicsBody?.isDynamic = false
        rectLine.physicsBody?.affectedByGravity = false
        rectLine.name = "barrier_line"
        rectLine.zRotation = 180
        return rectLine
    }
    
    private func createSmallLine() -> SKSpriteNode {
        let rectLine = SKSpriteNode(imageNamed: "line_rect")
        rectLine.size = CGSize(width: 15, height: 80)
        rectLine.physicsBody = SKPhysicsBody(rectangleOf: rectLine.size)
        rectLine.physicsBody?.isDynamic = false
        rectLine.physicsBody?.affectedByGravity = false
        rectLine.name = "barrier_line"
        rectLine.zRotation = 180
        return rectLine
    }
    
    private func createSmallLine_2() -> SKSpriteNode {
        let rectLine = SKSpriteNode(imageNamed: "line_rect")
        rectLine.size = CGSize(width: 15, height: 80)
        rectLine.physicsBody = SKPhysicsBody(rectangleOf: rectLine.size)
        rectLine.physicsBody?.isDynamic = false
        rectLine.physicsBody?.affectedByGravity = false
        rectLine.name = "barrier_line"
        rectLine.zRotation = -180
        return rectLine
    }
    
    private func createSmallLine_3() -> SKSpriteNode {
        let rectLine = SKSpriteNode(imageNamed: "line_rect")
        rectLine.size = CGSize(width: 15, height: 60)
        rectLine.physicsBody = SKPhysicsBody(rectangleOf: rectLine.size)
        rectLine.physicsBody?.isDynamic = false
        rectLine.physicsBody?.affectedByGravity = false
        rectLine.name = "barrier_line"
        rectLine.zRotation = -15
        return rectLine
    }
    
    private func createSmallLine_4() -> SKSpriteNode {
        let rectLine = SKSpriteNode(imageNamed: "line_rect")
        rectLine.size = CGSize(width: 15, height: 60)
        rectLine.physicsBody = SKPhysicsBody(rectangleOf: rectLine.size)
        rectLine.physicsBody?.isDynamic = false
        rectLine.physicsBody?.affectedByGravity = false
        rectLine.name = "barrier_line"
        rectLine.zRotation = 15
        return rectLine
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !rulesPassed && tappedOnRulesCount < 2 {
            tappedOnRulesCount += 1
            
            if currentSwitch == .none {
                currentSwitch = .left
            } else {
                if currentSwitch == .left {
                    currentSwitch = .right
                } else {
                    currentSwitch = .left
                }
            }
            
            return
        }
        
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let atPointObject = atPoint(location)
            
            if atPointObject.name == "game_pause_btn" {
                pauseGame()
                return
            }
            
            if currentSwitch == .none {
                currentSwitch = .left
            } else {
                if currentSwitch == .left {
                    currentSwitch = .right
                } else {
                    currentSwitch = .left
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 1 && contact.bodyA.categoryBitMask == 4 {
            
            let ballBody: SKPhysicsBody
            let catcherBody: SKPhysicsBody
            
            if contact.bodyA.categoryBitMask == 1 {
                ballBody = contact.bodyA
                catcherBody = contact.bodyB
            } else {
                ballBody = contact.bodyB
                catcherBody = contact.bodyA
            }
            
            if catcherBody.node != nil {
                let catcherNode = catcherBody.node!
                let catcherName = catcherNode.name
                let ballNode = ballBody.node!
                if catcherName == "left_catcher" && ballNode.name == "ball_green" {
                    passedBalls += 1
                } else if catcherName == "right_catcher" && ballNode.name == "ball_red" {
                    passedBalls += 1
                } else {
                    passedBalls -= 1
                }
            }
            
            ballBody.node?.removeFromParent()
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: SwitcherooGameScene(size: CGSize(width: 750, height: 1335), level: 1))
            .ignoresSafeArea()
    }
}
