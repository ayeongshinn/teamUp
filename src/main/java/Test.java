
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;

public class Test {
	
	public static void main(String[] args) throws UnknownHostException, SocketException {
		
		
		System.out.println(InetAddress.getLocalHost().getHostAddress());
		
		System.out.println(getLocalHost().getHostAddress());
	}
	
	
	private static InetAddress getLocalHost() throws SocketException, UnknownHostException {
        try{
            
        	//NetworkInterface networkInterface = NetworkInterface.getByName("en1");
        	
        	Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();
            
        	while(networkInterfaces.hasMoreElements()) {
        		NetworkInterface networkInterface = networkInterfaces.nextElement();
        		
        		for (Enumeration<InetAddress> addresses = networkInterface.getInetAddresses(); addresses.hasMoreElements(); ) {
                    InetAddress address = addresses.nextElement();
                    if (address instanceof Inet4Address && !address.isLoopbackAddress()) {
                        return address;
                    }
                }
        	}
            
        } catch(NullPointerException e){
            return InetAddress.getLocalHost();
        }
        return InetAddress.getLocalHost();
    }
	
	
	

}
