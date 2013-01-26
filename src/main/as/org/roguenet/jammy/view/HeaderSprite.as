package org.roguenet.jammy.view {

import aspire.geom.Vector2;

import flash.display.Shape;

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

    public function setPreviousThrobber (throbber :Throbber) :void
    {
        if (_prevThrob != null) {
            _prevThrob.model.destroySelf();
        }

        _prevThrob = new StaticThrobberSprite(
            new Throbber(PREV_THROB_POS.clone(), throbber.color, throbber.type));
        addDependentObject(_prevThrob, _sprite);
        addDependentObject(_prevThrob.model);

        setScore(_score + throbber.getScoreValue());
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
    }

    protected function setScore (score :int) :void
    {
        _scoreField.text = "Score: " + (_score = score);
    }

    protected static const CORNER_ROUND_SIZE :Number = 20;
    protected static const PREV_THROB_POS :Vector2 = new Vector2(JammyConsts.HEADER_WIDTH / 2,
        JammyConsts.THROBBER_MIN_RADIUS + JammyConsts.HEADER_MARGIN);

    protected var _prevThrob :StaticThrobberSprite;
    protected var _score :int;
    protected var _scoreField :TextField;
}
}
