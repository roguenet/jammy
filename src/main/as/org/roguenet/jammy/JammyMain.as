package org.roguenet.jammy {

import aspire.util.F;

import flash.display.Sprite;

import aspire.util.Log;

import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.utils.AssetManager;

[SWF(width="1280", height="700", frameRate="60", backgroundColor="#222222")]
public class JammyMain extends Sprite
{
    public function JammyMain ()
    {
        addEventListener(Event.ADDED_TO_STAGE, F.callbackOnce(addedToStage));
    }

    protected function addedToStage () :void
    {
        log.info("Added to stage");

        Starling.multitouchEnabled = true; // for Multitouch Scene
        Starling.handleLostContext = true; // required on Windows, needs more memory

        _starling = new Starling(Jammy, stage);
        _starling.simulateMultitouch = true;
        _starling.enableErrorChecking = Capabilities.isDebugger;
        _starling.start();

        // this event is dispatched when stage3D is set up
        _starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
    }

    protected function onRootCreated (event :Event, game :Jammy) :void
    {
        log.info("root created", "event", event, "game", game);

        // set framerate to 30 in software mode
        if (_starling.context.driverInfo.toLowerCase().indexOf("software") != -1) {
            _starling.nativeStage.frameRate = 30;
        }

        // define which resources to load
        var assets :AssetManager = new AssetManager();
        assets.verbose = Capabilities.isDebugger;
    }

    protected var _starling :Starling;

    private static const log :Log = Log.getLog(JammyMain);
}
}

