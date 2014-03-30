package com.access;

public interface DataAccess {

	public String dataBaseConn(String username, String dataType);
	public String dataOper(String ID, String SQLinfo);
	
	public boolean affairBegin(String ID);
	public boolean affairCommit(String ID);
	public boolean affairRollBack(String ID);
	public boolean affairEnd(String ID);
	
	public String dataSearchByTxt(String ID, String SQLinfo, String savaPath, String spaceMark);
	public String dataSearchByMemory(String ID, String SQLinfo);
	public String lobSearch(String ID, String SQLinfo, String savaPath);
	public String lobInsert(String ID, String SQLinfo, String filePath);
	
	public String dataBaseDisconn(String ID);
	public String errInfo(String errorCode);
	public String subscriptionRequest(String Oper, String tableName, int mode);
}
