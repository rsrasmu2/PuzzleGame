import starling.display.Sprite;
import starling.display.Image;
import starling.display.Button;
import starling.text.TextField;
import starling.core.Starling;
import starling.events.*;



class Options extends Sprite
{
	public function new()
	{
		super();
		var bg = new Image(Root.assets.getTexture("options_bg"));
		bg.width = Starling.current.stage.stageWidth;
		bg.height = Starling.current.stage.stageHeight;
		addChild(bg);
		
		var menu = new Image(Root.assets.getTexture("options_menu"));
		menu.width = Starling.current.stage.stageWidth / 2;
		menu.height = Starling.current.stage.stageHeight / 2;
		menu.x = (Starling.current.stage.stageWidth - menu.width) / 2;
		menu.y = (Starling.current.stage.stageHeight - menu.height) / 2;
		addChild(menu);
		
		var mainMenu = new Button(Root.assets.getTexture("Button"), "Main Menu");
		mainMenu.scaleX = .75;
		mainMenu.scaleY = .75;
		mainMenu.x = menu.x + 10;
		mainMenu.y = menu.y + menu.height - mainMenu.height - 10;
		mainMenu.fontSize = 24;
		mainMenu.fontName = "8bitwonder_0";
		mainMenu.addEventListener(Event.TRIGGERED, function()
		{
			Root.game.reset();
			Root.game.removeChild(this);
		});
		addChild(mainMenu);
		
		
		var vol = new TextField(175, 50, "Volume", "8bitwonder_0", 24, 0xffff00);
		vol.x = menu.x + menu.width - vol.width;
		vol.y = menu.y;
		addChild(vol);
		
		var incVol = new Button(Root.assets.getTexture("Button"), "Increase");
		incVol.scaleX = .75;
		incVol.scaleY = .75;
		incVol.x = vol.x + (vol.width - incVol.width) / 2;
		incVol.y = vol.y + vol.height;
		incVol.fontSize = 24;
		incVol.fontName = "8bitwonder_0";
		incVol.addEventListener(Event.TRIGGERED, function()
		{
			Root.game.incVol();
		});
		addChild(incVol);
		
		var decVol = new Button(Root.assets.getTexture("Button"), "Decrease");
		decVol.scaleX = .75;
		decVol.scaleY = .75;
		decVol.x = incVol.x;
		decVol.y = incVol.y + incVol.height;
		decVol.fontSize = 24;
		decVol.fontName = "8bitwonder_0";
		decVol.addEventListener(Event.TRIGGERED, function()
		{
			Root.game.decVol();
		});
		addChild(decVol);
		
		
		var score = new TextField(175, 50, "Score\n" + Root.game.highscore, "8bitwonder_0", 24, 0xffff00);
		score.x = menu.x + (menu.width - score.width) / 2;
		score.y = menu.y + (menu.height - score.height) / 2;
		addChild(score);
				
		var reset = new Button(Root.assets.getTexture("Button"), "Reset Save");
		reset.scaleX = .75;
		reset.scaleY = .75;
		reset.x = menu.x + 10;
		reset.y = menu.y + 10;
		//reset.x = menu.x + (menu.width - reset.width) / 2;
		//reset.y = menu.y + menu.height - reset.height;
		reset.fontSize = 24;
		reset.fontName = "8bitwonder_0";
		reset.addEventListener(Event.TRIGGERED, function()
		{
			addChild(new AreYouSure(this));
		});
		addChild(reset);
		
		
		var exit = new Button(Root.assets.getTexture("Button"), "Exit");
		exit.scaleX = .75;
		exit.scaleY = .75;
		exit.x = menu.x + menu.width - exit.width - 10;
		exit.y = menu.y + menu.height - exit.height - 10;
		exit.fontSize = 24;
		exit.fontName = "8bitwonder_0";
		exit.addEventListener(Event.TRIGGERED, function()
		{
			Root.game.removeChild(this);
		});
		addChild(exit);
	}
}


class AreYouSure extends Sprite
{
	public function new(options : Options)
	{
		super();
		var bg = new Image(Root.assets.getTexture("options_bg"));
		bg.width = Starling.current.stage.stageWidth;
		bg.height = Starling.current.stage.stageHeight;
		addChild(bg);
		
		var menu = new Image(Root.assets.getTexture("options_menu"));
		menu.width = Starling.current.stage.stageWidth / 3;
		menu.height = Starling.current.stage.stageHeight / 3;
		menu.x = (Starling.current.stage.stageWidth - menu.width) / 2;
		menu.y = (Starling.current.stage.stageHeight - menu.height) / 2;
		addChild(menu);
		
		var text = new TextField(175, 50, "Are You Sure?", "8bitwonder_0", 24, 0xffff00);
		text.x = menu.x + (menu.width - text.width) / 2;
		text.y = menu.y + 10;
		addChild(text);
		
		var yes = new Button(Root.assets.getTexture("Button"), "Yes");
		yes.scaleX = .75;
		yes.scaleY = .75;
		yes.x = menu.x + menu.width / 2 - yes.width - 15;
		yes.y = text.y + text.height + 50;
		yes.fontSize = 24;
		yes.fontName = "8bitwonder_0";
		yes.addEventListener(Event.TRIGGERED, function()
		{
			LoadStuff.resetLevel();
			Root.game.unlocked = Root.game.currentLevel = 0;
			LoadStuff.resetScores();
			Root.game.loadHighScores();
			options.removeChild(this);
		});
		addChild(yes);
		
		var no = new Button(Root.assets.getTexture("Button"), "No");
		no.scaleX = .75;
		no.scaleY = .75;
		no.x = menu.x + menu.width / 2 + 15;
		no.y = yes.y;
		no.fontSize = 24;
		no.fontName = "8bitwonder_0";
		no.addEventListener(Event.TRIGGERED, function()
		{
			options.removeChild(this);
		});
		addChild(no);
	}
}