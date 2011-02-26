package com.tpnmd.view;

import android.app.Activity;
import android.os.Bundle;
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
		
		title.setText(curOffice.getName());
		phoneNumber.setText(curOffice.getPhoneNumber());
		address.setText(curOffice.getAddress());
		
		this.setTitle("TPN MD - " + curOffice.getName());
		
		//ImageView officeImage = (ImageView) findViewById(R.id.officeImage);

		//Drawable img = this.getResources().getDrawable(R.drawable.defaultimg);
		//officeImage.setImageDrawable(img);
	}
}
