package com.serverProxy;

import java.nio.ByteBuffer;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.Future;

import org.apache.thrift.TException;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.dbconn.DBConnection;
import com.metadata.entity.MetaDataNode;
import com.server.DIFServiceImpl;
import com.server.DataTypeConfig;
import com.serverAgent.ServerAgent;
import com.session.Session;
import com.subscription.Subscriber;
import com.threadpool.ThreadPool;
import com.threadpool.WorkThread;
import com.util.IdGenerator;
import com.util.SqlSimpleParser;
import com.util.TimeRecord;

import service.thrift.DataInterfaceForward.Client;
import service.thrift.DataInterfaceForward.Iface;

public class DAIServerProxy implements Iface {

	DIFServiceImpl localServer = new DIFServiceImpl();
	IdGenerator idGenerator = new IdGenerator(0);
	private final String TransactionID = "transactionID";
	private final static Logger logger = LoggerFactory
			.getLogger(DAIServerProxy.class);
	ProxyDataRecord proxyDataRecord = new ProxyDataRecord();
	List<MetaDataNode> metaList = new ArrayList<MetaDataNode>();
	private String dataType = "2";
	Map<String, Client> clientList = new HashMap<String, Client>();	
	
	private Subscriber			subscriber				= Subscriber.getInstance();
	
	ServerAgent nodeServer = new ServerAgent();
	private static final int Proxy_PORT = 9000;
	public DAIServerProxy(){
		
	}

	@Override
	public Map<String, String> dataBaseConn(Map<String, String> mappara)
			throws TException {
		logger.info("Begin:dataBaseConn method;" + TimeRecord.CurrentCompleteTime());
		String type = mappara.get("dataType");
		Map<String,String> resMap = new HashMap<String, String>();
		if(dataType == null){
			dataType = DataTypeConfig.dataType;
		}
		if(!type.equals(dataType)){			
			String forwardIpAddr = proxyDataRecord.getIpAddr(type);
	
			resMap.put("redirectIpAddress", forwardIpAddr);
		}else{
			resMap = nodeServer.dealWithDbconn(mappara);
		}
		logger.info("End:dataBaseConn method;" + TimeRecord.CurrentCompleteTime());		
		return resMap;
	}
	
	public Map<String, String> dataOper(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("Begin dataOper method, current time is: "+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
		resMap = localServer.dataOper(mappara);
		logger.info("End dataOper method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}
	
	public Map<String, String> affairBegin(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("Begin:affairBegin method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
			resMap = localServer.affairBegin(mappara);
			logger.info("End:affairBegin method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

	@Override
	public Map<String, String> affairCommit(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("Begin affairCommit method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
			resMap = localServer.affairCommit(mappara);
			logger.info("End affairCommit method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

	@Override
	public Map<String, String> affairRollBack(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("begin:affairRollBack method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
			resMap = localServer.affairRollBack(mappara);
			logger.info("End:affairRollBack method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

	@Override
	public Map<String, String> affairEnd(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("begin:affairEnd method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
		String ID = mappara.get("ID");
			resMap = localServer.affairEnd(mappara);
			logger.info("End:affairEnd method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

	@Override
	public Map<String, String> dataSearchByTxt(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("begin dataSearchByTxt method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
			resMap = localServer.dataSearchByTxt(mappara);
			logger.info("End:dataSearchByTxt method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

	@Override
	public Map<String, String> dataSearchByMemory(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("begin:dataSearchByMemory method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
			resMap = localServer.dataSearchByMemory(mappara);
			logger.info("End:dataSearchByMemory method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

	@Override
	public ByteBuffer lobSearch(Map<String, String> mappara) throws TException {
		// TODO Auto-generated method stub
		logger.info("begin lobSearch method;"+TimeRecord.CurrentCompleteTime());
		ByteBuffer buffer = null;
			buffer = localServer.lobSearch(mappara);
			logger.info("End:lobSearch method;"+TimeRecord.CurrentCompleteTime());
		return buffer;
	}

	@Override
	public Map<String, String> lobInsert(Map<String, String> mappara,
			ByteBuffer bytes) throws TException {
		// TODO Auto-generated method stub
		logger.info("begin lobInsert method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
			resMap = localServer.lobInsert(mappara, bytes);
			logger.info("Begin:lobInsert method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

	@Override
	public Map<String, String> dataBaseDisconn(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("begin dataBaseDisconn method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
			resMap = localServer.dataBaseDisconn(mappara);
			logger.info("End:dataBaseDisconn method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

	@Override
	public Map<String, String> errInfo(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("begin:errInfo method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
			resMap = localServer.errInfo(mappara);
			logger.info("End:errInfo method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

	@Override
	public Map<String, String> subscriptionRequest(Map<String, String> mappara)
			throws TException {
		// TODO Auto-generated method stub
		logger.info("begin:subscriptionRequest method;"+TimeRecord.CurrentCompleteTime());
		Map<String, String> resMap = null;
		resMap = localServer.subscriptionRequest(mappara);
		logger.info("begin:subscriptionRequest method;"+TimeRecord.CurrentCompleteTime());
		return resMap;
	}

}
