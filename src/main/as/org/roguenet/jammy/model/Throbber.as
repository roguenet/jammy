package org.roguenet.jammy.model {

import aspire.geom.Vector2;

import flash.geom.Rectangle;

import flashbang.GameObject;
import flashbang.util.Collision;
import flashbang.util.Easing;

import org.osflash.signals.Signal;
import org.roguenet.jammy.JammyConsts;

public class Throbber extends GameObject
{
    public const positionChanged :Signal = new Signal();
    public const radiusChanged :Signal = new Signal();

    public function Throbber (position :Vector2, color :ThrobberColor = null,
        value :ThrobberValue = null)
    {
        _pos = position;
        grow();
        _color = color == null ? ThrobberColor.random() : color;
        _value = value == null ? ThrobberValue.random() : value;
    }

    public function get color () :ThrobberColor
    {
        return _color;
    }

    public function get value () :ThrobberValue
    {
        return _value;
    }

    public function get position () :Vector2
    {
        return _pos;
    }

    public function get radius () :int
    {
        return _radius;
    }

    public function moveTo (pos :Vector2) :void
    {
        _pos = pos.clone(); // protect against external modification
        _bounds = null;
        positionChanged.dispatch(pos);
    }

    public function grow () :void
    {
        setRadius(Easing.linear(JammyConsts.THROBBER_MIN_RADIUS, JammyConsts.THROBBER_MAX_RADIUS,
            ++_level, JammyConsts.THROBBER_LEVELS));
    }

    public function getBounds () :Rectangle
    {
        if (_bounds == null) {
            _bounds = new Rectangle();
            _bounds.left = _pos.x - _radius;
            _bounds.top = _pos.y - _radius;
            _bounds.width = _bounds.height = _radius * 2;
        }
        return _bounds.clone();
    }

    /**
     * Returns true if our circle contains or intersects the given point.
     */
    public function contains (pos :Vector2) :Boolean
    {
        return Collision.circlesIntersect(_pos, _radius, pos, 0);
    }

    /**
     * Returns true if our circle intersects with the provided circle.
     */
    public function intersects (pos :Vector2, radius :int) :Boolean
    {
        return Collision.circlesIntersect(_pos, _radius, pos, radius);
    }

    override public function toString () :String
    {
        return "Throbber [" + _pos + ", " + _radius + ", " + _color + ", " + _value + "]";
    }

    protected function setRadius (radius :int) :void
    {
        _bounds = null;
        radiusChanged.dispatch(_radius = radius);
    }

    protected var _color :ThrobberColor;
    protected var _value :ThrobberValue;
    protected var _pos :Vector2;
    protected var _radius :int;
    protected var _level :int = -1;

    protected var _bounds :Rectangle; // cached
}
}
