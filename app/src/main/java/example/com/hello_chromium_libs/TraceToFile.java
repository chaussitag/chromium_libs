package example.com.hello_chromium_libs;

import android.util.Log;

import org.chromium.base.annotations.JNINamespace;

@JNINamespace("app")
public class TraceToFile {
    private static final String TAG = TraceToFile.class.getSimpleName();
    private long mNativeObj = -1;

    public void startTracing(String trace_file_path, String trace_categories) {
        if (mNativeObj > 0) {
            Log.e(TAG,
                    "startTrace(" + trace_file_path + ", " + trace_categories + "), trace has already started");
            return;
        }
        mNativeObj = nativeInit();
        nativeStartTracing(mNativeObj, trace_file_path, trace_categories);
    }

    public void stopTracing() {
        if (mNativeObj <= 0) {
            return;
        }
        nativeStopTracing(mNativeObj);
        nativeDestroy(mNativeObj);
        mNativeObj = -1;
    }

    private native long nativeInit();

    private native void nativeStartTracing(long nativeTraceToFile, String trace_file_path, String trace_categories);

    private native void nativeStopTracing(long nativeTraceToFile);

    private native void nativeDestroy(long nativeTraceToFile);
}
