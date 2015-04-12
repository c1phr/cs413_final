all:
	mkdir -p bin
	haxe -cp src \
	-swf-header 1280:720:120:FFFFFF \
	-swf-version 11.3 \
	-swf bin/TowerDefense.swf \
	-swf-lib lib/Starling.swc \
	-swf-lib lib/Starling-Extension-Graphics.swc \
	--macro "patchTypes('lib/starling.patch')" \
	-main com.defense.haxe.Root

run:
	make
	cygstart bin/TowerDefense.swf

runkill:
	taskkill /f /IM FlashPlayer16Debug.exe /fi "memusage gt 2"
	make run
	
clean:
	rm bin/TowerDefense.swf
	mkdir -p bin