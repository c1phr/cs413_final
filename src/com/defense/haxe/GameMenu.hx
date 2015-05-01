package com.defense.haxe;

import starling.textures.Texture;
import starling.events.TouchEvent;
import starling.events.Event;
import starling.display.Sprite;
import starling.text.TextField;
import flash.system.System;
import starling.events.Touch;
import starling.display.Quad;
import starling.display.Button;
import starling.display.Image;


class GameMenu extends Sprite {

	//Super basic global variables - TODO: Need to change these
	public var M_BTN:Image = new Image(Root.assets.getTexture("startBtn"));
	public var background:Quad;
	public var textField:TextField = new TextField(550, 40, "Nameless Tower Defense!", "Arial", 36, 0x00CCFF);
	private var startButton:Sprite;
	private var tutorialButton:Sprite;
	private var backButton:Sprite;
	
	public function new(){
		super();
		this.width = 540;
		this.height = 540;
		this.background = createBackground();
		this.addChild(background);

		this.startButton = createButton("Start Game");
		this.startButton.x = 325 - (this.startButton.width/2);
		this.startButton.y = 100;
		this.startButton.addEventListener(TouchEvent.TOUCH, startGame);
		this.addChild(this.startButton);		
		this.tutorialButton = createButton("Tutorial");
		this.tutorialButton.x = 325 - (this.tutorialButton.width/2);
		this.tutorialButton.y = 250;
		this.tutorialButton.addEventListener(TouchEvent.TOUCH, showTutorial);
		this.addChild(this.tutorialButton);
	}

	private function createBackground():Quad {
		var background = new Quad(650, 400, 0x000000);
		background.x = 0;
		background.y = 0;
		background.alpha = 0.8;
		return background;
	}	

	private function createButton(buttonText:String):Sprite {
		var newButton = new Sprite();		
		var newButtonBackground = new Quad(200, 100, 0x020202);
		newButton.addChild(newButtonBackground);
		var newButtonText = new TextField(Std.int(newButton.width), Std.int(newButton.height), buttonText, "Arial", 36, 0x00CCFF);
		newButton.addChild(newButtonText);		
		return newButton;
	}

	private function createTutorialScene():Sprite {
		var tutorialScene = new Sprite();
		var tutorialText = new TextField(500, 75, "Place towers to defeat enemies\nClick Go to end build phase and start play phase", "Arial", 18, 0x00CCFF);
		tutorialScene.addChild(tutorialText);
		tutorialText.x = 325 - (tutorialText.width/2);
		tutorialText.y = 25;

		var wallImg = new Image(Root.assets.getTexture("wall_button"));
		wallImg.x = 100;
		wallImg.y = 100;
		var wallText = new TextField(400, 50, "Wall does no damage. Cost - 5", "Arial", 18, 0x00CCFF);
		wallText.x = wallImg.x + 40;
		wallText.y = wallImg.y;
		tutorialScene.addChild(wallText);
		tutorialScene.addChild(wallImg);
		
		var redTowerImg = new Image(Root.assets.getTexture("redtower"));
		redTowerImg.x = 100;
		redTowerImg.y = 150;
		var redTowerText = new TextField(400, 50, "Heavy damage tower. Cost - 100", "Arial", 18, 0x00CCFF);
		redTowerText.x = redTowerImg.x + 40;
		redTowerText.y = redTowerImg.y;
		tutorialScene.addChild(redTowerText);
		tutorialScene.addChild(redTowerImg);

		var greenTowerImg = new Image(Root.assets.getTexture("greentower"));
		greenTowerImg.x = 100;
		greenTowerImg.y = 200;
		var greenTowerText = new TextField(400, 50, "Causes damage over time. Cost - 150", "Arial", 18, 0x00CCFF);
		greenTowerText.x = greenTowerImg.x + 40;
		greenTowerText.y = greenTowerImg.y;
		tutorialScene.addChild(greenTowerText);
		tutorialScene.addChild(greenTowerImg);

		var blueTowerImg = new Image(Root.assets.getTexture("bluetower"));
		blueTowerImg.x = 100;
		blueTowerImg.y = 250;
		var blueTowerText = new TextField(400, 50, "Slows enemies. Cost - 150", "Arial", 18, 0x00CCFF);
		blueTowerText.x = blueTowerImg.x + 40;
		blueTowerText.y = blueTowerImg.y;
		tutorialScene.addChild(blueTowerText);
		tutorialScene.addChild(blueTowerImg);

		var yellowTowerImg = new Image(Root.assets.getTexture("purpletower"));
		yellowTowerImg.x = 100;
		yellowTowerImg.y = 300;
		var yellowTowerText = new TextField(400, 50, "Fires quickly but with less damage. Cost - 100", "Arial", 18, 0x00CCFF);
		yellowTowerText.x = yellowTowerImg.x + 40;
		yellowTowerText.y = yellowTowerImg.y;
		tutorialScene.addChild(yellowTowerText);
		tutorialScene.addChild(yellowTowerImg);

		backButton = createButton("Go Back");
		backButton.x = 325 - (this.backButton.width/2);
		backButton.y = 400;
		backButton.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent){
			if (event.touches[0].phase == "began")
			{
				this.addChild(this.startButton);
				this.addChild(this.tutorialButton);
				tutorialScene.removeFromParent();
			}			
		});
		tutorialScene.addChild(backButton);
		return tutorialScene;
	}

	private function startGame(event:TouchEvent) {
		if (event.touches[0].phase == "began"){
			this.removeFromParent();
		}		
	}

	private function showTutorial(event:TouchEvent) {
		if (event.touches[0].phase == "began") {
			this.startButton.removeFromParent();
			this.tutorialButton.removeFromParent();
			this.addChild(createTutorialScene());
		}
	}

}