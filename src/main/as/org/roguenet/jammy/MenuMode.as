package org.roguenet.jammy {

import flashbang.AppMode;
import flashbang.objects.Button;
import flashbang.objects.SimpleTextButton;

public class MenuMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var start :Button = new SimpleTextButton("Start Game", 18);
        start.display.x = (JammyConsts.WIDTH - start.display.width) * 0.5;
        start.display.y = (JammyConsts.HEIGHT - start.display.height) * 0.5;
        addObject(start, this.modeSprite);
        _regs.addSignalListener(start.clicked, function () :void {
            viewport.changeMode(new GameMode());
        });
    }
}
}
