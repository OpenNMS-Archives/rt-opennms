package org.opennms.integration.rt.ticketclient;

import java.rmi.RemoteException;

import org.apache.axis.AxisFault;
import org.opennms.integration.rt.ticketservice.Credentials;
import org.opennms.integration.rt.ticketservice.Ticket;
import org.opennms.integration.rt.ticketservice.TicketServiceLocator;
import org.opennms.integration.rt.ticketservice.TicketServicePort_PortType;

import junit.framework.TestCase;

public class TicketClientTest extends TestCase {
	
	private TicketServicePort_PortType port;
	private TicketServiceLocator service;
	private Credentials creds;
	private Ticket defaultTicket;
	
	protected void setUp() throws Exception {

		super.setUp();

		service = new TicketServiceLocator();

		service.setTicketServicePortEndpointAddress(new java.lang.String(
				"http://localhost/otrs/opennms.pl"));

		port = service.getTicketServicePort();
		
		creds = new Credentials("opennms","opennms");
		
		defaultTicket.setSubject("default subject");
		defaultTicket.setContents("default contents");
		defaultTicket.setStatus("open");
		defaultTicket.setRequestor("Alex");
		
	}
	
	public void testNoUserTicketCreate() {

		try {
			port.ticketCreate(defaultTicket, new Credentials("", ""));
			fail("SOAPfault expected");
		} catch (AxisFault af) {
			assertEquals("Authentication Failure", af.getFaultString());
		} catch (RemoteException e) {
			// ignore
		}

	}

	public void testBadUserTicketCreate() {

		try {
			port.ticketCreate(defaultTicket, new Credentials("opennms", ""));
			fail("Axisfault expected");
		} catch (AxisFault af) {
			assertEquals("Authentication Failure", af.getFaultString());
		} catch (RemoteException e) {
			// ignore
		}

	}

	public void testBadPassTicketCreate() {
    	
    	try{
    		port.ticketCreate(defaultTicket, new Credentials("opennms","badpass"));
    		fail("SOAPfault expected");
    	} catch( AxisFault af ) {
  		      assertEquals("Authentication Failure",  af.getFaultString() );
        } catch (RemoteException e) {
  		// ignore
        }
	
	}
	
	public void testCreateAndGet() {
		
		Ticket newTicket = new Ticket();
		Ticket retrievedTicket = null;
		Long newTicketId = null;
		
		newTicket.setSubject("test create subject");
		newTicket.setContents("test create contents");
		newTicket.setStatus("open");
		newTicket.setRequestor("Alex");
		
		try {
			newTicketId = port.ticketCreate(defaultTicket, creds);
		} catch (RemoteException e) {
			fail("failed to create ticket");
		}
		
		try {
			retrievedTicket = port.ticketGetByID(newTicketId, creds);
		} catch (RemoteException e) {
			fail("failed to create ticket");
		}
		
		assertEquals(newTicket.getSubject(),retrievedTicket.getSubject());
		assertEquals(newTicket.getContents(), retrievedTicket.getContents());
		assertEquals(newTicket.getRequestor(), retrievedTicket.getRequestor());
		assertEquals(newTicket.getStatus(), retrievedTicket.getStatus());
		
	}


}
