package com.defense.haxe.tower;

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
	
	public function new(texture:Texture, size:Int, gridX, gridY, gridIndex){
		super();
		
		this.gridX = gridX;
		this.gridY = gridY;
		this.gridIndex = gridIndex;
		
		baseImage = new Image(texture);
		this.width = this.height = baseImage.width = baseImage.height = size;
		baseImage.pivotX = size/2;
		baseImage.pivotY = size/2;
		addChild(baseImage);
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
	
	public function click(){		
	}
}