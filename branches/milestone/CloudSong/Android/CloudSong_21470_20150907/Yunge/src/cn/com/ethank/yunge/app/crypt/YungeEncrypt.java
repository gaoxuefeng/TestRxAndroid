package cn.com.ethank.yunge.app.crypt;


import org.cryptonode.jncryptor.AES256JNCryptor;
import org.cryptonode.jncryptor.JNCryptor;

public class YungeEncrypt {

 private static String password = "Showme$The$Money";

 public static byte[] decode(byte[] data) {
   try {
	   JNCryptor cryptor = new AES256JNCryptor();
	   byte[] enreturn = cryptor.decryptData(data,getPasswrod().toCharArray());
	   return enreturn;  
   } catch(Exception e) {
	   e.printStackTrace();
   }
   return null;
   
 }

 public static byte[] encode(byte[] src) {
  try {
   JNCryptor cryptor = new AES256JNCryptor();
   byte[] enreturn = cryptor.encryptData(src,getPasswrod().toCharArray());
   return enreturn;
  } catch (Exception e) {
   return null;
  }
 }
 
 private static String getPasswrod() {
//	 if(password == null) {
//		 password = Native.genkeyCommon();
//	 }
	 return password;
 }
 
 
}
