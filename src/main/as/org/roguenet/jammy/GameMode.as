package org.roguenet.jammy {

import aspire.geom.Vector2;

import flashbang.AppMode;

import org.roguenet.jammy.model.Throbber;
import org.roguenet.jammy.view.ThrobberSprite;

public class GameMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        for (var ii :int = 0; ii < 10; ii++) {
            var sprite :ThrobberSprite =
                new ThrobberSprite(new Throbber(randomPos(), JammyConsts.THROBBER_MAX_RADIUS));
            addObject(sprite, modeSprite);
            addObject(sprite.model);
            _models.push(sprite.model);
        }
    }

    public function get throb () :Number
    {
        return _timer.value;
    }

    override public function update (dt :Number) :void
    {
        _timer.update(dt);
        super.update(dt);
    }

    protected function randomPos () :Vector2
    {
        return new Vector2(JammyConsts.RAND.getNumber(JammyConsts.WIDTH),
            JammyConsts.RAND.getNumber(JammyConsts.HEIGHT));
    }

    protected var _models :Array = [];
    protected var _timer :ThrobTimer = new ThrobTimer();
}
}

import flashbang.util.Easing;

import org.roguenet.jammy.JammyConsts;

class ThrobTimer
{
    public function get value () :Number
    {
        return _value;
    }

    public function update (dt :Number) :void
    {
        // update tracking values.
        _throbElapsed += dt;
        _totalTimeElapsed += dt;

        // if we've elapsed more than we should in the current half cycle, evolve some values
        if (_throbElapsed > _throbTime) {
            _throbElapsed = _throbElapsed % _throbTime;
            _upThrob = !_upThrob;
            _throbTime = Easing.linear(HALF_TIME_MAX, HALF_TIME_MIN,
                Math.min(_totalTimeElapsed, RAMP_UP_TIME), RAMP_UP_TIME);
        }

        // only throb if we're within the threshold.
        var thresholdTime :Number =
            _upThrob ? THRESHOLD * _throbTime : (1 - THRESHOLD) * _throbTime;
        var doThrob :Boolean = (_upThrob && _throbElapsed >= thresholdTime) ||
            (!_upThrob && _throbElapsed <= thresholdTime);
        if (doThrob) {
            if (_upThrob) {
                _value =
                    Easing.easeIn(MIN, MAX, _throbElapsed - thresholdTime, _throbTime - thresholdTime);
            } else {
                _value = Easing.easeOut(MAX, MIN, _throbElapsed, thresholdTime);
            }
        } else {
            _value = MIN;
        }
    }

    protected static const MIN :Number = JammyConsts.THROB_MIN;
    protected static const MAX :Number = JammyConsts.THROB_MAX;
    protected static const THRESHOLD :Number = JammyConsts.THROB_TIMING_THRESHOLD;
    protected static const HALF_TIME_MIN :Number = JammyConsts.THROB_TIME_MIN / 2;
    protected static const HALF_TIME_MAX :Number = JammyConsts.THROB_TIME_MAX / 2;
    protected static const RAMP_UP_TIME :Number = JammyConsts.THROB_RAMP_UP_TIME;

    protected var _value :Number;
    protected var _throbElapsed :Number = 0;
    protected var _throbTime :Number = JammyConsts.THROB_TIME_MAX / 2;
    protected var _totalTimeElapsed :Number = 0;
    protected var _upThrob :Boolean = true;
}
