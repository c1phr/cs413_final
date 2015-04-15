package com.defense.haxe;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;
import starling.events.EventDispatcher;
import com.defense.haxe.tower.TowerType;
import com.defense.haxe.enemy.EnemyType;

class ObjectParser
{
	public var towers:List<TowerType>;	
	public var enemies:List<EnemyType>;
	public var dispatcher:EventDispatcher;

	public function new()
	{		
		this.towers = new List<TowerType>();
		this.enemies = new List<EnemyType>();
		this.dispatcher = new EventDispatcher();
		this.parseTowerJson("assets/towers.json");
		this.parseEnemyJson("assets/enemies.json");		
	}

	private function parseTowerJson(towerJsonLoc:String)
	{
		var towerJsonFile:URLRequest = new URLRequest(towerJsonLoc);
		var towerJsonLoader:URLLoader = new URLLoader();
		towerJsonLoader.load(towerJsonFile);
		towerJsonLoader.addEventListener(Event.COMPLETE, function(e:Event)
			{								
				var jsonTowers = haxe.Json.parse(towerJsonLoader.data);				
				for (towerIter in Reflect.fields(jsonTowers))
				{
					var anonTower = Reflect.field(jsonTowers, towerIter);
					var towerToAdd = new TowerType();
					towerToAdd.type = anonTower.type;					
					towerToAdd.texture = anonTower.texture;
					towerToAdd.damage = anonTower.damage;
					towerToAdd.bullet = anonTower.bullet_name;
					towerToAdd.speed = anonTower.speed;
					towerToAdd.range = anonTower.range;					
					this.towers.add(towerToAdd);					
				}				
				dispatcher.dispatchEventWith("TowerJsonReady", true, {value: this.towers});			
			});
	}

	private function parseEnemyJson(enemyJsonLoc:String)
	{
		var enemyJsonFile:URLRequest = new URLRequest(enemyJsonLoc);
		var enemyJsonLoader:URLLoader = new URLLoader();
		enemyJsonLoader.load(enemyJsonFile);
		enemyJsonLoader.addEventListener(Event.COMPLETE, function(e:Event)
			{				
				var jsonEnemies = haxe.Json.parse(enemyJsonLoader.data);				
				for (enemyIter in Reflect.fields(jsonEnemies))
				{					
					var anonEnemy = Reflect.field(jsonEnemies, enemyIter);
					var enemyToAdd = new EnemyType();
					enemyToAdd.type = anonEnemy.type;
					enemyToAdd.texture = anonEnemy.texture;
					enemyToAdd.speed = anonEnemy.speed;					
					this.enemies.add(enemyToAdd);
				}						
				dispatcher.dispatchEventWith("EnemyJsonReady", true, {value: this.enemies});
			});
	}	
}