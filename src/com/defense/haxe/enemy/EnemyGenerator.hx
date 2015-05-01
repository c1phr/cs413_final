package com.defense.haxe.enemy;

import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.text.TextField;
import starling.animation.Tween;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Quad;

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
	public var remaining:Int;
	public var initialCount:Int;

	// tells whether or not to generate waves
	private var isPlaying:Bool = false;
	private var youLose:Bool = false;

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
		if(isPlaying == true){
			for(enemy in a_Enemy){
				enemy.applyVelocity(modifier);
				
				if(enemy.isComplete() && !(enemy.getDead())){
					enemy.removeFromParent(true);
					a_Enemy.remove(enemy);
					remaining -=1;
					lives -= 1;
				}

				if(enemy.getDead()){
					enemy.removeFromParent(true);
					a_Enemy.remove(enemy);
					remaining -= 1;
				}

				if(lives <= 0){
					isPlaying = false;
					var backDropContainer = new Sprite();
					var backDrop = new Quad(Root.globalStage.stageWidth - 50, Root.globalStage.stageHeight - 50, 0x0);
					backDrop.alpha = .5;
					backDropContainer.addChild(backDrop);
					var waveBanner = new TextField(300,300,"", "Arial",40, 0x00CCFF);
					waveBanner.text = "You Lose!";
					waveBanner.x = 100;
					waveBanner.y = 20;
					backDropContainer.addChild(waveBanner);
					addChild(backDropContainer);
					var tween = new Tween(backDropContainer, 4.0, Transitions.EASE_OUT);
					tween.fadeTo(0);
					Starling.juggler.add(tween);
					tween.onComplete = function(){
						removeChild(backDropContainer);
						this.removeChildren();
						youLose = true;
						};
					
					break;
				}

				if(remaining == 0 && currentWave < waves.length - 1){
					var backDropContainer = new Sprite();
					var backDrop = new Quad(Root.globalStage.stageWidth - 50, Root.globalStage.stageHeight - 50, 0x0);
					backDrop.alpha = .5;
					backDropContainer.addChild(backDrop);
					var waveBanner = new TextField(300,300,"", "Arial",40, 0x00CCFF);
					waveBanner.text = "Wave " + (currentWave + 1) + " complete!";
					waveBanner.x = 100;
					waveBanner.y = 20;
					backDropContainer.addChild(waveBanner);
					addChild(backDropContainer);
					
					var tween = new Tween(backDropContainer, 3.0, Transitions.EASE_OUT);
					tween.fadeTo(0);
					Starling.juggler.add(tween);
					tween.onComplete = function(){
						removeChild(backDropContainer);
						};

					a_Enemy.clear();
					currentEnemy = 0;
					currentWave += 1;
					pullJson();
					isPlaying = false;
				}
				if(remaining == 0 && currentWave == waves.length - 1){
					isPlaying = false;
					var backDropContainer = new Sprite();
					var backDrop = new Quad(Root.globalStage.stageWidth - 50, Root.globalStage.stageHeight - 50, 0x0);
					backDrop.alpha = .5;
					backDropContainer.addChild(backDrop);
					var waveBanner = new TextField(300,300,"", "Arial",40, 0x00CCFF);
					waveBanner.text = "You Win!";
					waveBanner.x = 100;
					waveBanner.y = 20;
					backDropContainer.addChild(waveBanner);
					addChild(backDropContainer);
					var tween = new Tween(backDropContainer, 4.0, Transitions.EASE_OUT);
					tween.fadeTo(0);
					Starling.juggler.add(tween);
					tween.onComplete = function(){
						removeChild(backDropContainer);
						this.removeChildren();
						youLose = true;
						};
					
					break;
				}
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
		remaining = enemies.length;
		initialCount = enemies.length;
	}

	public function startWave(){
		isPlaying = true;
	}

	public function getWaveStatus(){
		return isPlaying;	
	}

	public function getWave():Int{
		return currentWave;
	}

	public function isOver():Bool{
		return youLose;
	}
}