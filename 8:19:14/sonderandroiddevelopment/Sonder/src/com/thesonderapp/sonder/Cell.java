package com.thesonderapp.sonder;

import com.parse.ParseClassName;
import com.parse.ParseGeoPoint;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

@ParseClassName("User")
public class Cell extends ParseObject {
  public String getText() {
    return getString("post");
  }
 
  public void setText(String value) {
    put("post", value);
  }
 
  public ParseUser getUser() {
    return getParseUser("User");
  }
 
  public void setUser(ParseUser value) {
    put("User", value);
  }
 
  public ParseGeoPoint getLocation() {
    return getParseGeoPoint("location");
  }
 
  public void setLocation(ParseGeoPoint value) {
    put("location", value);
  }
 
  public static ParseQuery<Cell> getQuery() {
    return ParseQuery.getQuery(Cell.class);
  }

}
