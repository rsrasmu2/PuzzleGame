FLEX_SDK = C:\Users\Temdog\Documents\Apache_Flex_SDK
ADL = $(FLEX_SDK)\bin\adl
AMXMLC = $(FLEX_SDK)\bin\amxmlc

SOURCES = src\Startup.hx src\Root.hx src\GameMap.hx src\Game.hx src\Obstacle.hx src\Player.hx

APP = puzzle

all: $(APP).swf

$(APP).swf: 
	$(SOURCES) 
	haxe \
	-cp src \
	-cp vendor \
	-swf-version 11.8 -swf-header 640:640:60:0 \
	-main Startup \
	-swf $(APP).swf \
	-swf-lib vendor/starling.swc --macro "patchTypes('vendor/starling.patch')"

clean:
	-del $(APP).swf
	
test: $(APP).swf
	$(ADL) -profile tv -screensize 640x360:640x360 $(APP).xml