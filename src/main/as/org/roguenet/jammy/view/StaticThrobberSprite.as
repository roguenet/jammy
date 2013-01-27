package org.roguenet.jammy.view {

import aspire.geom.Vector2;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.text.TextField;
import flash.text.TextFormat;

import org.roguenet.jammy.GameMode;
import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

import starling.display.Image;

public class StaticThrobberSprite extends RenderedSprite
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
        var img :Image = render(circle, 10);
        img.x = -JammyConsts.THROBBER_MAX_RADIUS - 10;
        img.y = -JammyConsts.THROBBER_MAX_RADIUS - 10;
    }

    protected function positionChanged (pos :Vector2) :void
    {
        _sprite.x = pos.x;
        _sprite.y = pos.y;
    }

    protected var _model :Throbber;
}
}
