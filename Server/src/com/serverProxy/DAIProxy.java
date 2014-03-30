package com.serverProxy;

import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TBinaryProtocol.Factory;
import org.apache.thrift.server.TServer;
import org.apache.thrift.server.TThreadPoolServer;
import org.apache.thrift.server.TThreadPoolServer.Args;
import org.apache.thrift.transport.TServerSocket;
import org.apache.thrift.transport.TServerTransport;
import org.apache.thrift.transport.TTransportException;




import service.thrift.DataInterfaceForward;
import service.thrift.DataInterfaceForward.Processor;

public class DAIProxy {

	private static final int Thrift_PORT = 9000;

	public DAIProxy(){
	}
	public static void main(String[] args){
		DAIServerProxy serverProxy = new DAIServerProxy();
		Processor<DAIServerProxy> processor =
				new DataInterfaceForward.Processor<DAIServerProxy>(serverProxy);
		TServerTransport serverTransport;
		try {
			serverTransport = new TServerSocket(Thrift_PORT);
			Factory portFactory = new TBinaryProtocol.Factory(true, true);
			Args arg = new Args(serverTransport);
			
			arg.processor(processor);
			arg.protocolFactory(portFactory);
			
			TServer server = new TThreadPoolServer(arg);

			System.out.println("Starting server...");
			server.serve();
		} catch (TTransportException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
