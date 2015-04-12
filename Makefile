UNAME := $(shell uname)

all:
	mkdir -p bin
	haxe -cp src \
	-swf-header 1280:720:120:FFFFFF \
	-swf-version 11.3 \
	-swf bin/TowerDefense.swf \
	-swf-lib lib/starling.swc \
	-swf-lib lib/Starling-Extension-Graphics.swc \
	--macro "patchTypes('lib/starling.patch')" \
	-main com.defense.haxe.Root

run:
	make
ifeq ($(UNAME),Darwin)
	open bin/TowerDefense.swf
endif
ifeq ($(UNAME),Cygwin)
	cygstart bin/TowerDefense.swf
endif
ifneq ($(UNAME),Darwin)
ifneq ($(UNAME),Cygwin)
	@echo "$(UNAME) environment not supported!"
endif
endif


runkill:
ifeq ($(UNAME),Darwin)
	killall Flash\ Player
endif
ifeq ($(UNAME),Cygwin)
	taskkill /f /IM FlashPlayer16Debug.exe /fi "memusage gt 2"
endif
	make run
	
clean:
	rm bin/TowerDefense.swf
	mkdir -p bin