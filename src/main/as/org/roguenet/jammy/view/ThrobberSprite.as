package org.roguenet.jammy.view {

import flashbang.resource.ImageResource;

import org.roguenet.jammy.GameMode;
import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

import starling.display.Image;

public class ThrobberSprite extends StaticThrobberSprite
{
    public function ThrobberSprite (model :Throbber)
    {
        super(model);
        _regs.addSignalListener(_model.positionChanged, positionChanged);
    }

    public function showFailure () :void
    {
        var img :Image = ImageResource.createImage("jammy-retina/x");
        img.x = -img.width / 2 - 10;
        img.y = -img.height / 2 - 10;
        _sprite.addChild(img);
    }

    override protected function update (dt :Number) :void
    {
        super.update(dt);
        updateRadius();
    }

    override protected function addedToMode () :void
    {
        super.addedToMode();
        updateRadius();
    }

    protected function updateRadius () :void
    {
        _sprite.scaleX = _sprite.scaleY =
            GameMode(mode).throb * (_model.radius / JammyConsts.THROBBER_MAX_RADIUS);
    }
}
}
