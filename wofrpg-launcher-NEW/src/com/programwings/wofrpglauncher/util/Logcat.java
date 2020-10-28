package com.programwings.wofrpglauncher.util;

public class Logcat {
	
	public static final int INFO = 0;
	public static final int WARNING = 1;
	public static final int ERROR = 2;
	public static final int SEVERE = 3;

	private int defaultLevel;

	public Logcat(int defaultLevel) {
		this.defaultLevel = defaultLevel;
	}

	public void log(String message) {
		switch (defaultLevel) {
			case 0:
				System.out.println("[INFO]: " + message);
				break;
			case 1:
				System.out.println("[WARNING]: " + message);
				break;
			case 2:
				System.err.println("[ERROR]: " + message);
				break;
			case 3:
				System.err.println("[SEVERE]: " + message);
				break;
		}
	}
	
	public void log(String message, int level) {
		switch (level) {
			case 0:
				System.out.println("[INFO]: " + message);
				break;
			case 1:
				System.out.println("[WARNING]: " + message);
				break;
			case 2:
				System.err.println("[ERROR]: " + message);
				break;
			case 3:
				System.err.println("[SEVERE]: " + message);
				break;
		}
	}

}
