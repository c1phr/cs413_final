package com.defense.haxe.enemy;

import com.cykon.haxe.movable.circle.Circle;
import com.cykon.haxe.cmath.Vector;
import com.cykon.haxe.movable.Point;
import starling.textures.Texture;

class Enemy extends Circle{
	private var pList:Array<Point>;
	private var currentPoint:Point;
	private var speed:Float;
	private var currentIndex:Int = 0;
	private var isDone:Bool = false;
	private var isDead:Bool = false;
	private var health:Float = 5;

	public function new(texture:Texture, x:Float, y:Float, radius:Float, speed:Float){
		super(texture,x,y,radius);
		this.speed = speed;
		this.pivotX = texture.width / 2;
		this.pivotY = texture.height / 2;
	}
	
	public function modifySpeed(modifier:Float){
		speed = speed * modifier;
		var speedVector = new Vector(vx,vy);
		speedVector.normalize().multiply(speed);
		vx = speedVector.vx;
		vy = speedVector.vy;
	}
	
	public function dealDamage(damage:Float){
		health -= damage;
		
		if(health <= 0){
			health = 0;
			isDead = true;
			isDone = true;
		}
	}

	public override function applyVelocity(modifier:Float):Bool{
		super.applyVelocity(modifier);

		this.rotation += Math.PI/30;
		
		var pointx = currentPoint.x;
		var pointy = currentPoint.y;

		var velocityVector = new Vector(vx, vy);
		var pointVector = Vector.getVector(x,y,pointx,pointy);

		
		// Tests enemy see if the enemy has passed the current point
		if (velocityVector.dot(pointVector) < 0 && currentIndex < pList.length){
			currentPoint = pList[currentIndex];
			if(currentIndex < pList.length){
				currentIndex += 1;
			}
			x = pointx;
			y = pointy;
			var speedVector = Vector.getVector(x,y,currentPoint.x,currentPoint.y).normalize().multiply(speed);
			this.vx = speedVector.vx;
			this.vy = speedVector.vy;
			
			pointx = currentPoint.x;
			pointy = currentPoint.y;
		}
		if(currentIndex == pList.length && this.x >= currentPoint.x && this.y >= currentPoint.y){
			isDone = true;
		}
		// }
		
		return true;
	}

	public function setPoints(pointList:Array<Point>){
		pList = pointList;
		currentPoint = pList[currentIndex];
		currentIndex += 1;
		x = currentPoint.x;
		y = currentPoint.y;
		var nextPoint = pList[currentIndex + 1];
		var speedVector = Vector.getVector(x,y,nextPoint.x,nextPoint.y).normalize().multiply(speed);
		this.vx = speedVector.vx;
	    this.vy = speedVector.vy;
	}

	public function isComplete(){
		return isDone;
	}

	public function getDead(){
		return isDead;
	}

}