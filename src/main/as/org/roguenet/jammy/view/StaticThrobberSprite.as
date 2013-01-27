package org.roguenet.jammy.view {

import aspire.geom.Vector2;

import flashbang.objects.SpriteObject;
import flashbang.resource.ImageResource;

import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

import starling.display.Image;

public class StaticThrobberSprite extends SpriteObject
{
    public function StaticThrobberSprite (model :Throbber)
    {
        _model = model;
        _model.addDependentObject(this);

        buildView();
        positionChanged(_model.position);
    }

    public function get model () :Throbber
    {
        return _model;
    }

    protected function buildView () :void
    {
        var img :Image = ImageResource.createImage(_model.type.assetName);
        img.x = -JammyConsts.THROBBER_MAX_RADIUS - 10;
        img.y = -JammyConsts.THROBBER_MAX_RADIUS - 10;
        _sprite.addChild(img);
    }

    protected function positionChanged (pos :Vector2) :void
    {
        _sprite.x = pos.x;
        _sprite.y = pos.y;
    }

    protected var _model :Throbber;
}
}
