package com.defense.haxe.enemy;

import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.EnterFrameEvent;
import com.defense.haxe.enemy.Enemy;
import com.defense.haxe.tower.TowerGrid;
import com.defense.haxe.tower.Tower;
import com.cykon.haxe.movable.Point;

class EnemyGenerator extends Sprite{
	private var enemy:Enemy;
	private var currentPath:Array<Point>;
	private var enemyArray:Array<Enemy> = new Array();
	private var enemyCount:Int = 0;

	public function new(path:Array<Point>){
		super();
		currentPath = path;
		Root.globalStage.addEventListener(KeyboardEvent.KEY_UP, generate);
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		
	}

	public function generate(){
		var enemy = new Enemy(Root.assets.getTexture("enemy"), 0,0, 16);
		enemyArray.push(enemy);
		enemyArray[enemyCount].setPoints(currentPath);
		this.addChild(enemyArray[enemyCount]);
		enemyCount += 1;
	}

	public function applyVelocity(modifier:Float){
		if(enemyCount > 0){
			for(i in 0...enemyCount){
				enemyArray[i].applyVelocity(modifier);
			}
		}
	}

	public function setPath(path:Array<Point>){
		currentPath = path;
	}

	public function onEnterFrame(event:EnterFrameEvent){
		for (i in 0...enemyCount){
			if(enemyArray[i].isComplete()){
				enemyArray[i].removeFromParent(true);
				//trace(enemyArray.length);
			}
		}
	}
}