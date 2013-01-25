package org.roguenet.jammy {

import flash.display.Sprite;

import aspire.util.Log;

public class Jammy extends Sprite
{
    public function Jammy ()
    {
        log.info("Hello world!");
    }

    private static const log :Log = Log.getLog(Jammy);
}
}
