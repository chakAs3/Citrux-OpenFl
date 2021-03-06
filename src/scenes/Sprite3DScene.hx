package scenes;

import flash.display3D.Context3DTriangleFace;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite3D;
import starling.citrux.events.Event;
import starling.textures.Texture;

class Sprite3DScene extends Scene
{
	private var mCube:Sprite3D;
	
	public function new()
	{
		super();
		
		var texture:Texture = Game.assets.getTexture("gamua-logo");
		
		mCube = createCube(texture);
		mCube.x = Constants.CenterX;
		mCube.y = Constants.CenterY;
		mCube.z = 100;
		
		addChild(mCube);
		
		addEventListener(Event.ADDED_TO_STAGE, start);
		addEventListener(Event.REMOVED_FROM_STAGE, stop);
	}

	private function start():Void
	{
		Starling.Juggler.tween(mCube, 6, { rotationX: 2 * Math.PI, repeatCount: 0 });
		Starling.Juggler.tween(mCube, 7, { rotationY: 2 * Math.PI, repeatCount: 0 });
		Starling.Juggler.tween(mCube, 8, { rotationZ: 2 * Math.PI, repeatCount: 0 });
	}

	private function stop():Void
	{
		Starling.Juggler.removeTweens(mCube);
	}

	private function createCube(texture:Texture):Sprite3D
	{
		var offset:Float = texture.width / 2;
		
		var front:Sprite3D = createSidewall(texture, 0xff0000);
		front.z = -offset;
		
		var back:Sprite3D = createSidewall(texture, 0x00ff00);
		back.rotationX = Math.PI;
		back.z = offset;
		
		var top:Sprite3D = createSidewall(texture, 0x0000ff);
		top.y = - offset;
		top.rotationX = Math.PI / -2.0;
		
		var bottom:Sprite3D = createSidewall(texture, 0xffff00);
		bottom.y = offset;
		bottom.rotationX = Math.PI / 2.0;
		
		var left:Sprite3D = createSidewall(texture, 0xff00ff);
		left.x = -offset;
		left.rotationY = Math.PI / 2.0;
		
		var right:Sprite3D = createSidewall(texture, 0x00ffff);
		right.x = offset;
		right.rotationY = Math.PI / -2.0;
		
		var cube:Sprite3D = new Sprite3D();
		cube.addChild(front);
		cube.addChild(back);
		cube.addChild(top);
		cube.addChild(bottom);
		cube.addChild(left);
		cube.addChild(right);
		
		return cube;
	}
	
	private function createSidewall(texture:Texture, color:UInt=0xffffff):Sprite3D
	{
		var image:Image = new Image(texture);
		image.color = color;
		image.alignPivot();
		
		var sprite:Sprite3D = new Sprite3D();
		sprite.addChild(image);
		
		return sprite;
	}
	
	public override function render(support:RenderSupport, parentAlpha:Float):Void
	{
		// Starling does not make any depth-tests, so we use a trick in order to only show
		// the front quads: we're activating backface culling, i.e. we hide triangles at which
		// we look from behind. 
		
		Starling.current.context.setCulling(Context3DTriangleFace.BACK);
		super.render(support, parentAlpha);
		Starling.current.context.setCulling(Context3DTriangleFace.NONE);
	}
}