package com.defense.haxe.enemy;

import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.text.TextField;

import com.defense.haxe.enemy.Enemy;
import com.defense.haxe.tower.TowerGrid;
import com.defense.haxe.tower.Tower;
import com.cykon.haxe.movable.Point;
import com.defense.haxe.tower.TowerType;

class EnemyGenerator extends Sprite {
	private var objectParser:ObjectParser;
	private var enemy:Enemy;
	private var currentPath:Array<Point>;
	private var currentEnemy:Int = 0;
	public var a_Enemy:List<Enemy> = new List();

	//Holds the wave
	private var enemies:Array<EnemyType>;
	private var waves:Array<String> = new Array<String>();

	private var currentWave:Int = 0;

	// Timing variables
	private var startTime:Float;
	private var realTime:Float;
	private var time:Float;

	// Lives variable
	private var lives:Int = 10;

	// Remaining enemies
	private var remaining:Int;

	// tells whether or not to generate waves
	private var isPlaying:Bool = false;

	public function new(){
		super();

		for (i in 0...5){
			waves.push("wave" + (i + 1));
		}

		Root.globalStage.addEventListener(KeyboardEvent.KEY_DOWN, generate);
		objectParser = new ObjectParser();

		pullJson();


	}

	public function generate(time:Float){
		if(isPlaying == true){
			if(currentEnemy == 0){
				
			}
			if(currentPath != null){
				if(currentEnemy < enemies.length && enemies[currentEnemy].time < realTime){
					var enemyTexture = Root.assets.getTexture(enemies[currentEnemy].texture);
					var enemy = new Enemy(enemyTexture, 0, 0, 16, enemies[currentEnemy].speed);
					enemy.setPoints(currentPath);
							
					this.addChild(enemy);
					a_Enemy.push(enemy);
					currentEnemy+=1;
				}
			}
		}
	}

	public function applyVelocity(modifier:Float){
		for(enemy in a_Enemy){
			enemy.applyVelocity(modifier);
			
			if(enemy.isComplete()){
				enemy.removeFromParent(true);
				a_Enemy.remove(enemy);
				lives -= 1;
			}

			if(enemy.getDead()){
				enemy.removeFromParent(true);
				a_Enemy.remove(enemy);
			}

			if(lives <= 0){
				isPlaying = false;
			}
			remaining = a_Enemy.length;

			if(remaining == 0 && currentEnemy == enemies.length && currentWave < waves.length){
				trace("Wave complete");
				currentEnemy = 0;
				currentWave += 1;
				resetTime();
				pullJson();
				isPlaying = false;
			}
		}
	}

	public function setPath(path:Array<Point>){
		currentPath = path;
	}

	public function timeUpdate(time:Float){
		this.time = time;
		realTime = time-startTime;
		generate(realTime);
	}

	public function resetTime(){
		startTime = time;
		currentEnemy = 0;
	}

	public function getLives(){
		return lives;
	}

	private function pullJson(){
		enemies = objectParser.parseEnemyJson(waves[currentWave]);
	}

	public function startWave(){
		isPlaying = true;
	}
}