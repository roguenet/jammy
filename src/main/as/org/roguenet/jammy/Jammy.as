package org.roguenet.jammy {

import flashbang.Config;
import flashbang.FlashbangApp;

import org.roguenet.jammy.rsrc.LoadingMode;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#222222")]
public class Jammy extends FlashbangApp
{
    override protected function run () :void
    {
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
}
}









