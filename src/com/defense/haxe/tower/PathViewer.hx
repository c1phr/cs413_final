package com.defense.haxe.tower;

import haxe.Timer;
import starling.textures.Texture;
import starling.display.Image;
import starling.display.Sprite;
import starling.core.Starling;
import starling.animation.Transitions;

import com.cykon.haxe.movable.Point;

class PathViewer extends Sprite{
	public var active:Bool = false;
	
	private var moveTime:Int;
	private var fadeTime:Int;
	private var texture:Texture;
	private var timer:Timer = null;
	private var a_Point:Array<Point>;
	private var pointIndex:Int;

	private var startAlpha:Float;
	private var endAlpha:Float;
	
	public function new(moveTime:Int, startAlpha:Float, endAlpha:Float, texture:Texture){
		super();
		this.moveTime = moveTime;
		this.startAlpha = startAlpha;
		this.endAlpha = endAlpha;
		this.texture = texture;
	}
	
	public function stopShowingPath(){
		if(timer != null)
			timer.stop();
		active = false;
		a_Point = null;
		this.removeChildren(0,-1,true);
	}
	
	public function showPath(a_Point:Array<Point>){
		if(this.a_Point != null && a_Point.length == this.a_Point.length){
			var sameList = true;
			
			for(i in 0...a_Point.length){
				var p1 = a_Point[i];
				var p2 = this.a_Point[i];
				if(p1.x != p2.x || p1.y != p2.y){
					sameList = false;
					break;
				}
			}
			
			if(sameList)
				return;
		}
		
		stopShowingPath();
		
		this.a_Point = a_Point;
		this.pointIndex = 0;
		fadeTime = moveTime * a_Point.length;
		
		for(point in a_Point){
			var flashImage = new Image(texture);
				flashImage.pivotX = flashImage.pivotY = texture.width/2;
				flashImage.x = point.x;
				flashImage.y = point.y;
				flashImage.alpha = endAlpha;
			addChild(flashImage);
		}
		
		timer = new Timer(moveTime);
		timer.run = showNext;
	}
	
	public function setColor(color:Int){
		for(i in 0...this.numChildren){
			var image:Dynamic = this.getChildAt(i);
			cast(image,Image);
			image.color = color;
		}
	}
	
	public function showNext(){
		var point = a_Point[pointIndex];
		var dispObject = getChildAt(pointIndex);
			dispObject.alpha = startAlpha;
		Starling.juggler.tween(dispObject, fadeTime/1000, {
			transition: Transitions.EASE_OUT,
			alpha: endAlpha
		});
		
		pointIndex = ++pointIndex % a_Point.length;
		
		if(pointIndex == 0){
			timer.stop();
			timer = new Timer(850);
			timer.run = function(){
				timer.stop();
				timer = new Timer(moveTime);
				timer.run = showNext;
			};
		}
	}
}