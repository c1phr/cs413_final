package com.defense.haxe.projectile;

import starling.textures.Texture;
import com.cykon.haxe.movable.circle.TrackingCircle;
import com.defense.haxe.enemy.Enemy;
import haxe.Timer;

class SlowProjectile extends BaseProjectile{
	
	private static var blueMod = 0x33;
	
	private var hitEnemy:Enemy = null;
	private var slowDuration:Int = 1000;
	private var slowAmount:Float = 0.75;
	
	public override function onEnemyHit(enemy:Enemy){
		super.onEnemyHit(enemy);
		
		hitEnemy = enemy;
		enemySlowStart();
		Timer.delay(enemySlowEnd, slowDuration);
	}
	
	private function enemySlowStart(){
		hitEnemy.modifySpeed(slowAmount);
		hitEnemy.color = 0x9999FF;
	}
	
	private function enemySlowEnd(){
		hitEnemy.modifySpeed(1/slowAmount);
		hitEnemy.color = 0xFFFFFF;
	}
}