package com.thesonderapp.sonder;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.parse.ParseAnalytics;
import com.parse.ParseUser;


public class MainActivity extends Activity  {

public static final String TAG = MainActivity.class.getSimpleName();


@Override
protected void onCreate(Bundle savedInstanceState) {
super.onCreate(savedInstanceState);

ParseAnalytics.trackAppOpened(getIntent());

ParseUser currentUser = ParseUser.getCurrentUser();
if (currentUser == null) {
	navigateToLaunch();
}
else {
	Log.i(TAG, currentUser.getUsername());
	navigateToThoughts();
}
}

private void navigateToThoughts() {
	Intent intent1 = new Intent(this, ThoughtsActivity.class);
	intent1.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	intent1.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
	startActivity(intent1);	
}

private void navigateToLaunch() {
Intent intent = new Intent(this, LaunchActivity.class);
intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
startActivity(intent);
}

   
}