package com.defense.haxe;

import starling.textures.Texture;
import starling.events.EnterFrameEvent;
import starling.events.KeyboardEvent;
import starling.events.TouchEvent;
import starling.events.Event;
import starling.display.Sprite;
import starling.display.Button;
import flash.system.System;
import starling.text.TextField;

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
	private var wall:Button;
	private var sell:Button;
	private var moneyField:TextField;

	private var towerDescr:TextField;

	private var background = new Quad(550, 400, 0x000000);

	private var selectedTower:String = "";

	public var money:Int = 500;

	public var redCost:Int = 30;
	public var blueCost:Int = 10;
	public var greenCost:Int = 15;
	public var purpleCost:Int = 10;
	public var wallCost:Int = 5;

	private var rTexture:Texture = Root.assets.getTexture("redtower");
	private var bTexture:Texture = Root.assets.getTexture("bluetower");
	private var gTexture:Texture = Root.assets.getTexture("greentower");
	private var pTexture:Texture = Root.assets.getTexture("purpletower");
	private var wTexture:Texture = Root.assets.getTexture("wall_button");

	public var placing = false;


	public function new(){
		super();
		redtower = new Button(rTexture);
		greentower = new Button(gTexture);
		bluetower = new Button(bTexture);
		purpletower = new Button(pTexture);
		wall = new Button(wTexture);
		var a_Button = [wall, redtower, greentower, bluetower, purpletower];
		
		for(i in 0...a_Button.length){
			var button = a_Button[i];
			button.x = -30;
			button.y = 18 + 45*i;
			button.pivotX = button.width/2;
			button.pivotY = button.height/2;
			button.visible = true;
			button.enabled = true;
			button.alphaWhenDisabled = .5;
			addChild(button);	
		}

		towerDescr = new TextField(300, 100, "","Arial", 16, 0xFFFFFF);
		towerDescr.text = "";
		towerDescr.y = 350;
		towerDescr.x = 0;
		addChild(towerDescr);

		moneyField = new TextField(300, 100, "","font", 30, 0xFFFFFF);
		moneyField.text = "$" + money;
		moneyField.y = -85;
		addChild(moneyField);

		redtower.addEventListener(Event.TRIGGERED, function(){addTower("red");});
		bluetower.addEventListener(Event.TRIGGERED, function(){addTower("blue");});
		greentower.addEventListener(Event.TRIGGERED, function(){addTower("green");});
		purpletower.addEventListener(Event.TRIGGERED, function(){addTower("purple");});
		wall.addEventListener(Event.TRIGGERED, function(){addTower("wall");});
	}

	public function addTower(tower){
		selectedTower = tower;
		switch(tower){
			case("red"):
				(money < redCost) ? towerDescr.text = "Not Enough Money!": towerDescr.text = "Speed Tower";
			case("blue"):
				(money < blueCost) ? towerDescr.text = "Not Enough Money!" : towerDescr.text = "Ice Tower";
			case("green"):
				(money < greenCost) ? towerDescr.text = "Not Enough Money!": towerDescr.text = "Bio Tower";
			case("purple"):
				(money < purpleCost) ? towerDescr.text = "Not Enough Money!" : towerDescr.text = "Splash Tower";
			case("wall"):
				(money < wallCost) ? towerDescr.text = "Not Enough Money!" : towerDescr.text = "Wall";	
			case("sell"):
				towerDescr.text = "Sell Tower";

		}
		placing = true;
	}

	public function getTower():String{
		return selectedTower;
	}

	public function subtractMoney(tower:String){
		money -= 30;
		moneyField.text = "$" + money;
	}

	public function canPurchase():Bool{
		var this_tower = getTower();

		switch(this_tower){
			case("red"):
				(money < redCost) ? return false: return true;
			case("blue"):
				(money < blueCost) ? return false: return true;
			case("green"):
				(money < greenCost) ? return false: return true;
			case("purple"):
				(money < purpleCost) ? return false: return true;
			case("wall"):
				(money < wallCost) ? return false: return true;
		}
				return false;

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
		/* redtower.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY);
			hideMenu();
		}); */
		
		bluetower.x = towerX + 50;
		bluetower.y = towerY;
		bluetower.visible = true;
		//if enough money and can build activate button
		if(money > 20 && occupied == true){

			bluetower.enabled = true;

		}
		//add tower when clicked
		/* bluetower.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY);
			hideMenu();
		}); */

		greentower.x = towerX;
		greentower.y = towerY - 50;
		greentower.visible = true;
		//if enough money and can build activate button
		if(money > 30 && occupied == true){

			greentower.enabled = true;

		}
		//add tower when clicked
		/* greentower.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY);
			hideMenu();
		}); */

		purpletower.x = towerX - 50;
		purpletower.y = towerY;
		purpletower.visible = true;
		//if enough money and can build activate button
		if(money > 10 && occupied == true){

			purpletower.enabled = true;

		}
		//add tower when clicked
		/* purpletower.addEventListener(Event.TRIGGERED, function(){
			grid.towerTouch(towerX,towerY);
			hideMenu();
		}); */

	}

	public function hideMenu(){

		overlay.visible = false;

		redtower.visible = false;

		bluetower.visible = false;

		greentower.visible = false;

		purpletower.visible = false;

	}

}