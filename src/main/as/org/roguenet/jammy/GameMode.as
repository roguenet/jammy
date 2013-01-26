package org.roguenet.jammy {

import flash.geom.Point;

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
                new ThrobberSprite(new Throbber(randomPos(), randomRadius()));
            addObject(sprite, modeSprite);
            addObject(sprite.model);
        }
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
}
}
