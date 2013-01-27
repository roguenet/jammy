package org.roguenet.jammy.view {

import aspire.geom.Vector2;
import aspire.util.Log;

import flash.display.Shape;

import org.roguenet.jammy.GameMode;
import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

import starling.display.Image;
import starling.events.Touch;
import starling.utils.Color;

public class ThrobberSprite extends StaticThrobberSprite
{
    public function ThrobberSprite (model :Throbber)
    {
        super(model);
        _regs.addSignalListener(_model.positionChanged, positionChanged);
        _regs.addSignalListener(touchEnded, function (touch :Touch) :void {
            log.info("touched", "throbber", _model, "touch", touch, "spritePos",
                new Vector2(_sprite.x, _sprite.y));
        });
    }

    public function showFailure () :void
    {
        var line :Vector2 = new Vector2(1, 1);
        line.length = JammyConsts.THROBBER_MAX_RADIUS * 2 - 10;
        var shape :Shape = new Shape();
        shape.graphics.lineStyle(10, Color.RED);
        shape.graphics.lineTo(line.x, line.y);
        shape.graphics.moveTo(line.x, 0);
        shape.graphics.lineTo(0, line.y);
        var img :Image = render(shape);
        img.x = -img.width / 2;
        img.y = -img.height / 2;
    }

    override protected function update (dt :Number) :void
    {
        super.update(dt);
        updateRadius();
    }

    override protected function updateRadius () :void
    {
        _sprite.scaleX = _sprite.scaleY =
            GameMode(mode).throb * (_model.radius / JammyConsts.THROBBER_MAX_RADIUS);
    }

    private static const log :Log = Log.getLog(ThrobberSprite);
}
}
