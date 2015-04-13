package com.defense.haxe.enemy;

import com.cykon.haxe.movable.circle.Circle;
import com.cykon.haxe.cmath.Vector;
import com.cykon.haxe.movable.Point;
import starling.textures.Texture;

class Enemy extends Circle{
	private var pList:Array<Point>;
	private var currentPoint:Point;
	private var speed:Int = 5;

	public function new(texture:Texture, x:Float, y:Float, radius:Float){
		super(texture,x,y,radius);
		this.pivotX = texture.width / 2;
		this.pivotY = texture.height / 2;
	}

	public override function applyVelocity(modifier:Float):Bool{
		super.applyVelocity(modifier);
		
		this.rotation += Math.PI/30;
		
		var pointx = currentPoint.x;
		var pointy = currentPoint.y;

		var velocityVector = new Vector(vx, vy);
		var pointVector = Vector.getVector(x,y,pointx,pointy);

		if (velocityVector.dot(pointVector) < 0){
			if(pList.length >= 1){
				currentPoint = pList[0];
				pList.remove(currentPoint);
			}
			x = pointx;
			y = pointy;
			var speedVector = Vector.getVector(x,y,currentPoint.x,currentPoint.y).normalize().multiply(speed);
			this.vx = speedVector.vx;
			this.vy = speedVector.vy;

			
			pointx = currentPoint.x;
			pointy = currentPoint.y;

			//velocityVector.getMag();
		}
		return true;

	}

	public function setPoints(pointList:Array<Point>){
		pList = pointList;
		currentPoint = pList[0];
		pList.remove(currentPoint);
		x = currentPoint.x;
		y = currentPoint.y;
		var nextPoint = pList[0];
		var speedVector = Vector.getVector(x,y,nextPoint.x,nextPoint.y).normalize().multiply(speed);
		this.vx = speedVector.vx;
	    this.vy = speedVector.vy;
	}

}