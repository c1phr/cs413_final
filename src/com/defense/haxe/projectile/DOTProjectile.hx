package com.defense.haxe.projectile;

import starling.textures.Texture;
import com.cykon.haxe.movable.circle.TrackingCircle;
import com.defense.haxe.enemy.Enemy;
import haxe.Timer;

class DOTProjectile extends BaseProjectile{
	
	private var hitEnemy:Enemy = null;
	
	private var damageAmount:Float = 0.25;
	private var damageInterval:Int = 250;
	private var damageCount:Int = 4;
	
	public override function onEnemyHit(enemy:Enemy){
		super.onEnemyHit(enemy);
		
		hitEnemy = enemy;
		enemyDOT();
	}
	
	private function enemyDOT(){
		hitEnemy.dealDamage(damageAmount);
		
		if(damageCount-- > 0){
			Timer.delay(enemyDOT, damageInterval);
		}
	}
}