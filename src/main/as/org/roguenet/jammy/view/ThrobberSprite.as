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

        // add a random rotation up to 30 degrees off in either direction
        _sprite.rotation = ((Math.random() * 60 - 30) / 180) * Math.PI;
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
