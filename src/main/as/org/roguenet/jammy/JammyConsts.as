package org.roguenet.jammy {

import aspire.util.Random;
import aspire.util.Randoms;

import starling.display.Image;

public class JammyConsts
{
    public static var SPLASH :Image;

    public static const RAND :Randoms = new Randoms(Random.create());

    public static const WIDTH :int = 1024;
    public static const HEIGHT :int = 768;

    public static const HEADER_WIDTH :int = WIDTH;
    public static const HEADER_HEIGHT :int = 136;

    public static const MENU_TOP_MARGIN :int = 391;

    public static const BOARD_X :int = 0;
    public static const BOARD_Y :int = 87;
    public static const BOARD_WIDTH :int = WIDTH;
    public static const BOARD_HEIGHT :int = HEIGHT - HEADER_HEIGHT;

    public static const PLACEMENT_ATTEMPTS_MAX :int = 100;
    public static const PLACEMENT_BUFFER :int = 30;

    public static const THROBBER_MAX_RADIUS :int = 60;
    public static const THROBBER_MIN_RADIUS :int = 25;

    public static const THROB_TIME_BASE :Number = 2.5;
    public static const THROB_TIME_FAST :Number = 1.0;
    public static const THROB_TIMING_THRESHOLD :Number = 0.6;
    public static const THROB_RAMP_UP_TIME :Number = 10.0;

    public static const THROB_MIN :Number = 1;
    public static const THROB_MAX :Number = 1.15;

    public static const THROBBER_COUNT_MAX :int = 12;
    public static const FAST_MODE_THRESHOLD :Number = THROBBER_COUNT_MAX - 2;

    public static const THROBBER_LEVELS :int = 6;
    public static const BASE_SCORE :int = 100;
    public static const FAST_MODE_SCORE_BONUS :int = 13;

    public static const INITIAL_THROBBER_COUNT :int = 2;
    public static const THROBBERS_PER_THROB :int = INITIAL_THROBBER_COUNT;

    public static const FADE_TIME :Number = 0.25;

    public static const MAX_THROBBERS_PER_TYPE :int = 2;

    public static const ROUND_TIME :int = 60.0;
    public static const TIMER_BEEPS_PER_ROUND :int = 5;

    public static const GAME_OVER_DELAY :Number = 3.0;
}
}
