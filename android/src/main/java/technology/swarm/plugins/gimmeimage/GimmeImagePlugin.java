package technology.swarm.plugins.gimmeimage;
import android.content.ContentUris;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Base64;
import android.util.Log;

import com.getcapacitor.JSObject;
import com.getcapacitor.Logger;
import com.getcapacitor.PermissionState;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.PermissionCallback;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;

@CapacitorPlugin(name = "GimmeImage")
public class GimmeImagePlugin extends Plugin {

    private GimmeImage implementation = new GimmeImage();

    @PermissionCallback
    private void permissionCallback(PluginCall call) {
        if (!isStoragePermissionGranted()) {
            Logger.debug(getLogTag(), "User denied storage permission");
            call.reject("Unable to do file operation, user denied permission request");
            return;
        }

        if (call.getMethodName().equals("gimmeMediaItem")) {
            _gimmeMediaItem(call);
        }
    }

    private boolean isStoragePermissionGranted() {
        return getPermissionState("publicStorage") == PermissionState.GRANTED;
    }

    @PluginMethod
    public void gimmeMediaItem(PluginCall call) {
        Log.d("DEBUG LOG", "GIMME MEDIA ITEM");
        if (isStoragePermissionGranted()) {
            Log.d("DEBUG LOG", "HAS PERMISSION");
            _gimmeMediaItem(call);
        } else {
            Log.d("DEBUG LOG", "NOT ALLOWED");
            this.bridge.saveCall(call);
            requestAllPermissions(call, "permissionCallback");
        }
    }

    private void _gimmeMediaItem(PluginCall call) {
        String identifier = call.getString("identifier");
        if (identifier == null)
        {
            call.reject("Identifier is null");
        }
        Uri uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        String selection = MediaStore.Images.Media._ID + "=?";
        String[] selectionArgs = new String[] { identifier };

        Cursor cursor = getContext().getContentResolver().query(uri, null, selection, selectionArgs, null);

        if (cursor != null && cursor.moveToFirst()) {
            int dataIndex = cursor.getColumnIndex(MediaStore.Images.Media.DATA);
            String filePath = cursor.getString(dataIndex);
            cursor.close();

            try {
                Uri fileUri = ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, Long.parseLong(identifier));
                InputStream inputStream = getContext().getContentResolver().openInputStream(fileUri);
                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

                byte[] buffer = new byte[1024];
                int bytesRead;
                if (inputStream != null) {
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                    inputStream.close();
                } else {
                    call.reject("Unable to read file (null stream)");
                }

                byte[] imageBytes = outputStream.toByteArray();
                String base64String = Base64.encodeToString(imageBytes, Base64.DEFAULT);

                JSObject ret = new JSObject();
                ret.put("identifier", identifier);
                ret.put("data", base64String);
                ret.put("creationDate", "");
                ret.put("fullWidth", 0);
                ret.put("fullHeight", 0);
                ret.put("thumbnailWidth", 0);
                ret.put("thumbnailHeight", 0);
                ret.put("location", null);
                call.resolve(ret);
            } catch (Exception e) {
                call.reject("Could not fetch image", e);
            }
        } else {
            call.reject("Asset not found");
        }
    }
}
