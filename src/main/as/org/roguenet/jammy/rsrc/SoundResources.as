package org.roguenet.jammy.rsrc {

import flashbang.resource.ResourceSet;

public class SoundResources
{
    public static function addSounds (resources :ResourceSet) :void
    {
        resources.add({type: "sound", name: "pulse", data: PULSE});
        resources.add({type: "sound", name: "tapCard", data: TAP_CARD});
        resources.add({type: "sound", name: "wrongCard", data: WRONG_CARD});
    }

    [Embed(source="../../../../../resources/sound/Pulse.mp3")]
    protected static const PULSE :Class;
    [Embed(source="../../../../../resources/sound/TapCard.mp3")]
    protected static const TAP_CARD :Class;
    [Embed(source="../../../../../resources/sound/WrongCard.mp3")]
    protected static const WRONG_CARD :Class;
}
}
