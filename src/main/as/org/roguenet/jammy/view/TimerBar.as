package org.roguenet.jammy.view {

import flash.display.Shape;

import org.roguenet.jammy.JammyConsts;

import starling.display.Image;
import starling.utils.Color;

public class TimerBar extends RenderedSprite
{
    public function TimerBar ()
    {
        var shape :Shape = new Shape();
        shape.graphics.beginFill(Color.GREEN);
        shape.graphics.drawRect(0, 0, JammyConsts.TIMERBAR_WIDTH, JammyConsts.TIMERBAR_HEIGHT);
        shape.graphics.endFill();
        _bar = render(shape);
    }

    public function setPercent (value :Number) :void
    {
        _bar.scaleX = Math.max(0, Math.min(1, value));
    }

    protected var _bar :Image;
}
}
