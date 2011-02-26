package com.tpnmd.office;

import java.io.Serializable;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.OverlayItem;

public class Office implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String name;
	private String address;
	@SuppressWarnings("unused")
	private String address2;
	private String phone;
	private String imagePath;
	
	private double lat;
	private double lon;
	
	public Office( String type, String name, 
			       String address, String address2,
			       String phone, String imagePath, String xmlIdentifier,
			       double lat, double lon ) {
		
		this.name = name;
		this.setAddress(address,address2);
		this.phone = phone;
		this.setImagePath(imagePath);
		this.lat = lat;
		this.lon = lon;
	}

	public OverlayItem getOverlayItem() {
        return new OverlayItem( new GeoPoint( (int)(lat*1E6), (int)(lon*1E6) ), name, phone );	
	}

	public String getPhoneNumber() {
		return phone;
	}
	
	public void setAddress( String address, String address2 ) {
		this.address = address;
		this.address2 = address2;
	}

	public String getAddress() {
		return address;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public String getImagePath() {
		return imagePath;
	}

	public String getName() {
		return name;
	}
	
	public String toString() {
		return name;
	}
}
