package org.roguenet.jammy.view {

import aspire.geom.Vector2;

import flash.display.Shape;

import flashbang.Flashbang;
import flashbang.objects.SceneObject;

import org.roguenet.jammy.JammyConsts;
import org.roguenet.jammy.model.Throbber;

import starling.text.TextField;
import starling.utils.Color;

public class HeaderSprite extends RenderedSprite
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
        _prevThrob.display.scaleX = _prevThrob.display.scaleY = 0.75;
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
        var background :Shape = new Shape();
        background.graphics.beginFill(0x888888);
        background.graphics.drawRect(0, 0, JammyConsts.HEADER_WIDTH,
            JammyConsts.HEADER_HEIGHT - CORNER_ROUND_SIZE);
        background.graphics.endFill();
        background.graphics.beginFill(0x888888);
        background.graphics.drawRoundRect(0, 0, JammyConsts.HEADER_WIDTH, JammyConsts.HEADER_HEIGHT,
            CORNER_ROUND_SIZE);
        background.graphics.endFill();
        render(background);

        _scoreField = new TextField(JammyConsts.HEADER_WIDTH / 4, JammyConsts.HEADER_HEIGHT,
            "Score: 0", "Verdana", 30, Color.GREEN, true);
        _scoreField.x = JammyConsts.HEADER_WIDTH - _scoreField.width;
        addDependentObject(new SceneObject(_scoreField), _sprite);

        addDependentObject(_timer = new TimerBar(), _sprite);
        _timer.sprite.x = JammyConsts.HEADER_MARGIN;
        _timer.sprite.y = (JammyConsts.HEADER_HEIGHT - JammyConsts.TIMERBAR_HEIGHT) / 2;
    }

    protected function setScore (score :int) :void
    {
        _scoreField.text = "Score: " + (_score = score);
    }

    protected static const CORNER_ROUND_SIZE :Number = 20;
    protected static const PREV_THROB_POS :Vector2 = new Vector2(JammyConsts.HEADER_WIDTH / 2,
        JammyConsts.THROBBER_MAX_RADIUS * 0.75 + JammyConsts.HEADER_MARGIN);

    protected var _prevThrob :StaticThrobberSprite;
    protected var _score :int;
    protected var _scoreField :TextField;
    protected var _timer :TimerBar;
    protected var _beepsToPlay :int = JammyConsts.TIMER_BEEPS_PER_ROUND;
}
}
