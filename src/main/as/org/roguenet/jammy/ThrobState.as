package org.roguenet.jammy {

import aspire.util.Enum;

import flashbang.util.Easing;

public class ThrobState extends Enum
{
    public static const IDLE_UP :ThrobState = new ThrobState("IDLE_UP");
    public static const UP :ThrobState = new ThrobState("UP");
    public static const DOWN :ThrobState = new ThrobState("DOWN");
    public static const IDLE_DOWN :ThrobState = new ThrobState("IDLE_DOWN");
    finishedEnumerating(ThrobState);

    public static function values () :Array
    {
        return Enum.values(ThrobState);
    }

    public static function valueOf (name :String) :ThrobState
    {
        return Enum.valueOf(ThrobState, name) as ThrobState;
    }

    public function checkState (elapsed :Number, total :Number) :ThrobState
    {
        if (elapsed >= total) {
            return next;
        }
        return this;
    }

    public function get next () :ThrobState
    {
        if (_next == null) {
            var all :Array = values();
            _next = all[(ordinal() + 1) % all.length];
        }
        return _next;
    }

    public function get prev () :ThrobState
    {
        if (_prev == null) {
            var all :Array = values();
            _prev = all[(ordinal() - 1 + all.length) % all.length];
        }
        return _prev;
    }

    public function isUp () :Boolean
    {
        return this == IDLE_UP || this == UP;
    }

    public function isThrobbing () :Boolean
    {
        return this == UP || this == DOWN;
    }

    public function ease (elapsed :Number, total :Number) :Number
    {
        if (!isThrobbing()) {
            return JammyConsts.THROB_MIN;
        }

        if (this == UP) {
            return Easing.easeIn(JammyConsts.THROB_MIN, JammyConsts.THROB_MAX, elapsed, total);
        } else {
            return Easing.easeOut(JammyConsts.THROB_MAX, JammyConsts.THROB_MIN, elapsed, total);
        }
    }

    public function stateTime (halfCycleTime :Number) :Number
    {
        return isThrobbing() ?
            halfCycleTime * (1 - JammyConsts.THROB_TIMING_THRESHOLD) :
            halfCycleTime * JammyConsts.THROB_TIMING_THRESHOLD;
    }

    public function ThrobState (name :String)
    {
        super(name);
    }

    protected var _next :ThrobState;
    protected var _prev :ThrobState;
}
}
