package scenes;

import flash.geom.Point;
import openfl.Vector;

import starling.core.RenderSupport;
import starling.display.BlendMode;
import starling.display.Button;
import starling.display.Image;
import starling.citrux.events.Event;
import starling.citrux.events.Touch;
import starling.citrux.events.TouchEvent;
import starling.citrux.events.TouchPhase;
import starling.text.TextField;
import starling.textures.RenderTexture;

class RenderTextureScene extends Scene
{
	private var mRenderTexture:RenderTexture;
	private var mCanvas:Image;
	private var mBrush:Image;
	private var mButton:Button;
	private var mColors:Map<Int, UInt>;
	private var mInfoTextDrawn:Bool;
	private var mTouches:Vector<Touch>;

	public function new()
	{
		super();
		
		mInfoTextDrawn = false;
		mTouches = null;

		mColors = new Map<Int, UInt>();
		mRenderTexture = new RenderTexture(320, 435);
		
		mCanvas = new Image(mRenderTexture);
		mCanvas.addEventListener(TouchEvent.TOUCH, onRenderTexTouch);
		addChild(mCanvas);
		
		mBrush = new Image(Game.assets.getTexture("brush"));
		mBrush.pivotX = mBrush.width / 2;
		mBrush.pivotY = mBrush.height / 2;
		mBrush.blendMode = BlendMode.NORMAL;
		
		mButton = new Button(Game.assets.getTexture("button_normal"), "Mode: Draw");
		mButton.x = cast(Constants.CenterX - mButton.width / 2);
		mButton.y = 15;
		mButton.name = "modeDraw";
		mButton.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(mButton);
	}

	private function onRenderTexTouch(event:TouchEvent):Void
	{
		mTouches = event.getTouches(mCanvas);
	}

	public override function render(support:RenderSupport, parentAlpha:Float):Void
	{
		// touching the canvas will draw a brush texture. The 'drawBundled' method is not
		// strictly necessary, but it's faster when you are drawing with several fingers
		// simultaneously.
		super.render(support, parentAlpha);
		if (!mInfoTextDrawn) {
			var infoText:TextField = new TextField(256, 128, "Touch the screen\nto draw!");
			infoText.fontSize = 24;
			infoText.x = Constants.CenterX - infoText.width / 2;
			infoText.y = Constants.CenterY - infoText.height / 2;
			mRenderTexture.draw(infoText);
			mInfoTextDrawn = true;
		}
		if (mTouches == null) {
			return;
		}
		mRenderTexture.drawBundled(function():Void
		{
			for (touch in mTouches)
			{
				if (touch.phase == TouchPhase.BEGAN) {
					mColors[touch.id] = Math.floor(Math.random() * 4294967295); // 0xFFFFFFFF
				}
				
				if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED)
					continue;
				
				var location:Point = touch.getLocation(mCanvas);
				mBrush.x = location.x;
				mBrush.y = location.y;
				//trace('mBrush x=${location.x} y=${location.y}');
				mBrush.color = mColors[touch.id];
				//trace('mBrush.color = 0x${StringTools.hex(mBrush.color, 8)}');
				mBrush.rotation = Math.random() * Math.PI * 2.0;
				
				mRenderTexture.draw(mBrush);
			}
		});
		mTouches = null;
	}

	private function onButtonTriggered():Void
	{
		if (mBrush.blendMode == BlendMode.NORMAL)
		{
			mBrush.blendMode = BlendMode.ERASE;
			mButton.text = "Mode: Erase";
		}
		else
		{
			mBrush.blendMode = BlendMode.NORMAL;
			mButton.text = "Mode: Draw";
		}
	}
	
	public override function dispose():Void
	{
		mRenderTexture.dispose();
		super.dispose();
	}
}