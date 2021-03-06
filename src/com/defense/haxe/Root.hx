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
		
		assets.enqueue("assets/tile.xml");
		assets.enqueue("assets/tile.png");
		
		assets.enqueue("assets/enemy.png");
		assets.enqueue("assets/enemy_fast.png");
		assets.enqueue("assets/enemy_slow.png");
		assets.enqueue("assets/startBtn.png");
		assets.enqueue("assets/waveBtn.png");
		assets.enqueue("assets/thumb.png");

		assets.enqueue("assets/wall_button.png");

		assets.enqueue("assets/32px/money.png");

		assets.enqueue("assets/towers.json");
		assets.enqueue("assets/enemies.json");


		assets.enqueue("assets/font.png");
		assets.enqueue("assets/font.fnt");

		//json enqueue
		assets.enqueue("assets/Json/wave1.json");
		assets.enqueue("assets/Json/wave2.json");
		assets.enqueue("assets/Json/wave3.json");
		assets.enqueue("assets/Json/wave4.json");
		assets.enqueue("assets/Json/wave5.json");
		assets.enqueue("assets/song.mp3");
		assets.enqueue("assets/song2.mp3");

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
            globalStage = starling.stage; 
			starling.start();  
        } catch(e:Dynamic){
            trace(e);
        }
    }
}