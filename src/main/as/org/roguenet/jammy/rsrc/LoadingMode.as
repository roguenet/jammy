package org.roguenet.jammy.rsrc {

import aspire.util.Log;

import flashbang.AppMode;
import flashbang.resource.ResourceSet;

import org.roguenet.jammy.GameMode;
import org.roguenet.jammy.MenuMode;

public class LoadingMode extends AppMode
{
    public function LoadingMode ()
    {
        var resources :ResourceSet = new ResourceSet();
        resources.add({type: "flump", name: "jammy", data: JAMMY});
        SoundResources.addSounds(resources);
        resources.load(function () :void {
                // resources loaded. kick off the game.
                viewport.changeMode(new GameMode());
                viewport.pushMode(new MenuMode());
            }, function (e :Error) :void {
                // there was a load error
                log.error("Error loading resources", e);
            });
    }

    protected static const log :Log = Log.getLog(LoadingMode);
    [Embed(source="../../../../../resources/default/jammy.zip", mimeType="application/octet-stream")]
    protected static const JAMMY :Class;
}
}
