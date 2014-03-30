package com.dbconn;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.util.TimeRecord;

public class MySqlConnection implements IDBConnection {
	private final static Logger logger = LoggerFactory.getLogger(MySqlConnection.class); 
	@Override
	public Connection getConnection() {
		// TODO Auto-generated method stub
		logger.info("Begin:getConnection method;"+ TimeRecord.CurrentCompleteTime());
		Connection conn = null;
		try {
			Class.forName(ConnConfig.mysql_driver);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			conn = DriverManager.getConnection(ConnConfig.mysql_url, ConnConfig.mysql_user, ConnConfig.mysql_password);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		logger.info("End:getConnection method;"+ TimeRecord.CurrentCompleteTime());
		return conn;
	}

	@Override
	public void closeConnection(Connection conn) {
		// TODO Auto-generated method stub
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
