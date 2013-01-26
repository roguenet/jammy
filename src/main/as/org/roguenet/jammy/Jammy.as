package org.roguenet.jammy {

import flashbang.Config;
import flashbang.FlashbangApp;

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

import aspire.util.Log;

import flashbang.AppMode;
import flashbang.resource.ResourceSet;

import org.roguenet.jammy.GameMode;

class LoadingMode extends AppMode
{
    public function LoadingMode ()
    {
        var resources :ResourceSet = new ResourceSet();
        resources.add({type: "flump", name: "jammy", data: JAMMY});
        resources.load(
            function () :void {
                // resources loaded. kick off the game.
                viewport.changeMode(new GameMode());
            },
            function (e :Error) :void {
                // there was a load error
                log.error("Error loading resources", e);
            });
    }

    protected static const log :Log = Log.getLog(LoadingMode);

    [Embed(source="../../../../resources/default/jammy.zip", mimeType="application/octet-stream")]
    protected static const JAMMY :Class;
}
