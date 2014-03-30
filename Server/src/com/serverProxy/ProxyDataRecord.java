package com.serverProxy;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.dbconn.DBConnection;
import com.metadata.entity.MetaDataNode;
import com.metadata.entity.MetaDataStore;
import com.serverAgent.ServerAgent;
import com.util.TimeRecord;

public class ProxyDataRecord {
	
	private Connection conn=null;
	private Statement stat =null;
	private final static int DBTYPE_MYSQL = 0;
	private ResultSet rs = null;
	private final static Logger logger = LoggerFactory.getLogger(ProxyDataRecord.class); 
	
	public String getIpAddr(String dataType){
		logger.info("Begin getIPAddr method." + TimeRecord.CurrentCompleteTime());
		String ip = null;
		if(conn == null){
			conn = DBConnection.getConnection(DBTYPE_MYSQL);
			try{
				stat = conn.createStatement();
			}catch(SQLException e){
				e.printStackTrace();
			}
		}
		String sql = "select * from t_metadata_node where dataKind='" + dataType + "'";
		ArrayList<MetaDataNode> nodeList = getDataNodeList(sql);
		for(MetaDataNode node:nodeList){
			if(node.getDataKind().equals(dataType))
				ip = node.getIpAddr();
			break;
		}
		logger.info("End getIPAddr method." + ip+"   "+TimeRecord.CurrentCompleteTime());
		return ip;
		
	}
	
	private ArrayList<MetaDataNode> getDataNodeList(String sql) {
		// TODO Auto-generated method stub
		logger.info("Begin getDataNodeList");
		ArrayList<MetaDataNode> metaDataNodeList = new ArrayList<MetaDataNode>();
		try {
			rs = stat.executeQuery(sql);
			while(rs.next()){
				MetaDataNode metaData = new MetaDataNode();
				metaData.setPhyAddr(rs.getString("phyAddr"));
				metaData.setIpAddr(rs.getString("ipAddr"));
				metaData.setDataKind(rs.getString("dataKind"));
				metaData.setAuthor(rs.getString("author"));
				metaData.setCreateTime(rs.getString("createTime"));
				metaData.setNodeKind(rs.getString("nodeKind"));
				metaData.setUpIPAddr(rs.getString("upIpAddr"));
				metaDataNodeList.add(metaData);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		logger.info("End getDataNodeList");
		return metaDataNodeList;
	}
}
