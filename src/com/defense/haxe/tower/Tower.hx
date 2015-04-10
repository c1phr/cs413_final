package com.defense.haxe.tower;

import starling.textures.Texture;
import starling.display.Sprite;
import starling.display.Image;


class Tower extends Sprite{
	public var baseImage:Image;
	private var active:Bool = false;
	
	public function new(texture:Texture, size:Int){
		super();
		
		baseImage = new Image(texture);
		this.width = this.height = baseImage.width = baseImage.height = size;
		baseImage.pivotX = size/2;
		baseImage.pivotY = size/2;
		addChild(baseImage);
	}
	
	public function isActive():Bool{
		return active;
	}
	
	public function setActive(active = true){
		this.active = active;
	}
	
	public function setTexture(texture:Texture = null){
		baseImage.texture = texture;
	}
	
	public function click(){		
	}
}