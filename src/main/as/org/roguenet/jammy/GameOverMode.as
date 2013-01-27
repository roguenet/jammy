package org.roguenet.jammy {

import aspire.util.F;

import flashbang.AppMode;
import flashbang.objects.SimpleTimer;

public class GameOverMode extends AppMode
{
    public function GameOverMode (game :GameMode)
    {
        _game = game;
    }

    override protected function setup () :void
    {
        super.setup();

        addObject(new SimpleTimer(JammyConsts.GAME_OVER_DELAY,
            F.callback(viewport.unwindToMode, new MenuMode(_game))));
    }

    protected var _game :GameMode;
}
}
