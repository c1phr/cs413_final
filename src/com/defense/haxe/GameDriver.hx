package com.defense.haxe;

import starling.textures.Texture;
import starling.events.EnterFrameEvent;
import starling.events.KeyboardEvent;
import starling.events.TouchEvent;
import starling.events.Event;
import flash.system.System;

import com.defense.haxe.Root;

class GameDriver extends starling.display.Sprite {
	/* The 'perfect' update time, used to modify velocities in case
	   the game is not quite running at frameRate */
	static var perfectDeltaTime : Float = 1/60;
	
	// Whether or not the game is running (paused)
	var running = true;
	
	// Simple constructor
    public function new() {
        super();
		this.addEventListener(Event.ADDED_TO_STAGE, start);
	}
	
	// Called when added to the stage, ready to start everything
	public function start(){
		
	}
	
	/** Do stuff with the menu screen */
	private function startScreen(){
		startGame();
	}
	
	/** Function to be called when we are ready to start the game */
	private function startGame() {
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);	
		Root.globalStage.addEventListener(TouchEvent.TOUCH, onTouch);
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
			
		// Create a modifier based on time passed / expected time
		var modifier = event.passedTime / perfectDeltaTime;
	}
	
	/** Used to detect clicks */
	private function onTouch( event:TouchEvent ){
	}
}