package org.roguenet.jammy.view {

import aspire.geom.Vector2;
import aspire.util.Log;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

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
                new Vector2(_sprite.x, _sprite.y));
        });
    }

    public function get model () :Throbber
    {
        return _model;
    }

    protected function buildView () :void
    {
        var circle :Sprite = new Sprite();
        circle.graphics.beginFill(_model.color.value);
        circle.graphics.drawCircle(JammyConsts.THROBBER_MAX_RADIUS,
            JammyConsts.THROBBER_MAX_RADIUS, JammyConsts.THROBBER_MAX_RADIUS);
        circle.graphics.endFill();
        var value :TextField = new TextField();
        var format :TextFormat = value.defaultTextFormat;
        format.bold = true;
        format.size = 50;
        format.underline = true;
        value.defaultTextFormat = format;
        value.text = _model.type.value;
        value.x = JammyConsts.THROBBER_MAX_RADIUS - 10;
        value.y = JammyConsts.THROBBER_MAX_RADIUS - 30; // fudge to near the middle
        circle.addChild(value);
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

    protected function positionChanged (pos :Vector2) :void
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
