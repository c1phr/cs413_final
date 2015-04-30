package com.defense.haxe.projectile;

import starling.textures.Texture;
import com.cykon.haxe.movable.circle.TrackingCircle;
import com.defense.haxe.enemy.Enemy;

class BaseProjectile extends TrackingCircle{
	
	private var trackEnemy : Enemy;
	private var damage = 1;
	
	public function new(texture:Texture, x:Float, y:Float, radius:Float, stageWidth:Float, stageHeight:Float, enemy:Enemy){
		super(texture, x, y, radius, stageWidth, stageHeight, enemy);
		trackEnemy = enemy;
	}
	
	public function trackingEnemyUpdate(){
		if(trackEnemy.isComplete()){
			stopTracking = true;
		}
	}
	
	public function enemyHitCheck(enemy:Enemy=null):Bool{
		if(enemy == null)
			enemy = this.trackEnemy;
		
		if(dumbCircleHit(enemy)) {
			onEnemyHit(enemy);
			return true;
		}
		
		return false;
	}

	public function onEnemyHit(enemy:Enemy){
		enemy.dealDamage(damage);
	}
}