package com.defense.haxe.tower;

import starling.textures.Texture;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.TouchEvent;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.text.TextField;

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

	private var red_tower:Texture = Root.assets.getTexture("redtower");
	private var blue_tower:Texture = Root.assets.getTexture("bluetower");
	private var green_tower:Texture = Root.assets.getTexture("greentower");
	private var purple_tower:Texture = Root.assets.getTexture("purpletower");
	private var wall:Texture = Root.assets.getTexture("wall_button");


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

	private var lives:Int = 10;
	
	/* Keep track of projectiles */
	private var a_Projectile:List<BaseProjectile> = new List<BaseProjectile>();
	
	/* Layers of operation */
	public var bgLayer:Sprite = new Sprite();
	public var baseLayer:Sprite = new Sprite();
	public var pathLayer:PathViewer;
	public var enemyLayer:EnemyGenerator = new EnemyGenerator();
	public var projectileLayer:Sprite = new Sprite();

	public var sideMenu:BuildMenu;

	// Keep track of game state
	private var playState:Bool;

	// Data textfields
	private var moneyField:TextField;

	public function new(tileSize:Int, tileBorder:Int, numWidth:Int, numHeight:Int){
		super();
		
		sideMenu = new BuildMenu(this);
		
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
		this.towerTouch(0,0,false);
		
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
			for(tower in a_Tower){
				tower.baseImage.color  = color;
			}
			pathLayer.setColor(color);
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
		var check_tower = sideMenu.getTower();

		switch(check_tower){
			case("red"):
				tower.setTurretTexture(red_tower, "DAMAGE");
			case("green"):
				tower.setTurretTexture(green_tower, "DOT");
			case("purple"):
				tower.setTurretTexture(purple_tower, "DAMAGE");
			case("blue"):
				tower.setTurretTexture(blue_tower, "SLOW");
		}
		tower.setActive();	
		fixTexture(tower.getGridX(), tower.getGridY(), true);	
		tower.setBGTexture(T_BG);

	}
	
	public function setTowerInactive(tower:Tower){
		tower.setActive(false);
		fixTexture(tower.getGridX(), tower.getGridY(), true);
		tower.setBGTexture(T_BLOCK);
		tower.setTexture(T_B0);
		tower.setTurretTexture(null);
	}
	
	public function toggleTowerActive(tower:Tower){
		if(!tower.isActive()){
			//Use the following to grab the appropriate tower:
			// sideMenu.getTower()
			//trace(sideMenu.getTower());
			//The above trace shows the output
			setTowerActive(tower);
		} else {
			setTowerInactive(tower);
		}
	}
	
	public function towerTouch(x:Int,y:Int,setActive:Bool){
		var tower = towerAt(x,y);
				
		// Hacky for now, but these are start / end points (for now)
		if(!(x == 0 && y == 0 || x == numWidth-1 && y == numHeight-1)){			
			//toggleTowerActive(tower);
			if(setActive){
				setTowerActive(tower);
			} else {
				setTowerInactive(tower);
			}
			
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
		
		for(tower in a_Tower){
			setTowerInactive(tower);
		}
	}
	
	
	public function onKeyUp( event:KeyboardEvent ){
		//trace(event.keyCode);
		switch(event.keyCode){
			case 8: // Backspace
				clearTowers();
			case 27:
				stopPreviewingTower();
			case 32:
				if(lastPath != null){
					var enemy = new Enemy(Root.assets.getTexture("enemy"), 0, 0, 16, 5);
						enemy.setPoints(lastPath);
					this.addChild(enemy);
					
					enemyLayer.a_Enemy.push(enemy);
				}
			case 38:
				enemyLayer.resetTime();
		}
	}
	
	public function stopPreviewingTower(){
		removePreviewTower();
		sideMenu.placing = false;
		prevX = -1;
		prevY = -1;
		prevActive = false;
	}
	
	public function removePreviewTower(){
		if(validLocation(prevX,prevY)){
			if ( prevActive ){
				towerAt(prevX, prevY).setTurretTexture(null);
			} else if (prevX != -1 && prevY != -1) {
				towerTouch(prevX, prevY, false);
			}			
		}
	}
	
	var lastClickTime = -999;
	var prevActive = false;
	var prevX = -1;
	var prevY = -1;
	public function onTouch( event:TouchEvent ){
		var touch: Touch = event.touches[0];
		
		// Get the tower grid we're trying to click
		var towerX = Math.floor((touch.globalX - this.x) / (tileSize + tileBorder));
		var towerY = Math.floor((touch.globalY - this.y) / (tileSize + tileBorder));
		
		// If it's a valid tower
		if (validLocation(towerX, towerY)) {
		    var tower = towerAt(towerX,towerY);
			
			// If we're in the placing state
			if (sideMenu.placing) {
		        
				// Update the tower preview
				if ((!tower.isActive() || (!tower.hasTurret()) && sideMenu.getTower() != "wall") && !(towerX == prevX && towerY == prevY) && sideMenu.canPurchase()) {
		            removePreviewTower();
		            prevX = towerX;
		            prevY = towerY;
		            prevActive = tower.isActive();
					towerTouch(towerX, towerY, true);
		        }
				
				// Finish the placing state on click
				if(touch.phase == "ended" && lastPath != null){
					prevX = -1;
					prevY = -1;
					prevActive = false;
				}
		    } else if( touch.phase == "ended" ){
				
				// Detect a double click
				var curTime = flash.Lib.getTimer();
				if(curTime - lastClickTime < 250){
					if(tower.hasTurret()){
						tower.setTurretTexture(null);
					} else if (tower.isActive()){
						setTowerInactive(tower);
					}
				
				}
				lastClickTime = curTime;
			}
			
		} else {
			removePreviewTower();
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
			if(tower.hasTurret() && tower.isActive()){
				var cannonMag = 10;
				var closestVector = null;
				var closestEnemy = null;
				var closestDistance = {'canFire':false, 'distance':99999.99};
				
				for(enemy in enemyLayer.a_Enemy){
					var targetVector = Vector.getVector(tower.x, tower.y, enemy.x, enemy.y);
					var tObject = tower.fireAtPoint(time, targetVector.vx, targetVector.vy);
						
					if(!(closestDistance.canFire && !tObject.canFire)){
						
						if(tObject.distance != -1 && (tObject.canFire && !closestDistance.canFire) || tObject.distance < closestDistance.distance){
							closestDistance.canFire = tObject.canFire;
							closestDistance.distance = tObject.distance;
							closestVector = targetVector;
							closestEnemy = enemy;
						}
					}
				}
			
				if(closestVector != null){
					// texture:Texture, x:Float, y:Float, radius:Float, stageWidth:Float, stageHeight:Float
					var directVector = Vector.getVector(tower.x, tower.y, closestVector.vx, closestVector.vy).normalize().multiply(cannonMag);
						
					if(closestDistance.canFire){
						tower.setLastFireTime(time);

						var projectile = tower.getProjectile(closestEnemy);
						projectile.setVelocity(directVector.vx, directVector.vy);
						projectile.color = 0x00FF00;
						projectileLayer.addChild(projectile);
						a_Projectile.push(projectile);
					}
					
					tower.setTurretAngle(closestVector.getAngle());
				}
			}
		}
	}
	public function initializeMenu(){
		addChild(sideMenu);
	}
	
	/** Function called every frame update, main game logic loop */
	public function onEnterFrame( event:EnterFrameEvent ) {
		// Create a modifier based on time passed / expected time
		var modifier = event.passedTime / GameDriver.perfectDeltaTime;
		var time = flash.Lib.getTimer();

		
		enemyLayer.applyVelocity(modifier);
		enemyLayer.timeUpdate(time);
		
		
		for(projectile in a_Projectile){
			projectile.applyVelocity(modifier);
			projectile.trackingEnemyUpdate();
			
			for(enemy in enemyLayer.a_Enemy){
				if(projectile.enemyHitCheck(enemy)){
					projectile.removeFromParent();
					projectile.despawnMe = true;
					break;
				}
			}
			
			if(projectile.hasDespawned()){
				a_Projectile.remove(projectile);
			}
		}
		
		tryFireCannons(time);
	}
}