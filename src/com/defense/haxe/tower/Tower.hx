package com.defense.haxe.tower;

import com.cykon.haxe.cmath.Vector;
import com.cykon.haxe.movable.Point;
import starling.textures.Texture;
import starling.display.Sprite;
import starling.display.Image;


class Tower extends Sprite{
	private static var TWO_PI:Float = 6.283185;
	
	public var baseImage:Image;
	public var bgImage:Image; // This will be attached to a different sprite.
	private var bgLayer:Sprite;
	private var active:Bool = false;
	
	// Used to keep track of where this tower exists in the TowerGrid array
	private var gridX:Int;
	private var gridY:Int;
	private var gridIndex:Int;
	
	// Public variables used in pathfinding
	public var prevTower:Tower;
	public var distance:Int;
	
	// Variables handling the firing of projectiles
	private var cooldown:Float = 1000;
	private var firingDistance:Float = 300;
	private var lastFireTime:Float = -9999;
	
	public function new(texture:Texture, bgLayer:Sprite, size:Int, gridX:Int, gridY:Int, gridIndex:Int){
		super();
		
		this.gridX = gridX;
		this.gridY = gridY;
		this.gridIndex = gridIndex;
		this.bgLayer = bgLayer;
		
		baseImage = new Image(texture);
		baseImage.width = baseImage.height = size;
		baseImage.pivotX = baseImage.pivotY = size / 2;
		addChild(baseImage);
		
		this.pivotX = this.pivotY = size / 2;
		
		baseImage.pivotX = baseImage.pivotY = size / 2; // TIL pivots are about the texture's size, not the image's
		baseImage.x = baseImage.y = size / 2;
		
	}
	
	public function getGridX():Int		{ return gridX; }
	public function getGridY():Int		{ return gridY; }
	public function getGridIndex():Int	{ return gridIndex; }
	
	public function isActive():Bool{
		return active;
	}
	
	/** Maximum firing distance */
	public function setFiringDistance(firingDistance:Float){
		if(firingDistance > 0){
			this.firingDistance = firingDistance;
		}
	}
	
	public function setActive(active = true){
		this.active = active;
		
		if(active){
			baseImage.color = 0x00CCFF;
		} else {
			baseImage.color = 0xFFFFFF;
		}
	}
	
	public function setBGTexture(texture:Texture = null){
		if(bgImage == null){
			bgImage = new Image(texture);
			bgImage.width = bgImage.height = this.width;
			bgImage.pivotX = bgImage.pivotY = this.pivotX;
			bgImage.x = this.x;
			bgImage.y = this.y;
			bgLayer.addChild(bgImage);
		} else {
			bgImage.texture = texture;
		}
	}
	
	public function setTexture(texture:Texture = null){
		baseImage.texture = texture;
	}

	/** Attempts to fire at a point if it is within the dist & angle */
	public function fireAtPoint(time:Float, x:Float, y:Float):Float{
		if(time - lastFireTime >= cooldown){
						
			// Translate (0,0) from the cannon's space to the world's space
			var worldPos = getTransformationMatrix(this.parent.parent).transformPoint(new flash.geom.Point());
			// Get the direct vector of the cannon to the target point
			var directVector = Vector.getVector(x, y, worldPos.x, worldPos.y);	
			
			// If we're in range...
			if(directVector.getMag() <= firingDistance){
				lastFireTime = time;
				return directVector.getMag();
			}
		}
		
		return -1;
	}
	
	// Four bit number: right << bottom << left << top
	public function fixTexture(towerMask:Int, towerGrid:TowerGrid){

		switch(towerMask){
			case 0: //
				baseImage.texture = towerGrid.T_B0;
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
				baseImage.texture = towerGrid.T_B4;
				baseImage.rotation = 0;
		}
	}

	public static function towerListToPoint(t_List:List<Tower>):Array<Point>{
		var p_List = new Array<Point>();
		for(tower in t_List){
			p_List.push(new Point(tower.x, tower.y));
		}
		return p_List;
	}
}