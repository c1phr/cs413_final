package com.defense.haxe.tower;

import starling.textures.Texture;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.Touch;

import com.defense.haxe.Root;
import com.defense.haxe.tower.Tower;
import com.defense.haxe.GameLoader;
import com.defense.haxe.tower.PathViewer;

class TowerGrid extends Sprite{
	/* Tower textures */
	public var T_BLOCK:Texture = Root.assets.getTexture("block");
	public var T_ACTIVE_BLOCK:Texture = Root.assets.getTexture("block_active");
	
	// Four bit number: right << bottom << left << top
	
	public var T_B0:Texture  = Root.assets.getTexture("border_0");
	public var T_B1:Texture  = Root.assets.getTexture("border_1");
	public var T_B2:Texture  = Root.assets.getTexture("border_2");
	public var T_B2P:Texture = Root.assets.getTexture("border_2p");
	public var T_B3:Texture  = Root.assets.getTexture("border_3");
	public var T_B4:Texture  = Root.assets.getTexture("border_4");
	public var T_BG:Texture = Root.assets.getTexture("border_background");

	/* Keep track of tile sizing */
	private var tileSize:Int;			// How big the tiles will be (excluding border)
	private var halfTileSize:Float;		// Half of the tile's true size, because screw division
	private var tileBorder:Int; 		// How big the border is around the tiles
	private var actualTileSize:Int;		// The actual size of each tile, including the border (tileSize + tileBorder*2)
	
	/* Keep track of the towers */
	private var numWidth:Int;
	private var numHeight:Int;
	private var a_Tower:Array<Tower>;
	
	/* Layers of operation */
	public var bgLayer:Sprite = new Sprite();
	public var baseLayer:Sprite = new Sprite();
	public var pathLayer:PathViewer;
	public var enemyLayer:Sprite = new Sprite();
	
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
		
		// Add the different layers
		pathLayer = new PathViewer(50, 0.35, 0.05, Root.assets.getTexture("path"));
		addChild(bgLayer);
		addChild(baseLayer);
		addChild(pathLayer);
		addChild(enemyLayer);
		
		// Initiate the tower array;
		a_Tower = new Array<Tower>();
		for(i in 0...numWidth*numHeight)
			a_Tower.push(null);
		
		// Populate the tower grid()
		populateGrid();
		borderGlow();
		this.towerTouch(0,0);
		var menu = new GameLoader();
		addChild(menu.start());
		addChild(menu.text());
		addChild(menu.button());
		
		this.addEventListener(TouchEvent.TOUCH, onTouch);
	}
	
	private var br = 0x00;
	private var bg = 0xAA;
	private var bb = 0xFF;
	private var direction = 1;
	public function borderGlow(){
		var timer = new haxe.Timer(25);
		timer.run = function(){
			
			bg += direction;
			if(bg > 0xFF){
				bg = 0xFF;
				direction = -1;
			} else if(bg < 0x99){
				bg = 0x99;
				direction = 1;
			}
			
			var color = (br << 16) + (bg << 8) + bb;
			baseLayer.unflatten();
			for(tower in a_Tower){
				tower.baseImage.color  = color;
			}
			pathLayer.setColor(color);
			baseLayer.flatten();
		}
	}
	
	private function populateGrid(){
		var bgTexture = Root.assets.getTexture("border_background");
		var halfSize = Math.ceil(actualTileSize/2);
		for(x in 0...numWidth)
			for(y in 0...numHeight){
				var tower = new Tower(T_B0, bgLayer, actualTileSize, x, y, x+y*numWidth);
				tower.x = x*(tileSize + tileBorder) + halfSize;
				tower.y = y*(tileSize + tileBorder) + halfSize;
				tower.setBGTexture(T_BLOCK);
				
				a_Tower[x + y*numWidth] = tower;
				baseLayer.addChild(tower);
			}
	}
	
	public function towerTouch(x:Int,y:Int){
		bgLayer.unflatten();
		baseLayer.unflatten();
		var tower = towerAt(x,y);
		
		// Debug reset path color...
		//for(tower in a_Tower)
		//	tower.baseImage.color = 0xFFFFFF; 
				
		// Hacky for now, but these are start / end points (for now)
		if(!(x == 0 && y == 0 || x == numWidth-1 && y == numHeight-1)){			
			if(!tower.isActive()){
				tower.setActive();
				tower.setBGTexture(T_BG);
				fixTexture(x,y, true);
			} else {
				tower.setActive(false);
				fixTexture(x,y, true);
				tower.setBGTexture(T_BLOCK);
				tower.setTexture(T_B0);
			}
		}
		
		var a_Traverse = pathFind(0,0,numWidth-1,numHeight-1);
		
		if(a_Traverse != null){
			pathLayer.showPath(Tower.towerListToPoint(a_Traverse));
		} else {
			// trace("No path.");
			pathLayer.stopShowingPath();
		}
		
		bgLayer.flatten();
		baseLayer.flatten();
	}
	
	public function validLocation(x:Int,y:Int):Bool{
		return(x > -1 && x < numWidth && y > -1 && y < numHeight);
	}
	
	public function pathFind(startX:Int, startY:Int, endX:Int, endY:Int):List<Tower>{
		if(!validLocation(startX,startY) || !validLocation(endX, endY)){
			trace("ERROR: INVALID START / END POINTS.");
			return null;
		}
		
		// Create the iterative list
		var a_Traverse:List<Tower> = new List<Tower>();
		
		// Reset the tower pathing variables
		for(tower in a_Tower){
			tower.prevTower = null;
			tower.distance = -1;
		}
		
		// Set up the first tower
		var startTower = towerAt(startX, startY);
		startTower.distance = 0;
		a_Traverse.add(startTower);
		
		var counter = 0;
		while(a_Traverse.length > 0){
			var tower = a_Traverse.first();
			var towerX = tower.getGridX();
			var towerY = tower.getGridY();
			
			pathFindCheckTower(tower, towerX+1, towerY, a_Traverse); // Right
			pathFindCheckTower(tower, towerX, towerY+1, a_Traverse); // Down
			pathFindCheckTower(tower, towerX-1, towerY, a_Traverse); // Left
			pathFindCheckTower(tower, towerX, towerY-1, a_Traverse); // Up
			a_Traverse.pop();
			counter++;
		}
		
		// Check to see if there is no path available
		var lastTower = towerAt(endX, endY);
		if(lastTower.distance == -1){
			return null;
		}
		
		// Populate the path list for returning
		a_Traverse.clear();
		a_Traverse.push( lastTower );
		while(a_Traverse.first() != startTower){
			a_Traverse.push( a_Traverse.first().prevTower );
		}
		
		//trace(counter, a_Traverse.length);
		return a_Traverse;
	}
	
	private function pathFindCheckTower(curTower:Tower, nextX:Int, nextY:Int, a_Traverse:List<Tower>){
		if(validLocation(nextX, nextY)){
			var tower = towerAt(nextX,nextY);
			
			if(!tower.isActive() && (tower.distance == -1 || tower.distance > curTower.distance+1)){
				tower.prevTower = curTower;
				tower.distance = curTower.distance + 1;
				a_Traverse.add(tower);
			}
		}
	}
	
	
	var prevX = -1;
	var prevY = -1;
	public function onTouch( event:TouchEvent ){
		var touch:Touch = event.touches[0];
		if(touch.phase == "began" || touch.phase == "moved" || touch.phase == "ended"){
			var towerX = Math.floor((touch.globalX - this.x)/(tileSize+tileBorder));
			var towerY = Math.floor((touch.globalY - this.y)/(tileSize+tileBorder));
			
			if(!(towerX == prevX && towerY == prevY && touch.phase != "began") && validLocation(towerX,towerY)){
				prevX = towerX;
				prevY = towerY;
				towerTouch(towerX, towerY);
			}
		}
	}
	
	public function fixTexture(x:Int, y:Int, fixOthers:Bool=false){
		var thisTower = towerAt(x,y);
		if(thisTower != null && thisTower.isActive()){
			var t0 = (!validLocation(x+1,y) || !towerAt(x+1,y).isActive()) ? 1 : 0;
			var t1 = (!validLocation(x,y-1) || !towerAt(x,y-1).isActive()) ? 1 : 0;
			var t2 = (!validLocation(x-1,y) || !towerAt(x-1,y).isActive()) ? 1 : 0;
			var t3 = (!validLocation(x,y+1) || !towerAt(x,y+1).isActive()) ? 1 : 0;
			
			var towerMask = (t0 << 3) + (t1 << 2) + (t2 << 1) + t3;
			thisTower.fixTexture(towerMask, this);
		}
		
		if(fixOthers) {
			fixTexture(x+1,y);
			fixTexture(x,y-1);
			fixTexture(x-1,y);
			fixTexture(x,y+1);
		}
	}
	
	public function towerAt(x:Int,y:Int):Tower{
		return validLocation(x,y) ? a_Tower[x + y*numWidth] : null;
	}
}