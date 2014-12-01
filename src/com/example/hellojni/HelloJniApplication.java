package com.example.hellojni;

import org.chromium.base.JNINamespace;

import android.app.Application;
import android.content.Context;

@JNINamespace("app")
public class HelloJniApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        System.loadLibrary("hello-jni");
        nativeInitApplicationContext(this);
    }

    private native void nativeInitApplicationContext(Context context);
}
