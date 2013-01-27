package org.roguenet.jammy {

import aspire.util.Enum;

import flashbang.util.Easing;

public class ThrobState extends Enum
{
    public static const IDLE_UP :ThrobState = new ThrobState("IDLE_UP",
        function (total :Number) :Number {
            return total * JammyConsts.THROB_TIMING_THRESHOLD;
        }
    );
    public static const UP :ThrobState = new ThrobState("UP",
        function (total :Number) :Number {
            return total;
        }
    );
    public static const DOWN :ThrobState = new ThrobState("DOWN",
        function (total :Number) :Number {
            return total * (1 - JammyConsts.THROB_TIMING_THRESHOLD);
        }
    );
    public static const IDLE_DOWN :ThrobState = new ThrobState("IDLE_DOWN",
        function (total :Number) :Number {
            return total;
        }
    );
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
        if (elapsed >= getThreshold(total)) {
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

    public function getThreshold (total :Number) :Number
    {
        return _thresholdFn(total);
    }

    public function ease (elapsed :Number, total :Number) :Number
    {
        if (!isThrobbing()) {
            return JammyConsts.THROB_MIN;
        }

        if (this == UP) {
            var threshold :Number = prev.getThreshold(total);
            return Easing.easeIn(JammyConsts.THROB_MIN, JammyConsts.THROB_MAX,
                elapsed - threshold, total - threshold);
        } else {
            return Easing.easeOut(JammyConsts.THROB_MAX, JammyConsts.THROB_MIN,
                elapsed, getThreshold(total));
        }
    }

    public function ThrobState (name :String, thresholdFn :Function)
    {
        super(name);
        _thresholdFn = thresholdFn;
    }

    protected var _thresholdFn :Function;
    protected var _next :ThrobState;
    protected var _prev :ThrobState;
}
}
