package com.client;

import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.server.TServer;
import org.apache.thrift.server.TSimpleServer;
import org.apache.thrift.transport.TServerSocket;
import org.apache.thrift.transport.TServerTransport;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import service.thrift.PushMessage;
import service.thrift.DataInterfaceForward.Client;

public class DAIClientTestStop {
	
	private TTransport transport;
	private TProtocol protocol;
	public Client client;
	
	private static String Host = "localhost";
//	private static String Host = "192.168.213.200";
	
	private static final int Thrift_PORT = 9000;
	
	//¿Í»§¶Ë¶Ë¿ÚºÅ
	private static final int Client_PORT = 9001;
	private final static Logger logger = LoggerFactory.getLogger(DAIClientTestStop.class);
	private TServer server;

	
	public static void main(String[] args){
		DAIClientTestStop server = new DAIClientTestStop();
		server.serverStartByThread();
		server.serverStopByThread();
	}
	
	public void serverStart(){
		PushMessageImpl pushMessage = new PushMessageImpl();
		PushMessage.Processor<PushMessageImpl> processor =
				new PushMessage.Processor<PushMessageImpl>(pushMessage);
		TServerTransport serverTransport;
		try {
			serverTransport = new TServerSocket(Client_PORT);
			server = new TSimpleServer(
					new TServer.Args(serverTransport).processor(processor));

			logger.info("server start.");
			server.serve();
		} catch (TTransportException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private Thread thread1 = new Thread(){
		public void run(){
			System.out.println("enter in thread1");
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("before server stop");
			server.stop();
			System.out.println("after server stop");
		}
	};
	private Thread thread2 = new Thread(){
		public void run(){
			serverStart();
		}
	};
	public void serverStopByThread(){
		thread1.start();
	}
	public void serverStartByThread(){
		thread2.start();
	}
}
