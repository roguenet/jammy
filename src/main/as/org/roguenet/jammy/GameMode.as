package org.roguenet.jammy {

import flash.geom.Point;

import flashbang.AppMode;
import flashbang.util.Easing;

import org.roguenet.jammy.model.Throbber;
import org.roguenet.jammy.view.ThrobberSprite;

public class GameMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        for (var ii :int = 0; ii < 10; ii++) {
            var sprite :ThrobberSprite =
                new ThrobberSprite(new Throbber(randomPos(), randomRadius()));
            addObject(sprite, modeSprite);
            addObject(sprite.model);
        }
    }

    public function get throb () :Number
    {
        return _throb;
    }

    override public function update (dt :Number) :void
    {
        _throbElapsed += dt;
        _totalTimeElapsed += dt;
        if (_throbElapsed > _throbTime) {
            if (_totalTimeElapsed < JammyContext.THROB_RAMP_UP_TIME) {
                _throbTime = Easing.linear(JammyContext.THROB_TIME_MAX / 2,
                    JammyContext.THROB_TIME_MIN / 2, _totalTimeElapsed,
                    JammyContext.THROB_RAMP_UP_TIME);
            }
            _throbElapsed = _throbElapsed % _throbTime;
            _upThrob = !_upThrob;
        }
        const min :Number = JammyContext.THROB_MIN;
        const max :Number = JammyContext.THROB_MAX;
        _throb = _upThrob ? Easing.easeIn(min, max, _throbElapsed, _throbTime) :
            Easing.easeOut(max, min, _throbElapsed, _throbTime);

        super.update(dt);
    }

    protected static function randomPos () :Point
    {
        return new Point(JammyContext.RAND.getNumber(JammyContext.WIDTH),
            JammyContext.RAND.getNumber(JammyContext.HEIGHT));
    }

    protected static function randomRadius () :int
    {
        return JammyContext.RAND.getInRange(JammyContext.THROBBER_MIN_RADIUS,
            JammyContext.THROBBER_MAX_RADIUS);
    }

    protected var _throb :Number;
    protected var _throbElapsed :Number = 0;
    protected var _throbTime :Number = JammyContext.THROB_TIME_MAX / 2;
    protected var _totalTimeElapsed :Number = 0;
    protected var _upThrob :Boolean = true;
}
}
