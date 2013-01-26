package org.roguenet.jammy.view {

import aspire.geom.Vector2;
import aspire.util.Log;

import org.roguenet.jammy.GameMode;
import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

import starling.events.Touch;

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
