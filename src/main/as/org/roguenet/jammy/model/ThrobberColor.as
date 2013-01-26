package org.roguenet.jammy.model {

import aspire.util.Enum;
import aspire.util.WeightedArray;

import org.roguenet.jammy.JammyContext;

import starling.utils.Color;

public class ThrobberColor extends Enum
{
    public static const BLUE: ThrobberColor = new ThrobberColor("BLUE", Color.BLUE);
    public static const RED :ThrobberColor = new ThrobberColor("RED", Color.RED);
    public static const GREEN :ThrobberColor = new ThrobberColor("GREEN", Color.GREEN);
    public static const YELLOW :ThrobberColor = new ThrobberColor("YELLOW", Color.YELLOW);
    finishedEnumerating(ThrobberColor);

    public static function values () :Array
    {
        return Enum.values(ThrobberColor);
    }

    public static function valueOf (name :String) :ThrobberColor
    {
        return Enum.valueOf(ThrobberColor, name) as ThrobberColor;
    }

    public static function random () :ThrobberColor
    {
        if (_weights == null) {
            _weights = new WeightedArray(JammyContext.RAND);
            values().forEach(function (color :ThrobberColor, ...ignored) :void {
                _weights.push(color, color._weight);
            });
        }
        return _weights.getNextData();
    }

    public function get value () :uint
    {
        return _value;
    }

    public function ThrobberColor (name :String, value :uint, weight :int = 1)
    {
        super(name);
        _value = value;
        _weight = weight;
    }

    protected var _value :uint;
    protected var _weight :int;

    protected static var _weights :WeightedArray;
}
}
