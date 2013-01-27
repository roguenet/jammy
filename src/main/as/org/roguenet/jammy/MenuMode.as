package org.roguenet.jammy {

import flash.display.DisplayObject;

import flashbang.AppMode;
import flashbang.objects.Button;
import flashbang.objects.SceneObject;
import flashbang.objects.SimpleTextButton;

import starling.display.Quad;
import starling.text.TextField;
import starling.utils.Color;

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

        if (_game != null && _game.score >= 0) {
            addRow(new SceneObject(new TextField(JammyConsts.WIDTH, 40,
                "Score: " + _game.score, "Verdana", 30, Color.GREEN, true)));
        }

        var start :Button = new SimpleTextButton("Start Game", 18);
        addRow(start);
        _regs.addSignalListener(start.clicked, function () :void {
            viewport.changeMode(new GameMode());
        });

        var yOff :Number = (JammyConsts.HEIGHT - _totalHeight) / 2;
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

    protected static const MARGIN :int = 10;

    protected var _game :GameMode;
    protected var _rows :Array = [];
    protected var _totalHeight :Number = 0;
}
}
