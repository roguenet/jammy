package org.roguenet.jammy {

import flash.display.BitmapData;
import flash.display.DisplayObject;

import flashbang.Config;
import flashbang.FlashbangApp;

import org.roguenet.jammy.rsrc.LoadingMode;

import starling.display.Image;
import starling.textures.Texture;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#222222")]
[Frame(factoryClass="org.roguenet.jammy.Preloader")]
public class Jammy extends FlashbangApp
{
    public function Jammy (splash :DisplayObject)
    {
        _splash = splash;
    }

    override protected function run () :void
    {
        _splash.parent.removeChild(_splash);
        var data :BitmapData = new BitmapData(_splash.width, _splash.height, true, 0);
        data.draw(_splash);
        JammyConsts.SPLASH = new Image(Texture.fromBitmapData(data));
        defaultViewport.pushMode(new LoadingMode());
    }

    override protected function createConfig () :Config
    {
        var config :Config = new Config();
        config.stageWidth = JammyConsts.WIDTH;
        config.stageHeight = JammyConsts.HEIGHT;
        config.windowWidth = JammyConsts.WIDTH;
        config.windowHeight = JammyConsts.HEIGHT;
        return config;
    }

    protected var _splash :DisplayObject;
}
}









