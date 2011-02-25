package com.tpnmd.office;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.drawable.Drawable;
import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.OverlayItem;

public class OfficesOverlay extends ItemizedOverlay<OverlayItem> {

	private Context context;
	private ArrayList<OverlayItem> overlays;
	
	public OfficesOverlay( Drawable defaultMarker, Context ctx ) {
		this( defaultMarker );
		this.context = ctx;	
		populate();
	}
	
	public OfficesOverlay( Drawable defaultMarker ) {
		super( boundCenterBottom( defaultMarker ) );
		overlays = new ArrayList<OverlayItem>();
		for ( Office curOffice: OfficeModel.getAll() ) {
			overlays.add( curOffice.getOverlayItem() );
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
	  OverlayItem item = overlays.get(index);
	  AlertDialog.Builder dialog = new AlertDialog.Builder(context);
	  dialog.setTitle(item.getTitle());
	  dialog.setMessage(item.getSnippet());
	  dialog.show();
	  return true;
	}

}
