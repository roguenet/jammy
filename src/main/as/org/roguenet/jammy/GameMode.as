package org.roguenet.jammy {

import aspire.geom.Vector2;
import aspire.util.Log;
import aspire.util.Randoms;
import aspire.util.Set;
import aspire.util.Sets;

import flash.geom.Rectangle;

import flashbang.AppMode;

import org.roguenet.jammy.model.Throbber;
import org.roguenet.jammy.view.ThrobberSprite;

public class GameMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        for (var ii :int = 0; ii < 10; ii++) {
            var pos :Vector2 = randomPos();
            if (pos == null) {
                break;
            }
            var sprite :ThrobberSprite = new ThrobberSprite(new Throbber(pos, START_RADIUS));
            addObject(sprite, modeSprite);
            addObject(sprite.model);
            _throbbers.push(sprite.model);
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
        var quads :Array = Quadrant.values();
        while (quads.length > 0) {
            var quadIdx :int = RAND.getInt(quads.length);
            var pos :Vector2 = randomPosInBounds(Quadrant(quads[quadIdx]).slice(PLACEMENT_BOUNDS));
            if (pos != null) {
                return pos;
            }
            quads.slice(quadIdx, 1);
        }
        log.error("Could not find a suitable random position!");
        return null;
    }

    protected function randomPosInBounds (placementBounds :Rectangle) :Vector2
    {
        for (var ii :int = 0; ii < JammyConsts.PLACEMENT_ATTEMPTS_MAX; ii++) {
            // first, pick a random point that is guaranteed not to intersect with a wall.
            var pos :Vector2 = getRandomVector(placementBounds);

            // make sure we're not inside any of the circles (immediately stop), or intersecting
            // with any circles (grow to avoid).
            var intersects :Array = getIntersects(pos);
            if (intersects == null) {
                // try again, this pos can't work
                break;
            }
            if (intersects.length == 0) {
                // we're clean, return this pos
                return pos;
            }

            // we have intersecting throbbers, grow away from them
            var quads :Set = Sets.newSetOf(Quadrant, Quadrant.values());
            var numQuads :int = quads.size();
            for each (var throbber :Throbber in intersects) {
                quads.remove(Quadrant.of(throbber.position.subtract(pos)));
            }
            if (quads.size() == numQuads) {
                // we're surrounded, abandon ship!
                break;
            }
            var quadList :Array = quads.toArray();
            while (quadList.length > 0) {
                // pick a random quadrant we don't have an intersection with
                var quadIdx :int = RAND.getInt(quadList.length);
                var quad :Quadrant = quadList[quadIdx];
                quadList.splice(quadIdx, 1);

                // we can tune this to not move the thing so far if this algorithm has too much
                // trouble finding a placement for a new throbber
                var grownPos :Vector2 = quad.grow(pos, START_RADIUS + BUFFER);
                if (!placementBounds.contains(grownPos.x, grownPos.y)) {
                    // we're too close to a wall
                    break;
                }
                intersects = getIntersects(grownPos);
                if (intersects != null && intersects.length == 0) {
                    // we have a winner
                    return grownPos;
                }
                // else, try to grow again
            }
        }
        return null;
    }

    protected function getIntersects (pos :Vector2) :Array
    {
        var intersects :Array = [];
        for each (var throb :Throbber in _throbbers) {
            if (throb.contains(pos)) {
                // try again, this pos can't work
                return null;
            }

            if (throb.intersects(pos, START_RADIUS + BUFFER)) {
                // add to the list of throbbers we currently intersect.
                intersects.push(throb);
            }
        }
        return intersects;
    }

    protected static function getRandomVector (bounds :Rectangle) :Vector2
    {
        return new Vector2(RAND.getNumberInRange(bounds.left, bounds.right),
            RAND.getNumberInRange(bounds.top, bounds.bottom));
    }

    protected static const RAND :Randoms = JammyConsts.RAND;
    protected static const PLACEMENT_BOUNDS :Rectangle =
        new Rectangle(
            JammyConsts.BOARD_X + JammyConsts.THROBBER_MAX_RADIUS,
            JammyConsts.BOARD_Y + JammyConsts.THROBBER_MAX_RADIUS,
            JammyConsts.BOARD_WIDTH - JammyConsts.THROBBER_MAX_RADIUS * 2,
            JammyConsts.BOARD_HEIGHT - JammyConsts.THROBBER_MAX_RADIUS * 2);
    protected static const START_RADIUS :int = JammyConsts.THROBBER_MAX_RADIUS;
    protected static const BUFFER :int = JammyConsts.PLACEMENT_BUFFER;

    protected var _throbbers :Array = [];
    protected var _timer :ThrobTimer = new ThrobTimer();

    private static const log :Log = Log.getLog(GameMode);
}
}

import aspire.geom.Vector2;
import aspire.util.Enum;

import flash.geom.Rectangle;

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

class Quadrant extends Enum
{
    public static const ONE :Quadrant = new Quadrant("ONE", new Vector2(1, 1));
    public static const TWO :Quadrant = new Quadrant("TWO", new Vector2(-1, 1));
    public static const THREE :Quadrant = new Quadrant("THREE", new Vector2(-1, -1));
    public static const FOUR :Quadrant = new Quadrant("FOUR", new Vector2(1, -1));
    finishedEnumerating(Quadrant);

    public static function values () :Array
    {
        return Enum.values(Quadrant);
    }

    public static function valueOf (name :String) :Quadrant
    {
        return Enum.valueOf(Quadrant, name) as Quadrant;
    }

    public static function of (pos :Vector2) :Quadrant
    {
        if (pos.x >= 0 && pos.y >= 0) return ONE;
        else if (pos.x < 0 && pos.y >= 0) return TWO;
        else if (pos.x < 0 && pos.y < 0) return THREE;
        else return FOUR;
    }

    public function grow (pos :Vector2, distance :Number) :Vector2
    {
        var toAdd :Vector2 = _unitVector.clone();
        toAdd.length = distance;
        return toAdd.addLocal(pos);
    }

    public function slice (bounds :Rectangle) :Rectangle
    {
        var x :Number = bounds.x + bounds.width / 2 * Math.max(0, _unitVector.x);
        var y :Number = bounds.y + bounds.height / 2 * Math.max(0, _unitVector.y);
        return new Rectangle(x, y, bounds.width / 2, bounds.height / 2);
    }

    public function Quadrant (name :String, unitVector :Vector2)
    {
        super(name);
        _unitVector = unitVector;
    }

    protected var _unitVector :Vector2;
}
