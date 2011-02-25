package com.tpnmd.view;

import android.app.Activity;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.widget.ImageView;

import com.tpnmd.R;

public class OfficeView extends Activity {

	@Override
	public void onCreate(Bundle savedInstance) {
		super.onCreate(savedInstance);
		this.setContentView(R.layout.officeview);
		ImageView officeImage = (ImageView) findViewById(R.id.officeImage);

		Drawable img = this.getResources().getDrawable(R.drawable.defaultimg);
		officeImage.setImageDrawable(img);
	}
}
