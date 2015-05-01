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
		var background = new Quad(550, 400, 0x000000);
		background.x = 0;
		background.y = 0;
		background.alpha = 0.5;
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
		var tutorialText = new TextField(500, 400, "Place towers to defeat enemies\nClick the down arrow to end build phase and start play phase", "Arial", 18, 0x00CCFF);
		tutorialScene.addChild(tutorialText);
		tutorialText.x = 325 - (tutorialText.width/2);
		backButton = createButton("Go Back");
		backButton.x = 325 - (this.backButton.width/2);
		backButton.y = 300;
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