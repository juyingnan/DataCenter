package com.client;

import java.util.List;

import org.apache.thrift.TException;

import service.thrift.PushMessage.Iface;

public class PushMessageImpl implements Iface
{
	@Override
	public List<String> push(List<String> messages) throws TException
	{
		Pusher pusher = Pusher.getInstance();
		// System.out.println(pusher);
		// System.out.println("Get new subscription. Push to client.");
		pusher.setResult(messages);
		pusher.setLock(false);
		// System.out.println("push return");
		return messages;
	}
}
