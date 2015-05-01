package com.defense.haxe;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;
import starling.events.EventDispatcher;
import com.defense.haxe.tower.TowerType;
import com.defense.haxe.enemy.EnemyType;

class ObjectParser
{
	public var towers:Array<TowerType>;	
	public var enemies:Array<EnemyType>;
	public var dispatcher:EventDispatcher;
	private var towerObject:Dynamic;
	private var enemyObject:Dynamic;

	public function new()
	{		
		this.towers = new Array<TowerType>();
		this.enemies = new Array<EnemyType>();
		this.dispatcher = new EventDispatcher();
		this.towerObject = Root.assets.getObject("towers");
		this.enemyObject = Root.assets.getObject("enemies");
		trace(enemyObject.length);	
	}

	public function parseTowerJson():Array<TowerType>
	{
		for(i in 0...towerObject.length){
	        var data = towerObject[i];
	        var towerToAdd = new TowerType();
			towerToAdd.type = data.type;					
			towerToAdd.texture = data.texture;
			towerToAdd.damage = data.damage;
			towerToAdd.bullet = data.bullet_name;
			towerToAdd.speed = data.speed;
			towerToAdd.range = data.range;					
			this.towers.push(towerToAdd);	
        }
        return towers;
						
	}

	public function parseEnemyJson():Array<EnemyType>
	{
		for(i in 0...enemyObject.length){
	        var data = enemyObject[i];
			var enemyToAdd = new EnemyType();
			enemyToAdd.type = data.type;
			enemyToAdd.texture = data.texture;
			enemyToAdd.speed = data.speed;
			enemyToAdd.time = data.time;			
			this.enemies.push(enemyToAdd);
		}
		return enemies;
	}	
}