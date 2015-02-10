FLEX_SDK = C:\Users\Nancy\Documents\ApacheFlex

APP=puzzle
APP_XML=$(APP).xml
ADL=$(FLEX_SDK)/bin/adl
AMXMLC=$(FLEX_SDK)/bin/amxmlc
SOURCES=src/*.hx

all: $(APP).swf
$(APP).swf: $(SOURCES)
	haxe \
	-cp src \
	-cp vendor \
	-swf-version 11.8 \
	-swf-header 640:640:60:ffffff \
	-main Startup \
	-swf $(APP).swf \
	-swf-lib vendor/starling.swc --macro "patchTypes('vendor/starling.patch')"

clean:
	del $(APP).swf
	
test: $(APP).swf
	$(ADL) -profile tv -screensize 640x640:640x640 $(APP_XML)