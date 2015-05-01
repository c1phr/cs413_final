package com.defense.haxe.enemy;

import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.EnterFrameEvent;
import com.defense.haxe.enemy.Enemy;
import com.defense.haxe.tower.TowerGrid;
import com.defense.haxe.tower.Tower;
import com.cykon.haxe.movable.Point;
import com.defense.haxe.tower.TowerType;
import starling.events.Event;

class EnemyGenerator extends Sprite {
	private var enemy:Enemy;
	private var currentPath:Array<Point>;
	private var currentEnemy:Int = 0;
	public var a_Enemy:List<Enemy> = new List();

	private var towers:Array<TowerType>;
	private var enemies:Array<EnemyType>;

	private var time:Float;

	public function new(){
		super();
		Root.globalStage.addEventListener(KeyboardEvent.KEY_DOWN, generate);

		var objectParser = new ObjectParser();
		// Events because Flash IO is async
		objectParser.dispatcher.addEventListener("TowerJsonReady", function(e:Event){
				this.towers = e.data.value;							
			});
		objectParser.dispatcher.addEventListener("EnemyJsonReady", function(e:Event){
				this.enemies = e.data.value;				
			});
	}

	public function generate(time:Float){
		if(currentPath != null){
			if(currentEnemy < enemies.length && enemies[currentEnemy].time < time){
				trace(time);
				var enemyTexture = Root.assets.getTexture(enemies[currentEnemy].texture);
				var enemy = new Enemy(enemyTexture, 0, 0, 16, enemies[currentEnemy].speed);
				enemy.setPoints(currentPath);
						
				this.addChild(enemy);
				a_Enemy.push(enemy);
				currentEnemy+=1;
			}
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

	public function timeUpdate(time:Float){
		this.time = time;
		generate(time);
	}
}