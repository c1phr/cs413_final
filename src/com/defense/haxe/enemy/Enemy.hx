package com.defense.haxe.enemy;

import com.cykon.haxe.movable.circle.Circle;
import com.cykon.haxe.cmath.Vector;
import com.cykon.haxe.movable.Point;
import starling.textures.Texture;

class Enemy extends Circle{
	private var pList:List<Point>;
	private var currentPoint:Point;

	public function new(texture:Texture, x:Float, y:Float, radius:Float){
		super(texture,x,y,radius);
	}

	public override function applyVelocity(modifier:Float):Bool{
		super.applyVelocity(modifier);
		

		var pointx = currentPoint.x;
		var pointy = currentPoint.y;

		var velocityVector = new Vector(vx, vy);
		var pointVector = Vector.getVector(x,y,pointx,pointy);

		if (velocityVector.dot(pointVector) < 0){
			if(pList.length > 1){
				currentPoint = pList.pop();
			}
			x = pointx;
			y = pointy;

			
			pointx = currentPoint.x;
			pointy = currentPoint.y;

			//velocityVector.getMag();
		}
		return true;

	}

	public function setPoints(pointList:List<Point>){
		pList = pointList;
		currentPoint = pList.pop();
		vx = 4;
	}

}