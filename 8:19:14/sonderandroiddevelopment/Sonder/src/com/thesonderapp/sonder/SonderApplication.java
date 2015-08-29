package com.thesonderapp.sonder;

import android.app.Application;

import com.parse.Parse;

public class SonderApplication extends Application{
	@Override
	public void onCreate() {
		super.onCreate();

		  Parse.initialize(this, "VW3bZhirX7USTbnhf6YFHOuBF0kvaTOURXrxnIao", "9WQfvvB4Z9hZk6kVUFbIngnn7iLSfCuEALJW7Xc9");
		 // ParseFacebookUtils.initialize("1410867669155409");

		  
	
	}
}




