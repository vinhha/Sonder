package com.thesonderapp.sonder;

import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.location.LocationClient;
import com.parse.ParseException;
import com.parse.ParseGeoPoint;
import com.parse.ParseUser;
import com.parse.SaveCallback;

public class SignUpSocialMediaActivity extends Activity implements
GooglePlayServicesClient.ConnectionCallbacks,
GooglePlayServicesClient.OnConnectionFailedListener{
	
	
	
	protected TextView mFinishButton;
	protected EditText mTwitter;
	protected EditText mInstagram;
	protected Button mConnectFacebook;
	protected Location  mLocation;
	protected ParseGeoPoint mpoint;
	protected LocationClient mlocClient;
	protected Location mCurrentLocation;
	// Implement This Code Where You Want Location To Refresh Often
	// Implement This Code Where You Want Location To Refresh Often
	// Implement This Code Where You Want Location To Refresh Often
	// Implement This Code Where You Want Location To Refresh Often
	//private static final long MINIMUM_DISTANCE_CHANGE_FOR_UPDATES = 100; // in Meters
   // private static final long MINIMUM_TIME_BETWEEN_UPDATES = 120000; // in Milliseconds
	private final static int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
	  static final String TAG = "HelloGooglePlayServices";


	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_sign_up_social_media);
		
		mFinishButton = (TextView)findViewById(R.id.Finish);
		mTwitter = (EditText)findViewById(R.id.twitterField);
		mInstagram = (EditText)findViewById(R.id.instagramField);
		mConnectFacebook = (Button)findViewById(R.id.facebookButton);

		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.empty_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_HOME|ActionBar.DISPLAY_SHOW_CUSTOM);
		
		
		// Start Location Manager
		
		 if (checkPlayServices()) {
			  //Google Play Functional
			 
			 	mlocClient = new LocationClient(SignUpSocialMediaActivity.this,SignUpSocialMediaActivity.this,SignUpSocialMediaActivity.this);
				mlocClient.connect();
				
			     }
			      else {
			  //Google Play Non-Functional

			     Log.i(TAG, "No valid GPS APK found.");
			     }
			 
		
		
		mConnectFacebook.setOnClickListener(new View.OnClickListener(){

			
			

			@Override
			public void onClick(View v) {
				
			}
		});
		
		
		mFinishButton.setOnClickListener(new View.OnClickListener(){


			@Override
			public void onClick(View v) {
				
				
				String twitter = mTwitter.getText().toString();
				String instagram = mInstagram.getText().toString();
				twitter = twitter.trim();
				instagram = instagram.trim();
				
				/*if (twitter.isEmpty() || instagram.isEmpty()){
					AlertDialog.Builder builder = new AlertDialog.Builder(SignUpSocialMediaActivity.this);
					builder.setMessage(R.string.signup_error_nothing)
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				
				else{
					
					*/

				
			          
			//	LocationManager mlocManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
						// Implement This Code Where You Want Location To Refresh Often
						// Implement This Code Where You Want Location To Refresh Often
						// Implement This Code Where You Want Location To Refresh Often
						// Implement This Code Where You Want Location To Refresh Often
						//LocationListener mlocListener = new MyLocationListener();
						//mlocManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, mlocListener);

				
				// NON- GOOGLE PLAY LOCATION TACTIC
				
						/*try{
							
						mLocation = mlocManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
						
						mpoint = new ParseGeoPoint(mLocation.getLatitude(), mLocation.getLongitude());
						}
						catch(Exception ex){
							Toast.makeText(SignUpSocialMediaActivity.this,
					 		        "Location Manager Non-Functional.", Toast.LENGTH_SHORT).show();
						}*/
			         
				
				//ADD THIS CODE WHEN YOU RUN ON AN ACTUAL DEVICE
				//ADD THIS CODE WHEN YOU RUN ON AN ACTUAL DEVICE
				//ADD THIS CODE WHEN YOU RUN ON AN ACTUAL DEVICE

				
						/*try{
					    mCurrentLocation = mlocClient.getLastLocation();
						}
						catch(Exception ex){
							Toast.makeText(SignUpSocialMediaActivity.this,
					 		        "Location Client Non-Functional.", Toast.LENGTH_SHORT).show();
							mpoint = new ParseGeoPoint(mLocation.getLatitude(), mLocation.getLongitude());
						}*/
					
					//Add objects to backend
					ParseUser currentUser = ParseUser.getCurrentUser();

					
					
					if (twitter != null){
					currentUser.put("twitter", twitter);
					}
					if (instagram != null){
					currentUser.put("instagram", instagram);
					}
					if (mpoint != null){
					currentUser.put("location", mpoint);
					}
					
					currentUser.saveInBackground(new SaveCallback() {
						@SuppressLint("InlinedApi") public void done(ParseException e) {
						    if (e == null) {
						      // Hooray! Let them use the app now.
						    	 Toast.makeText(SignUpSocialMediaActivity.this,
						 		        "Success!", Toast.LENGTH_SHORT).show();
						    	Intent intent = new Intent(SignUpSocialMediaActivity.this, ThoughtsActivity.class);
						    	intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						    	intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
								startActivity(intent);
						    } else {
						      // Sign up didn't succeed. Look at the ParseException
						      // to figure out what went wrong
						    	AlertDialog.Builder builder = new AlertDialog.Builder(SignUpSocialMediaActivity.this);
								builder.setMessage(e.getMessage())
									.setTitle(R.string.signup_error_title)
									.setPositiveButton(android.R.string.ok, null);
								AlertDialog dialog = builder.create();
								dialog.show();
						    }
						  }
						});
					
				
				}
				
				
				
			//}

		});
		
	
		
		
		
	}


	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.sign_up, menu);
		return true;
	}
/*
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
*/
	public class MyLocationListener implements LocationListener
	{
	@Override
	public void onLocationChanged(Location loc)
	{
		// Implement This Code Where You Want Location To Refresh Often
		// Implement This Code Where You Want Location To Refresh Often
		// Implement This Code Where You Want Location To Refresh Often
		// Implement This Code Where You Want Location To Refresh Often

		/*
	loc.getLatitude();
	loc.getLongitude();
	String Text = "My current location is: " + "Latitud = " + loc.getLatitude() + "Longitud = " + loc.getLongitude();
	Toast.makeText( getApplicationContext(),Text,Toast.LENGTH_SHORT).show();
	*/
	}
	@Override
	public void onProviderDisabled(String provider)
	{
		/*
	Toast.makeText( getApplicationContext(),"Gps Disabled",Toast.LENGTH_SHORT ).show();
	*/
	}
	@Override
	public void onProviderEnabled(String provider)
	{
		/*
	Toast.makeText( getApplicationContext(),"Gps Enabled",Toast.LENGTH_SHORT).show();
	*/
	}
	@Override
	public void onStatusChanged(String provider, int status, Bundle extras)
	{
	}
	}/* End of Class MyLocationListener */
	



@Override
public void onConnectionFailed(ConnectionResult arg0) {
	
}


@Override
public void onConnected(Bundle arg0) {
	
}


@Override
public void onDisconnected() {
	
}
private boolean checkPlayServices() {
	 int resultCode = GooglePlayServicesUtil
	                      .isGooglePlayServicesAvailable(this);
	 if (resultCode != ConnectionResult.SUCCESS) {
	  if (GooglePlayServicesUtil.isUserRecoverableError(resultCode))
	         {
	   GooglePlayServicesUtil.getErrorDialog(resultCode, this,
	   PLAY_SERVICES_RESOLUTION_REQUEST).show();
	          } else {
	  Log.i(TAG, "This device is not supported.");
	  finish();
	              }
	  return false;
	 }
	     return true;
	   }
}




