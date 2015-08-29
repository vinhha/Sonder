package com.thesonderapp.sonder;

import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseUser;
import com.parse.SaveCallback;

public class ComposeActivityPost extends Activity{
	protected TextView mContinueButton;
	protected EditText mPost;
	



	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_compose);
		
		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.back_left_action_bar_post_compose);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		
		
		mPost = (EditText)findViewById(R.id.bioField);
		
		mContinueButton = (TextView)findViewById(R.id.Continue);
		mContinueButton.setOnClickListener(new View.OnClickListener(){


			@Override
			public void onClick(View v) {
				
				
				String post = mPost.getText().toString();
				post = post.trim();
				
				if (post.isEmpty()){
					AlertDialog.Builder builder = new AlertDialog.Builder(ComposeActivityPost.this);
					builder.setMessage(R.string.bio_error_nothing)
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				
				else if (post.length() > 140){
					AlertDialog.Builder builder = new AlertDialog.Builder(ComposeActivityPost.this);
					builder.setMessage("Make sure your bio is less than 140 characters.")
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				else{
					//Add objects to backend
					ParseUser currentUser = ParseUser.getCurrentUser();
					
					currentUser.put("post", post);
					
					currentUser.saveInBackground(new SaveCallback() {
						@SuppressLint("InlinedApi") public void done(ParseException e) {
						    if (e == null) {
						      // Hooray! Let them use the app now.
						    	 Toast.makeText(ComposeActivityPost.this,
						 		        "Success!", Toast.LENGTH_SHORT).show();
						    	Intent intent = new Intent(ComposeActivityPost.this, PostActivity.class);
						    	intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						    	intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
								startActivity(intent);
						    } else {
						      // Sign up didn't succeed. Look at the ParseException
						      // to figure out what went wrong
						    	AlertDialog.Builder builder = new AlertDialog.Builder(ComposeActivityPost.this);
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

	



	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.sign_up, menu);
		return true;
	}
	
	public void Back (View v) {
		Intent intent = new Intent(ComposeActivityPost.this, PostActivity.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
		startActivity(intent);
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
}