package ;
import openfl.display.BitmapData;
import openfl.Assets;
import starling.events.Event;
import starling.display.Image;
import starling.textures.Texture;
import starling.utils.AssetManager;
import openfl.display.Sprite;
import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.utils.AssetManager;

class MySprite extends Sprite{
    private static var sAssets:AssetManager;
    public function new() {
        super();
    }

    public function start(assets:AssetManager):Void
    {
        sAssets = assets;

//this.stage.color = 0xFFFF0000;
        //var texture:Texture = assets.getTexture('background');
        //addChild(new Image(texture));




      var bmd:BitmapData = Assets.getBitmapData("assets/textures/1x/background.jpg");
		var texture:Texture = Texture.fromBitmapData(bmd);
		addChild(new Image(texture));


       // addEventListener(Event.TRIGGERED, onButtonTriggered);
        //stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
    }
}
