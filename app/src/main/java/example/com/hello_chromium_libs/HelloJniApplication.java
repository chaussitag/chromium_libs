package example.com.hello_chromium_libs;

import org.chromium.base.JNINamespace;

import android.app.Application;
import android.content.Context;

@JNINamespace("app")
public class HelloJniApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        System.loadLibrary("hello-chromium-base");
        nativeInitApplicationContext(this);
    }

    private native void nativeInitApplicationContext(Context context);
}

