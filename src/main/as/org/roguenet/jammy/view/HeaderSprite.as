package org.roguenet.jammy.view {

import aspire.geom.Vector2;

import flash.display.Shape;

import flashbang.Flashbang;
import flashbang.objects.SceneObject;
import flashbang.objects.SpriteObject;
import flashbang.resource.ImageResource;

import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

import starling.text.TextField;
import starling.utils.Color;

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

        _scoreField = new TextField(400, 60, "", "Verdana", 36, Color.RED, true);
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
        _scoreField.text = "SCORE: " + (_score = score);
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
