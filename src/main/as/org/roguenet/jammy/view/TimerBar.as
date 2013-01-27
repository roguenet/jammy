package org.roguenet.jammy.view {

import flashbang.objects.SpriteObject;
import flashbang.resource.ImageResource;

import starling.display.Image;

public class TimerBar extends SpriteObject
{
    public function TimerBar ()
    {
        _sprite.addChild(ImageResource.createImage("jammy/timer"));
    }

    public function get percent () :Number
    {
        return _sprite.scaleX;
    }

    public function setPercent (value :Number) :void
    {
        _sprite.scaleX = Math.max(0, Math.min(1, value));
    }

    protected var _bar :Image;
}
}
