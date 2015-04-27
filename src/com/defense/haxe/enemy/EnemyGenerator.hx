package com.defense.haxe.enemy;

import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.EnterFrameEvent;
import com.defense.haxe.enemy.Enemy;
import com.defense.haxe.tower.TowerGrid;
import com.defense.haxe.tower.Tower;
import com.cykon.haxe.movable.Point;

class EnemyGenerator extends Sprite {
	private var enemy:Enemy;
	private var currentPath:Array<Point>;
	public var a_Enemy:List<Enemy> = new List();

	public function new(){
		super();
		Root.globalStage.addEventListener(KeyboardEvent.KEY_DOWN, generate);		
	}

	public function generate(){
		if(currentPath != null){
			var enemy = new Enemy(Root.assets.getTexture("enemy"), 0,0, 16);
			enemy.setPoints(currentPath);
			
			this.addChild(enemy);
			a_Enemy.push(enemy);
		}
	}

	public function applyVelocity(modifier:Float){
		for(enemy in a_Enemy){
			enemy.applyVelocity(modifier);
			
			if(enemy.isComplete()){
				enemy.removeFromParent(true);
				a_Enemy.remove(enemy);
			}
		}
	}

	public function setPath(path:Array<Point>){
		currentPath = path;
	}
}