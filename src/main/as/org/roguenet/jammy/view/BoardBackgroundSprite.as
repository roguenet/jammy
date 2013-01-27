package org.roguenet.jammy.view {

import flash.display.Shape;

import org.roguenet.jammy.JammyConsts;

public class BoardBackgroundSprite extends RenderedSprite
{
    public function BoardBackgroundSprite ()
    {
        _sprite.x = JammyConsts.BOARD_X;
        _sprite.y = JammyConsts.BOARD_Y;

        var shape :Shape = new Shape();
        shape.graphics.beginFill(0x222222);
        shape.graphics.drawRect(0, 0, JammyConsts.BOARD_WIDTH, JammyConsts.BOARD_HEIGHT);
        render(shape);
    }
}
}
