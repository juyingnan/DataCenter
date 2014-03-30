package com.access.test;

import java.io.IOException;

import org.apache.thrift.transport.TTransportException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.access.DataAccessInterface;
import com.client.subscription.test.SubscriptionClientTest;
import com.util.TimeRecord;

public class DataAccessInterfaceTest {
	private final static Logger logger = LoggerFactory
			.getLogger(DataAccessInterfaceTest.class);

	public static void main(String[] args){
		

		
		try {
			DataAccessInterface dai;
			dai = new DataAccessInterface();
//			dai.start();
			logger.info("current time before statup dataBaseConn = "+TimeRecord.CurrentCompleteTime());
			String ID = dai.dataBaseConn("ll", "2");
			System.out.println("result ID = "+ID);
			System.out.println("connection id = "+ID);
//			testDataOper(ID,dai);
//			testDataSearchByMemory(ID,dai);
//			testDataSearchByTxt(ID,dai);
//			testLobSearch(ID,dai);
//			testLobInsert(ID,dai);
//			testsubscriptionRequest2(dai);
			testTransaction1(ID,dai);
//			testTransaction2(ID,dai);
//			testTransaction3(ID,dai);
//			testTransaction4(ID,dai);
//			testsubscriptionRequest1(ID,dai);
			
			
			dai.dataBaseDisconn(ID);
			logger.info("current time after break dataBaseConn = "+TimeRecord.CurrentCompleteTime());
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	
	}
	
	private static void testDataOper(String ID,DataAccessInterface dai){
		String SQLinfo = "update river set description='three' where river_id = 1 ;";
		dai.dataOper(ID, SQLinfo);
	}
	
	private static void testDataSearchByMemory(String ID,DataAccessInterface dai){
		String SQLinfo = "SELECT information_id, description "+
		"FROM  `information` WHERE kind = 0 ";
		dai.dataSearchByMemory(ID, SQLinfo);
	}
	private static void testDataSearchByTxt(String ID,DataAccessInterface dai){
		String SQLinfo = "SELECT information_id, description "+
				"FROM  `information` WHERE kind = 0 ";
		String spaceMark =" ";
		String savePath = System.getProperty("user.dir");//+"\\a.txt";
		dai.dataSearchByTxt(ID, SQLinfo, savePath, spaceMark);
	}
	private static void testLobSearch(String ID,DataAccessInterface dai){
		String savePath = System.getProperty("user.dir")+"\\receive\\image.jpg";
		String SQLinfo = "SELECT image FROM  `information` "+
		" WHERE information_id = 6 ; ";
//		String savaPath;
		dai.lobSearch(ID, SQLinfo, savePath);
	}
	private static void testLobInsert(String ID,DataAccessInterface dai){
		String SQLinfo = "insert into information (description , data ,image) "
				+" values('mountain','extra data is null',?)";
		String filePath = System.getProperty("user.dir")+"\\send\\image.jpg";
		dai.lobInsert(ID, SQLinfo, filePath);
	}
	
	private static void testTransaction1(String ID,DataAccessInterface dai){
		dai.affairBegin(ID);
		
		String SQLinfo1 = "update river set description='first' where river_id = 1 ;";
		dai.dataOper(ID, SQLinfo1);
		String SQLinfo2 = "update river set description = 'second' where river_id = 2 ;";
		dai.dataOper(ID, SQLinfo2);
		dai.affairCommit(ID);
		
	}
	
	//本次事务没有提交affairCommit
	private static void testTransaction2(String ID,DataAccessInterface dai){
		dai.affairBegin(ID);
		String SQLinfo1 = "update information set description = 'first' where information_id = 1 ;";
		dai.dataOper(ID, SQLinfo1);
		String SQLinfo2 = "update information set description = 'second' where information_id = 6 ;";
		dai.dataOper(ID, SQLinfo2);
		dai.affairCommit(ID);
	}
	//本次事务里面既有dataOper，又有LobInsert,同时提交affairCommit
	private static void testTransaction3(String ID,DataAccessInterface dai){
		dai.affairBegin(ID);
		String SQLinfo1 = "update information set kind = 5 where information_id = 1 ;";
		dai.dataOper(ID, SQLinfo1);
		testLobInsert(ID,dai);
		dai.affairCommit(ID);
	}
	private static void testTransaction4(String ID,DataAccessInterface dai){
		dai.affairBegin(ID);
		String SQLinfo1 = "update information set kind = 3 where information_id = 1 ;";
		dai.dataOper(ID, SQLinfo1);
		testLobInsert(ID,dai);
	}
	
	private static void testsubscriptionRequest1(String ID,DataAccessInterface dai){
		String Oper = "ADD";
		String tableName = "river";
		int mode = 0;
		dai.subscriptionRequest(Oper, tableName, mode);
		SubscriptionClientTest clientTest = new SubscriptionClientTest();
		clientTest.getSubscription();
		dai.affairBegin(ID);
		String SQLinfo1 = "update river set description ='second' where river_id = 1 ;";
		dai.dataOper(ID, SQLinfo1);
		String SQLinfo2 = "update river set description = 'first' where river_id = 2 ;";
		dai.dataOper(ID, SQLinfo2);
		dai.affairCommit(ID);
	}
	
	private static void testsubscriptionRequest2(DataAccessInterface dai){
		String Oper = "RMV";
		String tableName = "river";
		int mode = 0;
		dai.subscriptionRequest(Oper, tableName, mode);
	}
}
