package com.tpnmd.office;

import java.util.ArrayList;
import java.util.List;


import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.OverlayItem;
import com.tpnmd.view.OfficeView;



public class OfficesOverlay extends ItemizedOverlay<OverlayItem> {

    public enum MapFilter {
        ALL,
        URGENT,
        PRACTICES
    }
    
	private Context context;
	private ArrayList<OverlayItem> overlays;
	private MapFilter curFilter;
	
	public OfficesOverlay( Drawable defaultMarker, Context ctx, MapFilter filter, Drawable drawables[] ) {
		this( defaultMarker, filter, drawables );
		this.context = ctx;	
		populate();
	}
	
	public OfficesOverlay( Drawable defaultMarker, MapFilter filter, Drawable drawables[] ) {
		super( boundCenterBottom( defaultMarker ) );
		curFilter = filter;
		overlays = new ArrayList<OverlayItem>();
		
		List<Office> offices = null;
		
		if ( filter == MapFilter.ALL ) {
		    offices = OfficeModel.getAll();
		} else if ( filter == MapFilter.URGENT ) {
		    offices = OfficeModel.getUrgentCare();
		} else {
		    offices = OfficeModel.getPractices();
		}
		
		for ( Office curOffice: offices ) {
			overlays.add( curOffice.getOverlayItem(drawables) );
		}
		populate();
	}

	@Override
	protected OverlayItem createItem(int num) {
		return overlays.get( num );
	}

	@Override
	public int size() {
		return overlays.size();
	}
	
	@Override
	protected boolean onTap(int index) {
	    Office office = null;
	    if ( curFilter == MapFilter.ALL ) {
	        office = OfficeModel.getAll().get(index);
	    } else if ( curFilter == MapFilter.URGENT ) {
	        office = OfficeModel.getUrgentCare().get(index);
	    } else {
	        office = OfficeModel.getPractices().get(index);
	    }
	    Intent intent = new Intent(context, OfficeView.class);
	    intent.putExtra(Office.class.getName(), office);
	    context.startActivity(intent);
	    return true;
	}

}
