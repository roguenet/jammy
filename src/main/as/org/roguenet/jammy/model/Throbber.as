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

    public function Throbber (position :Vector2, color :ThrobberColor = null,
        value :ThrobberType = null)
    {
        _pos = position;
        setRadius(radiusForLevel(_level));
        _color = color == null ? ThrobberColor.random() : color;
        _type = value == null ? ThrobberType.random() : value;
    }

    public function get color () :ThrobberColor
    {
        return _color;
    }

    public function get type () :ThrobberType
    {
        return _type;
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

    public function levelUp () :void
    {
        if (++_level == JammyConsts.THROBBER_LEVELS) {
            destroySelf();
        } else {
            addTask(new RadiusTask(radiusForLevel(_level)));
        }
    }

    /**
     * Returns true if our circle contains or intersects the given point.
     */
    public function contains (pos :Vector2) :Boolean
    {
        return Collision.circlesIntersect(_pos, _radius, pos, 0);
    }

    /**
     * Returns true if our circle will contain or intersect the given point when we're as big as
     * we get.
     */
    public function containsAtMax (pos :Vector2) :Boolean
    {
        return Collision.circlesIntersect(_pos, MAX_RADIUS, pos, 0);
    }

    /**
     * Returns true if our circle intersects with the provided circle.
     */
    public function intersects (pos :Vector2, radius :int) :Boolean
    {
        return Collision.circlesIntersect(_pos, _radius, pos, radius);
    }

    /**
     * Returns true if our circle will intersect with the provided circle when we're as big as we
     * get.
     */
    public function intersectsAtMax (pos :Vector2, radius :int) :Boolean
    {
        return Collision.circlesIntersect(_pos, MAX_RADIUS, pos, radius);
    }

    public function setRadius (radius :int) :void
    {
        _radius = radius;
    }

    override public function toString () :String
    {
        return "Throbber [" + _pos + ", " + _radius + ", " + _color + ", " + _type + "]";
    }

    protected static function radiusForLevel (level :int) :Number
    {
        return Easing.linear(MIN_RADIUS, MAX_RADIUS, Math.min(LEVELS - 1, level), LEVELS - 1);
    }

    protected static const MAX_RADIUS :int = JammyConsts.THROBBER_MAX_RADIUS;
    protected static const MIN_RADIUS :int = JammyConsts.THROBBER_MIN_RADIUS;
    protected static const LEVELS :int = JammyConsts.THROBBER_LEVELS;

    protected var _color :ThrobberColor;
    protected var _type :ThrobberType;
    protected var _pos :Vector2;
    protected var _radius :int;
    protected var _level :int = 0;

    protected var _bounds :Rectangle; // cached
}
}

import flashbang.GameObject;
import flashbang.tasks.InterpolatingTask;
import flashbang.util.Easing;

import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

class RadiusTask extends InterpolatingTask
{
    public function RadiusTask (radius :Number)
    {
        super((1 - JammyConsts.THROB_TIMING_THRESHOLD) * (JammyConsts.THROB_TIME_MIN / 2),
            Easing.easeIn);
        _to = radius;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (_elapsedTime == 0) {
            _from = Throbber(obj).radius;
        }

        _elapsedTime += dt;
        Throbber(obj).setRadius(interpolate(_from, _to));
        return (_elapsedTime >= _totalTime);
    }

    protected var _to :Number;
    protected var _from :Number;
}
