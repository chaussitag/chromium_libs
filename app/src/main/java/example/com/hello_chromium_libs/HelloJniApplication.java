package example.com.hello_chromium_libs;

import android.app.Application;
import android.content.Context;

import org.chromium.base.CommandLine;
import org.chromium.base.ContextUtils;

public class HelloJniApplication extends Application {
    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        ContextUtils.initApplicationContext(this);
    }
//        @Override
//    public void onCreate() {
//        super.onCreate();
////        CommandLine.enableNativeProxy();
////        System.loadLibrary("hello-chromium-base");
//        ContextUtils.initApplicationContext(this);
//    }
    public void initCommandLine() {
        if (!CommandLine.isInitialized()) {
            CommandLine.init(new String[]{"HelloJniApplication"});
        }
    }

}

