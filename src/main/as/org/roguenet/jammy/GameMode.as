package org.roguenet.jammy {

import aspire.geom.Vector2;
import aspire.util.F;
import aspire.util.Log;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.Randoms;
import aspire.util.Set;
import aspire.util.Sets;

import flash.geom.Rectangle;

import flashbang.AppMode;
import flashbang.Flashbang;
import flashbang.GameObjectRef;
import flashbang.objects.SpriteObject;
import flashbang.tasks.AlphaTask;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.SerialTask;

import org.roguenet.jammy.model.Throbber;
import org.roguenet.jammy.model.ThrobberType;
import org.roguenet.jammy.view.BoardBackgroundSprite;
import org.roguenet.jammy.view.HeaderSprite;
import org.roguenet.jammy.view.ThrobberSprite;

import starling.display.Quad;

public class GameMode extends AppMode
{
    override protected function enter () :void
    {
        if (_board != null) {
            _board.destroySelf();
            _header.destroySelf();
            _boardBackground.destroySelf();
        }

        _totalTime = 0;
        _throbbers = Maps.newMapOf(Throbber);
        _timer = new ThrobTimer();

        // header on top so its previous throbber sprite can overhang the board
        addObject(_board = new SpriteObject(), modeSprite);
        addObject(_header = new HeaderSprite(), modeSprite);

        addObject(_boardBackground = new BoardBackgroundSprite(), _board.sprite);
        _regs.addSignalListener(_boardBackground.touchEnded,
            F.callback(Flashbang.audio.playSoundNamed, "noCardTap"));
        for (var ii :int = 0; ii < JammyConsts.INITIAL_THROBBER_COUNT; ii++) {
            addThrobber();
        }
        _regs.addSignalListener(_timer.throbStateChanged, throbStateChanged);

        _youSuckTokens = [];
        for (ii = 0; ii < JammyConsts.THROBBER_LEVELS; ii++) {
            _youSuckTokens.push(0);
        }
    }

    /**
     * Returns -1 if this GameMode has never gone through a game
     */
    public function get score () :int
    {
        return _header == null ? -1 : _header.score;
    }

    public function get throb () :Number
    {
        return _timer.value;
    }

    override public function update (dt :Number) :void
    {
        _timer.update(dt);
        super.update(dt);

        _header.updateTimer(_totalTime += dt);
        if (_totalTime >= JammyConsts.ROUND_TIME) {
            Flashbang.audio.playSoundNamed("gameOver");

            // have to set up the quad here because we want it under the header
            var quad :Quad = new Quad(JammyConsts.WIDTH, JammyConsts.HEIGHT, 0);
            quad.alpha = 0.5;
            modeSprite.addChildAt(quad, modeSprite.getChildIndex(_header.sprite));
            viewport.pushMode(new GameOverMode(this));
        }
    }

    override public function destroyObject (ref :GameObjectRef) :void
    {
        // must do this before the call to super, or ref.object is gone
        if (ref.object is Throbber) {
            _throbbers.remove(Throbber(ref.object));
        }

        super.destroyObject(ref);
    }

    protected function touchedThrobber (throbber :Throbber) :void
    {
        if (_header.previous == null || _header.previous.isCompatible(throbber)) {
            throbber.destroySelf();
            var bonus :int = 0;
            if (_timer.fast) {
                bonus = (_currentFastBonus += JammyConsts.FAST_MODE_SCORE_BONUS);
            } else {
                _currentFastBonus = 0;
            }
            _header.setPreviousThrobber(throbber, bonus);
            Flashbang.audio.playSoundNamed("cardTap");
            updateFastMode();

        } else {
            var view :ThrobberSprite = _throbbers.get(throbber);
            view.showFailure();
            removeThrobber(view);
            Flashbang.audio.playSoundNamed("wrongCard");
            youSuck();
            _currentFastBonus = 0;
        }
    }

    protected function removeThrobber (view :ThrobberSprite) :void
    {
        view.addTask(new SerialTask(new AlphaTask(0, JammyConsts.FADE_TIME),
            // can't use SelfDestructTask because we need to destroy the model, and
            // this task is on the view.
            new FunctionTask(view.model.destroySelf)));
    }

    protected function addThrobber (excludeTypes :Array = null) :Throbber
    {
        if (_throbbers.size() >= JammyConsts.THROBBER_COUNT_MAX) {
            log.error("Already at max throbber count, not adding more");
            return null;
        }

        var pos :Vector2 = randomPos();
        if (pos == null) {
            log.warning("Unable to add throbber, nowhere to put it");
            return null;
        }

        var type :ThrobberType = randomType(excludeTypes);
        var sprite :ThrobberSprite = new ThrobberSprite(new Throbber(pos, type));
        addObject(sprite, _board.sprite);
        addObject(sprite.model);
        _throbbers.put(sprite.model, sprite);
        _regs.addSignalListener(sprite.touchEnded, F.callback(touchedThrobber, sprite.model));
        return sprite.model;
    }

    protected function randomType (excludeTypes :Array = null) :ThrobberType
    {
        // make sure we don't ever have more than 2 of the same type on the board at a time, or
        // 2 that match the previous
        var counts :Map = Maps.newMapOf(ThrobberType);
        if (_header.previous != null) {
            counts.put(_header.previous.type, 1);
        }
        for each (var throbber :Throbber in _throbbers.keys()) {
            counts.put(throbber.type, (counts.get(throbber.type) || 0) + 1);
        }
        var types :Array = ThrobberType.values();
        if (excludeTypes != null) {
            for (var ii :int = 0; ii < excludeTypes.length; ii++) {
                var idx :int = types.indexOf(excludeTypes[ii]);
                if (idx >= 0) types.splice(idx, 1);
            }
        }
        counts.forEach(function (type :ThrobberType, count :int) :void {
            if (count >= JammyConsts.MAX_THROBBERS_PER_TYPE) {
                idx = types.indexOf(type);
                if (idx >= 0) types.splice(idx, 1);
            }
        });
        return RAND.pick(types);
    }

    protected function throbStateChanged (newState :ThrobState) :void
    {
        if (newState == ThrobState.UP) {
            for each (var throbber :Throbber in _throbbers.keys()) {
                throbber.levelUp();
                if (throbber.level == JammyConsts.THROBBER_LEVELS) {
                    removeThrobber(ThrobberSprite(_throbbers.get(throbber)));
                }
            }

        } else if (newState == ThrobState.DOWN) {
            var types :Array = [];
            for (var ii :int = 0; ii < JammyConsts.THROBBERS_PER_THROB; ii++) {
                throbber = addThrobber(types);
                if (throbber != null) {
                    types.push(throbber.type);
                }
            }
            _youSuckTokens.shift();
            _youSuckTokens.push(0);
            updateFastMode();
            Flashbang.audio.playSoundNamed("pulse");
        }
    }

    protected function updateFastMode () :void
    {
        _timer.setFastMode(
            _throbbers.size() + youSuckValue() < JammyConsts.FAST_MODE_THRESHOLD);
    }

    protected function youSuckValue () :int
    {
        var count :int = 0;
        for each (var value :int in _youSuckTokens) count += value;
        return count;
    }

    protected function youSuck () :void
    {
        _youSuckTokens[_youSuckTokens.length - 1]++;
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
                var grownPos :Vector2 = quad.grow(pos, PLACEMENT_DIST_MIN);
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
        for each (var throb :Throbber in _throbbers.keys()) {
            if (throb.containsAtMax(pos)) {
                // try again, this pos can't work
                return null;
            }

            if (throb.intersectsAtMax(pos, PLACEMENT_DIST_MIN)) {
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
    protected static const PLACEMENT_DIST_MIN :Number =
        JammyConsts.THROBBER_MAX_RADIUS * JammyConsts.THROB_MAX + JammyConsts.PLACEMENT_BUFFER;
    protected static const PLACEMENT_BOUNDS :Rectangle =
        new Rectangle(
            JammyConsts.BOARD_X + PLACEMENT_DIST_MIN,
            JammyConsts.BOARD_Y + PLACEMENT_DIST_MIN,
            JammyConsts.BOARD_WIDTH - PLACEMENT_DIST_MIN * 2,
            JammyConsts.BOARD_HEIGHT - PLACEMENT_DIST_MIN * 2);

    protected var _throbbers :Map;
    protected var _header :HeaderSprite;
    protected var _boardBackground :BoardBackgroundSprite;
    protected var _board :SpriteObject;
    protected var _timer :ThrobTimer;
    // if the player clears a piece by hitting one out of order, he gets a you suck token for
    // LEVELS number of turns. These tokens can prevent the user from getting into fast mode.
    protected var _youSuckTokens :Array = [];
    protected var _totalTime :Number = 0;
    protected var _currentFastBonus :int = 0;

    private static const log :Log = Log.getLog(GameMode);
}
}

import aspire.geom.Vector2;
import aspire.util.Enum;

import flash.geom.Rectangle;

import flashbang.util.Easing;

import org.osflash.signals.Signal;
import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.ThrobState;

class ThrobTimer
{
    public const throbStateChanged :Signal = new Signal();

    public function get value () :Number
    {
        return _value;
    }

    public function get state () :ThrobState
    {
        return _state;
    }

    public function get fast () :Boolean
    {
        return _fast;
    }

    public function setFastMode (fast :Boolean) :void
    {
        if (_fast == fast) {
            return;
        }

        _fast = fast;
        _modeTimeElapsed = 0;
        _prevModeTime = _throbTime;

        var distanceNormal :Number =
            (_throbTime - HALF_TIME_FAST) / (HALF_TIME_BASE - HALF_TIME_FAST);
        if (!_fast) {
            distanceNormal = 1 - distanceNormal;
        }
        _rampUpTime = RAMP_UP_TIME * distanceNormal;
    }

    public function update (dt :Number) :void
    {
        // update tracking values.
        _stateElapsed += dt;
        _modeTimeElapsed += dt;

        _throbTime = Easing.linear(_prevModeTime, _fast ? HALF_TIME_FAST : HALF_TIME_BASE,
            Math.min(_modeTimeElapsed, _rampUpTime), _rampUpTime);
        changeState(_state.checkState(_stateElapsed, _state.stateTime(_throbTime)));
        // our state may have changed, recalculate the state time.
        _value = _state.ease(_stateElapsed, _state.stateTime(_throbTime));
    }

    public function changeState (newState :ThrobState) :void
    {
        if (newState == _state) {
            return; // short-circuit the NOOP
        }

        var stateTime :Number = _state.stateTime(_throbTime);
        _stateElapsed = _stateElapsed > stateTime ? _stateElapsed % stateTime : 0;
        throbStateChanged.dispatch(_state = newState);
    }

    protected static const HALF_TIME_BASE :Number = JammyConsts.THROB_TIME_BASE / 2;
    protected static const HALF_TIME_FAST :Number = JammyConsts.THROB_TIME_FAST / 2;
    protected static const RAMP_UP_TIME :Number = JammyConsts.THROB_RAMP_UP_TIME;

    protected var _value :Number;
    protected var _stateElapsed :Number = 0;
    protected var _throbTime :Number = HALF_TIME_FAST;
    protected var _modeTimeElapsed :Number = 0;
    protected var _state :ThrobState = ThrobState.IDLE_UP;
    protected var _fast :Boolean = true;
    protected var _prevModeTime :Number = _throbTime;
    protected var _rampUpTime :Number = RAMP_UP_TIME;
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
