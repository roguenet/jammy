package org.roguenet.jammy.view {

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;

import flashbang.objects.SpriteObject;

import starling.display.Image;
import starling.textures.Texture;

public class RenderedSprite extends SpriteObject
{
    protected function render (dispObj :DisplayObject, margin :int = 0) :Image
    {
        var data :BitmapData = new BitmapData(
            dispObj.width + margin * 2, dispObj.height + margin * 2, true, 0);
        var matrix :Matrix = new Matrix();
        matrix.translate(margin, margin);
        data.draw(dispObj, matrix);
        var img :Image = new Image(Texture.fromBitmapData(data));
        _sprite.addChild(img);
        return img;
    }
}
}
