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


class GameLoader extends Sprite {

	//Super basic global variables - TODO: Need to change these
	public var M_BTN:Image = new Image(Root.assets.getTexture("startBtn"));
	public var background = new Quad(550, 400, 0x000000);
	public var textField:TextField = new TextField(550, 40, "Nameless Tower Defense!", "Arial", 36, 0xffffff);

	public function new(){
		super();
	}

	public function start():Quad{
		background.x = 0;
		background.y = 0;
		background.alpha = 0.5;
		return background;
	}

	public function text():TextField{
    	return textField;
	}

	public function button():Image{
		M_BTN.x = 160;
		M_BTN.y = 150;
		M_BTN.addEventListener(TouchEvent.TOUCH, aa);
		return M_BTN;
	}

	public function aa( event:TouchEvent ){
		var touch:Touch = event.touches[0];
		if(touch.phase == "began"){
		 	M_BTN.removeFromParent();
		 	background.removeFromParent();
		 	textField.removeFromParent();
		}
	}

}