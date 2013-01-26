package org.roguenet.jammy.model {

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.GameObject;

import org.osflash.signals.Signal;

public class Throbber extends GameObject
{
    public const positionChanged :Signal = new Signal();
    public const radiusChanged :Signal = new Signal();

    public function Throbber (position :Point, radius :int,
        color :ThrobberColor = null, value :ThrobberValue = null)
    {
        _pos = position;
        _radius = radius;
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

    public function get position () :Point
    {
        return _pos;
    }

    public function get radius () :int
    {
        return _radius;
    }

    public function moveTo (pos :Point) :void
    {
        _pos = pos.clone(); // protect against external modification
        _bounds = null;
        positionChanged.dispatch(pos);
    }

    public function setRadius (radius :int) :void
    {
        _bounds = null;
        radiusChanged.dispatch(_radius = radius);
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

    override public function toString () :String
    {
        return "Throbber [" + _pos + ", " + _radius + ", " + _color + ", " + _value + "]";
    }

    protected var _color :ThrobberColor;
    protected var _value :ThrobberValue;
    protected var _pos :Point;
    protected var _radius :int;

    protected var _bounds :Rectangle; // cached
}
}
