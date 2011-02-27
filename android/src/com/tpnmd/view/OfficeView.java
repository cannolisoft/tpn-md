package com.tpnmd.view;

import android.app.Activity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.tpnmd.R;
import com.tpnmd.office.Office;

public class OfficeView extends Activity {

	@Override
	public void onCreate(Bundle savedInstance) {
		super.onCreate(savedInstance);
		this.setContentView(R.layout.officeview);
		
		Office curOffice = (Office)getIntent().getSerializableExtra(Office.class.getName());
		
		TextView title = (TextView) findViewById( R.id.title );
		TextView phoneNumber = (TextView) findViewById( R.id.phoneNumberTextView );
		TextView address = (TextView) findViewById( R.id.addressTextView );
		
		this.setTitle("TPN MD - " + curOffice.getName());
		title.setText(curOffice.getName());
		phoneNumber.setText(curOffice.getPhoneNumber());
		address.setText(curOffice.getAddress());
		
		address.setOnClickListener( new OnClickListener() {
			public void onClick(View view) {
				String addy = ((TextView)view).getText().toString();

				// The following URI launches a window which asks weather to
				// look up the address in the browser or in google maps.
				// String GOOGLE_MAPS_URI = new String( "http://maps.google.com/maps?daddr=" );
				// Uri googleMaps = Uri.parse( GOOGLE_MAPS_URI + addy );

				// This Uri attempts to navigate to the address immedietly using
				// google navigator
				Uri googleMaps = Uri.parse("google.navigation:q="+addy);
				Intent directionsIntent = new Intent( android.content.Intent.ACTION_VIEW, googleMaps );
				startActivity( directionsIntent );
			}
		});

		// ImageView officeImage = (ImageView) findViewById(R.id.image);
		// Drawable img = this.getResources().getDrawable(R.drawable.defaultimg);
		// officeImage.setImageDrawable(img);
	}
}
