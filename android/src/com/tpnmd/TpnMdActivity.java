package com.tpnmd;

import android.graphics.drawable.Drawable;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.MyLocationOverlay;
import com.tpnmd.view.OfficesListView;


public class TpnMdActivity extends MapActivity {
	
	private MapView mapView;
	private MyLocationOverlay location;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate( Bundle savedInstanceState ) {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.main );
        mapView = (MapView) findViewById( R.id.mapview );
        mapView.preLoad();
        mapView.setBuiltInZoomControls( true );
        
        location = new MyLocationOverlay( this, mapView );
        
        mapView.getController().animateTo( new GeoPoint( (int)(35.767442*1E6), (int)(-78.986845*1E6) ) );
        mapView.getController().setZoom(9);
        
        Drawable pin = this.getResources().getDrawable(R.drawable.hospitals);
        pin.setBounds( 0, 0, pin.getIntrinsicWidth(), pin.getIntrinsicHeight() );
        
        mapView.getOverlays().add( new OfficesOverlay( pin, this));
        
        Button list = (Button) findViewById( R.id.listButton );
        list.setOnClickListener( new View.OnClickListener() {
    	    public void onClick(View view) {
    	    	Intent intent = new Intent( view.getContext(), OfficesListView.class );
    	    	startActivity( intent );
	        }
    	});
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
