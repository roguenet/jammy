package org.roguenet.jammy.model {

import aspire.util.Enum;
import aspire.util.WeightedArray;

import org.roguenet.jammy.JammyConsts;

public class ThrobberType extends Enum
{
    public static const ZERO :ThrobberType = new ThrobberType("ZERO", "0");
    public static const ONE :ThrobberType = new ThrobberType("ONE", "1");
    public static const TWO :ThrobberType = new ThrobberType("TWO", "2");
    public static const THREE :ThrobberType = new ThrobberType("THREE", "3");
    public static const FOUR :ThrobberType = new ThrobberType("FOUR", "4");
    public static const FIVE :ThrobberType = new ThrobberType("FIVE", "5");
    public static const SIX :ThrobberType = new ThrobberType("SIX", "6");
    public static const SEVEN :ThrobberType = new ThrobberType("SEVEN", "7");
    public static const EIGHT :ThrobberType = new ThrobberType("EIGHT", "8");
    public static const NINE :ThrobberType = new ThrobberType("NINE", "9");
    finishedEnumerating(ThrobberType);

    public static function values () :Array
    {
        return Enum.values(ThrobberType);
    }

    public static function valueOf (name :String) :ThrobberType
    {
        return Enum.valueOf(ThrobberType, name) as ThrobberType;
    }

    public static function random () :ThrobberType
    {
        if (_weights == null) {
            _weights = new WeightedArray(JammyConsts.RAND);
            values().forEach(function (value :ThrobberType, ...ignored) :void {
                _weights.push(value, value._weight);
            });
        }
        return _weights.getNextData();
    }

    public function get assetName () :String
    {
        return "jammy-retina/" + name().toLowerCase();
    }

    public function get value () :String
    {
        return _value;
    }

    public function get next () :ThrobberType
    {
        if (_next == null) {
            var all :Array = values();
            _next = all[(ordinal() + 1) % all.length];
        }
        return _next;
    }

    public function get prev () :ThrobberType
    {
        if (_prev == null) {
            var all :Array = values();
            _prev = all[(ordinal() - 1 + all.length) % all.length];
        }
        return _prev;
    }

    public function isCompatible (other :ThrobberType) :Boolean
    {
        return next == other || prev == other;
    }

    public function getCompatible () :Array
    {
        return [ next, prev ];
    }

    public function ThrobberType (name :String, value :String, weight :int = 1)
    {
        super(name);
        _value = value;
        _weight = weight;
    }

    protected var _value :String;
    protected var _weight :int;
    protected var _next :ThrobberType;
    protected var _prev :ThrobberType;

    protected static var _weights :WeightedArray;
}
}
