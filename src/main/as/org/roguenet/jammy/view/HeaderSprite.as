package org.roguenet.jammy.view {

import aspire.geom.Vector2;

import flashbang.Flashbang;
import flashbang.objects.SceneObject;
import flashbang.objects.SpriteObject;
import flashbang.resource.ImageResource;

import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

import starling.text.TextField;

public class HeaderSprite extends SpriteObject
{
    public function HeaderSprite ()
    {
        buildView();
    }

    public function get score () :int
    {
        return _score;
    }

    public function get previous () :Throbber
    {
        return _prevThrob == null ? null : _prevThrob.model;
    }

    public function setPreviousThrobber (throbber :Throbber) :void
    {
        if (_prevThrob != null) {
            _prevThrob.model.destroySelf();
        }

        _prevThrob = new StaticThrobberSprite(
            new Throbber(PREV_THROB_POS.clone(), throbber.type));
        _prevThrob.display.scaleX = _prevThrob.display.scaleY = 0.85;
        addDependentObject(_prevThrob, _sprite);
        addDependentObject(_prevThrob.model);

        setScore(_score + throbber.getScoreValue());
    }

    public function updateTimer (time :Number) :void
    {
        var percent :Number = Math.max(0, Math.min(1,
            (JammyConsts.ROUND_TIME - time) / JammyConsts.ROUND_TIME));
        if (percent > _timer.percent) {
            _beepsToPlay = JammyConsts.TIMER_BEEPS_PER_ROUND; // we're starting over
        } else {
            var remaining :Number = Math.max(0, JammyConsts.ROUND_TIME - time);
            if (remaining < _beepsToPlay) {
                Flashbang.audio.playSoundNamed("timer");
                _beepsToPlay--;
            }
        }
        _timer.setPercent(percent);
    }

    protected function buildView () :void
    {
        _sprite.addChild(ImageResource.createImage("jammy/header"));

        _scoreField = new TextField(400, 60, "", "Verdana", 36, 0xC60511, true);
        setScore(0);
        _scoreField.hAlign = "center"
        _scoreField.x = JammyConsts.HEADER_WIDTH - _scoreField.width - 20;
        _scoreField.y = 10;
        addDependentObject(new SceneObject(_scoreField), _sprite);

        addDependentObject(_timer = new TimerBar(), _sprite);
        _timer.sprite.x = 28;
        _timer.sprite.y = 20;
    }

    protected function setScore (score :int) :void
    {
        replaceNamedTask("score", new ScoreTask(score, _score, _scoreField));
        _score = score;
    }

    protected static const PREV_THROB_POS :Vector2 = new Vector2(JammyConsts.HEADER_WIDTH / 2 + 7,
        JammyConsts.THROBBER_MAX_RADIUS + 8);

    protected var _prevThrob :StaticThrobberSprite;
    protected var _score :int;
    protected var _scoreField :TextField;
    protected var _timer :TimerBar;
    protected var _beepsToPlay :int = JammyConsts.TIMER_BEEPS_PER_ROUND;
}
}

import flashbang.GameObject;
import flashbang.tasks.InterpolatingTask;
import flashbang.util.Easing;

import org.roguenet.jammy.JammyConsts;

import starling.text.TextField;

class ScoreTask extends InterpolatingTask
{
    public function ScoreTask (score :int, from :int, field :TextField)
    {
        super(JammyConsts.FADE_TIME, Easing.easeInOut);
        _to = score;
        _from = from;
        _field = field;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        _elapsedTime += dt;
        _field.text = "SCORE: " + int(interpolate(_from, _to));
        return (_elapsedTime >= _totalTime);
    }

    protected var _to :int;
    protected var _from :int;
    protected var _field :TextField;
}
