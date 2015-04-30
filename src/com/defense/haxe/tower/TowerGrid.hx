package com.defense.haxe.tower;

import starling.textures.Texture;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.TouchEvent;
import starling.events.KeyboardEvent;
import starling.events.Touch;

import com.cykon.haxe.cmath.Vector;
import com.cykon.haxe.movable.Point;
import com.cykon.haxe.movable.circle.DespawningCircle;
import com.cykon.haxe.movable.circle.TrackingCircle;
import com.cykon.haxe.movable.circle.Circle;

import com.defense.haxe.Root;
import com.defense.haxe.tower.Tower;
import com.defense.haxe.GameMenu;
import com.defense.haxe.tower.PathViewer;
import com.defense.haxe.enemy.EnemyGenerator;
import com.defense.haxe.enemy.Enemy;
import com.defense.haxe.projectile.*;
import com.defense.haxe.BuildMenu;


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

	// public var sideMenu:Texture = Root.assets.getTexture("thumb");

	/* Keep track of tile sizing */
	private var tileSize:Int;			// How big the tiles will be (excluding border)
	private var halfTileSize:Float;		// Half of the tile's true size, because screw division
	private var tileBorder:Int; 		// How big the border is around the tiles
	private var actualTileSize:Int;		// The actual size of each tile, including the border (tileSize + tileBorder*2)
	
	/* Keep track of the towers */
	private var numWidth:Int;
	private var numHeight:Int;
	private var a_Tower:Array<Tower>;
	public var lastPath:Array<Point>;

	private var money:Int;
	
	/* Keep track of the enemies */
	private var enemyGen:EnemyGenerator;
	
	/* Keep track of projectiles */
	private var a_Projectile:List<BaseProjectile> = new List<BaseProjectile>();
	
	/* Layers of operation */
	public var bgLayer:Sprite = new Sprite();
	public var baseLayer:Sprite = new Sprite();
	public var pathLayer:PathViewer;
	public var enemyLayer:EnemyGenerator = new EnemyGenerator();
	public var projectileLayer:Sprite = new Sprite();

	public var sideMenu:BuildMenu = new BuildMenu();

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
		addChild(projectileLayer);
		
		// Initiate the tower array;
		a_Tower = new Array<Tower>();
		for(i in 0...numWidth*numHeight)
			a_Tower.push(null);
		
		// Populate the tower grid()
		populateGrid();
		borderGlow();
		this.towerTouch(0,0);
		
		// sideMenu = new BuildMenu();

		/* var menu = new GameLoader();
		addChild(menu.start());
		addChild(menu.text());
		addChild(menu.button()); */

		
		this.addEventListener(TouchEvent.TOUCH, onTouch);
		this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
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
	
	public function setTowerActive(tower:Tower){
		tower.setActive();
		tower.setBGTexture(T_BG);
		fixTexture(tower.getGridX(), tower.getGridY(), true);
	}
	
	public function setTowerInactive(tower:Tower){
		tower.setActive(false);
		fixTexture(tower.getGridX(), tower.getGridY(), true);
		tower.setBGTexture(T_BLOCK);
		tower.setTexture(T_B0);
	}
	
	public function toggleTowerActive(tower:Tower){
		if(!tower.isActive()){
			setTowerActive(tower);
		} else {
			//setTowerInactive(tower);
			addChild(sideMenu.getMenu());

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
			toggleTowerActive(tower);
		}
		
		var a_Traverse = pathFind(0,0,numWidth-1,numHeight-1);
		
		if(a_Traverse != null){
			lastPath = Tower.towerListToPoint(a_Traverse);
			enemyLayer.setPath(lastPath);
			pathLayer.showPath(lastPath);
		} else {
			lastPath = null;
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
	
	public function clearTowers(){
		bgLayer.unflatten();
		baseLayer.unflatten();
		
		for(tower in a_Tower){
			setTowerInactive(tower);
		}
		
		bgLayer.flatten();
		baseLayer.flatten();
	}
	
	
	public function onKeyUp( event:KeyboardEvent ){
		switch(event.keyCode){
			case 8: // Backspace
				clearTowers();
		}
	}
	
	var prevX = -1;
	var prevY = -1;
	public function onTouch( event:TouchEvent ){
		var touch:Touch = event.touches[0];
		if(touch.phase == "began"){
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
	
	public function tryFireCannons(time:Float){
		
		for(tower in a_Tower){
			if(tower.isActive()){
				var cannonMag = 10;
				var closestVector = null;
				var closestEnemy = null;
				var closestDistance = 9999999999;
				
				for(enemy in enemyLayer.a_Enemy){
					/* var distFromTarget = Vector.getVector(tower.x, tower.y, enemy.x, enemy.y).getMag();
					var targetVector = new Vector(enemy.getVX(), enemy.getVY());
					var targetMag = targetVector.getMag();
					
					// The value forming a right triangle, which must be multiplied by the cannon and enemy magnitudes
					//	 |\
					// d | \ cannonMag*s
					//	 |__\
					//    shipMag*s
					var modValue = Math.sqrt( (distFromTarget*distFromTarget) / (cannonMag*cannonMag - targetMag*targetMag) );
					
					targetVector.multiply(modValue);
					targetVector.vx += enemy.x;
					targetVector.vy += enemy.y;
					
					var distance = tower.fireAtPoint(time, targetVector.vx, targetVector.vy); */
					
					var targetVector = Vector.getVector(tower.x, tower.y, enemy.x, enemy.y);
					var targetDistance = tower.fireAtPoint(time, targetVector.vx, targetVector.vy);
					
					if(targetDistance != -1 && targetDistance < closestDistance){
						closestDistance = targetDistance;
						closestVector = targetVector;
						closestEnemy = enemy;
					}
				}
			
				if(closestVector != null){
					// texture:Texture, x:Float, y:Float, radius:Float, stageWidth:Float, stageHeight:Float
					var directVector = Vector.getVector(tower.x, tower.y, closestVector.vx, closestVector.vy).normalize().multiply(cannonMag);
					
					var testProjectile = new BaseProjectile(T_BG, tower.x,  tower.y, 5, Root.globalStage.stageWidth, Root.globalStage.stageHeight, closestEnemy);
					testProjectile.setVelocity(directVector.vx, directVector.vy);
					testProjectile.color = 0x00FF00;
					projectileLayer.addChild(testProjectile);
					a_Projectile.push(testProjectile);
				}
			}
		}
	}
	
	/** Function called every frame update, main game logic loop */
	public function onEnterFrame( event:EnterFrameEvent ) {
		// Create a modifier based on time passed / expected time
		var modifier = event.passedTime / GameDriver.perfectDeltaTime;
		var time = flash.Lib.getTimer();
		
		enemyLayer.applyVelocity(modifier);
		
		
		for(projectile in a_Projectile){
			projectile.applyVelocity(modifier);
			
			for(enemy in enemyLayer.a_Enemy){
				if(projectile.enemyHitCheck(enemy)){
					projectile.removeFromParent();
					projectile.despawnMe = true;
				}
			} 
			
			/* if(projectile.enemyHitCheck()){
				projectile.removeFromParent();
				projectile.despawnMe = true;
			} */
			
			if(projectile.hasDespawned()){
				a_Projectile.remove(projectile);
			}
		}
		
		tryFireCannons(time);
	}
}