package com.defense.haxe;

import starling.core.Starling;
import starling.display.Stage;
import starling.display.Sprite;
import starling.utils.AssetManager;

// @:bitmap("bin/assets/loadingScreen.png")

class Root extends Sprite {

    public static var assets:AssetManager;
	public static var globalStage:Stage = null;
	
    function new() {
        super();
		pushLoadingScreen();
		populateAssetManager();
    }
	
	function pushLoadingScreen(){
		/* loadingBitmap = new Bitmap(new LoadingBitmapData(0, 0));
        loadingBitmap.x = 0;
        loadingBitmap.y = 0;
        loadingBitmap.width = flash.Lib.current.stage.stageWidth;
        loadingBitmap.height = flash.Lib.current.stage.stageHeight;
        addChild(loadingBitmap); */
	}
	
	function populateAssetManager(){
		assets = new AssetManager();
		/*assets.enqueue("assets/32px/path.png");
		assets.enqueue("assets/32px/block.png");
		assets.enqueue("assets/32px/border_background.png");
		assets.enqueue("assets/32px/border_0.png");
		assets.enqueue("assets/32px/border_1.png");
		assets.enqueue("assets/32px/border_2.png");
		assets.enqueue("assets/32px/border_2p.png");
		assets.enqueue("assets/32px/border_3.png");
		assets.enqueue("assets/32px/border_4.png");*/
		
		assets.enqueue("assets/32px/tile.xml");
		assets.enqueue("assets/32px/tile.png");
		
		assets.enqueue("assets/enemy.png");
		assets.enqueue("assets/startBtn.png");
		assets.enqueue("assets/thumb.png");

		assets.enqueue("assets/32px/redtower.png");
		assets.enqueue("assets/32px/bluetower.png");
		assets.enqueue("assets/32px/greentower.png");
		assets.enqueue("assets/32px/purpletower.png");
		assets.enqueue("assets/wall_button.png");
		// assets.enqueue();
		// assets.enqueue();
		assets.enqueue("assets/32px/money.png");


		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {
				// Loading Screen Management here...
				this.removeChildren(0,-1,true);
				this.addChild( new GameDriver() );
			}
		});
	}

    /** Main method, used to set up the initial game instance */
    public static function main() {
	
        try {
			// Attempt to start the game logic 
			var starling = new starling.core.Starling(Root, flash.Lib.current.stage);
			starling.showStats = true;
            globalStage = starling.stage; 
			starling.start();  
        } catch(e:Dynamic){
            trace(e);
        }
    }
}