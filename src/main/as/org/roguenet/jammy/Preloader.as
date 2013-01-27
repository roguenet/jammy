package org.roguenet.jammy {

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.getDefinitionByName;

public class Preloader extends Sprite
{
    public function Preloader ()
    {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        addChild(_splash = new SPLASH());
        addEventListener(Event.ENTER_FRAME, waitingOnLoading);
    }

    protected function waitingOnLoading (event :Event) :void
    {
        if (root.loaderInfo.bytesLoaded == root.loaderInfo.bytesTotal) {
            removeEventListener(Event.ENTER_FRAME, waitingOnLoading);
            const Main :Class = Class(getDefinitionByName("org.roguenet.jammy.Jammy"));
            addChild(DisplayObject(new Main(_splash)));
        }
    }

    [Embed("../../../../resources/raw/splash.png")]
    protected static const SPLASH :Class;
    protected var _splash :DisplayObject;
}
}
