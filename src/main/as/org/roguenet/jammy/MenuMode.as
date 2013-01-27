package org.roguenet.jammy {

import flashbang.AppMode;
import flashbang.objects.Button;
import flashbang.objects.SimpleTextButton;

import starling.display.Quad;

public class MenuMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var quad :Quad = new Quad(JammyConsts.WIDTH, JammyConsts.HEIGHT, 0);
        quad.alpha = 0.5;
        modeSprite.addChild(quad);

        var start :Button = new SimpleTextButton("Start Game", 18);
        start.display.x = (JammyConsts.WIDTH - start.display.width) / 2;
        start.display.y = (JammyConsts.HEIGHT - start.display.height) / 2;
        addObject(start, modeSprite);
        _regs.addSignalListener(start.clicked, function () :void {
            viewport.popMode();
        });
    }
}
}
