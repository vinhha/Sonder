package com.thesonderapp.sonder;

import java.io.ByteArrayOutputStream;
import java.io.FileDescriptor;
import java.io.FileNotFoundException;
import java.io.IOException;

import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.view.Menu;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseFile;
import com.parse.ParseUser;
import com.parse.SaveCallback;

public class EditProfileActivity extends Activity{
	

	protected static final int COVER_PHOTO_REQUEST = 1;

	protected static final int PROFILE_PHOTO_REQUEST = 0;
	
	protected String relationshipStatusChoice;
	protected TextView mContinueTextView;
	protected TextView mAddProfilePhoto;
	protected TextView mAddCoverPhoto;
	protected EditText mSchool;
	protected EditText mHometown;
	protected ImageView mProfilePhoto;
	protected ImageView mCoverPhoto;
	protected byte[] mCover;
	protected byte[] mProfile;
	private RadioGroup radioGroupId;
	private RadioButton radioBtn1;

	protected TextView mTitle;



	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		

		
		
		setContentView(R.layout.activity_sign_up_profile_build);
		
		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.back_left_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		mTitle = (TextView)findViewById(R.id.home_title);
		mTitle.setText("Settings");
		
		
		mSchool = (EditText)findViewById(R.id.schoolField);
		mHometown = (EditText)findViewById(R.id.hometownField);
		mAddProfilePhoto = (TextView)findViewById(R.id.addProfilePhoto);
		mContinueTextView = (TextView)findViewById(R.id.continueButton);
		mAddCoverPhoto = (TextView)findViewById(R.id.addCoverPhoto);
		radioGroupId = (RadioGroup)findViewById(R.id.radioGroup1);
		
		// Need Photo Gallery To Run Without Error
		// Need Photo Gallery To Run Without Error
		// Need Photo Gallery To Run Without Error
		
		
		mProfilePhoto = (ImageView)findViewById(R.id.SignUpProfilePhoto);
		mCoverPhoto = (ImageView)findViewById(R.id.SignUpCoverPhoto);
		
		
		
			mAddCoverPhoto.setOnClickListener(new View.OnClickListener(){
			@Override
			public void onClick(View v) {
				
				Intent choosePhotoIntent = new Intent(Intent.ACTION_GET_CONTENT);
				choosePhotoIntent.setType("image/*");
				startActivityForResult(choosePhotoIntent, COVER_PHOTO_REQUEST);
			}

					
			});
		
			
		mAddProfilePhoto.setOnClickListener(new View.OnClickListener(){
				@Override
				public void onClick(View v) {
					
					Intent choosePhotoIntent = new Intent(Intent.ACTION_GET_CONTENT);
					choosePhotoIntent.setType("image/*");
					startActivityForResult(choosePhotoIntent, PROFILE_PHOTO_REQUEST);
					
				}
				});
		
		// Need Photo Gallery To Run Without Error
		// Need Photo Gallery To Run Without Error
		// Need Photo Gallery To Run Without Error

		
		mContinueTextView.setOnClickListener(new View.OnClickListener(){
			
			@Override
			public void onClick(View v) {

		        int selected = radioGroupId.getCheckedRadioButtonId();
		        radioBtn1 = (RadioButton)findViewById(selected);
		        
		        relationshipStatusChoice = (String) radioBtn1.getText();
				String school = mSchool.getText().toString();
				String hometown = mHometown.getText().toString();
				school = school.trim();
				hometown = hometown.trim();

				
				if (school.length() > 10 ){
					AlertDialog.Builder builder = new AlertDialog.Builder(EditProfileActivity.this);
					builder.setMessage("Please try to abbreviate your school.")
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				else if (hometown.length() > 30 ){
					AlertDialog.Builder builder = new AlertDialog.Builder(EditProfileActivity.this);
					builder.setMessage("Please try to abbreviate your hometown.")
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				else{
					//Create New User
					
					ParseUser currentUser = ParseUser.getCurrentUser();
				
					if (!(hometown.isEmpty())){
					currentUser.put("bio", hometown);
					}
					if (!(relationshipStatusChoice.isEmpty())){
					currentUser.put("relationship", relationshipStatusChoice);
					}
					if (!(school.isEmpty())){
					currentUser.put("school", school);
					}
					
					// Need Photo Gallery To Run Without Error
					// Need Photo Gallery To Run Without Error
					// Need Photo Gallery To Run Without Error
					
					
					
					
					if (mCover != null){
						ParseFile Coverfile = new ParseFile("image.png", mCover);
						Coverfile.saveInBackground();
					currentUser.put("coverfile", Coverfile);
					}
					if (mProfile != null){

						ParseFile Profilefile = new ParseFile("image.png", mProfile);
						Profilefile.saveInBackground();
					currentUser.put("file", Profilefile);
					}
					
					currentUser.put("coverfileType", "image");
					currentUser.put("fileType", "image");
					 
					// Need Photo Gallery To Run Without Error
					// Need Photo Gallery To Run Without Error
					// Need Photo Gallery To Run Without Error
					
					currentUser.saveInBackground(new SaveCallback() {
					@SuppressLint("InlinedApi") public void done(ParseException e) {
					    if (e == null) {
					      // Hooray! Let them use the app now.
					    	 Toast.makeText(EditProfileActivity.this,
					 		        "Success!", Toast.LENGTH_SHORT).show();
					    	Intent intent = new Intent(EditProfileActivity.this, SettingsActivity.class);
					    	intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					    	intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
							startActivity(intent);
					    } else {
					      // Sign up didn't succeed. Look at the ParseException
					      // to figure out what went wrong
					    	AlertDialog.Builder builder = new AlertDialog.Builder(EditProfileActivity.this);
							builder.setMessage(e.getMessage())
								.setTitle(R.string.signup_error_title)
								.setPositiveButton(android.R.string.ok, null);
							AlertDialog dialog = builder.create();
							dialog.show();
					    }
					  }
					});
					

				}
				
				
				
			}

		});
		
		
		
		
	}

	

	
//	private void addListenerRadioGroup1() {
//		radioGroupId = (RadioGroup) findViewById
//			    (R.id.radioGroup1);
//				mSignUpTextView = (TextView)findViewById(R.id.signUpButton);
//			    mSignUpTextView.setOnClickListener(new View.OnClickListener() {
//
//			      public void onClick(View v) {
//			        // get selected radio button from radioGroupCricket
//			        int selected = radioGroupId.getCheckedRadioButtonId();
//			      
//			        Toast.makeText(SignUpActivity.this,
//			        selected, Toast.LENGTH_SHORT).show();
//			     } 
//			   });	
//	}
//		   

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


	// Need Photo Gallery To Run Without Error
	// Need Photo Gallery To Run Without Error
	// Need Photo Gallery To Run Without Error

	
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
	    if (resultCode == RESULT_OK && requestCode == PROFILE_PHOTO_REQUEST && null != data) {
	        decodeUriProfile(data.getData());
	   
	    }
	    if (resultCode == RESULT_OK && requestCode == COVER_PHOTO_REQUEST && null != data) {
	        decodeUriCover(data.getData());
	    }
	}

	public void decodeUriProfile(Uri uri) {
	    ParcelFileDescriptor parcelFD = null;
	    try {
	        parcelFD = getContentResolver().openFileDescriptor(uri, "r");
	        FileDescriptor imageSource = parcelFD.getFileDescriptor();

	        // Decode image size
	        BitmapFactory.Options o = new BitmapFactory.Options();
	        o.inJustDecodeBounds = true;
	        BitmapFactory.decodeFileDescriptor(imageSource, null, o);

	        // the new size we want to scale to
	        final int REQUIRED_SIZE = 1024;

	        // Find the correct scale value. It should be the power of 2.
	        int width_tmp = o.outWidth, height_tmp = o.outHeight;
	        int scale = 1;
	        while (true) {
	            if (width_tmp < REQUIRED_SIZE && height_tmp < REQUIRED_SIZE) {
	                break;
	            }
	            width_tmp /= 2;
	            height_tmp /= 2;
	            scale *= 2;
	        }


            //create output stream
            ByteArrayOutputStream Profilestream = new ByteArrayOutputStream();
            //create file
            
	        // decode with inSampleSize
	        BitmapFactory.Options o2 = new BitmapFactory.Options();
	        o2.inSampleSize = scale;
	        Bitmap profile = BitmapFactory.decodeFileDescriptor(imageSource, null, o2);
	        mProfilePhoto.setImageBitmap(profile);
	        profile.compress(Bitmap.CompressFormat.PNG, 100, Profilestream);
	        mProfile = Profilestream.toByteArray();


	    } catch (FileNotFoundException e) {
	        // handle errors
	    } finally {
	        if (parcelFD != null)
	            try {
	                parcelFD.close();
	                
	            } catch (IOException e) {
	                // ignored
	            }
	    }
	        
	}
	
	public void decodeUriCover(Uri uri) {
	    ParcelFileDescriptor parcelFD = null;
	    try {
	        parcelFD = getContentResolver().openFileDescriptor(uri, "r");
	        FileDescriptor imageSource = parcelFD.getFileDescriptor();

	        // Decode image size
	        BitmapFactory.Options o = new BitmapFactory.Options();
	        o.inJustDecodeBounds = true;
	        BitmapFactory.decodeFileDescriptor(imageSource, null, o);

	        // the new size we want to scale to
	        final int REQUIRED_SIZE = 1024;

	        // Find the correct scale value. It should be the power of 2.
	        int width_tmp = o.outWidth, height_tmp = o.outHeight;
	        int scale = 1;
	        while (true) {
	            if (width_tmp < REQUIRED_SIZE && height_tmp < REQUIRED_SIZE) {
	                break;
	            }
	            width_tmp /= 2;
	            height_tmp /= 2;
	            scale *= 2;
	        }
	        //create output stream
            ByteArrayOutputStream Coverstream = new ByteArrayOutputStream();
            //create file
            
	        // decode with inSampleSize
	        BitmapFactory.Options o2 = new BitmapFactory.Options();
	        o2.inSampleSize = scale;
	        Bitmap cover = BitmapFactory.decodeFileDescriptor(imageSource, null, o2);
	        mCoverPhoto.setImageBitmap(cover);
	        cover.compress(Bitmap.CompressFormat.PNG, 100, Coverstream);
	        mCover = Coverstream.toByteArray();


	    } catch (FileNotFoundException e) {
	        // handle errors
	    } finally {
	        if (parcelFD != null)
	            try {
	                parcelFD.close();
	            } catch (IOException e) {
	                // ignored
	            }
	    }
	}
	
		// Need Photo Gallery To Run Without Error
		// Need Photo Gallery To Run Without Error
		// Need Photo Gallery To Run Without Error
	
	public void Back (View v) {
		Intent intent = new Intent(EditProfileActivity.this, SettingsActivity.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
		startActivity(intent);
	}
}
