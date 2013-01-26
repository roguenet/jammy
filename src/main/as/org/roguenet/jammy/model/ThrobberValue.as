package org.roguenet.jammy.model {

import aspire.util.Enum;
import aspire.util.WeightedArray;

import org.roguenet.jammy.JammyConsts;

public class ThrobberValue extends Enum
{
    public static const ONE :ThrobberValue = new ThrobberValue("ONE", "1");
    public static const TWO :ThrobberValue = new ThrobberValue("TWO", "2");
    public static const THREE :ThrobberValue = new ThrobberValue("THREE", "3");
    public static const FOUR :ThrobberValue = new ThrobberValue("FOUR", "4");
    finishedEnumerating(ThrobberValue);

    public static function values () :Array
    {
        return Enum.values(ThrobberValue);
    }

    public static function valueOf (name :String) :ThrobberValue
    {
        return Enum.valueOf(ThrobberValue, name) as ThrobberValue;
    }

    public static function random () :ThrobberValue
    {
        if (_weights == null) {
            _weights = new WeightedArray(JammyConsts.RAND);
            values().forEach(function (value :ThrobberValue, ...ignored) :void {
                _weights.push(value, value._weight);
            });
        }
        return _weights.getNextData();
    }

    public function get value () :String
    {
        return _value;
    }

    public function ThrobberValue (name :String, value :String, weight :int = 1)
    {
        super(name);
        _value = value;
        _weight = weight;
    }

    protected var _value :String;
    protected var _weight :int;

    protected static var _weights :WeightedArray;
}
}
