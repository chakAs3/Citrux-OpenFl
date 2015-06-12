package ;
import starling.utils.AssetManager;
import starling.core.Starling;
import openfl.display.Sprite;
import starling.textures.RenderTexture;

import msignal.Signal.Signal0;
class Main extends Sprite{

    private var mStarling:Starling;
    public function new() {
         super();
        trace("Hello ----");

        var changed = new Signal0();
        changed.addOnce(changeHandler);
        changed.dispatch();


        Starling.multitouchEnabled = true; // for Multitouch Scene
        Starling.handleLostContext = true; // recommended everywhere when using AssetManager
        RenderTexture.optimizePersistentBuffers = true; // should be safe on Desktop

        mStarling = new Starling(MySprite, stage, null, null, "auto", "baselineExtended");
        mStarling.antiAliasing = 0;
        mStarling.simulateMultitouch = false;
//mStarling.enableErrorChecking = Capabilities.isDebugger;
        mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():Void
        {
            trace("Root is created ");
            loadAssets(startGame);
           // switchRendering();
        });

        mStarling.start();

    }
    private function loadAssets(onComplete:Function):Void
    {
// Our assets are loaded and managed by the 'AssetManager'. To use that class,
// we first have to enqueue pointers to all assets we want it to load.
        var assets:AssetManager = new AssetManager();

//assets.verbose = Capabilities.isDebugger;
//assets.enqueue(EmbeddedAssets);
        assets.enqueueWithName(EmbeddedAssets.atlas, "atlas");
        assets.enqueueWithName(EmbeddedAssets.atlas_xml, "atlas_xml");
        assets.enqueueWithName(EmbeddedAssets.background, "background");
        //assets.enqueueWithName(EmbeddedAssets.compressed_texture, "compressed_texture");
        //assets.enqueueWithName(EmbeddedAssets.desyrel, "desyrel");
        //assets.enqueueWithName(EmbeddedAssets.desyrel_fnt, "desyrel_fnt");
        //assets.enqueueWithName(EmbeddedAssets.wing_flap, "wing_flap");

// Now, while the AssetManager now contains pointers to all the assets, it actually
// has not loaded them yet. This happens in the "loadQueue" method; and since this
// will take a while, we'll update the progress bar accordingly.

        assets.loadQueue(function(ratio:Float):Void
        {
            if (ratio == 1) onComplete(assets);
        });
    }

    private function startGame(assets:AssetManager):Void
    {
        var game:MySprite = cast mStarling.root;
        game.start(assets);
    }

    function changeHandler()
    {
        trace("signal send event : changed");
    }
}

typedef Function = Dynamic -> Void;
