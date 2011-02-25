package com.tpnmd;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.MyLocationOverlay;
import com.tpnmd.office.OfficesOverlay;
import com.tpnmd.view.OfficesListView;

public class TpnMdActivity extends MapActivity {

	private static final int CENTER_LAT = (int) (35.767442 * 1E6);
	private static final int CENTER_LON = (int) (-78.986845 * 1E6);
	private static final int CENTER_ZOOM = 9;

	private MapView mapView;
	private MyLocationOverlay location;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		initMap();
		location = new MyLocationOverlay(this, mapView);
		Button list = (Button) findViewById(R.id.listButton);
		list.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				Intent intent = new Intent(view.getContext(),
						OfficesListView.class);
				startActivity(intent);
			}
		});
	}

	/**
	 * Initialize Map View to zoom in on center, and draw all offices.
	 */
	private void initMap() {
		mapView = (MapView) findViewById(R.id.mapview);
		mapView.preLoad();
		mapView.setBuiltInZoomControls(true);
		mapView.getController().animateTo(new GeoPoint(CENTER_LAT, CENTER_LON));
		mapView.getController().setZoom(CENTER_ZOOM);
		mapView.getOverlays().add(new OfficesOverlay(getMapPin(), this));
	}

	/**
	 * Obtain Drawable map "pin" icon for hospitols.
	 * 
	 * @return The bounded map "pin" icon.
	 */
	private Drawable getMapPin() {
		Drawable pin = this.getResources().getDrawable(R.drawable.hospitals);
		pin.setBounds(0, 0, pin.getIntrinsicWidth(), pin.getIntrinsicHeight());
		return pin;
	}

	@Override
	protected void onResume() {
		super.onResume();
		location.enableMyLocation();
	}

	@Override
	protected void onPause() {
		location.disableMyLocation();
		super.onPause();
	}

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}

	@Override
	protected boolean isLocationDisplayed() {
		return false;
	}
}
