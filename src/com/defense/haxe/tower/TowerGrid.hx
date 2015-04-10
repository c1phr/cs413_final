package com.defense.haxe.tower;

import starling.textures.Texture;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.Touch;

import com.defense.haxe.Root;
import com.defense.haxe.tower.Tower;

class TowerGrid extends Sprite{
	/* Tower textures */
	private var T_BLOCK:Texture = Root.assets.getTexture("block");
	private var T_ACTIVE_BLOCK:Texture = Root.assets.getTexture("block_active");
	
	/* Keep track of tile sizing */
	private var tileSize:Int;			// How big the tiles will be (excluding border)
	private var halfTileSize:Float;		// Half of the tile's true size, because screw division
	private var tileBorder:Int; 		// How big the border is around the tiles
	private var actualTileSize:Int;		// The actual size of each tile, including the border (tileSize + tileBorder*2)
	
	/* Keep track of the towers */
	private var numWidth:Int;
	private var numHeight:Int;
	private var a_Tower:Array<Tower>;
	
	public function new(tileSize:Int, tileBorder:Int, numWidth:Int, numHeight:Int){
		super();
		
		this.tileSize = tileSize;
		this.tileBorder = tileBorder;
		this.halfTileSize = tileSize / 2.0;
		this.actualTileSize = tileSize + tileBorder*2;
		
		this.numWidth = numWidth;
		this.numHeight = numHeight;
		this.width = numWidth*tileSize;
		this.height = numHeight*tileSize;
		
		// Initiate the tower array;
		a_Tower = new Array<Tower>();
		for(i in 0...numWidth*numHeight)
			a_Tower.push(null);
		
		// Populate the tower grid()
		populateGrid();
		
		this.addEventListener(TouchEvent.TOUCH, onTouch);
	}
	
	private function populateGrid(){
		for(x in 0...numWidth)
			for(y in 0...numHeight){
				var tower = new Tower(T_BLOCK, actualTileSize);
				tower.x = x*tileSize + actualTileSize/2;
				tower.y = y*tileSize + actualTileSize/2;
				a_Tower[x + y*numWidth] = tower;
				addChild(tower);
			}
	}
	
	public function towerTouch(x:Int,y:Int){
		var tower = towerAt(x,y);
		
		if(!tower.isActive()){
			tower.setTexture(T_ACTIVE_BLOCK);
			tower.setActive();
		} else {
			tower.setTexture(T_BLOCK);
			tower.setActive(false);
		}
	}
	
	public function onTouch( event:TouchEvent ){
		var touch:Touch = event.touches[0];
		if(touch.phase == "ended"){
			var towerX = Math.floor((touch.globalX - this.x)/tileSize);
			var towerY = Math.floor((touch.globalY - this.y)/tileSize);
			towerTouch(towerX, towerY);
		}
	}
	
	public function towerAt(x:Int,y:Int):Tower{
		return a_Tower[x + y*numWidth];
	}
}