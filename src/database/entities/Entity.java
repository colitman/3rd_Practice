package database.entities;

import java.util.*;

public interface Entity {
	
	public void setID(int id);
	public int getID();
	public List<Entity> getAllChildren();
	
}