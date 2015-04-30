package com.defense.haxe;

import starling.textures.Texture;
import starling.events.EnterFrameEvent;
import starling.events.KeyboardEvent;
import starling.events.TouchEvent;
import starling.events.Event;
import starling.display.Sprite;
import starling.display.Button;
import flash.system.System;

import starling.display.Image;
import starling.display.Quad;
import com.defense.haxe.Root;
import com.defense.haxe.tower.TowerGrid;

class BuildMenu extends Sprite {

	//images
	private var overlay:Image;
	private var redtower:Button;
	private var bluetower:Button;
	private var greentower:Button;
	private var purpletower:Button;

	private var background = new Quad(550, 400, 0x000000);
	
	private var rTexture:Texture = Root.assets.getTexture("redtower");
	private var bTexture:Texture = Root.assets.getTexture("bluetower");
	private var gTexture:Texture = Root.assets.getTexture("greentower");
	private var pTexture:Texture = Root.assets.getTexture("purpletower");

	public function new(){
		super();
		//postion towers
		redtower = new Button(rTexture, "red");
		addChild(redtower);
		redtower.x = 0;
		redtower.y = 0;
		redtower.visible = false;
		redtower.enabled = false;
		redtower.alphaWhenDisabled = .5;

		bluetower = new Button(bTexture, "blue");
		addChild(bluetower);
		bluetower.x = 0;
		bluetower.y = 0;
		bluetower.visible = false;
		bluetower.enabled = false;
		bluetower.alphaWhenDisabled = .5;

		greentower = new Button(gTexture, "green");
		addChild(greentower);
		greentower.x = 0;
		greentower.y = 0;
		greentower.visible = false;
		greentower.enabled = false;
		greentower.alphaWhenDisabled = .5;

		purpletower = new Button(pTexture, "purple");
		addChild(purpletower);
		purpletower.x = 0;
		purpletower.y = 0;
		purpletower.visible = false;
		purpletower.enabled = false;
		purpletower.alphaWhenDisabled = .5;
	}

	public function getMenu():Quad{
		background.x = 0;
		background.y = 0;
		background.alpha = 0.5;
		return background;
	}

	public function showMenu(towerX:Int, towerY:Int, money:Int, occupied:Bool, grid:TowerGrid){

		overlay.visible = true;
		
		redtower.x = towerX;
		redtower.y = towerY + 50;
		redtower.visible = true;
		//if enough money and can build activate button
		if(money > 10 && occupied == true){

			redtower.enabled = true;

		}
		//add tower when clicked
		redtower.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY);
			hideMenu();
		});
		
		bluetower.x = towerX + 50;
		bluetower.y = towerY;
		bluetower.visible = true;
		//if enough money and can build activate button
		if(money > 20 && occupied == true){

			bluetower.enabled = true;

		}
		//add tower when clicked
		bluetower.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY);
			hideMenu();
		});

		greentower.x = towerX;
		greentower.y = towerY - 50;
		greentower.visible = true;
		//if enough money and can build activate button
		if(money > 30 && occupied == true){

			greentower.enabled = true;

		}
		//add tower when clicked
		greentower.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY);
			hideMenu();
		});

		purpletower.x = towerX - 50;
		purpletower.y = towerY;
		purpletower.visible = true;
		//if enough money and can build activate button
		if(money > 10 && occupied == true){

			purpletower.enabled = true;

		}
		//add tower when clicked
		purpletower.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY);
			hideMenu();
		});

	}

	public function hideMenu(){

		overlay.visible = false;

		redtower.visible = false;

		bluetower.visible = false;

		greentower.visible = false;

		purpletower.visible = false;

	}

}