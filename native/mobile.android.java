import android.view.*;
import android.os.*;

class mobile {
	static int getRotation(){
		android.view.Display display = ((WindowManager)MonkeyGame.activity.getSystemService(android.content.Context.WINDOW_SERVICE)).getDefaultDisplay();
		if (android.os.Build.VERSION.SDK_INT < 8)
			return 0;
		else
			return display.getRotation();
	}
	
	static String getOrientation(){
		android.view.Display display = ((WindowManager)MonkeyGame.activity.getSystemService(android.content.Context.WINDOW_SERVICE)).getDefaultDisplay();
		if (android.os.Build.VERSION.SDK_INT < 8) {
			return "portrait"; // deprecated, but getRotation() is not available until Android v2.2 (SDK_INT=8)
		} else {
			int rotation = display.getRotation();
			if (rotation == 0 || rotation == 2) {
				return "portrait";
			} else {
				return "landscape";
			}
		}
	}
	
	static int getDisplayWidth(){
		android.view.Display display = ((WindowManager)MonkeyGame.activity.getSystemService(android.content.Context.WINDOW_SERVICE)).getDefaultDisplay();
		return display.getWidth();
	}
	
	static int getDisplayHeight(){
		android.view.Display display = ((WindowManager)MonkeyGame.activity.getSystemService(android.content.Context.WINDOW_SERVICE)).getDefaultDisplay();
		return display.getHeight();
	}
}