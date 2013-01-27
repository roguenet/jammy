package org.roguenet.jammy.view {

import flashbang.objects.SpriteObject;
import flashbang.resource.ImageResource;

import org.roguenet.jammy.JammyConsts;

public class BoardBackgroundSprite extends SpriteObject
{
    public function BoardBackgroundSprite ()
    {
        _sprite.x = JammyConsts.BOARD_X;
        _sprite.y = JammyConsts.BOARD_Y;
        _sprite.addChild(ImageResource.createImage("jammy/background"));
    }
}
}
