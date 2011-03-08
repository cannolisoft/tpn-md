package com.tpnmd;

import android.app.AlertDialog;

import android.content.DialogInterface;
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
import com.tpnmd.office.OfficesOverlay.MapFilter;
import com.tpnmd.view.OfficesListView;

public class TpnMdActivity extends MapActivity {

	private static final int CENTER_LAT = (int) (35.767442 * 1E6);
	private static final int CENTER_LON = (int) (-78.986845 * 1E6);
	private static final int CENTER_ZOOM = 9;

	private MapView mapView;
	private MyLocationOverlay location;
	private Drawable drawables[];

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		initMap();

		Button list = (Button) findViewById(R.id.listButton);
		list.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				Intent intent = new Intent(view.getContext(),
						OfficesListView.class);
				startActivity(intent);
			}
		});
		
		
		Button filter = (Button) findViewById(R.id.filterButton);
		filter.setOnClickListener(new View.OnClickListener() {
            
            public void onClick(View v) {
                final CharSequence[] items = {"All", "Urgent Care", "Practices"};

                AlertDialog.Builder builder = new AlertDialog.Builder(v.getContext());
                builder.setTitle("Choose care centers to display:");
                builder.setSingleChoiceItems(items, -1, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int item) {
                        switch (item) {
                            case 0:
                                updateMap(MapFilter.ALL);
                                break;
                            case 1:
                                updateMap(MapFilter.URGENT);
                                break;
                            case 2:
                                updateMap(MapFilter.PRACTICES);
                                break;
                        }
                        dialog.dismiss();
                    }
                    
                });
                AlertDialog alert = builder.create();
                alert.show();
            }
        });
	}

	
	private void updateMap( MapFilter filter ) {
	    mapView.getOverlays().clear();
	    mapView.getOverlays().add(new OfficesOverlay(getMapPin(), this, filter, drawables));
	    mapView.postInvalidate();
	}
	
	/**
	 * Initialize Map View to zoom in on center, and draw all offices.
	 */
	private void initMap() {
	    drawables = new Drawable[2];
	    drawables[0] = this.getResources().getDrawable(R.drawable.hospitals);
	    drawables[1] = this.getResources().getDrawable(R.drawable.pin);
	    
		mapView = (MapView) findViewById(R.id.mapview);
		mapView.preLoad();
		mapView.setBuiltInZoomControls(true);
		mapView.getController().animateTo(new GeoPoint(CENTER_LAT, CENTER_LON));
		mapView.getController().setZoom(CENTER_ZOOM);
		
		OfficesOverlay overlay = new OfficesOverlay(getMapPin(), this, MapFilter.ALL, drawables);
		mapView.getOverlays().add(overlay);
		mapView.getZoomButtonsController().setAutoDismissed(false);
		mapView.displayZoomControls(true);
		mapView.getZoomButtonsController().setVisible(true);
		mapView.getZoomButtonsController().getZoomControls().postInvalidate();
		mapView.performLongClick();
		location = new MyLocationOverlay(this, mapView);
		mapView.getOverlays().add(location);
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
