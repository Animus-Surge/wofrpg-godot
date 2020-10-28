package com.programwings.wofrpglauncher.util;

import java.io.*;

public class FileHandler {
	
	private static BufferedReader reader;

	/**
	 * 
	 * Opens a file and stores it to local buffer
	 * 
	 * @param filepath The absolute path of the file to be loaded
	 * @return if it was successful or not
	 */
	public static boolean openFile(String filepath) {
		try {
			reader = new BufferedReader(new FileReader(new File(filepath)));
		} catch (IOException e) {
			new Logcat(2).log("Failed to load file: " + filepath + " Reason: " + e.getClass().toString());
			return false;
		}
		return true;
	}

	public static String getFileAsText() {
		String output = "";
		try {
			String line = reader.readLine();
			while (line != "") {
				output += line + "\n";
				line = reader.readLine();
			}
		} catch (IOException e) {
			new Logcat(2).log("Error reading a line from buffered file. Reason: " + e.getClass().toString());
			output = "ERRORED";
		}
		
		return output;
		
	}

}
