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
	
	public function enemyHitCheck(enemy:Enemy=null):Bool{
		if(enemy == null)
			enemy = this.trackEnemy;
		
		if(enemy.isComplete()){
			stopTracking = true;
		} else if(dumbCircleHit(enemy)) {
			onEnemyHit();
			stopTracking = true;
			return true;
		}
		
		return false;
	}

	public function onEnemyHit(){
		trackEnemy.dealDamage(damage);
	}
}