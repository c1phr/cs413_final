UNAME := $(shell uname)

all:
	mkdir -p bin
	haxe -cp src \
	-swf-header 650:500:60:0 \
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
ifeq (CYGWIN,$(findstring CYGWIN,$(UNAME)))
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
ifeq (CYGWIN,$(findstring CYGWIN,$(UNAME)))
	taskkill /f /IM FlashPlayer16Debug.exe /fi "memusage gt 2"
endif
	make run
	
clean:
	rm bin/TowerDefense.swf
	mkdir -p bin
	mkdir -p bin