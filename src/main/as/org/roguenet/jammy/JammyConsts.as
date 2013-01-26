package org.roguenet.jammy {

import aspire.util.Random;
import aspire.util.Randoms;

public class JammyConsts
{
    public static const RAND :Randoms = new Randoms(Random.create());

    public static const WIDTH :int = 1024;
    public static const HEIGHT :int = 768;

    public static const BOARD_X :int = 0;
    public static const BOARD_Y :int = 0;
    public static const BOARD_WIDTH :int = WIDTH;
    public static const BOARD_HEIGHT :int = HEIGHT;

    public static const PLACEMENT_ATTEMPTS_MAX :int = 100;
    public static const PLACEMENT_BUFFER :int = 30;

    public static const THROBBER_MAX_RADIUS :int = 70;
    public static const THROBBER_MIN_RADIUS :int = 30;

    public static const THROB_TIME_MAX :Number = 2.0;
    public static const THROB_TIME_MIN :Number = THROB_TIME_MAX; // no time changes right now
    public static const THROB_TIMING_THRESHOLD :Number = 0.6;
    public static const THROB_RAMP_UP_TIME :Number = 15.0;
    public static const THROB_MIN :Number = 1;
    public static const THROB_MAX :Number = 1.25;

    // with the configured sizes, we can't fit much more than 10 on the board.
    public static const THROBBER_COUNT_MAX :int = 10;

    public static const THROBBER_LEVELS :int = 5;

    public static const INITIAL_THROBBER_COUNT :int = 2;
    public static const THROBBERS_PER_THROB :int = INITIAL_THROBBER_COUNT;
}
}
