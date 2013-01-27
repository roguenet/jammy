package org.roguenet.jammy.view {

import flash.display.Shape;

import org.roguenet.jammy.JammyConsts;

import starling.display.Image;
import starling.utils.Color;

public class TimerBar extends RenderedSprite
{
    public function TimerBar ()
    {
        var outline :Shape = new Shape();
        outline.graphics.lineStyle(2, Color.BLACK);
        outline.graphics.drawRect(0, 0, JammyConsts.TIMERBAR_WIDTH, JammyConsts.TIMERBAR_HEIGHT);
        render(outline);

        var bar :Shape = new Shape();
        bar.graphics.beginFill(Color.GREEN);
        bar.graphics.drawRect(0, 0, JammyConsts.TIMERBAR_WIDTH, JammyConsts.TIMERBAR_HEIGHT);
        bar.graphics.endFill();
        _bar = render(bar);
    }

    public function get percent () :Number
    {
        return _bar.scaleX;
    }

    public function setPercent (value :Number) :void
    {
        _bar.scaleX = Math.max(0, Math.min(1, value));
    }

    protected var _bar :Image;
}
}
