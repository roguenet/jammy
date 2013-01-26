package org.roguenet.jammy {

import aspire.util.Random;
import aspire.util.Randoms;

/**
 * Oh look, at static context class. Welcome to 2001. Classy!
 */
public class JammyContext
{
    public static const RAND :Randoms = new Randoms(Random.create());

    public static const WIDTH :int = 1024;
    public static const HEIGHT :int = 768;

    public static const THROBBER_MAX_RADIUS :int = 150;
    public static const THROBBER_MIN_RADIUS :int = 30;
}
}
