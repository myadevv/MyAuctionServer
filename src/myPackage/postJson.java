package myPackage;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;

public class postJson {
	public static String getrequestBody(HttpServletRequest request) throws IOException {
		
		String reqStr = null;
		StringBuilder stringBuilder = new StringBuilder();
		BufferedReader bufferedReader = null;
			
		try {
			InputStream inputStream = request.getInputStream();
			if (inputStream != null) {
				bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
				char[] charBuffer = new char[128];
				int bytesRead = -1;
				while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
					stringBuilder.append(charBuffer, 0, bytesRead);
				}
			} else {
				stringBuilder.append("");
			}
		} catch (IOException ex) {
			throw ex;
		} finally {
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (IOException ex) {
					throw ex;
				}
			}
		}
			
		reqStr = stringBuilder.toString();
		return reqStr;
	}
	
	public static void writeInputStreamToFile(String fileName, InputStream in) throws IOException {
        OutputStream out = null;
        try {
        	String saveFolder = "/image/";
        	
        	File Folder = new File(saveFolder);
        	if (!Folder.exists()) {
        		try { Folder.mkdir(); } 
        		catch(Exception e) { e.getStackTrace(); }
        	}
        	
        	File imgFile = new File(saveFolder + fileName);
        	if (!imgFile.exists()) {
        		try { imgFile.mkdir(); } 
        		catch(Exception e) { e.getStackTrace(); }
        	}
            out = new FileOutputStream(saveFolder + fileName);

            int read = 0;
            byte[] bytes = new byte[1024];

            while ((read = in.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
            if (in != null) {
                in.close();
            }
        }
    }
}