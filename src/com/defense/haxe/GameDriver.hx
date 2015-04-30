package com.defense.haxe;

import starling.textures.Texture;
import starling.events.EnterFrameEvent;
import starling.events.KeyboardEvent;
import starling.events.TouchEvent;
import starling.events.Event;
import starling.display.Sprite;
import flash.system.System;

import com.defense.haxe.Root;
import com.defense.haxe.tower.TowerGrid;
import com.defense.haxe.enemy.EnemyGenerator;
import com.defense.haxe.GameMenu;
import com.defense.haxe.enemy.Enemy;
import com.defense.haxe.tower.Tower;
import com.defense.haxe.tower.TowerType;
import com.defense.haxe.enemy.EnemyType;

class GameDriver extends Sprite {
	/* The 'perfect' update time, used to modify velocities in case
	   the game is not quite running at frameRate */
	public static var perfectDeltaTime : Float = 1/60;
	
	/* Whether or not the game is running (paused) */
	private var running:Bool = true;
	
	/* Keep track of game assets */
	private var towerGrid:TowerGrid;
	
	private var towers:List<TowerType>;
	private var enemies:List<EnemyType>;

	// Simple constructor
    public function new() {
        super();
		this.addEventListener(Event.ADDED_TO_STAGE, start);		
		var objectParser = new ObjectParser();
		// Events because Flash IO is async
		objectParser.dispatcher.addEventListener("TowerJsonReady", function(e:Event){
				this.towers = e.data.value;							
			});
		objectParser.dispatcher.addEventListener("EnemyJsonReady", function(e:Event){
				this.enemies = e.data.value;				
			});
	}
	
	// Called when added to the stage, ready to start everything
	public function start(){
		startGame();

	}
	
	/** Do stuff with the menu screen */
	private function startScreen(){
	}
	
	/** Function to be called when we are ready to start the game */
	private function startGame() {
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		Root.globalStage.addEventListener(TouchEvent.TOUCH, onTouch);
		
		towerGrid = new TowerGrid(32,2,15,11);
		towerGrid.x = Math.round(this.stage.stageWidth/2 - towerGrid.width/2);
		towerGrid.y = Math.round(this.stage.stageHeight/2 - towerGrid.height/2);
		addChild(towerGrid);
	}
	
	/** The game is over! */
	private function triggerGameOver(){
	}
	
	/** Restart the game */
	private function restartGame(){
		this.removeChildren();
		this.removeEventListeners();
	}
	
	/** Function called every frame update, main game logic loop */
	private function onEnterFrame( event:EnterFrameEvent ) {
		if(!running)
			return;
			
		towerGrid.onEnterFrame(event);
	}
	
	/** Used to detect clicks */
	private function onTouch( event:TouchEvent ){
	}
}