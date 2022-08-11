package com.flutter.app.flutterPlugin;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.kk.sdkforzip.SdkForZipUtils;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** TimesdkPlugin */
public class TimeSdkPlugin implements MethodCallHandler {

    private static String TAG = "TimeSdkPlugin";

    private MethodChannel channel;
    private SdkForZipUtils mSdkForZipUtils;
    private MethodCall mCall;
    private Result mResult;

    private TimeSdkPlugin() {}

    public static TimeSdkPlugin getInstance() {
        return Inner.instance;
    }

    private static class Inner {
        private static final TimeSdkPlugin instance = new TimeSdkPlugin();
    }

    public void registerWith(FlutterEngine flutterEngine, Activity activity) {
        channel = new MethodChannel(
            flutterEngine.getDartExecutor().getBinaryMessenger(), "timesdk_plugin");
        channel.setMethodCallHandler(this);
        initTimeSDK(activity);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        mCall = call;
        mResult = result;

        io.flutter.Log.d("", "onMethodCall: " + call.method);
        if (call.method.equals("collectMessage")) {
            collectMessage(call.arguments.toString());
        } else {
            result.notImplemented();
        }
    }

    private void initTimeSDK(Activity activity) {

        mSdkForZipUtils = new SdkForZipUtils(activity, new SdkForZipUtils.OnTimeFileCallBack() {

            @Override
            public void onFile(File file, String md5, String orderNo, boolean isSubmit, String json) {
                Map<String, Object> map = new HashMap();
                map.put("file", file.getAbsolutePath());
                map.put("md5", md5);
                map.put("orderNo", orderNo);
                map.put("isSubmit", isSubmit);
                map.put("json", json);

                io.flutter.Log.e(TAG, "OnTimeFileCallBack onFile");
                channel.invokeMethod("onTimeFileCallBack", map);
            }

            @Override
            public void onFail(String orderNo, boolean isSubmit, String json) {

                Map<String, Object> map = new HashMap();
                map.put("orderNo", orderNo);
                map.put("isSubmit", isSubmit);
                map.put("json", json);

                io.flutter.Log.e(TAG, "OnTimeFileCallBack onFail");
                channel.invokeMethod("onTimeFailCallBack", map);
            }
        });

        if (mSdkForZipUtils == null) {
            io.flutter.Log.e(TAG, "timeSdk is not init");
        } else {
            io.flutter.Log.d(TAG, "timeSdk init");
        }

    }

    private void collectMessage(String json) {
        io.flutter.Log.e(TAG, "native collectMessage json: \n " + json);
        if (mSdkForZipUtils != null) {
            mSdkForZipUtils.setJson(json);
        } else {
            io.flutter.Log.e(TAG, "sdk is not init");
        }

    }

    public void onRequestPermission() {
        if (mSdkForZipUtils != null) {
            // 获取权限
            // 权限回调结果需要在项目MainActivity下重写onRequestPermissionsResult
            try {
                mSdkForZipUtils.onRequestPermission();
            } catch (Exception e) {
                Log.i("", "mSdkForZipUtils requestPermission error" + e.getMessage());
            }

        } else {
            io.flutter.Log.e(TAG, "timeSdk is not init");
        }
    }

    public int getTimeRequestCode() {
        return SdkForZipUtils.TIME_PERMISSION_REQUEST_CODE;
    }


}
