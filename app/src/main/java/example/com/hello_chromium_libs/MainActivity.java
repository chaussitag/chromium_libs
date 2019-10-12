package example.com.hello_chromium_libs;


import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
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

import static android.icu.lang.UCharacter.GraphemeClusterBreak.V;

@JNINamespace("app")
public class MainActivity extends AppCompatActivity {
    private static final String TAG = MainActivity.class.getSimpleName();

    private TraceToFile mTraceToFile = new TraceToFile();
    private TextView mTextView;
    private long mNativeObj;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initializing the command line must occur before loading the library.
        if (!CommandLine.isInitialized()) {
            ((HelloChromiumLibsApplication) getApplication()).initCommandLine();
        }

        try {
            LibraryLoader.getInstance().ensureInitialized(LibraryProcessType.PROCESS_BROWSER);
        } catch (ProcessInitException e) {
            e.printStackTrace();
        }

        setContentView(R.layout.activity_hello_chromium_libs);

        mNativeObj = nativeInit();

        // Example of a call to a native method
        mTextView = findViewById(R.id.sample_text);
        mTextView.setText(nativeGetString());

        Button startUpdateTextButton = findViewById(R.id.start_update_text);
        startUpdateTextButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                nativeStartUpdateTextViewRepeatedly(mNativeObj);
            }
        });

        Button stopUpdateTextButton = findViewById(R.id.stop_update_text);
        stopUpdateTextButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                nativeStopUpdateTextView(mNativeObj);
            }
        });

        nativeLogVendor();
        nativePostTaskExamples();
    }

    @Override
    public void onStart() {
        super.onStart();
        mTraceToFile.startTracing(generateTracingFilePath(), "");
    }

    @Override
    public void onPause() {
        super.onPause();
        mTraceToFile.stopTracing();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        nativeDestroy(mNativeObj);
    }

    @CalledByNative
    private void someJavaMethod(String message) {
        Log.d(TAG, "SomeJavaMethod(), message from native: " + message);
        mTextView.setText(message);
    }

    @CalledByNative
    private void updateTextView(String text) {
        mTextView.setText(text);
    }

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

    private static native void nativeLogVendor();
    private static native void nativePostTaskExamples();

    private native String nativeGetString();

    private native long nativeInit();
    private native void nativeStartUpdateTextViewRepeatedly(long nativeMainActivityJni);
    private native void nativeStopUpdateTextView(long nativeMainActivityJni);
    private native void nativeDestroy(long nativeMainActivityJni);

}
