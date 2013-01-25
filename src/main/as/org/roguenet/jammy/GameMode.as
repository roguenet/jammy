package org.roguenet.jammy {

import flashbang.AppMode;
import flashbang.objects.Button;
import flashbang.objects.MovieObject;
import flashbang.objects.SimpleTextButton;

public class GameMode extends AppMode
{
    override protected function setup () :void
    {
        super.setup();

        var obj :MovieObject = MovieObject.create("flump/walk");
        obj.display.x = Jammy.WIDTH / 2;
        obj.display.y = Jammy.HEIGHT / 2;
        addObject(obj, this.modeSprite);

        var pause :Button = new SimpleTextButton("Pause", 18);
        pause.display.x = (Jammy.WIDTH - pause.display.width) * 0.5;
        pause.display.y = Jammy.HEIGHT - pause.display.height - 20;
        addObject(pause, this.modeSprite);
        _regs.addSignalListener(pause.clicked, function () :void {
            viewport.pushMode(new PauseMode());
        });
    }
}
}
