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
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseUser;
import com.parse.SignUpCallback;

public class SignUpActivity extends Activity{
	protected String genderChoice;
	protected TextView mSignUpTextView;
	protected EditText mFirstName;
	protected EditText mLastName;
	protected EditText mEmail;
	protected EditText mPassword;
	protected EditText mBirthday;
	protected EditText mEmailCheck;
	protected EditText mPasswordCheck;
	private RadioGroup radioGroupId;
	private RadioButton radioBtn1;



	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
//		addListenerRadioGroup1();

		
		setContentView(R.layout.activity_sign_up);
		
		ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.empty_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_HOME|ActionBar.DISPLAY_SHOW_CUSTOM);
		
		
		mFirstName = (EditText)findViewById(R.id.firstnameField);
		mLastName = (EditText)findViewById(R.id.lastnameField);
		mEmail = (EditText)findViewById(R.id.emailField1);
		mPassword = (EditText)findViewById(R.id.passwordField1);
		mEmailCheck = (EditText)findViewById(R.id.emailField2);
		mPasswordCheck = (EditText)findViewById(R.id.passwordField2);
		mBirthday = (EditText)findViewById(R.id.birthdayField);
		radioGroupId = (RadioGroup)findViewById(R.id.radioGroup1);
		
	
//		radioGroupId.setOnCheckedChangeListener(SignUpActivity.this);
		
		
		mSignUpTextView = (TextView)findViewById(R.id.signUpButton);
		mSignUpTextView.setOnClickListener(new View.OnClickListener(){
			
			

			@Override
			public void onClick(View v) {
				
				 
		        int selected = radioGroupId.getCheckedRadioButtonId();
		        radioBtn1 = (RadioButton)findViewById(selected);
//		        Toast.makeText(SignUpActivity.this,
//		        		radioBtn1.getText(), Toast.LENGTH_SHORT).show();
		        
		        genderChoice = (String) radioBtn1.getText();
		      
				
				String email = mEmail.getText().toString();
				String password = mPassword.getText().toString();
				String birthday = mBirthday.getText().toString();
				String first = mFirstName.getText().toString();
				String last = mLastName.getText().toString();
				String emailCheck = mEmailCheck.getText().toString();
				String passwordCheck = mPasswordCheck.getText().toString();
				
				email = email.trim();
				password = password.trim();
				birthday = birthday.trim();
				first = first.trim();
				last = last.trim();
				emailCheck = emailCheck.trim();
				passwordCheck = passwordCheck.trim();
				
				
				if (email.isEmpty() || password.isEmpty() || birthday.isEmpty() || first.isEmpty() || last.isEmpty() || genderChoice.isEmpty()){
					AlertDialog.Builder builder = new AlertDialog.Builder(SignUpActivity.this);
					builder.setMessage(R.string.signup_error_nothing)
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
//					Toast.makeText(getApplicationContext(), (String)genderChoice, 
//							   Toast.LENGTH_LONG).show();
				}
				else if  (!(birthday.matches("(0?[1-9]|1[012])/(0?[1-9]|[12][0-9]|3[01])/((18|19|20|21)\\d\\d)"))) {
					AlertDialog.Builder builder = new AlertDialog.Builder(SignUpActivity.this);
					builder.setMessage("Make sure you entered your birthday correctly.")
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				else if (email.length() < 4 || !(email.substring(email.length()-4).equals(".edu"))){
					AlertDialog.Builder builder = new AlertDialog.Builder(SignUpActivity.this);
					builder.setMessage("Make sure you entered a valid .edu email.")
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				else if (!(emailCheck.equals(email))){
					AlertDialog.Builder builder = new AlertDialog.Builder(SignUpActivity.this);
					builder.setMessage("Make sure your emails match.")
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				else if (!(passwordCheck.equals(password))){
					AlertDialog.Builder builder = new AlertDialog.Builder(SignUpActivity.this);
					builder.setMessage("Make sure your passwords match.")
						.setTitle(R.string.signup_error_title)
						.setPositiveButton(android.R.string.ok, null);
					AlertDialog dialog = builder.create();
					dialog.show();
				}
				else{
					//Create New User
					
					ParseUser newUser = new ParseUser();
					newUser.setUsername(email);
					newUser.setPassword(password);
					newUser.setEmail(email);
					 
					// other fields can be set just like with ParseObject
					newUser.put("name", first + " " + last);
					newUser.put("gender", genderChoice);
					newUser.put("birthday", birthday);
					newUser.put("complimentsValue", 00);
					newUser.put("postValue", 00);
					newUser.put("thoughtTotal", 00);
					newUser.put("profileTotal", 00);
				
					/* newUser.username = username;
                    newUser.password = password;
                    newUser.email = email;
                    newUser[@"name"] = self.name;
                    newUser[@"gender"] = self.gender;
                    newUser[@"birthday"] = birthdate;
                    newUser[@"complimentsValue"] = [NSNumber numberWithInteger: 00];
                    newUser[@"postValue"] = [NSNumber numberWithInteger: 00];
                    newUser[@"thoughtTotal"] = [NSNumber numberWithInt: 00];
                    newUser[@"profileTotal"] = [NSNumber numberWithInt: 00];*/
					
					newUser.signUpInBackground(new SignUpCallback() {
					@SuppressLint("InlinedApi") public void done(ParseException e) {
					    if (e == null) {
					      // Hooray! Let them use the app now.
					    	 Toast.makeText(SignUpActivity.this,
					 		        "Success!", Toast.LENGTH_SHORT).show();
					    	Intent intent = new Intent(SignUpActivity.this, SignUpProfileActivity.class);
					    	intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					    	intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
							startActivity(intent);
					    } else {
					      // Sign up didn't succeed. Look at the ParseException
					      // to figure out what went wrong
					    	AlertDialog.Builder builder = new AlertDialog.Builder(SignUpActivity.this);
							builder.setMessage(e.getMessage())
								.setTitle(R.string.signup_error_title)
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
//	public void onCheckedChanged(RadioGroup group, int checkedId) {
//
//		if(checkedId == 0){
//			genderChoice = "Male";
//		}
//		else if (checkedId == 1){
//			genderChoice = "Female";
//		}
//	}
	
}
