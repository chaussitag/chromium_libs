package org.chromium.base.natives;

import java.lang.String;
import javax.annotation.Generated;

@Generated("org.chromium.jni_generator.JniProcessor")
public final class GEN_JNI {
  public static boolean TESTING_ENABLED;

  public static boolean REQUIRE_MOCK;

  /**
   * org.chromium.base.AnimationFrameTimeHistogram.saveHistogram
   * @param histogramName (java.lang.String)
   * @param frameTimesMs (long[])
   * @param count (int)
   * @return (void)
   */
  public static final native void org_chromium_base_AnimationFrameTimeHistogram_saveHistogram(
      String histogramName, long[] frameTimesMs, int count);
}
