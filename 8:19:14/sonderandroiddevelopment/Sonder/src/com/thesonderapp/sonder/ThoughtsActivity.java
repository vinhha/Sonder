package com.thesonderapp.sonder;

import java.util.ArrayList;
import java.util.List;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.ListView;

import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQueryAdapter;

public class ThoughtsActivity extends Activity{
	
	protected ListView mcell;
	protected List<ParseObject> cellList;
	protected ArrayList<String> mcellList;
	private ParseQueryAdapter<Cell> posts;
public static final String TAG = ThoughtsActivity.class.getSimpleName();


	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
		setContentView(R.layout.activity_thoughts);
		
		ActionBar actionBar = getActionBar();
		actionBar.setDisplayShowHomeEnabled(false);
		actionBar.setCustomView(R.layout.thoughts_default_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		
	mcell = (ListView)findViewById(R.id.cell);
	
	final ParseQueryAdapter<Cell> arrayAdapter = new ParseQueryAdapter<Cell>(this, Cell.class);
	arrayAdapter.setTextKey("post");
	mcell.setAdapter(arrayAdapter);
	
	
	ParseQueryAdapter.QueryFactory<Cell> factory = new ParseQueryAdapter.QueryFactory<Cell>() {

		@Override
		public ParseQuery<Cell> create() {
			
			ParseQuery<Cell> query = Cell.getQuery();
			
			return query;
		}
		
	};
	
	posts = new ParseQueryAdapter<Cell>(this, factory);
	
	
	mcell.setAdapter(posts);
	
		
	//QUERY FOR OBJECTS
	
	
	/*ParseQuery<ParseUser> query = ParseUser.getQuery();
	//query.whereEqualTo("username", "vinhha@umail.ucsb.edu");
	//query.include("post");
	query.setLimit(50);
	query.findInBackground(new FindCallback<ParseUser>() {
		*/
	
	
	/*ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("Messages");
	query.whereEqualTo("objectId", null);
	query.findInBackground(new FindCallback<ParseObject>(){*/

		/*public void done(List<ParseUser> cellList, ParseException e) {
			if(e == null){
				Log.d("cells", "Retrieved " + cellList.size() + " Thoughts");
				
				Set<String> user = new HashSet<String>();
				 for(int i = 0; i < cellList.size(); i++) {
					 user.add((cellList.get(i)).getString("post"));
					 arrayAdapter.addAll(user);
					 Log.d("cells", "Retrieved " + user + " Thoughts");
				 }
				*/
				
				/*for (int i = 0; i < cellList.size(); i++){
					//String post = ((cellList.get(i)).getString("objectId")).toString();
					String post = (cellList.get(i)).toString();
					arrayAdapter.add(post);
				}*/
				
			/*}
			else{
				Log.d("cells", "Error:" + e.getMessage());
			}*/
			/*if (cellList.size() == 0){
				Toast.makeText(ThoughtsActivity.this,
		 		        "There are no thoughts to show. Invite your friends to join Sonder.", Toast.LENGTH_SHORT).show();
			}*/
				
	/*	}
	});*/
		/*@Override
		public void done(List<ParseUser> cellList, ParseException e) {
			if(e == null){
				Log.d("cells", "Retrieved " + cellList.size() + " Thoughts");
				
				for (int i = 0; i < cellList.size(); i++){
					//Object object = cellList.get(i);
					//String post = (((ParseObject) object).getString("post")).toString();
					String post = cellList.get(i).toString();
					arrayAdapter.add(post);
				}
				
			}
			else{
				Log.d("cells", "Error:" + e.getMessage());
			}
			if (cellList.size() == 0){
				Toast.makeText(ThoughtsActivity.this,
		 		        "There are no thoughts to show. Invite your friends to join Sonder.", Toast.LENGTH_SHORT).show();
			}	
		}
		
		
		});
	*/
	arrayAdapter.notifyDataSetChanged();
	
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
	// Inflate the menu; this adds items to the action bar if it is present.
	getMenuInflater().inflate(R.menu.main, menu);
	return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	switch (item.getItemId())
	{
	case R.id.menu_thoughts:
		Log.i(TAG, "Thoughts Item Clicked");
		Intent intent = new Intent(this, ThoughtsActivity.class);
		startActivity(intent);
		return true;
	case R.id.menu_sonder:
		Log.i(TAG, "Sonder Item Clicked");
		Intent intent1 = new Intent(this, SonderActivity.class);
		startActivity(intent1);
		return true;
	case R.id.menu_post:
		Log.i(TAG, "Post Item Clicked");
		Intent intent2 = new Intent(this, PostActivity.class);
		startActivity(intent2);
		return true;
	case R.id.menu_inbox:
		Log.i(TAG, "Inbox Item Clicked");
		Intent intent3 = new Intent(this, InboxActivity.class);
		startActivity(intent3);
		return true;
	case R.id.menu_home:
		Log.i(TAG, "Home Item Clicked");
		Intent intent4 = new Intent(this, HomeActivity.class);
		startActivity(intent4);
		return true;
		
	default:
		return super.onOptionsItemSelected(item);
	}
	}
	
	public void More (View v) {

		ActionBar actionBar = getActionBar();
		actionBar.setDisplayShowHomeEnabled(false);
		actionBar.setCustomView(R.layout.filter_action_bar);
		actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
		
	}
	
	public void Compose (View v) {
		Intent intent = new Intent(ThoughtsActivity.this, ComposeActivityThoughts.class);
		startActivity(intent);
	}
}
	
