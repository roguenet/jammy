package org.roguenet.jammy.rsrc {

import flashbang.resource.ResourceSet;

public class SoundResources
{
    public static function addSounds (resources :ResourceSet) :void
    {
        resources.add({type: "sound", name: "pulse", data: PULSE});
        resources.add({type: "sound", name: "cardTap", data: TAP_CARD});
        resources.add({type: "sound", name: "noCardTap", data: NO_TAP_CARD});
        resources.add({type: "sound", name: "wrongCard", data: WRONG_CARD});
        resources.add({type: "sound", name: "timer", data: TIMER});
        resources.add({type: "sound", name: "gameOver", data: GAME_OVER});
    }

    [Embed(source="../../../../../resources/sound/Pulse.mp3")]
    protected static const PULSE :Class;
    [Embed(source="../../../../../resources/sound/TapCard.mp3")]
    protected static const TAP_CARD :Class;
    [Embed(source="../../../../../resources/sound/NoCardTap.mp3")]
    protected static const NO_TAP_CARD :Class;
    [Embed(source="../../../../../resources/sound/WrongCard.mp3")]
    protected static const WRONG_CARD :Class;
    [Embed(source="../../../../../resources/sound/Timer.mp3")]
    protected static const TIMER :Class;
    [Embed(source="../../../../../resources/sound/GameOver.mp3")]
    protected static const GAME_OVER :Class;
}
}
