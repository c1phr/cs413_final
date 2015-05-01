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
	private var moneyField:TextField;
	private var towerDescr:TextField;

	private var selectedTower:String = "";

	public var money:Int = 500;

	public var redCost:Int = 30;
	public var blueCost:Int = 10;
	public var greenCost:Int = 15;
	public var purpleCost:Int = 10;
	public var wallCost:Int = 5;

	private var towerGrid:TowerGrid;
	public var placing = false;


	public function new(towerGrid:TowerGrid){
		super();
		this.towerGrid = towerGrid;
		var redtower = 		new Button(Root.assets.getTexture("redtower"));
		var greentower = 	new Button(Root.assets.getTexture("bluetower"));
		var bluetower = 	new Button(Root.assets.getTexture("greentower"));
		var purpletower = 	new Button(Root.assets.getTexture("purpletower"));
		var wall = 			new Button(Root.assets.getTexture("wall_button"));
		var cancel = 		new Button(Root.assets.getTexture("cancel"));
				
		var a_Button = [wall, redtower, greentower, bluetower, purpletower, cancel];
		
		for(i in 0...a_Button.length){
			var button = a_Button[i];
			button.x = -36;
			button.y = 20 + 44*i;
			button.pivotX = button.width/2;
			button.pivotY = button.height/2;
			button.visible = true;
			button.enabled = true;
			button.alphaWhenDisabled = .5;
			addChild(button);	
		}
		
		cancel.y += 20;

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
		cancel.addEventListener(Event.TRIGGERED, towerGrid.stopPreviewingTower);
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
}