package org.roguenet.jammy {

import aspire.util.Random;
import aspire.util.Randoms;

public class JammyContext
{
    public static const RAND :Randoms = new Randoms(Random.create());

    public static const WIDTH :int = 1024;
    public static const HEIGHT :int = 768;

    public static const THROBBER_MAX_RADIUS :int = 150;
    public static const THROBBER_MIN_RADIUS :int = 30;

    public static const THROB_TIME_MAX :Number = 2.0;
    public static const THROB_TIME_MIN :Number = 0.3;
    public static const THROB_RAMP_UP_TIME :Number = 15.0;
    public static const THROB_MIN :Number = 0.65;
    public static const THROB_MAX :Number = 1;
}
}
