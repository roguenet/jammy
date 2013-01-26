package org.roguenet.jammy {

import aspire.util.Random;
import aspire.util.Randoms;

public class JammyConsts
{
    public static const RAND :Randoms = new Randoms(Random.create());

    public static const WIDTH :int = 1024;
    public static const HEIGHT :int = 768;

    public static const THROBBER_MAX_RADIUS :int = 70;
    public static const THROBBER_MIN_RADIUS :int = 30;

    public static const THROB_TIME_MAX :Number = 3.0;
    public static const THROB_TIME_MIN :Number = 0.5;
    public static const THROB_TIMING_THRESHOLD :Number = 0.6;
    public static const THROB_RAMP_UP_TIME :Number = 15.0;
    public static const THROB_MIN :Number = 1;
    public static const THROB_MAX :Number = 1.25;
}
}
