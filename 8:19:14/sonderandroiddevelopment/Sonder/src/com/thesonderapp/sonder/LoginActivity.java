package com.thesonderapp.sonder;

import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.EditText;
import android.widget.TextView;

import com.parse.LogInCallback;
import com.parse.ParseException;
import com.parse.ParseUser;

public class LoginActivity extends Activity {

	protected EditText mUsername;
	protected EditText mPassword;

	protected TextView mLogInTextView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
		setContentView(R.layout.activity_login);
		
		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.empty_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_HOME|ActionBar.DISPLAY_SHOW_CUSTOM);
		
		
		mUsername = (EditText)findViewById(R.id.usernameField);
		mUsername.requestFocus();
		mPassword = (EditText)findViewById(R.id.passwordField);
		mLogInTextView = (TextView)findViewById(R.id.logInButton);
		mLogInTextView.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				String username = mUsername.getText().toString();
				String password = mPassword.getText().toString();
				
				username = username.trim();
				password = password.trim();
				
				if (username.isEmpty() || password.isEmpty()) {
					AlertDialog.Builder builder = new AlertDialog.Builder(LoginActivity.this);
					builder.setMessage(R.string.login_error_nothing)
						.setTitle(R.string.login_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				else {
					// Login
					setProgressBarIndeterminateVisibility(true);
					
					ParseUser.logInInBackground(username, password, new LogInCallback() {
						@SuppressLint("InlinedApi") @Override
						public void done(ParseUser user, ParseException e) {
							setProgressBarIndeterminateVisibility(false);
							
							if (e == null) {
								// Success!
								Intent intent = new Intent(LoginActivity.this, MainActivity.class);
								intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
								intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
								startActivity(intent);
							}
							else {
								AlertDialog.Builder builder = new AlertDialog.Builder(LoginActivity.this);
								builder.setMessage(e.getMessage())
									.setTitle(R.string.login_error_title)
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

//	@Override
//	public boolean onCreateOptionsMenu(Menu menu) {
//		// Inflate the menu; this adds items to the action bar if it is present.
//		getMenuInflater().inflate(R.menu.login, menu);
//		return true;
//	}

}


/*public class LoginActivity extends ActionBarActivity {
	
	protected TextView mLogInTextView;
	protected EditText mEmail;
	protected EditText mPassword;



	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);

		mEmail = (EditText)findViewById(R.id.emailField1);
		mPassword = (EditText)findViewById(R.id.passwordField1);
	
		mLogInTextView = (TextView)findViewById(R.id.logInButton);
		mLogInTextView.setOnClickListener(new View.OnClickListener(){

			@Override
			public void onClick(View v) {
				String email = mEmail.getText().toString();
				String password = mPassword.getText().toString();
				email = email.trim();
				password = password.trim();

				if (email.isEmpty() || password.isEmpty() ){
					AlertDialog.Builder builder = new AlertDialog.Builder(LoginActivity.this);
					builder.setMessage(R.string.login_error_nothing)
						.setTitle(R.string.login_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
//					Toast.makeText(getApplicationContext(), (String)genderChoice, 
//							   Toast.LENGTH_LONG).show();
				}
				else{
					//Login
					ParseUser.logInInBackground(email, password, new LogInCallback() {
						@SuppressLint("InlinedApi") @Override
						public void done(ParseUser user, ParseException e){
							if(e == null) {
								//Success!
								 Toast.makeText(LoginActivity.this,
							 		        "Success!", Toast.LENGTH_SHORT).show();
							    	Intent intent = new Intent(LoginActivity.this, MainActivity.class);
							    	intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
							    	intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
									startActivity(intent);
							}
							else{
								AlertDialog.Builder builder = new AlertDialog.Builder(LoginActivity.this);
								builder.setMessage(R.string.login_error_incorrect)
									.setTitle(R.string.login_error_title)
									.setPositiveButton(android.R.string.ok, null);
								AlertDialog dialog = builder.create();
								dialog.show();
							}
						}
					});
				
//					Intent intent = new Intent(SignUpActivity.this, MainActivity.class);
//					startActivity(intent);
				}
				
				
				
			}

		});
		
		
	}*/

//	@Override
//	public boolean onCreateOptionsMenu(Menu menu) {
//		// Inflate the menu; this adds items to the action bar if it is present.
//		getMenuInflater().inflate(R.menu.login, menu);
//		return true;
//	}
//
//	@Override
//	public boolean onOptionsItemSelected(MenuItem item) {
//		// Handle action bar item clicks here. The action bar will
//		// automatically handle clicks on the Home/Up button, so long
//		// as you specify a parent activity in AndroidManifest.xml.
//		int id = item.getItemId();
//		if (id == R.id.action_settings) {
//			return true;
//		}
//		return super.onOptionsItemSelected(item);
//	}



