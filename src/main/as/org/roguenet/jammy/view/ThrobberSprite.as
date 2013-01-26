package org.roguenet.jammy.view {

import aspire.util.Log;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.filters.DropShadowFilter;
import flash.geom.Point;

import flashbang.objects.SpriteObject;

import org.roguenet.jammy.GameMode;
import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

import starling.display.Image;
import starling.events.Touch;
import starling.textures.Texture;

public class ThrobberSprite extends SpriteObject
{
    public function ThrobberSprite (model :Throbber)
    {
        _model = model;
        _model.addDependentObject(this);
        _regs.addSignalListener(_model.positionChanged, positionChanged);

        buildView();
        positionChanged(_model.position);

        _regs.addSignalListener(touchEnded, function (touch :Touch) :void {
            log.info("touched", "throbber", _model, "touch", touch, "spritePos",
                new Point(_sprite.x, _sprite.y));
        });
    }

    public function get model () :Throbber
    {
        return _model;
    }

    protected function buildView () :void
    {
        var circle :Shape = new Shape();
        circle.graphics.beginFill(_model.color.value);
        circle.graphics.drawCircle(JammyConsts.THROBBER_MAX_RADIUS,
            JammyConsts.THROBBER_MAX_RADIUS, JammyConsts.THROBBER_MAX_RADIUS);
        circle.graphics.endFill();
        circle.filters = [ new DropShadowFilter() ];

        const shadowBuffer :int = 20;
        var data :BitmapData = new BitmapData(JammyConsts.THROBBER_MAX_RADIUS * 2 + shadowBuffer,
            JammyConsts.THROBBER_MAX_RADIUS * 2 + shadowBuffer, true, 0);
        data.draw(circle);
        var img :Image = new Image(Texture.fromBitmapData(data));
        img.x = -JammyConsts.THROBBER_MAX_RADIUS - shadowBuffer / 2;
        img.y = -JammyConsts.THROBBER_MAX_RADIUS - shadowBuffer / 2;
        _sprite.addChild(img);
    }

    protected function positionChanged (pos :Point) :void
    {
        _sprite.x = pos.x;
        _sprite.y = pos.y;
    }

    override protected function addedToMode () :void
    {
        super.addedToMode();
        updateRadius();
    }

    override protected function update (dt :Number) :void
    {
        super.update(dt);
        updateRadius();
    }

    protected function updateRadius () :void
    {
        _sprite.scaleX = _sprite.scaleY =
            GameMode(mode).throb * (_model.radius / JammyConsts.THROBBER_MAX_RADIUS);
    }

    protected var _model :Throbber;

    private static const log :Log = Log.getLog(ThrobberSprite);
}
}
