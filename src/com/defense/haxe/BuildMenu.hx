package com.defense.haxe

import starling.textures.Texture;
import starling.events.EnterFrameEvent;
import starling.events.KeyboardEvent;
import starling.events.TouchEvent;
import starling.events.Event;
import starling.display.Sprite;
import starling.display.Button;
import flash.system.System;

import com.defense.haxe.Root;
import com.defense.haxe.tower.TowerGrid;

class BuildMenu extends Sprite {

	//images
	private var overlay:Image = new Image(overlay);
	private var tower1:Button = new Button();
	private var tower2:Button = new Button();
	private var tower3:Button = new Button();
	private var tower4:Button = new Button();


	public function new(){

		//position ovelay
		addChild(overlay);
		overlay.x = 0;
		overlay.y = 0;
		overlay.visible = false;

		//postion towers
		addChild(tower1);
		tower1.x = 0;
		tower1.y = 0;
		tower1.visible = false;
		tower1.enabled = false;
		tower1.alphaWhenDisabled = .5;

		addChild(tower2);
		tower2.x = 0;
		tower2.y = 0;
		tower2.visible = false;
		tower2.enabled = false;
		tower2.alphaWhenDisabled = .5;

		addChild(tower3);
		tower3.x = 0;
		tower3.y = 0;
		tower3.visible = false;
		tower3.enabled = false;
		tower3.alphaWhenDisabled = .5;

		addChild(tower4);
		tower4.x = 0;
		tower4.y = 0;
		tower4.visible = false;
		tower4.enabled = false;
		tower4.alphaWhenDisabled = .5;

	}

	public function showMenu(towerX:Int, towerY:Int, int money, boolean occupied, grid:TowerGrid){

		overlay.visible = true;
		
		tower1.x = towerX;
		tower1.y = towerY + 50;
		tower1.visible = true;
		//if enough money and can build activate button
		if(money > 10 && occupied = true){

			tower1.enabled = true;

		}
		//add tower when clicked
		tower1.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY,'tower1');
			hideMenu();
		});
		
		tower2.x = towerX + 50;
		tower2.y = towerY;
		tower2.visible = true;
		//if enough money and can build activate button
		if(money > 20 && occupied = true){

			tower2.enabled = true;

		}
		//add tower when clicked
		tower2.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY,'tower2');
			hideMenu();
		});

		tower3.x = towerX;
		tower3.y = towerY - 50;
		tower3.visible = true;
		//if enough money and can build activate button
		if(money > 30 && occupied = true){

			tower3.enabled = true;

		}
		//add tower when clicked
		tower3.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY,'tower3');
			hideMenu();
		});

		tower4.x = towerX - 50;
		tower4.y = towerY;
		tower4.visible = true;
		//if enough money and can build activate button
		if(money > 10 && occupied = true){

			tower4.enabled = true;

		}
		//add tower when clicked
		tower4.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY,'tower4');
			hideMenu();
		});

	}

	public function hideMenu(){

		overlay.visible = false;

		tower1.visible = false;

		tower2.visible = false;

		tower3.visible = false;

		tower4.visible = false;

	}

}