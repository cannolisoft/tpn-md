package com.tpnmd.view;

import android.app.Activity;
import android.app.AlertDialog;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.tpnmd.R;
import com.tpnmd.office.Office;

public class OfficeView extends Activity {

	@Override
	public void onCreate(Bundle savedInstance) {
		super.onCreate(savedInstance);
		this.setContentView(R.layout.officeview);
		
		final Office curOffice = (Office)getIntent().getSerializableExtra(Office.class.getName());
		
		TextView title = (TextView) findViewById( R.id.title );
		TextView phoneNumber = (TextView) findViewById( R.id.phoneNumberTextView );
		TextView address = (TextView) findViewById( R.id.addressTextView );
		
		this.setTitle("TPN MD - " + curOffice.getName());
		title.setText(curOffice.getName());
		phoneNumber.setText(curOffice.getPhoneNumber());
		address.setText(curOffice.getAddress());
		
		        
		ImageView addyImg = (ImageView) findViewById( R.id.imageView1 );
		ImageView phoneImg = (ImageView) findViewById( R.id.imageView2 );
		
		OnClickListener addressListener = new OnClickListener() {
			public void onClick(View view) {
				String addy = curOffice.getAddress();
				navigate( addy, view.getContext() );
			}
		};

		addyImg.setOnClickListener(addressListener);
		address.setOnClickListener(addressListener);
		
		OnClickListener phoneListener = new OnClickListener() {
			public void onClick(View view) {
				String number = curOffice.getPhoneNumber();
				call( number );
			}
		};
		
		phoneNumber.setOnClickListener(phoneListener);
		phoneImg.setOnClickListener(phoneListener);
		
		// ImageView officeImage = (ImageView) findViewById(R.id.image);
		// Drawable img = this.getResources().getDrawable(R.drawable.defaultimg);
		// officeImage.setImageDrawable(img);
	}
	
	public void call(String number) {
        Uri phoneCall = Uri.parse("tel:" + number);
		Intent callIntent = new Intent( android.content.Intent.ACTION_VIEW, phoneCall );
		startActivity(callIntent);
	}
	
	public void navigate(String addy, Context ctx) {
		/**
		 * This Uri attempts to navigate to the address immedietly using google navigator.
		 */
		try {
			Uri googleMaps = Uri.parse("google.navigation:q="+addy);
			Intent directionsIntent = new Intent( android.content.Intent.ACTION_VIEW, googleMaps );
			startActivity( directionsIntent );
		} catch ( ActivityNotFoundException anfe ) {
			
		    try {
		        /**
		         * The following URI launches a window which asks weather to
		         * look up the address in the browser or in google maps.
		         */
		        String GOOGLE_MAPS_URI = new String( "http://maps.google.com/maps?daddr=" );
		        Uri googleMaps = Uri.parse( GOOGLE_MAPS_URI + addy );
		        Intent directionsIntent = new Intent( android.content.Intent.ACTION_VIEW, googleMaps );
		        startActivity( directionsIntent );
		    
		    } catch ( Exception e ) { 
		        AlertDialog.Builder dialog = new AlertDialog.Builder(ctx);
		        dialog.setTitle("Navigation Error");
		        dialog.setMessage("Sorry for the inconvenience, TPNMD is unable to route you to this location.");
		        dialog.show();
		    }
		    
		}
	}
	
}
