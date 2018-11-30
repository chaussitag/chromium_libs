package example.com.hello_chromium_libs;

import org.chromium.base.CalledByNative;
import org.chromium.base.JNINamespace;


import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

@JNINamespace("app")
public class HelloChromiumLibs extends AppCompatActivity {
    private static final String TAG = HelloChromiumLibs.class.getSimpleName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_hello_chromium_libs);

        // Example of a call to a native method
        TextView tv = (TextView) findViewById(R.id.sample_text);
        tv.setText(nativeGetString());

        nativeLogVendor();
    }

    @CalledByNative
    private void someJavaMethod(String message) {
        Log.d(TAG, "SomeJavaMethod(), message from native: " + message);
    }

    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
    private native String nativeGetString();
    private static native void nativeLogVendor();
}
