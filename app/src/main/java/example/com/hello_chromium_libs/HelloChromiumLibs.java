package example.com.hello_chromium_libs;


import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import org.chromium.base.CommandLine;
import org.chromium.base.annotations.CalledByNative;
import org.chromium.base.annotations.JNINamespace;
import org.chromium.base.library_loader.LibraryLoader;
import org.chromium.base.library_loader.LibraryProcessType;
import org.chromium.base.library_loader.ProcessInitException;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

@JNINamespace("app")
public class HelloChromiumLibs extends AppCompatActivity {
    private static final String TAG = HelloChromiumLibs.class.getSimpleName();

    private TraceToFile mTraceToFile = new TraceToFile();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initializing the command line must occur before loading the library.
        if (!CommandLine.isInitialized()) {
            ((HelloJniApplication) getApplication()).initCommandLine();
        }

        try {
            LibraryLoader.getInstance().ensureInitialized(LibraryProcessType.PROCESS_BROWSER);
        } catch (ProcessInitException e) {
            e.printStackTrace();
        }

        mTraceToFile.startTracing(generateTracingFilePath(), "");


        setContentView(R.layout.activity_hello_chromium_libs);

        // Example of a call to a native method
        TextView tv = (TextView) findViewById(R.id.sample_text);
        tv.setText(nativeGetString());

        nativeLogVendor();
    }

    @Override
    public void onPause() {
        super.onPause();
        mTraceToFile.stopTracing();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        //mTraceToFile.stopTracing();
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

    private static String generateTracingFilePath() {
        String state = Environment.getExternalStorageState();
        if (!Environment.MEDIA_MOUNTED.equals(state)) {
            return null;
        }

        // Generate a hopefully-unique filename using the UTC timestamp.
        // (Not a huge problem if it isn't unique, we'll just append more data.)
        SimpleDateFormat formatter = new SimpleDateFormat(
                "yyyy-MM-dd-HHmmss", Locale.US);
        formatter.setTimeZone(TimeZone.getTimeZone("UTC"));
        File dir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS);
        File file = new File(
                dir, "chrome-profile-results-" + formatter.format(new Date()));
        return file.getPath();
    }

}
