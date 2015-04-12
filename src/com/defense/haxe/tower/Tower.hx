package com.defense.haxe.tower;

import com.cykon.haxe.movable.Point;
import starling.textures.Texture;
import starling.display.Sprite;
import starling.display.Image;


class Tower extends Sprite{
	public var baseImage:Image;
	private var active:Bool = false;
	
	// Used to keep track of where this tower exists in the TowerGrid array
	private var gridX:Int;
	private var gridY:Int;
	private var gridIndex:Int;
	
	// Public variables used in pathfinding
	public var prevTower:Tower;
	public var distance:Int;
	
	public function new(texture:Texture, size:Int, gridX:Int, gridY:Int, gridIndex:Int){
		super();
		
		this.gridX = gridX;
		this.gridY = gridY;
		this.gridIndex = gridIndex;
		
		baseImage = new Image(texture);
		baseImage.width = baseImage.height = size;
		addChild(baseImage);
		
		this.pivotX = this.pivotY = size / 2;
		
		baseImage.pivotX = baseImage.pivotY = texture.width / 2; // TIL pivots are about the texture's size, not the image's
		baseImage.x = baseImage.y = size / 2;
		
	}
	
	public function getGridX():Int		{ return gridX; }
	public function getGridY():Int		{ return gridY; }
	public function getGridIndex():Int	{ return gridIndex; }
	
	public function isActive():Bool{
		return active;
	}
	
	public function setActive(active = true){
		this.active = active;
	}
	
	public function setTexture(texture:Texture = null){
		baseImage.texture = texture;
	}
	
	// Four bit number: right << bottom << left << top
	public function fixTexture(towerMask:Int, towerGrid:TowerGrid){
		trace(towerMask);
	
		switch(towerMask){
			case 0: //
				baseImage.texture = towerGrid.T_B4;
			case 1: //
				baseImage.texture = towerGrid.T_B1;
				baseImage.rotation = Math.PI/2;
			case 2: //
				baseImage.texture = towerGrid.T_B1;
				baseImage.rotation = Math.PI;
			case 3: //
				baseImage.texture = towerGrid.T_B2;
				baseImage.rotation = Math.PI/2;
			case 4: //
				baseImage.texture = towerGrid.T_B1;
				baseImage.rotation = -Math.PI/2;
			case 5: //
				baseImage.texture = towerGrid.T_B2P;
				baseImage.rotation = 0;
			case 6: //
				baseImage.texture = towerGrid.T_B2;
				baseImage.rotation = Math.PI;
			case 7: //
				baseImage.texture = towerGrid.T_B3;
				baseImage.rotation = Math.PI;
			case 8: //
				baseImage.texture = towerGrid.T_B1;
				baseImage.rotation = 0;
			case 9: //
				baseImage.texture = towerGrid.T_B2;
				baseImage.rotation = 0;
			case 10: //
				baseImage.texture = towerGrid.T_B2P;
				baseImage.rotation = Math.PI/2;
			case 11: //
				baseImage.texture = towerGrid.T_B3;
				baseImage.rotation = Math.PI/2;
			case 12: //
				 baseImage.texture = towerGrid.T_B2;
				 baseImage.rotation = -Math.PI/2;
			case 13: //
				baseImage.texture = towerGrid.T_B3;
				baseImage.rotation = 0;
			case 14: //
				baseImage.texture = towerGrid.T_B3;
				baseImage.rotation = -Math.PI/2;
			case 15: //
				baseImage.texture = towerGrid.T_B0;
				baseImage.rotation = 0;
		}
	}

	public static function towerListToPoint(t_List:List<Tower>):List<Point>{
		var p_List = new List<Point>();
		for(tower in t_List){
			p_List.add( new Point(tower.x, tower.y) );
		}
		return p_List;
	}
}