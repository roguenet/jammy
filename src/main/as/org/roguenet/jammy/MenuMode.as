package org.roguenet.jammy {

import flashbang.AppMode;
import flashbang.objects.SceneObject;
import flashbang.resource.ImageResource;

import starling.text.TextField;

public class MenuMode extends AppMode
{
    public function MenuMode (game :GameMode = null)
    {
        _game = game;
    }

    override protected function setup () :void
    {
        super.setup();

        modeSprite.addChild(JammyConsts.SPLASH);

        var start :SceneObject = new SceneObject(ImageResource.createImage("jammy/play"));
        addRow(start);
        _regs.addSignalListener(start.touchEnded, function () :void {
            viewport.changeMode(new GameMode());
        });

        if (_game != null && _game.score >= 0) {
            addRow(new SceneObject(new TextField(JammyConsts.WIDTH, 60,
                "SCORE: " + _game.score, "Verdana", 40, 0xFFEA00, true)));
        }

        var yOff :Number = JammyConsts.MENU_TOP_MARGIN;
        for each (var obj :SceneObject in _rows) {
            obj.display.y = yOff;
            yOff += obj.display.height + MARGIN;
        }
    }

    protected function addRow (obj :SceneObject) :void
    {
        obj.display.x = (JammyConsts.WIDTH - obj.display.width) / 2;
        _totalHeight += (_rows.length > 0 ? MARGIN : 0) + obj.display.height;
        _rows.push(obj);
        addObject(obj, modeSprite);
    }

    protected static const MARGIN :int = 12;

    protected var _game :GameMode;
    protected var _rows :Array = [];
    protected var _totalHeight :Number = 0;
}
}
