package database.entities;

import java.util.*;

public class Country implements Entity {

	private List<Region> regions;
	private long id;
	private String name;
	private String language; 
	private long population;
	private long timeZone;
	
	public Country() {
	
	}
	
	@Override
	public void setID(int id) {
		this.id = id;
	}
	
	@Override
	public int getID() {
		return id;
	}
	
	@Override
	public List<Entity> getAllChildren() {
		return regions;
	}

}